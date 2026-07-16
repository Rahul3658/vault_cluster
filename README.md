# HashiCorp Vault High Availability (HA) Cluster using Docker Compose & Raft

![Vault](https://img.shields.io/badge/Vault-1.19-blue)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Overview

This repository demonstrates how to deploy a **3-node HashiCorp Vault High Availability (HA)** cluster using **Docker Compose** and **Raft Integrated Storage**.

It includes complete deployment documentation, configuration files, failover testing, Vault Agent concepts, Auto Unseal, troubleshooting, and production best practices.

This project is intended for learning, testing, and educational purposes.

---

## Features

- 3 Node Vault HA Cluster
- Docker Compose Deployment
- Raft Integrated Storage
- Automatic Leader Election
- Automatic Failover
- Data Replication
- Vault Web UI
- Complete Documentation
- Vault Agent Guide
- Auto Unseal Guide
- Troubleshooting
- Production Best Practices

---

## Architecture

(Add architecture image here)

Example

![Architecture](screenshots/architecture.png)

---

## Tested Environment

| Component | Version |
|------------|----------|
| Ubuntu | 24.04 |
| Vault | 1.19 |
| Docker | Latest |
| Docker Compose | v2 |

---

## Repository Structure

(Repository tree)

---

## Quick Start

Clone Repository

```bash
git clone https://github.com/<your-username>/vault-ha-cluster.git
```

Move into repository

```bash
cd vault-ha-cluster
```

Read

```
docs/01-Prerequisites.md
```

Follow documentation in sequence.

---

## Documentation

| Document | Description |
|----------|-------------|
| 01 | Prerequisites |
| 02 | Vault Configuration |
| 03 | Deployment |
| 04 | Cluster Initialization |
| 05 | Unseal & Join |
| 06 | Failover Testing |
| 07 | Raft Explained |
| 08 | Troubleshooting |
| 09 | Best Practices |
| 10 | Vault Agent |
| 11 | Auto Unseal |
| 12 | Backup & Restore |
| 13 | Security Hardening |

---

## Configuration

Configuration files are available inside

```
config/
```

Docker Compose

```
docker-compose.yml
```

---

## Screenshots

Store screenshots under

```
screenshots/
```

Recommended screenshots:

- Vault Login
- Vault UI
- Docker Containers
- Raft Peers
- Leader Election
- Secret Replication
- Failover

---

## Tested Scenarios

- Vault Initialization
- Manual Unseal
- Cluster Join
- Leader Election
- Automatic Failover
- Secret Replication
- Node Recovery
- Cluster Synchronization

---

## Future Improvements

- AWS KMS Auto Unseal
- Vault Agent Deployment
- TLS
- Kubernetes Deployment
- AppRole Authentication
- Prometheus Monitoring
- Grafana Dashboard
- Backup Automation
- Disaster Recovery

---

## Disclaimer

This repository is intended for learning and educational purposes.

Before deploying Vault in production, implement:

- TLS
- Auto Unseal
- Monitoring
- Backup Strategy
- Disaster Recovery
- Least Privilege Policies

---

## References

- HashiCorp Vault Documentation
- Docker Documentation
- Raft Consensus Algorithm Documentation

---

## Contributing

Contributions, improvements, and suggestions are welcome.

Feel free to open an Issue or Pull Request.

---

## License

MIT License
