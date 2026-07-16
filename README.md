# HashiCorp Vault High Availability (HA) Cluster using Docker Compose and Raft

## Overview

This document explains how to deploy a **3-node HashiCorp Vault High Availability (HA)** cluster using **Docker Compose** and **Raft Integrated Storage**.

The objective of this implementation is to achieve:

- High Availability (HA)
- Automatic Leader Election
- Data Replication
- Fault Tolerance
- Zero Single Point of Failure
- Integrated Storage using Raft

This implementation is intended for **learning and testing purposes**. For production deployments, TLS, Auto Unseal, and a Load Balancer should be configured.

---

# Architecture

```
                           Client
                              |
                              |
                    Vault UI / API Request
                              |
        -------------------------------------------------
        |                                               |
                    Vault HA Cluster
        -------------------------------------------------

        +----------------+     +----------------+     +----------------+
        |    Vault-1     |     |    Vault-2     |     |    Vault-3     |
        |                |     |                |     |                |
        |    Leader      |<--->|   Follower     |<--->|   Follower     |
        |                |     |                |     |                |
        +----------------+     +----------------+     +----------------+

                <--------- Raft Replication --------->
```

---

# Environment

| Component | Details |
|------------|---------|
| Vault Version | 1.19.x |
| Deployment | Docker Compose |
| Storage Backend | Raft Integrated Storage |
| Operating System | Ubuntu |
| Number of Nodes | 3 |

## Cluster Information

| Node | Hostname | IP Address |
|------|----------|------------|
| Vault1 | master | 192.168.7.156 |
| Vault2 | worker1 | 192.168.56.101 |
| Vault3 | worker2 | 192.168.56.102 |

---

# Features

This implementation provides:

- Vault Web UI
- Raft Integrated Storage
- High Availability
- Leader Election
- Data Replication
- Automatic Failover
- Docker Compose Deployment

---

# Prerequisites

Before starting, ensure the following requirements are met.

- Ubuntu Server
- Docker
- Docker Compose Plugin
- Root or sudo privileges
- Network connectivity between all nodes
- Ports 8200 and 8201 open between all Vault nodes

---

# Network Ports

| Port | Description |
|-------|-------------|
| 8200 | Vault API & Web UI |
| 8201 | Raft Cluster Communication |

---

# Repository Structure

```
vault-ha-cluster/
│
├── README.md
│
├── docker-compose.yml
│
├── config/
│   ├── vault1.hcl
│   ├── vault2.hcl
│   └── vault3.hcl
│
├── docs/
│   ├── 01-Prerequisites.md
│   ├── 02-Vault-Configuration.md
│   ├── 03-Deployment.md
│   ├── 04-Cluster-Initialization.md
│   ├── 05-Node-Join.md
│   ├── 06-Failover-Testing.md
│   ├── 07-Raft-Explanation.md
│   ├── 08-Troubleshooting.md
│   └── 09-Best-Practices.md
│
└── screenshots/
```

---

# High Availability Workflow

```
                 Client

                    │

                    ▼

            Active Vault Node

                    │

          Replicate using Raft

        ┌───────────┼────────────┐

        ▼                        ▼

   Standby Node             Standby Node
```

---

# Failover Workflow

Initial State

```
Vault1  → Leader

Vault2  → Follower

Vault3  → Follower
```

## Configuration Files

The repository includes sample Vault configuration files for each node.

| File | Description |
|------|-------------|
| `config/vault1.hcl` | Vault configuration for Node 1 |
| `config/vault2.hcl` | Vault configuration for Node 2 |
| `config/vault3.hcl` | Vault configuration for Node 3 |
| `docker-compose.yml` | Docker Compose deployment file |
```
If Vault1 goes down

```
Vault1  → Down

Vault2  → Leader

Vault3  → Follower
```

When Vault1 comes back

```
Vault1  → Follower

Vault2  → Leader

Vault3  → Follower
```

The original leader **does not automatically become leader again**. Raft keeps the current leader to avoid unnecessary leader changes.

---

# Verification

The cluster was validated using the following tests.

- Successfully initialized Vault.
- Successfully unsealed Vault.
- Joined multiple nodes using Raft.
- Verified cluster members.
- Tested automatic leader election.
- Tested failover.
- Verified data replication.
- Restarted failed node and confirmed automatic synchronization.

---

# Tested Scenarios

✅ Vault Initialization

✅ Manual Unseal

✅ Raft Cluster Join

✅ Leader Election

✅ Automatic Failover

✅ Data Replication

✅ Node Recovery

✅ Secret Synchronization

---

# Production Recommendations

This implementation is intended for testing.

For Production:

- Enable TLS
- Configure Auto Unseal
- Deploy Vault Agent
- Configure Load Balancer
- Enable Monitoring
- Schedule Raft Snapshots
- Configure Backup Strategy

---

# Next Documents

Continue with the following documentation:

1. 01-Prerequisites.md
2. 02-Vault-Configuration.md
3. 03-Deployment.md
4. 04-Cluster-Initialization.md
5. 05-Node-Join.md
6. 06-Failover-Testing.md
7. 07-Raft-Explanation.md
8. 08-Troubleshooting.md
9. 09-Best-Practices.md
