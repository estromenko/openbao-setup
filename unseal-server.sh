#!/bin/sh

export BAO_ADDR="http://127.0.0.1:8202"

export BAO_TOKEN="root"

export BAO_DEV_LISTEN_ADDRESS="127.0.0.1:8202"

mkdir -p ./logs

bao server -dev -dev-root-token-id="root" > ./logs/unseal-server.log 2>&1 &

sleep 1

bao audit enable file file_path=./logs/unseal-server-audit.log

bao secrets enable transit

bao write -f transit/keys/autounseal

bao policy write autounseal -<<EOF
path "transit/encrypt/autounseal" {
   capabilities = [ "update" ]
}

path "transit/decrypt/autounseal" {
   capabilities = [ "update" ]
}
EOF

bao token create -orphan -policy="autounseal" -wrap-ttl=120 -period=24h -field=wrapping_token > wrapping-token.txt
