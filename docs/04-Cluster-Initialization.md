# Vault Cluster Initialization

## Overview

After deploying the Vault containers, the next step is to initialize the Vault cluster.

**Important:** Only the **first Vault node** should be initialized.

Once initialized, the remaining Vault nodes will join the existing cluster using the Raft protocol.

Initializing multiple nodes will create multiple independent Vault clusters, which is incorrect.

---

# Cluster Status Before Initialization

Initially, all Vault nodes are running but are **not initialized**.

```
Vault1

Initialized : false

Sealed : true
```

```
Vault2

Initialized : false

Sealed : true
```

```
Vault3

Initialized : false

Sealed : true
```

At this stage:

- No leader exists.
- No secrets can be stored.
- No Raft cluster has been created.

---

# Initialize Vault

Run the following command **only on Vault1**.

```bash
docker exec -it \
-e VAULT_ADDR=http://127.0.0.1:8200 \
vault vault operator init
```

Example Output

```
Unseal Key 1: xxxxxxxxxxxxxxxxx

Unseal Key 2: xxxxxxxxxxxxxxxxx

Unseal Key 3: xxxxxxxxxxxxxxxxx

Unseal Key 4: xxxxxxxxxxxxxxxxx

Unseal Key 5: xxxxxxxxxxxxxxxxx

Initial Root Token:

hvs.xxxxxxxxxxxxxxxxxxxxxxxxx
```

Store the Unseal Keys and Root Token securely.

These values are displayed **only once** during initialization.

---

# What Happens During Initialization?

During initialization, Vault performs the following actions:

1. Generates the Master Encryption Key.
2. Splits the Master Key using Shamir Secret Sharing.
3. Creates the Initial Root Token.
4. Initializes the Raft storage.
5. Marks the Vault cluster as initialized.

After initialization:

```
Vault1

Initialized : true

Sealed : true
```

Notice that Vault is still **sealed**.

Initialization does **not** automatically unseal Vault.

---

# Shamir Secret Sharing

Vault protects the Master Encryption Key using **Shamir Secret Sharing**.

Instead of storing the Master Key directly, Vault splits it into multiple key shares.

Example:

```
Master Key

↓

Split Into

↓

Key1

Key2

Key3

Key4

Key5
```

By default:

```
Total Keys = 5

Threshold = 3
```

This means:

Any **3** keys are sufficient to reconstruct the Master Key.

Examples:

```
Key1

Key2

Key3

✓ Success
```

```
Key2

Key4

Key5

✓ Success
```

```
Key1

Key5

✗ Not enough keys
```

---

# Unseal Keys

The Unseal Keys are used only to reconstruct the Master Key when Vault starts.

They are **not** authentication credentials.

Purpose:

- Unseal Vault
- Recover Master Key

They cannot be used to:

- Login
- Read Secrets
- Create Secrets

---

# Root Token

The Initial Root Token is the administrator credential generated during initialization.

Purpose:

- Login to Vault
- Create Policies
- Enable Authentication Methods
- Manage Secrets
- Configure Vault

Example Login

```bash
vault login
```

Paste the Initial Root Token when prompted.

---

# Verify Initialization

Check the Vault status.

```bash
docker exec -it \
-e VAULT_ADDR=http://127.0.0.1:8200 \
vault vault status
```

Expected Output

```
Initialized

true

Sealed

true
```

The Vault cluster is initialized but still sealed.

---

# Why Only One Node is Initialized?

A Vault HA cluster represents **one logical Vault**.

Only one node should create the cluster metadata.

Initializing Vault2 or Vault3 would create a completely separate Vault cluster.

Correct Workflow:

```
Vault1

↓

Initialize

↓

Leader
```

```
Vault2

↓

Join Existing Cluster
```

```
Vault3

↓

Join Existing Cluster
```

Never execute:

```
vault operator init
```

on Vault2 or Vault3.

---

# Common Mistake

Incorrect:

```
Vault1

↓

Init
```

```
Vault2

↓

Init
```

```
Vault3

↓

Init
```

Result:

Three independent Vault clusters.

No High Availability.

No Replication.

---

Correct:

```
Vault1

↓

Init
```

```
Vault2

↓

Raft Join
```

```
Vault3

↓

Raft Join
```

Result:

Single Vault HA Cluster.

---

# Security Best Practices

- Store Unseal Keys securely.
- Store the Root Token securely.
- Never commit keys into Git.
- Never store the Root Token in application code.
- Rotate the Root Token after initial setup.
- Enable Auto Unseal in production.

---

# Initialization Checklist

Verify the following:

- Vault initialized successfully.
- Five Unseal Keys generated.
- Root Token generated.
- Vault status shows Initialized = true.
- Vault remains sealed until manually unsealed.

---

# Next Step

Continue with:

```
docs/05-Unseal-and-Raft-Join.md
```

In the next document:

- Unseal Vault1.
- Join Vault2 to the Raft cluster.
- Join Vault3 to the Raft cluster.
- Verify leader election.
- Verify cluster members.
