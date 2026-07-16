# HashiCorp Vault High Availability (HA) Cluster using Docker Compose & Raft

## Overview

This repository provides a complete implementation guide for deploying a **3-node HashiCorp Vault High Availability (HA)** cluster using **Docker Compose** and **Raft Integrated Storage**.

The purpose of this repository is to help engineers understand and implement:

- HashiCorp Vault High Availability (HA)
- Raft Integrated Storage
- Cluster Initialization
- Manual Unseal Process
- Leader Election
- Automatic Failover
- Data Replication
- Vault Agent Concepts
- Auto Unseal Concepts
- Production Best Practices

This project is intended for **learning, testing, and educational purposes** and serves as a practical reference for engineers deploying Vault in Docker-based environments.

---

# Features

- 3 Node Vault HA Cluster
- Docker Compose Deployment
- Raft Integrated Storage
- Leader Election
- Automatic Failover
- Data Replication
- Vault Web UI
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
| Storage Backend | Raft Integrated Storage |
| Operating System | Ubuntu |
| Number of Nodes | 3 |

---

# Cluster Information

| Node | Hostname | IP Address |
|------|----------|------------|
| Vault1 | master | 192.168.7.156 |
| Vault2 | worker1 | 192.168.56.101 |
| Vault3 | worker2 | 192.168.56.102 |

> **Note:** These IP addresses are from a private lab environment and are provided as examples.

---

# Repository Structure

```text
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

The repository contains ready-to-use configuration files for all Vault nodes.

| File | Description |
|------|-------------|
| docker-compose.yml | Docker Compose deployment configuration |
| config/vault1.hcl | Vault configuration for Node 1 |
| config/vault2.hcl | Vault configuration for Node 2 |
| config/vault3.hcl | Vault configuration for Node 3 |

> **Note:** The same `docker-compose.yml` file is used on all three Vault nodes. The only difference between the nodes is the mounted `vault.hcl` configuration file.

---

# Documentation

Detailed implementation guides are available in the **docs/** directory.

| Document | Description |
|----------|-------------|
| 01-Prerequisites.md | System requirements and prerequisites |
| 02-Vault-Configuration.md | Explanation of Vault configuration |
| 03-Deployment.md | Docker deployment steps |
| 04-Cluster-Initialization.md | Vault initialization process |
| 05-Unseal-and-Raft-Join.md | Unseal Vault and join nodes |
| 06-Failover-Testing.md | Leader election and failover validation |
| 07-Raft-Explanation.md | Raft consensus explained |
| 08-Troubleshooting.md | Common issues and resolutions |
| 09-Best-Practices.md | Production recommendations |
| 10-Vault-Agent.md | Vault Agent implementation |
| 11-Auto-Unseal.md | Auto Unseal concepts |

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

The following failover scenarios were successfully tested.

- Leader container stopped.
- Automatic leader election verified.
- Secret creation after failover.
- Original leader restarted.
- Original leader rejoined as follower.
- Automatic Raft synchronization verified.

---

# Screenshots

Store screenshots in the **screenshots/** directory.

Recommended screenshots:

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

This implementation is intended for learning and testing.

For production deployments, implement:

- TLS
- Auto Unseal
- Vault Agent
- Vault Agent Cache
- Load Balancer (NGINX or HAProxy)
- Audit Logging
- Monitoring
- Backup Strategy
- Disaster Recovery
- Least Privilege Policies

---

# Disclaimer

This repository demonstrates the deployment of a **HashiCorp Vault High Availability (HA)** cluster using **Docker Compose** and **Raft Integrated Storage** for learning, testing, and educational purposes.

The configurations and examples provided are intended for lab environments. Before deploying Vault in production, implement appropriate security measures such as:

- TLS Encryption
- Auto Unseal
- Vault Agent
- Authentication Policies
- Monitoring
- Backup & Restore Strategy
- Disaster Recovery Planning

---

# References

The following official resources provide additional information about HashiCorp Vault and related technologies.

- HashiCorp Vault Documentation
- Vault Raft Integrated Storage Documentation
- Vault Agent Documentation
- Docker Documentation
- Docker Compose Documentation

---

# Contributing

Contributions, suggestions, and improvements are welcome.

If you find any issues or have recommendations to improve this repository, feel free to open an Issue or submit a Pull Request.

---

# License

This project is licensed under the **MIT License**.

See the `LICENSE` file for more information.
