# Raft Consensus Algorithm

## Overview

HashiCorp Vault uses **Raft Integrated Storage** as its built-in storage backend and consensus algorithm.

Raft ensures that all Vault nodes maintain the same data while providing High Availability (HA), automatic leader election, fault tolerance, and data consistency.

Unlike traditional storage backends such as Consul or MySQL, Raft allows Vault to manage storage and consensus internally without requiring any external database.

---

# What is Raft?

Raft is a distributed consensus algorithm.

Its primary responsibility is to ensure that every Vault node agrees on the same data even when one or more nodes fail.

Raft guarantees:

- Data Consistency
- Leader Election
- Log Replication
- Fault Tolerance
- Split Brain Prevention

---

# Vault HA Architecture

```

                 Client
                    |
                    |
               Vault Cluster
                    |
      +-------------+-------------+
      |                           |
      ▼                           ▼

 Leader                    Followers

Vault1                    Vault2

|

▼

Vault3

```

Only one node acts as the Leader.

All remaining nodes act as Followers.

---

# Node Roles

Vault nodes can have one of three states.

## Leader

The Leader is responsible for:

- Accepting write requests
- Updating the Raft log
- Replicating changes
- Sending heartbeat messages
- Managing cluster state

Only one Leader exists at any given time.

---

## Follower

Followers:

- Store replicated data
- Respond to read requests
- Participate in leader elections
- Become Leader if the current Leader fails

Followers never accept direct writes.

---

## Candidate

A Follower becomes a Candidate when it stops receiving heartbeat messages from the Leader.

The Candidate requests votes from other nodes.

If it receives a majority of votes, it becomes the new Leader.

---

# How Writes Work

Suppose a user creates a secret.

```

vault kv put secret/db password=MyPassword123

```

The request is sent to the Leader.

```

Client

↓

Leader

↓

Write to Raft Log

↓

Replicate to Followers

↓

Majority Confirmation

↓

Success Response

```

The write is considered successful only after it has been acknowledged by a majority of nodes.

---

# Log Replication

Every write operation is stored in the Raft log.

Example

```

Log Entry 1

Log Entry 2

Log Entry 3

Log Entry 4

```

The Leader sends every new log entry to all Followers.

```

Leader

|

+-------> Vault2

|

+-------> Vault3

```

Followers store the same log entries.

Eventually all nodes contain identical data.

---

# Heartbeat Messages

Even when there are no write requests, the Leader continuously sends heartbeat messages.

```

Leader

↓

Heartbeat

↓

Follower

```

Purpose:

- Inform Followers that the Leader is alive.
- Prevent unnecessary elections.
- Maintain cluster stability.

If heartbeats stop, Followers assume the Leader has failed.

---

# Leader Election

Suppose the Leader crashes.

```

Vault1

Leader

↓

Stopped

```

Followers stop receiving heartbeats.

After the election timeout expires, Followers become Candidates.

Each Candidate requests votes from other nodes.

```

Vault2

↓

Vote Request

↓

Vault3

```

If a Candidate receives the majority of votes, it becomes the new Leader.

```

Vault3

↓

Leader

```

No manual intervention is required.

---

# Quorum

Raft requires a majority of nodes to agree before committing data.

Formula

```

Majority = (Total Nodes / 2) + 1

```

Examples

### 3 Nodes

```

3 Nodes

↓

Majority = 2

```

### 5 Nodes

```

5 Nodes

↓

Majority = 3

```

### 7 Nodes

```

7 Nodes

↓

Majority = 4

```

---

# Why Quorum Matters

Example

Three-node cluster.

```

Vault1

Alive

```

```

Vault2

Alive

```

```

Vault3

Down

```

Alive Nodes = 2

Majority = 2

Cluster continues operating normally.

---

Now suppose:

```

Vault1

Alive

```

```

Vault2

Down

```

```

Vault3

Down

```

Alive Nodes = 1

Majority = 2

The cluster loses quorum.

Without quorum:

- No Leader can be elected.
- New write operations fail.
- Data consistency cannot be guaranteed.

---

# Why Doesn't the Old Leader Become Leader Again?

This behaviour was observed during failover testing.

Scenario:

```

Vault1

Leader

↓

Stopped

↓

Vault3 becomes Leader

↓

Vault1 starts again

```

Vault1 does **not** automatically become Leader.

Instead:

```

Vault1

↓

Follower

```

Reason:

Raft avoids unnecessary leader changes.

Keeping the existing healthy Leader improves cluster stability.

A new election occurs only if the current Leader becomes unavailable.

---

# Automatic Synchronization

Suppose Vault3 is offline.

During downtime:

```

Leader

↓

Secret1

↓

Secret2

↓

Secret3

```

Vault3 misses these updates.

When Vault3 rejoins:

```

Vault3

↓

Requests Missing Logs

↓

Leader

↓

Sends Missing Log Entries

```

Vault3 automatically catches up with the latest cluster state.

No manual synchronization is required.

---

# Split Brain Prevention

Split Brain occurs when multiple nodes believe they are the Leader.

Raft prevents Split Brain using:

- Leader Election
- Quorum
- Majority Voting

Only one node can receive a majority of votes.

Therefore only one Leader can exist at any time.

---

# Advantages of Raft

- Integrated Storage
- No External Database Required
- Automatic Leader Election
- High Availability
- Data Replication
- Fault Tolerance
- Automatic Recovery
- Strong Consistency
- Easy Deployment

---

# Summary

Raft is the distributed consensus algorithm used by HashiCorp Vault to provide High Availability and consistent data replication.

The Leader processes all write operations, replicates changes to Followers, and maintains cluster consistency using heartbeat messages.

If the Leader fails, Raft automatically elects a new Leader using majority voting.

When failed nodes return, they automatically synchronize missing data without manual intervention.

---

# Next Step

Continue with:

```

docs/08-Troubleshooting.md

```

The next document covers the common issues encountered during deployment and their resolutions.
