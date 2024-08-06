ui = true

storage "file" {
  path = "/opt/openbao/data"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/opt/openbao/tls/tls.crt"
  tls_key_file = "/opt/openbao/tls/tls.key"
}

seal "transit" {
  address = "http://127.0.0.1:8202"
  token = "TOKEN"
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"
}
