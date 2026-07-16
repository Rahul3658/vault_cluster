# HashiCorp Vault High Availability (HA) Cluster using Docker Compose & Raft

## Overview

This repository provides a complete implementation guide for deploying a **3-node HashiCorp Vault High Availability (HA)** cluster using **Docker Compose** and **Raft Integrated Storage**.

The purpose of this repository is to help engineers understand:

- Vault High Availability (HA)
- Raft Integrated Storage
- Leader Election
- Automatic Failover
- Data Replication
- Cluster Initialization
- Vault Agent
- Auto Unseal
- Production Best Practices

This implementation was created for **learning, testing, and internal knowledge sharing**.

---

# Features

- 3 Node Vault HA Cluster
- Docker Compose Deployment
- Raft Integrated Storage
- Leader Election
- Automatic Failover
- Data Replication
- Vault UI
- Complete Step-by-Step Documentation
- Troubleshooting Guide
- Production Best Practices
- Vault Agent Overview
- Auto Unseal Overview

---

# Architecture

```
                           Client
                              |
                              |
                        Vault UI / API
                              |
                 ---------------------------
                              |
                     Vault HA Cluster
                 ---------------------------

          +---------------+---------------+---------------+
          |               |               |               |
          |    Vault1     |    Vault2     |    Vault3     |
          |               |               |               |
          |    Leader     |   Follower    |   Follower    |
          +---------------+---------------+---------------+

               <----- Raft Replication ----->
```

---

# Environment

| Component | Value |
|------------|-------|
| Vault Version | 1.19.x |
| Deployment | Docker Compose |
| Storage Backend | Raft |
| Operating System | Ubuntu |
| Number of Nodes | 3 |

---

# Cluster Information

| Node | Hostname | IP Address |
|------|----------|------------|
| Vault1 | master | 192.168.7.156 |
| Vault2 | worker1 | 192.168.56.101 |
| Vault3 | worker2 | 192.168.56.102 |

---

# Repository Structure

```
vault-ha-cluster/
│
├── README.md
├── docker-compose.yml
├── LICENSE
├── .gitignore
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
│   ├── 05-Unseal-and-Raft-Join.md
│   ├── 06-Failover-Testing.md
│   ├── 07-Raft-Explanation.md
│   ├── 08-Troubleshooting.md
│   ├── 09-Best-Practices.md
│   ├── 10-Vault-Agent.md
│   └── 11-Auto-Unseal.md
│
└── screenshots/
```

---

# Configuration Files

| File | Description |
|------|-------------|
| docker-compose.yml | Docker Compose deployment file |
| config/vault1.hcl | Vault configuration for Node 1 |
| config/vault2.hcl | Vault configuration for Node 2 |
| config/vault3.hcl | Vault configuration for Node 3 |

> **Note:**  
> The same `docker-compose.yml` file is used on all three Vault nodes. The only difference between the nodes is the mounted `vault.hcl` configuration file.

---

# Documentation

Detailed implementation guides are available under the **docs/** directory.

| Document | Description |
|----------|-------------|
| 01-Prerequisites.md | System requirements and environment preparation |
| 02-Vault-Configuration.md | Explanation of every Vault configuration parameter |
| 03-Deployment.md | Deploy Vault using Docker Compose |
| 04-Cluster-Initialization.md | Initialize Vault and understand Unseal Keys |
| 05-Unseal-and-Raft-Join.md | Unseal Vault and join additional nodes |
| 06-Failover-Testing.md | Validate leader election and failover |
| 07-Raft-Explanation.md | Understand the Raft consensus algorithm |
| 08-Troubleshooting.md | Common deployment issues and fixes |
| 09-Best-Practices.md | Production recommendations |
| 10-Vault-Agent.md | Vault Agent architecture and caching |
| 11-Auto-Unseal.md | Manual Unseal vs Auto Unseal |

---

# Tested Scenarios

The following scenarios have been successfully validated.

- Vault Initialization
- Manual Unseal
- Raft Cluster Join
- Leader Election
- Automatic Failover
- Data Replication
- Node Recovery
- Secret Synchronization

---

# Failover Validation

The following failover scenarios were tested successfully.

- Leader container stopped.
- Automatic leader election.
- Secret creation after failover.
- Original leader restarted.
- Original leader rejoined as follower.
- Automatic Raft synchronization verified.

---

# Screenshots

Store screenshots in the **screenshots/** directory.

Suggested screenshots:

- Vault Login Page
- Vault UI Dashboard
- Raft Storage Overview
- Cluster Members
- Leader Election
- Failover Testing
- Secret Replication
- Architecture Diagram

---

# Production Recommendations

This repository is intended for learning and testing.

For production deployments, implement:

- TLS
- Auto Unseal
- Vault Agent
- Vault Agent Cache
- Load Balancer (HAProxy or NGINX)
- Audit Logging
- Monitoring
- Backup Strategy
- Disaster Recovery
- Least Privilege Policies

---

# Future Enhancements

The following topics can be added in future versions of this repository.

- Backup and Restore (Raft Snapshots)
- Monitoring (Prometheus & Grafana)
- Security Hardening
- Kubernetes Deployment
- AppRole Authentication
- Disaster Recovery
- Performance Replication
- TLS Configuration

---

# References

- HashiCorp Vault Documentation
- Raft Integrated Storage Documentation
- Docker Documentation

---

# Author

Prepared for internal knowledge sharing and implementation reference.

---

# License

This repository is intended for internal use and learning purposes.
