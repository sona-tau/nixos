# secrets/

Encrypted secrets managed by [sops-nix](https://github.com/Mic92/sops-nix).
Secrets are encrypted with age keys derived from SSH host keys (machine decryption)
and the user SSH key (manual access). See `../.sops.yaml` for key groups.

## First-time setup

Derive your age private key from your SSH key and store it:

```bash
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519" >> ~/.config/sops/age/keys.txt
```

## Creating / editing secrets

```bash
# Create or edit a secrets file (opens $EDITOR)
nix-shell -p sops --run "sops secrets/hp.yaml"
```

## Using a secret in NixOS config

```nix
# Declare the secret
sops.secrets."borgbackup/passphrase" = {};

# Reference the decrypted file path at runtime
services.borgbackup.jobs.main.encryption.passCommand =
  "cat ${config.sops.secrets."borgbackup/passphrase".path}";
```

## Adding a new machine

1. Get the host's age key:
   ```bash
   nix-shell -p ssh-to-age --run "ssh-to-age" < /etc/ssh/ssh_host_ed25519_key.pub
   ```
2. Add it to `.sops.yaml` under `keys` and the relevant `creation_rules`
3. Re-encrypt existing secrets to include the new key:
   ```bash
   nix-shell -p sops --run "sops updatekeys secrets/hp.yaml"
   ```
