# Xray VLESS+WS node — same image for Render (free) and Railway (free $1/mo).
# The platform terminates TLS on its own domain; Xray serves plain WebSocket
# on $PORT. Client connects with wss://<domain>:443/<WS_PATH>.
FROM alpine:latest

RUN apk add --no-cache curl unzip ca-certificates \
  && curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v26.10.31/Xray-linux-64.zip \
  && unzip /tmp/xray.zip -d /usr/local/bin/ \
  && chmod +x /usr/local/bin/xray \
  && rm -f /tmp/xray.zip

ENV XRAY_LOCATION_ASSET=/usr/local/bin

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
