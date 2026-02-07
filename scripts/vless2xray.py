#!/usr/bin/env python3
import json
import sys
from urllib.parse import urlsplit, parse_qs


def q1(q, k, default=""):
    v = q.get(k)
    return v[0] if v else default


def main():
    url = sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read().strip()
    if not url.startswith("vless://"):
        raise SystemExit("Expected vless:// URL")

    u = urlsplit(url)
    uuid = u.username or ""
    host = u.hostname or ""
    port = u.port or 443
    q = parse_qs(u.query)

    network = q1(q, "type", "tcp")             # type=xhttp
    security = q1(q, "security", "none")       # security=reality

    xhttp = {}
    if network == "xhttp":
        # parse_qs already decodes %2F -> /
        xhttp["path"] = q1(q, "path", "/")
        if "host" in q:
            xhttp["host"] = q1(q, "host")
        if "mode" in q:
            xhttp["mode"] = q1(q, "mode")

    reality = {}
    if security == "reality":
        # sni=... pbk=... sid=... spx=... fp=... pqv=...
        reality["serverName"] = q1(q, "sni", q1(q, "serverName", ""))
        reality["publicKey"] = q1(q, "pbk", "")
        reality["shortId"] = q1(q, "sid", "")
        reality["spiderX"] = q1(q, "spx", "")
        reality["fingerprint"] = q1(q, "fp", "chrome")
        # pqv from the URL maps to mldsa65Verify in realitySettings
        if "pqv" in q:
            reality["mldsa65Verify"] = q1(q, "pqv", "")

    encryption = q1(q, "encryption", "none")   # VLESS encryption string
    flow = q1(q, "flow", "")

    cfg = {
        "log": {"loglevel": "warning"},
        "inbounds": [
            {
                "tag": "socks-in",
                "listen": "127.0.0.1",
                "port": 10808,
                "protocol": "socks",
                "settings": {"udp": True}
            }
        ],
        "outbounds": [
            {
                "tag": "proxy",
                "protocol": "vless",
                "settings": {
                    "vnext": [
                        {
                            "address": host,
                            "port": port,
                            "users": [
                                {
                                    "id": uuid,
                                    "encryption": encryption,
                                    "flow": flow
                                }
                            ]
                        }
                    ]
                },
                "streamSettings": {
                    "network": network,
                    **({"xhttpSettings": xhttp} if xhttp else {}),
                    "security": security,
                    **({"realitySettings": reality} if reality else {})
                }
            },
            {"tag": "direct", "protocol": "freedom"},
            {"tag": "block", "protocol": "blackhole"}
        ],
        "routing": {
            "rules": [
                {"type": "field", "ip": ["geoip:private"], "outboundTag": "direct"}
            ]
        }
    }

    print(json.dumps(cfg, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
