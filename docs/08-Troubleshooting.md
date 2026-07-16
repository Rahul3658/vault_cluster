# Troubleshooting

## Overview

This document contains the most common issues encountered while deploying a HashiCorp Vault High Availability (HA) cluster using Docker Compose and Raft Integrated Storage.

Each issue includes the observed error, possible cause, and recommended solution.

---

# Issue 1 - Permission Denied

## Error

```
failed to create fsm

failed to open bolt file

open /vault/data/vault.db: permission denied
```

## Cause

The Vault container does not have permission to write to the mounted data directory.

## Solution

```bash
sudo chown -R 100:100 /opt/vault/data
```

```bash
sudo chmod -R 700 /opt/vault/data
```

Restart Vault.

```bash
docker compose down

docker compose up -d
```

---

# Issue 2 - HTTP Response to HTTPS Client

## Error

```
http: server gave HTTP response to HTTPS client
```

## Cause

Vault CLI is trying to connect using HTTPS while Vault is configured with TLS disabled.

Current configuration:

```hcl
tls_disable = 1
```

## Solution

```bash
export VAULT_ADDR=http://127.0.0.1:8200
```

Verify:

```bash
echo $VAULT_ADDR
```

---

# Issue 3 - Permission Denied (Vault CLI)

## Error

```
permission denied
```

## Cause

User is not authenticated.

## Solution

Login using the Root Token.

```bash
vault login
```

---

# Issue 4 - Vault Starts in Sealed State

## Behaviour

Vault starts successfully but all requests fail.

## Cause

Vault is designed to start in a sealed state.

This is expected behaviour.

## Solution

Unseal Vault.

```bash
vault operator unseal
```

Repeat three times using three different Unseal Keys.

---

# Issue 5 - Node Join Failed

## Error

```
Joined false
```

## Possible Causes

- Leader not initialized
- Leader still sealed
- Incorrect Leader IP
- Network connectivity issue

## Solution

Verify Leader status.

```bash
vault status
```

Verify connectivity.

```bash
ping <leader-ip>
```

Verify Leader API.

```bash
curl http://<leader-ip>:8200/v1/sys/health
```

---

# Issue 6 - Leader Not Changing

## Behaviour

Leader container stopped.

No new Leader elected.

## Cause

Cluster lost quorum.

Example

```
Vault1

Down

Vault2

Down

Vault3

Alive
```

Only one node remains.

Majority cannot be achieved.

## Solution

Ensure at least two Vault nodes are available.

---

# Issue 7 - Old Leader Does Not Become Leader Again

## Behaviour

Old Leader restarted.

Becomes Follower.

## Cause

Expected Raft behaviour.

The existing Leader remains active until another election occurs.

No action required.

---

# Issue 8 - Connection Refused

## Error

```
failed to heartbeat

connection refused
```

## Cause

Follower node is offline.

Leader continues attempting heartbeat communication.

Example

```
failed to heartbeat

dial tcp

connection refused
```

This is expected.

After the node starts again and is unsealed, it automatically synchronizes.

---

# Issue 9 - NGINX Port Already in Use

## Error

```
bind() to 0.0.0.0:8200 failed

Address already in use
```

## Cause

Vault container is already listening on port 8200.

## Solution

Use another port.

Example

```
8300
```

or deploy NGINX on a separate server.

---

# Issue 10 - Raft List Shows Offline Node

## Behaviour

Stopped node still appears in:

```bash
vault operator raft list-peers
```

## Cause

This command shows Raft membership, not real-time node availability.

Offline nodes remain cluster members until explicitly removed.

This is expected behaviour.

---

# Useful Commands

Check Vault Status

```bash
vault status
```

Check Cluster Members

```bash
vault operator raft list-peers
```

Container Logs

```bash
docker logs vault
```

Container Status

```bash
docker ps -a
```

Restart Vault

```bash
docker restart vault
```

Verify Port

```bash
ss -tulpn | grep 8200
```

---

# Summary

The majority of deployment issues are related to:

- Incorrect permissions
- Incorrect Vault address
- Missing authentication
- Sealed Vault
- Network connectivity
- Incorrect cluster initialization

Following the deployment guide carefully resolves most issues.
