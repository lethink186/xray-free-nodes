#!/bin/sh
# Generates /etc/xray/config.json from env vars, then runs Xray.
# Required env: UUID. Optional: PORT (default 8080), WS_PATH (default /tk-rail).
set -e

PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-/tk-rail}"

if [ -z "$UUID" ]; then
  echo "ERROR: UUID env var is required" >&2
  exit 1
fi

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "$UUID" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "$WS_PATH" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

echo "Starting Xray on port $PORT, ws path $WS_PATH"
exec /usr/local/bin/xray -config /etc/xray/config.json
