# Auto Unseal

## Overview

By default, HashiCorp Vault starts in a **sealed** state after every restart.

To become operational, Vault must be manually unsealed using the required number of Unseal Keys generated during initialization.

While manual unseal is suitable for learning and testing environments, production environments typically use **Auto Unseal** to automate this process.

Auto Unseal enables Vault to automatically retrieve the encryption key from a trusted external Key Management System (KMS) or Hardware Security Module (HSM) during startup.

---

# What is Seal?

When Vault starts, all secrets stored on disk are encrypted.

Vault keeps the Master Encryption Key protected and does not automatically load it into memory.

Therefore, Vault starts in the following state:

```
Initialized : true

Sealed : true
```

Applications cannot access secrets until Vault is unsealed.

---

# Manual Unseal

Current Lab Implementation

```
Vault Start

↓

Sealed

↓

Unseal Key 1

↓

Unseal Key 2

↓

Unseal Key 3

↓

Vault Ready
```

Example

```bash
vault operator unseal
```

Run the command three times using three different Unseal Keys.

---

# Limitations of Manual Unseal

Manual unseal introduces operational challenges.

- Manual intervention required
- Longer recovery time
- Difficult to automate
- Not suitable for auto-scaling
- Service unavailable until unsealed

For production environments, Auto Unseal is recommended.

---

# Auto Unseal

Auto Unseal allows Vault to automatically decrypt the Master Key during startup.

```
Vault Start

↓

AWS KMS

↓

Decrypt Master Key

↓

Vault Ready
```

No Unseal Keys are required during startup.

---

# Auto Unseal Workflow

```
          Vault Starts

                |

                ▼

      Request Encryption Key

                |

                ▼

     External KMS / HSM

                |

                ▼

      Master Key Returned

                |

                ▼

        Vault Unsealed
```

---

# Supported Auto Unseal Providers

HashiCorp Vault supports multiple Auto Unseal providers.

| Provider | Description |
|----------|-------------|
| AWS KMS | AWS Key Management Service |
| Azure Key Vault | Microsoft Azure Key Management |
| Google Cloud KMS | Google Cloud Key Management |
| PKCS#11 HSM | Hardware Security Module |
| HashiCorp Transit | Another Vault Cluster |

---

# AWS KMS

One of the most commonly used production options.

Architecture

```
Vault

↓

AWS KMS

↓

Decrypt Master Key

↓

Vault Ready
```

Benefits

- Fully managed
- Highly available
- Secure
- Automatic recovery

---

# Azure Key Vault

For workloads running on Microsoft Azure.

```
Vault

↓

Azure Key Vault

↓

Vault Unsealed
```

---

# Google Cloud KMS

For workloads deployed on Google Cloud.

```
Vault

↓

Google Cloud KMS

↓

Vault Ready
```

---

# HashiCorp Transit Auto Unseal

A dedicated Vault cluster can be used to unseal another Vault cluster.

Architecture

```
Production Vault

↓

Transit Engine

↓

Recovery Vault
```

Common use cases

- Multi-cluster environments
- Disaster Recovery
- Enterprise deployments

---

# HSM (Hardware Security Module)

Highly secure option for enterprise deployments.

```
Vault

↓

Hardware Security Module

↓

Decrypt Master Key
```

Benefits

- Highest security
- FIPS compliance
- Hardware-protected keys

---

# Configuration Example (AWS KMS)

```hcl
seal "awskms" {
  region     = "ap-south-1"
  kms_key_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

At startup, Vault automatically communicates with AWS KMS to retrieve the key required to decrypt the Master Key.

---

# Manual Unseal vs Auto Unseal

| Feature | Manual Unseal | Auto Unseal |
|----------|---------------|-------------|
| Manual Intervention | Required | Not Required |
| Startup Recovery | Manual | Automatic |
| Suitable for Production | No | Yes |
| Uses Unseal Keys | Yes | No (during startup) |
| Automation Friendly | No | Yes |

---

# High Availability with Auto Unseal

```
                Load Balancer

                      |

        +-------------+-------------+

        |             |             |

     Vault1       Vault2       Vault3

        |             |             |

        +-------------+-------------+

                      |

                  AWS KMS
```

If a Vault node restarts:

```
Node Restart

↓

Vault Starts

↓

AWS KMS

↓

Vault Automatically Unsealed

↓

Node Rejoins Cluster
```

No administrator action is required.

---

# Benefits

Using Auto Unseal provides:

- Faster recovery
- Automatic startup
- Reduced operational effort
- Better availability
- Suitable for Kubernetes
- Suitable for Docker
- Suitable for Cloud deployments

---

# Security Considerations

- Protect access to the KMS.
- Apply least privilege IAM permissions.
- Enable KMS auditing.
- Rotate encryption keys regularly.
- Monitor KMS availability.

---

# Best Practices

- Use Auto Unseal in production.
- Use cloud-native KMS when deploying in AWS, Azure, or GCP.
- Restrict KMS access using IAM roles.
- Test Auto Unseal after every upgrade.
- Keep recovery procedures documented.

---

# Summary

Manual Unseal is appropriate for development and testing environments.

Production environments should use Auto Unseal with a trusted Key Management Service or Hardware Security Module to ensure Vault automatically becomes available after restarts while maintaining strong security controls.
