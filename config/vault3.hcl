ui = true

api_addr = "http://192.168.56.102:8200"
cluster_addr = "http://192.168.56.102:8201"

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

storage "raft" {
  path = "/vault/data"
  node_id = "vault3"
}

disable_mlock = true
