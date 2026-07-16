# Vault Configuration

## Overview

HashiCorp Vault uses a configuration file (`vault.hcl`) to define how the Vault server starts, listens for client requests, communicates with other Vault nodes, and stores data.

In this implementation, each Vault node has its own configuration file with a unique IP address and `node_id`.

---

# Configuration File Location

The Vault configuration file is stored at:

```text
/opt/vault/config/vault.hcl
```

Each node has its own configuration.

Example:

| Node | Configuration |
|------|---------------|
| Vault1 | vault.hcl |
| Vault2 | vault.hcl |
| Vault3 | vault.hcl |

Although the filename is the same, the values of `api_addr`, `cluster_addr`, and `node_id` differ on each node.

---

# Vault1 Configuration

```hcl
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
```

---

# Explanation of Each Parameter

## ui = true

```hcl
ui = true
```

### Purpose

Enables the Vault Web UI.

Without this option, only the Vault CLI and API can be used.

Example:

```
http://192.168.7.156:8200
```

will display the Vault login page.

---

## api_addr

```hcl
api_addr = "http://192.168.7.156:8200"
```

### Purpose

Specifies the public API address of this Vault node.

Clients, Vault CLI, Vault Agent, and applications use this address to communicate with Vault.

### Important

Every node must have its own unique `api_addr`.

Example:

Vault1

```hcl
api_addr="http://192.168.7.156:8200"
```

Vault2

```hcl
api_addr="http://192.168.56.101:8200"
```

Vault3

```hcl
api_addr="http://192.168.56.102:8200"
```

---

## cluster_addr

```hcl
cluster_addr = "http://192.168.7.156:8201"
```

### Purpose

This address is **not used by clients**.

It is used only for communication between Vault nodes.

Examples include:

- Raft Replication
- Heartbeat
- Leader Election
- Log Synchronization

Port **8201** is reserved for cluster communication.

---

## listener "tcp"

```hcl
listener "tcp" {

address = "0.0.0.0:8200"

tls_disable = 1

}
```

### Purpose

Configures the Vault API listener.

Vault listens on TCP port **8200** for incoming API and UI requests.

---

### address

```hcl
address = "0.0.0.0:8200"
```

Meaning:

Listen on all available network interfaces.

Clients can access Vault using the server IP address.

---

### tls_disable

```hcl
tls_disable = 1
```

TLS is disabled for this lab environment.

**Reason**

This implementation is for learning and testing.

### Production Recommendation

Never disable TLS in production.

Instead, configure:

- SSL Certificate
- Private Key
- CA Certificate

---

## storage "raft"

```hcl
storage "raft" {

path = "/vault/data"

node_id = "vault1"

}
```

### Purpose

Configures Vault to use Raft Integrated Storage.

Raft stores all Vault data locally while automatically replicating it to every node in the cluster.

No external database is required.

---

### path

```hcl
path="/vault/data"
```

Specifies where Vault stores the Raft database.

This directory is mounted from the host.

Docker Mapping:

```
Host

/opt/vault/data

↓

Container

/vault/data
```

---

### node_id

```hcl
node_id="vault1"
```

Unique identifier of the Vault node.

Every node must have a different node ID.

Example

Vault1

```
vault1
```

Vault2

```
vault2
```

Vault3

```
vault3
```

Duplicate node IDs are not allowed.

---

## disable_mlock

```hcl
disable_mlock = true
```

### Purpose

Disables memory locking.

Vault normally locks secrets in RAM using `mlock()` to prevent them from being swapped to disk.

Docker containers usually cannot use `mlock()` without additional privileges.

Therefore, for Docker-based deployments:

```hcl
disable_mlock = true
```

is commonly used.

### Production Recommendation

If supported by the operating system and container runtime, enable memory locking.

---

# Configuration Differences Between Nodes

## Vault1

```text
api_addr = http://192.168.7.156:8200

cluster_addr = http://192.168.7.156:8201

node_id = vault1
```

---

## Vault2

```text
api_addr = http://192.168.56.101:8200

cluster_addr = http://192.168.56.101:8201

node_id = vault2
```

---

## Vault3

```text
api_addr = http://192.168.56.102:8200

cluster_addr = http://192.168.56.102:8201

node_id = vault3
```

---

# Summary

The Vault configuration file defines:

- Vault UI
- Client API Address
- Cluster Communication Address
- Listener Configuration
- Raft Storage Backend
- Unique Node Identification
- Memory Locking Behavior

These settings allow each Vault server to participate in the High Availability (HA) cluster while maintaining automatic replication and leader election.

---

# Next Step

Continue with:

```
docs/03-Deployment.md
```

In the next section, we will deploy the Vault containers using Docker Compose and verify that all three Vault nodes are running successfully.
