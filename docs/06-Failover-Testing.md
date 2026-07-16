# Failover Testing

## Overview

One of the primary objectives of deploying Vault in High Availability (HA) mode is to ensure that the service remains available even if one of the Vault nodes becomes unavailable.

This document demonstrates how failover was tested on the Vault HA cluster using Raft Integrated Storage.

---

# Objective

The purpose of this test is to verify:

- Leader failure detection
- Automatic leader election
- Continuous availability
- Data replication
- Node recovery
- Cluster synchronization

---

# Initial Cluster State

Before testing, the cluster status was:

| Node | IP Address | Role |
|------|------------|------|
| Vault1 | 192.168.7.156 | Leader |
| Vault2 | 192.168.56.101 | Standby |
| Vault3 | 192.168.56.102 | Standby |

Verify the current leader:

```bash
vault status
```

or

```bash
vault operator raft list-peers
```

Example Output

```
Node      Address                State

vault1    192.168.7.156:8201     leader

vault2    192.168.56.101:8201    follower

vault3    192.168.56.102:8201    follower
```

---

# Test 1 - Verify Current Leader

Confirm which node is currently acting as the Leader.

```
Vault1

Leader
```

Cluster Diagram

```
                Leader

             Vault1

                |

      ----------------------

      |                    |

      ▼                    ▼

   Vault2              Vault3

   Standby             Standby
```

---

# Test 2 - Stop the Leader

Stop the Vault container running on the Leader node.

```bash
docker stop vault
```

The Leader node becomes unavailable.

---

# Expected Behaviour

The remaining Vault nodes stop receiving heartbeats.

Raft automatically starts a new election.

One of the standby nodes becomes the new Leader.

No manual intervention is required.

---

# Verify New Leader

Wait approximately 5–10 seconds.

Run:

```bash
vault operator raft list-peers
```

Expected Example

```
Node      Address                State

vault3    192.168.56.102:8201    leader

vault2    192.168.56.101:8201    follower

vault1    192.168.7.156:8201     follower
```

The cluster continues operating normally.

---

# Why Did Leader Change?

Raft continuously sends heartbeat messages from the Leader to all Followers.

When Followers stop receiving heartbeats for a specific period, they assume the Leader has failed.

The Followers immediately begin a leader election.

The node receiving the majority of votes becomes the new Leader.

---

# Test 3 - Verify Secret Creation During Failover

While Vault3 was acting as Leader, create a new secret.

Example

```bash
vault kv put secret/demo username=rahul password=test123
```

Verify

```bash
vault kv get secret/demo
```

The secret should be created successfully.

This confirms that the new Leader is fully operational.

---

# Test 4 - Restart the Original Leader

Restart the Vault container.

```bash
docker start vault
```

Vault starts in a sealed state.

Unseal Vault.

```bash
vault operator unseal
```

Run the command three times using three different Unseal Keys.

---

# Verify Cluster

Execute

```bash
vault operator raft list-peers
```

Example

```
vault3      Leader

vault2      Follower

vault1      Follower
```

Notice that Vault1 does **not** automatically become Leader again.

---

# Why Doesn't the Original Leader Become Leader Again?

This is expected Raft behaviour.

When Vault1 rejoins the cluster, it checks which node is currently acting as Leader.

Since Vault3 is already the elected Leader, Vault1 simply rejoins as a Follower.

This prevents unnecessary leader changes and improves cluster stability.

---

# Test 5 - Verify Replication

Read the secret created while Vault1 was offline.

```bash
vault kv get secret/demo
```

Expected

```
username = rahul

password = test123
```

The secret is available on all nodes.

This confirms successful Raft log replication.

---

# Internal Workflow

Leader Failure

```
Vault1

↓

Stopped
```

Follower Detection

```
Vault2

No Heartbeat

↓

Election
```

```
Vault3

No Heartbeat

↓

Election
```

Majority Vote

```
Vault3

↓

Leader
```

Original Leader Returns

```
Vault1

↓

Follower
```

---

# Leader Election Process

```
Leader

↓

Heartbeat

↓

Followers

↓

Leader Failure

↓

Election Timeout

↓

Vote Request

↓

Majority Vote

↓

New Leader
```

---

# Cluster Health Verification

Verify cluster members.

```bash
vault operator raft list-peers
```

Verify node status.

```bash
vault status
```

Verify secret.

```bash
vault kv get secret/demo
```

---

# Test Results

| Test | Result |
|------|--------|
| Leader Failure | Successful |
| Automatic Election | Successful |
| Secret Creation | Successful |
| Data Replication | Successful |
| Node Recovery | Successful |
| Cluster Synchronization | Successful |

---

# Conclusion

The failover test confirms that the Vault HA cluster continues operating even after the Leader node becomes unavailable.

Raft automatically elects a new Leader, maintains data consistency, and synchronizes the original Leader when it rejoins the cluster.

No manual cluster reconfiguration was required during testing.

---

# Next Step

Continue with:

```
docs/07-Raft-Explanation.md
```

The next document explains:

- What is Raft?
- Leader
- Follower
- Candidate
- Heartbeats
- AppendEntries
- Quorum
- Log Replication
- Split Brain Prevention
- Node Recovery
