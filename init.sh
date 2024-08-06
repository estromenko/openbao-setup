#!/bin/sh

./install-openbao.sh

./unseal-server.sh

BAO_TOKEN="$(BAO_ADDR="http://127.0.0.1:8202" bao unwrap -field=token "$(cat wrapping-token.txt)")"

export BAO_TOKEN="${BAO_TOKEN}"

sudo cp ./config.hcl /etc/openbao/openbao.hcl

sudo sed -i "s/TOKEN/${BAO_TOKEN}/g" /etc/openbao/openbao.hcl

sudo -u openbao bao server -config /etc/openbao/openbao.hcl
