# Convert VLESS URL to Xray config (xhttp)

Goal: generate `config.json` for Xray from a `vless://` URL (including `xhttp` and `reality`).

## 1) Script location
The script lives in `scripts/vless2xray.py`.

## 2) Example usage
```sh
chmod +x scripts/vless2xray.py

cat > vless.txt <<'EOF'
vless://UUID_HERE@HOST_HERE:PORT_HERE?type=xhttp&encryption=ENCRYPTION_HERE&path=%2F&host=HOST_HEADER_HERE&mode=auto&security=reality&pbk=PUBLIC_KEY_HERE&fp=chrome&sni=SNI_HERE&sid=SHORT_ID_HERE&spx=%2F&pqv=PQV_HERE
EOF

./scripts/vless2xray.py < vless.txt > config.json
```

## 3) Optional: pass URL as argument
```sh
./scripts/vless2xray.py 'vless://UUID_HERE@HOST_HERE:PORT_HERE?type=xhttp&encryption=ENCRYPTION_HERE&path=%2F&host=HOST_HEADER_HERE&mode=auto&security=reality&pbk=PUBLIC_KEY_HERE&fp=chrome&sni=SNI_HERE&sid=SHORT_ID_HERE&spx=%2F&pqv=PQV_HERE' > config.json
```

## 4) Optional: add TUN inbound
To have Xray create a TUN interface, add a `tun` inbound to `inbounds`:
```json
"inbounds": [
  {
    "tag": "tun-in",
    "protocol": "tun",
    "settings": {
      "name": "xray0",
      "MTU": 1500
    }
  },
  {
    "tag": "socks-in",
    "listen": "127.0.0.1",
    "port": 10808,
    "protocol": "socks"
  }
]
```

On desktop, you can run Chrome through the local SOCKS proxy:
```sh
google-chrome --proxy-server="socks5://127.0.0.1:10808"
```
