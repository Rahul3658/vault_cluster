# Unseal Vault and Join Nodes to the Raft Cluster

## Overview

After initializing the first Vault node, the Vault cluster is still sealed and cannot serve requests.

In this step, we will:

- Unseal the primary Vault node.
- Join the remaining Vault nodes to the Raft cluster.
- Unseal the joined nodes.
- Verify High Availability.

---

# Current Cluster Status

At this stage:

| Node | Initialized | Sealed | Role |
|------|-------------|---------|------|
| Vault1 | Yes | Yes | Not Available |
| Vault2 | No | Yes | Not Joined |
| Vault3 | No | Yes | Not Joined |

Vault cannot serve requests until it is unsealed.

---

# Why is Vault Sealed?

Vault encrypts all stored secrets using a Master Key.

For security reasons, Vault never stores the Master Key directly in memory after a restart.

Instead, Vault starts in a **sealed** state.

When sealed:

- API requests are rejected.
- Secrets cannot be read.
- Secrets cannot be written.
- Authentication is unavailable.

Vault must be unsealed before it becomes operational.

---

# Step 1 - Open Vault Shell

Connect to the Vault container.

```bash
docker exec -it vault sh
```

---

# Step 2 - Configure Vault Address

Since TLS is disabled in this lab environment, configure the Vault CLI to use HTTP.

```bash
export VAULT_ADDR=http://127.0.0.1:8200
```

Verify:

```bash
echo $VAULT_ADDR
```

Expected Output

```
http://127.0.0.1:8200
```

---

# Step 3 - Unseal Vault1

Run the following command.

```bash
vault operator unseal
```

Paste **Unseal Key 1**.

Run the command again.

```bash
vault operator unseal
```

Paste **Unseal Key 2**.

Run the command a third time.

```bash
vault operator unseal
```

Paste **Unseal Key 3**.

Vault is now unsealed.

---

# Step 4 - Verify Vault1 Status

Execute:

```bash
vault status
```

Expected Output

```
Initialized      true

Sealed           false

HA Enabled       true

HA Mode          active
```

Explanation:

- Vault is initialized.
- Vault is unsealed.
- Vault1 has become the Active node.
- The Raft cluster has been created.

---

# Step 5 - Join Vault2 to the Cluster

Log in to the Vault2 container.

```bash
docker exec -it vault sh
```

Configure Vault Address.

```bash
export VAULT_ADDR=http://127.0.0.1:8200
```

Join the cluster.

```bash
vault operator raft join http://192.168.7.156:8200
```

Expected Output

```
Joined true
```

This means Vault2 successfully joined the existing Raft cluster.

---

# Step 6 - Unseal Vault2

Run:

```bash
vault operator unseal
```

Enter Unseal Key 1.

Repeat for:

- Unseal Key 2
- Unseal Key 3

Verify:

```bash
vault status
```

Expected Output

```
Initialized      true

Sealed           false

HA Enabled       true

HA Mode          standby
```

Vault2 is now a Standby node.

---

# Step 7 - Join Vault3

Repeat the same process on Vault3.

```bash
docker exec -it vault sh
```

```bash
export VAULT_ADDR=http://127.0.0.1:8200
```

```bash
vault operator raft join http://192.168.7.156:8200
```

Expected Output

```
Joined true
```

---

# Step 8 - Unseal Vault3

Execute:

```bash
vault operator unseal
```

Provide:

- Unseal Key 1
- Unseal Key 2
- Unseal Key 3

Verify:

```bash
vault status
```

Expected Output

```
Initialized      true

Sealed           false

HA Enabled       true

HA Mode          standby
```

---

# Cluster Status

The cluster should now look like this.

| Node | Status | Role |
|------|---------|------|
| Vault1 | Unsealed | Leader |
| Vault2 | Unsealed | Standby |
| Vault3 | Unsealed | Standby |

---

# Verify Cluster Members

Login using the Root Token.

```bash
vault login
```

Then verify the cluster.

```bash
vault operator raft list-peers
```

Expected Output

```
Node       Address                 State      Voter

vault1     192.168.7.156:8201      leader     true

vault2     192.168.56.101:8201     follower   true

vault3     192.168.56.102:8201     follower   true
```

---

# Understanding Leader and Standby

Only one Vault node can be the Leader.

The Leader is responsible for:

- Processing write requests.
- Replicating data.
- Managing Raft logs.
- Sending heartbeats.

Standby nodes:

- Receive replicated data.
- Participate in leader elections.
- Automatically become Leader if the current Leader fails.

---

# Cluster Architecture

```
                Vault Cluster

                     Leader

               +--------------+

               |   Vault1     |

               +------+-------+

                      |

      ----------------+----------------

      |                               |

      ▼                               ▼

+-------------+                 +-------------+

|   Vault2    |                 |   Vault3    |

|   Standby   |                 |   Standby   |

+-------------+                 +-------------+
```

---

# Validation Checklist

Verify the following:

- Vault1 initialized.
- Vault1 unsealed.
- Vault2 joined.
- Vault2 unsealed.
- Vault3 joined.
- Vault3 unsealed.
- Leader elected.
- Two standby nodes available.
- Raft cluster healthy.

---

# Troubleshooting

## Error

```
HTTP response to HTTPS client
```

Solution

```bash
export VAULT_ADDR=http://127.0.0.1:8200
```

---

## Error

```
permission denied
```

Cause

Not logged in.

Solution

```bash
vault login
```

---

## Error

```
Joined false
```

Cause

Leader not initialized or not unsealed.

Verify:

```bash
vault status
```

on Vault1.

---

# Next Step

Continue with:

```
docs/06-Failover-Testing.md
```

In the next section, we will:

- Simulate leader failure.
- Observe automatic leader election.
- Verify secret replication.
- Recover the failed node.
- Validate High Availability.
