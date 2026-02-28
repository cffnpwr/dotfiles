# Secret Management Workflow

## Overview

This project uses **agenix** for managing secrets with age encryption.

**Key Concepts:**
- Secrets are encrypted with age encryption
- Encryption key: `~/.config/age/key.txt` (must have 600 permissions)
- Secret definitions: `secrets/secrets.nix`
- Encrypted files: `secrets/*.age`

## Security Requirements

**YOU MUST:**
- Get user permission before outputting secret content to logs
- Never display confidential information (passwords, tokens, API keys)
- Always verify encryption status after editing
- Verify key permissions (600) for `~/.config/age/key.txt`

**NEVER:**
- Output confidential information to diff or logs
- Display encrypted file content in plain text
- Commit unencrypted secrets to repository

## Common Operations

### Editing Existing Secret

```bash
# Edit encrypted secret (uses $EDITOR)
agenix -e secrets/github-token.age

# Your editor will open with decrypted content
# Make changes, save, and close
# File will be automatically re-encrypted
```

**Verification:**
```bash
# Verify file is still encrypted (should show binary data)
file secrets/github-token.age
# Output: secrets/github-token.age: data
```

### Adding New Secret

#### Step 1: Define Secret

Edit `secrets/secrets.nix`:

```nix
{
  # Add new secret definition
  "my-secret.age".publicKeys = [
    # Add authorized public keys
    "age1..." # Your age public key
  ];
}
```

#### Step 2: Create Encrypted File

```bash
# Create and edit new secret
agenix -e secrets/my-secret.age

# Enter secret content in your editor
# Save and close to encrypt
```

#### Step 3: Reference in Nix Module

Edit appropriate module to use the secret:

```nix
{
  age.secrets.my-secret = {
    file = ../../secrets/my-secret.age;
    # Optional: specify owner, group, mode
  };
}
```

#### Step 4: Deploy

```bash
# Build and deploy
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

### Rekeying Secrets

After changing age key or adding new authorized keys:

```bash
# Rekey all secrets
agenix --rekey

# This will re-encrypt all secrets with updated keys
```

### Verifying Secret Permissions

```bash
# Check age key permissions (must be 600)
ls -l ~/.config/age/key.txt
# Expected: -rw------- 1 user group ... key.txt

# Fix permissions if needed
chmod 600 ~/.config/age/key.txt
```

## Secret Access in System

After deployment, decrypted secrets are available at:
```
/run/agenix/<secret-name>
```

**Example:**
```nix
# In Nix configuration
age.secrets.github-token.file = ../../secrets/github-token.age;

# Access in programs
programs.git.extraConfig.credential.helper =
  "!f() { echo \"password=$(cat /run/agenix/github-token)\"; }; f";
```

## Troubleshooting

### Cannot Edit Secret

**Issue:** `agenix -e` fails with permission error

**Solution:**
```bash
# Check age key exists and has correct permissions
ls -l ~/.config/age/key.txt
chmod 600 ~/.config/age/key.txt

# Verify you're using correct key
# Your public key should be in secrets/secrets.nix
```

### Secret Not Available After Deployment

**Issue:** `/run/agenix/<secret-name>` doesn't exist

**Solution:**
```bash
# Check secret is defined in secrets/secrets.nix
# Check secret is referenced in Nix module
# Rebuild and redeploy
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

### Forgot to Rekey After Key Change

**Issue:** Secrets can't be decrypted after changing age key

**Solution:**
```bash
# Use old key to rekey with new key
# 1. Restore old key temporarily
# 2. Run rekey
agenix --rekey
# 3. Switch back to new key
```

## Best Practices

1. **Minimal Exposure**: Only decrypt secrets when necessary
2. **Access Control**: Limit which programs/services can access secrets
3. **Regular Rotation**: Periodically update sensitive credentials
4. **Version Control**: Commit encrypted `.age` files, NEVER plaintext
5. **Backup Keys**: Keep secure backup of age private key
6. **Verify Encryption**: Always verify files are encrypted after editing
