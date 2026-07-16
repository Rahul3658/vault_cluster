# Prerequisites

## Overview

Before deploying a HashiCorp Vault High Availability (HA) cluster, ensure that all required software, networking, and system prerequisites are available.

This document describes the environment used for this implementation and the minimum requirements for successfully deploying a Vault HA cluster using Docker Compose and Raft Integrated Storage.

---

# System Requirements

| Component | Requirement |
|------------|-------------|
| Operating System | Ubuntu 22.04 / Ubuntu 24.04 |
| CPU | Minimum 2 vCPU |
| Memory | Minimum 2 GB RAM (4 GB Recommended) |
| Storage | Minimum 20 GB |
| Docker | Latest Stable Version |
| Docker Compose | v2.x |

---

# Cluster Topology

This implementation uses three virtual machines.

| Node | Hostname | IP Address | Purpose |
|------|----------|------------|---------|
| Vault1 | master | 192.168.7.156 | Initial Leader |
| Vault2 | worker1 | 192.168.56.101 | Standby Node |
| Vault3 | worker2 | 192.168.56.102 | Standby Node |

---

# Network Requirements

All Vault nodes must be able to communicate with each other over the network.

Verify connectivity before deployment.

Example:

```bash
ping 192.168.56.101

ping 192.168.56.102

ping 192.168.7.156
```

Successful communication between nodes is mandatory for Raft replication and leader election.

---

# Required Ports

| Port | Purpose |
|------|----------|
| 8200 | Vault API & Web UI |
| 8201 | Raft Cluster Communication |

Verify the ports are accessible between all nodes.

Example:

```bash
nc -zv 192.168.56.101 8200
```

---

# Install Docker

Update package information.

```bash
sudo apt update
```

Install Docker.

```bash
sudo apt install docker.io docker-compose-plugin -y
```

Enable Docker.

```bash
sudo systemctl enable docker
```

Start Docker.

```bash
sudo systemctl start docker
```

Verify installation.

```bash
docker --version

docker compose version
```

Expected output:

```text
Docker version xx.xx.x

Docker Compose version v2.x.x
```

---

# Create Required Directories

Create configuration and data directories on every Vault node.

```bash
mkdir -p /opt/vault/config

mkdir -p /opt/vault/data
```

Directory structure:

```
/opt/vault

├── config

└── data
```

Purpose:

- **config** stores Vault configuration files.
- **data** stores the Raft database.

---

# Verify Docker Service

Ensure Docker is running.

```bash
systemctl status docker
```

Expected:

```text
Active: active (running)
```

---

# Verify Node Connectivity

Each Vault node must be reachable.

Example:

```bash
ping 192.168.56.101

ping 192.168.56.102
```

---

# Verify Hostname Resolution

(Optional)

Configure hostname resolution using the hosts file.

Example:

```text
192.168.7.156 master

192.168.56.101 worker1

192.168.56.102 worker2
```

Verify:

```bash
ping worker1

ping worker2
```

---

# Prerequisites Checklist

Before continuing, verify the following.

- Ubuntu installed
- Docker installed
- Docker Compose installed
- Three virtual machines available
- Network connectivity verified
- Required ports opened
- Vault directories created
- Docker service running

Once all prerequisites are completed, continue with **02-Vault-Configuration.md**.
