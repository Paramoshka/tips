# MySQL recovery dump via Docker (InnoDB force recovery)

Goal: extract a dump when a MySQL datadir is broken and MySQL won't start normally.

Notes:
- This uses `innodb_force_recovery=6` (last resort). If possible, try 1..5 first.
- The container runs MySQL with `--skip-networking` and `--skip-grant-tables` and dumps via a Unix socket.
- The `:Z` suffix on volumes is for SELinux; omit it if not needed.

## 1) Set image and paths
- `IMG` should be a MySQL image that matches your datadir version (for example `mysql:8.0`).
- `/home/docker/.middleware/data/mysql` is your host datadir path (change it).
- `/home/docker/dumps` is where the dump will be written (change it).

## 2) Run recovery dump
```sh
IMG="mysql:8.0"

docker run --rm -i \
  -v /home/docker/.middleware/data/mysql:/var/lib/mysql:Z \
  -v /home/docker/dumps:/dump:Z \
  --entrypoint sh "$IMG" -lc '
    set -eu

    DB="default"
    TS=$(date +%F-%H%M)
    SOCK=/tmp/mysqld.sock
    PID=/tmp/mysqld.pid
    ERR=/tmp/mysqld-error.log

    rm -f "$SOCK" "$PID" "$ERR"

    # start mysqld in recovery mode (no networking, no auth)
    mysqld --user=mysql --datadir=/var/lib/mysql \
      --innodb_force_recovery=6 \
      --innodb_buffer_pool_load_at_startup=0 \
      --innodb_buffer_pool_dump_at_shutdown=0 \
      --innodb_stats_persistent=0 \
      --skip-networking \
      --socket="$SOCK" \
      --pid-file="$PID" \
      --skip-grant-tables \
      --log-error="$ERR" \
      --max_connections=50 &

    # wait for socket
    for i in $(seq 1 90); do [ -S "$SOCK" ] && break; sleep 1; done

    if [ ! -S "$SOCK" ]; then
      echo "mysqld did not start (no socket). Log:"
      tail -n 200 "$ERR" || true
      exit 1
    fi

    echo "Dumping DB=$DB ..."
    mysqldump --protocol=SOCKET -S "$SOCK" \
      --databases "$DB" \
      --single-transaction --routines --events --hex-blob \
      | gzip -1 > "/dump/${DB}-${TS}.sql.gz"

    # stop mysqld
    mysqladmin --protocol=SOCKET -S "$SOCK" shutdown || true

    echo "DONE: /dump/${DB}-${TS}.sql.gz"
  '
```

## 3) Common tweaks
- Dump all databases: replace `--databases "$DB"` with `--all-databases`.
- If 6 is too aggressive, try `--innodb_force_recovery=1`..`5`.
- If your datadir is not owned by `mysql` in the image, run `mysqld` as root and set `--user=mysql` only if it exists in the container.
