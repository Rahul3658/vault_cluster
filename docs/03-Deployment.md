# Vault Deployment using Docker Compose

## Overview

This document explains how to deploy a HashiCorp Vault High Availability (HA) cluster using Docker Compose.

Each Vault node runs as an independent Docker container with its own configuration and local Raft storage.

---

# Deployment Architecture

```

+-------------------------+
| Ubuntu Virtual Machine |
| |
| +-------------------+ |
| | Vault Container | |
| | |
| | Port 8200 | |
| | Port 8201 | |
| | |
| +-------------------+ |
| |
+-------------------------+

```

Each VM hosts one Vault container.

---

# Docker Compose File

The following Docker Compose file is used on every Vault node.

```yaml
services:

  vault:

    image: hashicorp/vault:1.19

    container_name: vault

    restart: unless-stopped

    cap_add:
      - IPC_LOCK

    ports:
      - "8200:8200"
      - "8201:8201"

    volumes:
      - /opt/vault/config:/vault/config
      - /opt/vault/data:/vault/data

    command: vault server -config=/vault/config/vault.hcl
```

---

# Configuration Explanation

## image

```yaml
image: hashicorp/vault:1.19
```

Specifies the official HashiCorp Vault Docker image.

Using the official image ensures compatibility and receives official security updates.

---

## container_name

```yaml
container_name: vault
```

Assigns a fixed container name.

Benefits:

- Easier administration
- Simple Docker commands
- Consistent naming across nodes

Example

```bash
docker logs vault

docker exec -it vault sh
```

---

## restart

```yaml
restart: unless-stopped
```

Automatically restarts the Vault container if:

- Docker service restarts
- Server reboots
- Container crashes

The container will not restart only if it is manually stopped.

---

## cap_add

```yaml
cap_add:
  - IPC_LOCK
```

Vault attempts to lock sensitive information into memory.

The IPC_LOCK capability allows Vault to use memory locking when supported.

Although this lab uses:

```hcl
disable_mlock = true
```

keeping IPC_LOCK is considered a good practice and simplifies future production migration.

---

## ports

```yaml
ports:

- "8200:8200"

- "8201:8201"
```

### Port 8200

Used for:

- Vault API
- Vault CLI
- Vault Web UI

Example

```
http://192.168.7.156:8200
```

---

### Port 8201

Used only for:

- Raft replication
- Leader election
- Heartbeat communication

Applications should never connect to this port.

---

## volumes

```yaml
volumes:

- /opt/vault/config:/vault/config

- /opt/vault/data:/vault/data
```

Maps directories from the host into the container.

Configuration

```
Host

/opt/vault/config

↓

Container

/vault/config
```

Storage

```
Host

/opt/vault/data

↓

Container

/vault/data
```

This ensures Vault data persists even if the container is recreated.

---

## command

```yaml
command:

vault server -config=/vault/config/vault.hcl
```

Starts the Vault server using the specified configuration file.

Without this command, Vault starts with its default configuration.

---

# Start Vault

Start the Vault container.

```bash
docker compose up -d
```

Verify

```bash
docker ps
```

Expected output

```
vault

Up
```

---

# Verify Container Logs

```bash
docker logs vault
```

Expected

```
Vault server started!

Storage

raft

Listener

tcp
```

This confirms that Vault started successfully using Raft Integrated Storage.

---

# Permission Issue Encountered

During deployment, Vault failed to start.

Error

```
failed to open bolt file

permission denied
```

Root Cause

Docker container did not have permission to write to:

```
/vault/data
```

---

# Resolution

Update directory ownership.

```bash
sudo chown -R 100:100 /opt/vault/data
```

Update permissions.

```bash
sudo chmod -R 700 /opt/vault/data
```

Restart Vault.

```bash
docker compose down

docker compose up -d
```

Verify again.

```bash
docker logs vault
```

Vault started successfully.

---

# Verify Vault is Listening

Execute

```bash
ss -tulpn | grep 8200
```

Expected

```
LISTEN

8200
```

Verify Docker

```bash
docker ps
```

Expected

```
vault

Up
```

---

# Deployment Validation Checklist

Verify the following before continuing.

- Docker container running
- Vault logs show no errors
- Port 8200 listening
- Port 8201 listening
- Raft storage initialized
- Configuration mounted successfully
- Data directory mounted successfully

---

# Next Step

The Vault server is now running.

Continue with:

```
docs/04-Cluster-Initialization.md
```

In the next document, the Vault cluster will be initialized, unsealed, and prepared for additional nodes to join the Raft cluster.
