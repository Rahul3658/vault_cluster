ui = true

api_addr = "http://192.168.7.156:8200"
cluster_addr = "http://192.168.7.156:8201"

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

storage "raft" {
  path = "/vault/data"
  node_id = "vault1"
}

disable_mlock = true
