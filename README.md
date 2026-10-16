# LogicMonitor + HCP Terraform POC

This repository has two **separate Terraform root modules**. Use **two separate HCP Terraform VCS-driven workspaces** if testing both.

## 1. `basic/`: start here

- No cloud credentials or SSH credentials required.
- Built-in `terraform_data` resource; no additional provider download needed.
- In HCP Terraform, create a VCS-driven workspace with **Working Directory = `basic`**.
- Queue a plan, then apply. Outputs are `message` and `environment`.
- Later test starting a run using HCP Terraform `POST /runs` and polling `GET /runs/{run_id}`.
- To run locally instead: `cd basic && terraform init && terraform apply`.

## 2. `linux-ssh/`: optional Linux connectivity test

This uses `terraform_data` with a `remote-exec` provisioner to run read-only commands over SSH. This is a connectivity demonstration, **not** a recommended general-purpose remediation engine. Provisioners only execute on resource creation/replacement. To re-execute, change `execution_id`, which will replace the Terraform resource in state.

- Create another VCS-driven HCP Terraform workspace with **Working Directory = `linux-ssh`**.
- Set these **Terraform variables** in Workspace > Variables:
  - `linux_host`: DNS or IP of your Linux host.
  - `ssh_user`: e.g. `ec2-user` or `ubuntu` (optional; defaults to ec2-user).
  - `ssh_private_key`: the **contents**, not the path, of the SSH private key. Mark **Sensitive**. Never commit this to Git.
  - `ssh_host_key`: the *verified* public host key, such as `ssh-ed25519 AAAAC3...` (not your user's public key). Obtain and verify it through a trusted channel.
  - `execution_id`: change from `run-001` to `run-002` for another execution.
- Allow inbound TCP 22 from the actual Terraform runner to the Linux test host. Confirm host reachability before running. HCP-hosted agents normally **cannot reach private-only Linux IPs**. For private networks, use a suitable private runner or execute the module locally on a machine with access.
- Queue a plan and apply; inspect the run logs for `hostname`, `uname`, `id`, and `date`.
- When executing locally, `cd linux-ssh && terraform init && terraform apply` and supply variables through secure local inputs. Avoid shell history and plaintext secrets.

## Important limitations

- VCS workflow controls configuration sourcing; HCP Terraform REST APIs can trigger runs regardless of VCS sourcing.
- Terraform plans do **not** execute provisioners. They execute during apply on creation or replacement.
- If HCP Terraform is performing remote runs, `local-exec` runs on its runner, **not** on your laptop or target Linux server.
- `terraform_data` is a logical resource in Terraform state; it does not create an EC2 instance or expose a managed-host inventory.
- Prefer AWS SSM, configuration management, or controlled job runners for production host commands.
# terraform-lm-poc
