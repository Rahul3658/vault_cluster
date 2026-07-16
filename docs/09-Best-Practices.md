# Best Practices

## Overview

This document outlines the recommended best practices for deploying and operating a HashiCorp Vault High Availability (HA) cluster in a production environment.

The current implementation is designed for learning and testing purposes. Production deployments should include additional security, monitoring, backup, and disaster recovery configurations.

---

# 1. Enable TLS

## Current Lab Configuration

```hcl
tls_disable = 1
```

TLS is disabled to simplify testing.

## Production Recommendation

Always enable TLS.

Benefits:

- Encrypts communication
- Prevents Man-in-the-Middle (MITM) attacks
- Secures API communication
- Secures Vault UI

Recommended Certificates:

- Server Certificate
- Private Key
- CA Certificate

---

# 2. Configure Auto Unseal

## Current Lab

Manual Unseal

```bash
vault operator unseal
```

Required after every Vault restart.

## Production Recommendation

Configure Auto Unseal using:

- AWS KMS
- Azure Key Vault
- Google Cloud KMS
- HSM (Hardware Security Module)

Benefits:

- No manual intervention
- Faster recovery
- Automatic startup after reboot

---

# 3. Use Vault Agent

Applications should not communicate directly with Vault.

Recommended Architecture

```
Application

↓

Vault Agent

↓

Vault HA Cluster
```

Benefits

- Lower latency
- Token management
- Secret caching
- Automatic token renewal

---

# 4. Enable Vault Agent Cache

Instead of requesting secrets from Vault for every application request, enable Vault Agent Cache.

```
Application

↓

Vault Agent Cache

↓

Vault Cluster
```

Benefits

- Reduced latency
- Reduced Vault load
- Improved application performance

---

# 5. Use Least Privilege Access

Avoid using the Root Token.

Instead:

- Create Policies
- Create AppRoles
- Assign minimum required permissions

Example

Application A

↓

Read Database Credentials

Only

---

# 6. Secure Unseal Keys

Never:

- Store in Git
- Share over email
- Store in plain text

Recommended:

- Password Manager
- Secure Vault
- HSM

---

# 7. Rotate Root Token

The Initial Root Token should only be used during initial configuration.

After setup:

- Create Administrator Policies
- Create Administrator Tokens
- Revoke the Initial Root Token

---

# 8. Enable Audit Logging

Enable Vault Audit Devices.

Example

```bash
vault audit enable file file_path=/var/log/vault_audit.log
```

Benefits

- User tracking
- Security auditing
- Compliance
- Troubleshooting

---

# 9. Monitor Vault

Monitor:

- CPU
- Memory
- Disk Usage
- Seal Status
- Leader Changes
- API Latency
- Raft Health

Recommended Tools

- Prometheus
- Grafana
- Loki
- Alertmanager

---

# 10. Configure Backup Strategy

Schedule regular Raft snapshots.

Example

```bash
vault operator raft snapshot save backup.snap
```

Store backups securely.

Recommended locations:

- S3
- Azure Blob Storage
- NFS
- Backup Server

---

# 11. Test Disaster Recovery

Regularly test:

- Node Failure
- Leader Failure
- Backup Restore
- Cluster Recovery

A backup is only useful if it can be successfully restored.

---

# 12. Use Odd Number of Nodes

Recommended cluster sizes:

- 3 Nodes
- 5 Nodes
- 7 Nodes

Avoid even-numbered clusters.

Reason:

Raft requires majority voting.

---

# 13. Use a Load Balancer

Applications should connect to a Load Balancer instead of individual Vault nodes.

Example

```
Application

↓

HAProxy / NGINX

↓

Vault Cluster
```

Benefits

- Simplified client configuration
- Automatic failover
- Better availability

---

# 14. Secure Network Communication

Restrict access to:

Port 8200

Port 8201

Allow only trusted servers and applications.

---

# 15. Monitor Certificate Expiry

If TLS is enabled, monitor certificate expiration dates.

Renew certificates before expiration.

---

# 16. Configure Resource Limits

For Docker deployments, configure:

- CPU Limits
- Memory Limits
- Restart Policy

This prevents resource exhaustion.

---

# 17. Perform Regular Updates

Keep Vault updated to the latest stable version.

Benefits:

- Security patches
- Bug fixes
- Performance improvements
- New features

Always test upgrades in a non-production environment before upgrading production.

---

# Production Architecture

```
                Client

                   |

            Load Balancer

                   |

      +------------+------------+

      |            |            |

  Vault1       Vault2       Vault3

   Leader      Standby      Standby

      |            |            |

      +------------+------------+

              Raft Storage

                   |

             Auto Unseal

                   |

               AWS KMS
```

---

# Summary

A production-ready Vault deployment should include:

- TLS Enabled
- Auto Unseal
- Vault Agent
- Vault Agent Cache
- Load Balancer
- Audit Logging
- Monitoring
- Backup Strategy
- Disaster Recovery Testing
- Least Privilege Access
- Regular Upgrades

Following these best practices improves security, availability, maintainability, and operational reliability.
