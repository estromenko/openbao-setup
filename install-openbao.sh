#!/bin/sh

HOST="${HOST:="127.0.0.1"}"

sudo apt install -y openssl

if ! type "bao" > /dev/null; then
  echo Installing openbao...
  wget https://github.com/openbao/openbao/releases/download/v2.0.0/bao_2.0.0_linux_amd64.deb
  sudo apt install -y ./bao_2.0.0_linux_amd64.deb
  rm ./bao_2.0.0_linux_amd64.deb
fi

sudo mkdir -p /opt/openbao/tls

sudo openssl req \
  -out /opt/openbao/tls/tls.crt \
  -new \
  -keyout /opt/openbao/tls/tls.key \
  -newkey rsa:4096 \
  -nodes \
  -sha256 \
  -x509 \
  -subj "/O=Openbao/CN=${HOST}" \
  -days 1095 \
  -addext "subjectAltName = IP:${HOST}"

sudo chown -R openbao /opt/openbao

sudo cp /opt/openbao/tls/tls.crt /usr/local/share/ca-certificates/openbao.crt

sudo update-ca-certificates
