# Vault Agent

## Overview

Vault Agent is a lightweight process that runs alongside an application and acts as an intermediary between the application and the Vault server.

Instead of every application communicating directly with the Vault cluster, the application communicates with the local Vault Agent.

Vault Agent manages:

- Authentication
- Token Renewal
- Secret Caching
- Secret Rendering
- Lease Renewal

This reduces application complexity while improving performance and security.

---

# Why Vault Agent?

Without Vault Agent, every application request requiring a secret must communicate directly with the Vault cluster.

```

Application

↓

Vault Cluster

↓

Retrieve Secret

```

Problems:

- Higher network latency
- Increased Vault API requests
- Additional authentication overhead
- More load on the Vault cluster

---

# Architecture

```

           Application

                 |

         localhost:8100

                 |

          Vault Agent

                 |

         Vault HA Cluster

```

The application only communicates with the Vault Agent.

Vault Agent handles all communication with Vault.

---

# Vault Agent Features

Vault Agent provides the following capabilities:

- Auto Authentication
- Token Management
- Secret Caching
- Template Rendering
- Lease Renewal
- Token Renewal

---

# Auto Authentication

Applications should not store Vault Tokens.

Instead, Vault Agent authenticates automatically using supported authentication methods.

Supported methods include:

- AppRole
- Kubernetes Authentication
- AWS IAM
- Azure MSI
- GCP IAM
- Token (Testing only)

---

# Recommended Authentication

For Docker and Virtual Machines, AppRole is the recommended authentication method.

```

Application

↓

Vault Agent

↓

AppRole Login

↓

Vault Cluster

```

Benefits

- No hardcoded Root Token
- Limited permissions
- Automatic authentication
- Improved security

---

# Vault Agent Cache

Vault Agent supports in-memory caching.

When enabled, secrets are cached locally after the first request.

First Request

```

Application

↓

Vault Agent

↓

Vault Cluster

↓

Secret Retrieved

↓

Stored in Memory

```

Second Request

```

Application

↓

Vault Agent

↓

Memory Cache

```

No request is sent to Vault.

---

# Memory Cache vs File Storage

## Memory Cache

```

Application

↓

Vault Agent

↓

Memory

```

Advantages

- Very fast
- No disk storage
- Reduced latency
- More secure

Recommended for production.

---

## File Rendering

Vault Agent can also write secrets into files.

Example

```

Vault

↓

Vault Agent

↓

/etc/secrets/database.env

```

Advantages

- Compatible with legacy applications
- Easy integration
- Automatic file updates

Disadvantages

- Secrets stored on disk
- File permissions must be secured

---

# Agent Configuration Example

```hcl
pid_file = "/tmp/vault-agent.pid"

vault {
  address = "http://192.168.7.156:8200"
}

listener "tcp" {
  address = "0.0.0.0:8100"
  tls_disable = true
}

cache {
  use_auto_auth_token = true
}

api_proxy {
  use_auto_auth_token = true
}
```

---

# Auto Authentication Example

```hcl
auto_auth {

  method "approle" {

    mount_path = "auth/approle"

    config = {

      role_id_file_path = "/vault/role-id"

      secret_id_file_path = "/vault/secret-id"

    }

  }

  sink "file" {

    config = {

      path = "/tmp/vault-token"

    }

  }

}
```

Vault Agent automatically:

- Authenticates
- Retrieves a Vault Token
- Renews the Token
- Stores it securely

---

# Docker Deployment

Vault Agent can run as a separate Docker container.

```

Docker Host

|

├── Vault Server

├── Vault Agent

└── Application

```

The application communicates only with Vault Agent.

---

# Secret Retrieval Workflow

```

Application

↓

Vault Agent

↓

Memory Cache

↓

Vault Cluster (Only if cache miss)

```

---

# Secret Rotation

If a secret changes in Vault:

```

Vault

↓

Vault Agent

↓

Cache Refresh

↓

Application

```

Vault Agent automatically refreshes cached secrets based on their lease and TTL.

---

# Benefits

Using Vault Agent provides:

- Lower latency
- Reduced Vault load
- Automatic authentication
- Automatic token renewal
- Secret caching
- Improved application security
- Simpler application code

---

# Best Practices

- Use AppRole instead of Root Token.
- Enable Vault Agent Cache.
- Prefer memory cache over file storage when possible.
- Run Vault Agent close to the application (same VM or same Docker host).
- Use TLS in production.
- Apply least privilege policies.

---

# Production Architecture

```

              Application

                    |

           localhost:8100

                    |

              Vault Agent

      (Auto Auth + Cache)

                    |

             Vault Cluster

       +---------+---------+

       |                   |

    Vault1             Vault2

       |

    Vault3

```

---

# Summary

Vault Agent simplifies application integration with Vault by handling authentication, token renewal, and secret retrieval.

Using Vault Agent with in-memory caching reduces latency, decreases load on the Vault cluster, and improves security by eliminating the need for applications to manage Vault tokens directly.
