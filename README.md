# dynatrace-provisioning-ia

Contains Ansible code to automate the installation of OneAgent Dynatrace in Win and Linux machines

## Overview

- [Pre-requisites](#pre-requisites)
- [Project structure](#project-structure)
- [Mac setup](#mac-setup)
- [References](#references)


## Pre-requisites
- Python 3.9.1
- Ansible 2.10.7 to install Dynatrace OneAgent
- Download the Dynatrace OneAgent
- Have a valid Azure Subscription

## Project structure

```
├── create-azure-infra
│   ├── ssh
├── files
├── src
```
- Directory *create-azure-infra* has the Ansible code to create the infrastructure in Azure to host the OneAgent installations.
- Directory *create-azure-infra/ssh* has the private and public SSH keys used for SSH access to the Linux Azure machine.
- Directory *files* has the OneAgent installers for Windows and Linux. See [references](#references).
- Directory *src* has the Ansible playbooks to install OneAgent in both Linux and Windows machines.


# Mac Setup

1. Execute script install.sh located in *src* directory.
```bash
install.sh -h - Displays the usage of the Bash script
install.sh -python - Installs Python 3.9.1
install.sh -azure - Installs Azure CLI
install.sh -ansible - Installs several versions of Ansible. Supported Ansible version is 2.10.7

# Retrieves the public ip addresses of the VMs and add them to the inventory.yml file
install.sh -oneagent - Installs OneAgent on Windows and Linux machines
```

2. Cloning the project

```bash
https://pat-arctiq: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@github.com/pat-arctiq/dynatrace-provisioning-ia.git

```


## References
- [List of Azure VM](https://learn.microsoft.com/en-us/azure/backup/backup-azure-policy-supported-skus)
- [Comparing Azure VM](https://azureprice.net/?_memoryInMB_min=8.5)
- [Install OneAgent on Linux](https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent/installation-and-operation/linux/installation/install-oneagent-on-linux)
- [Customize OneAgent on Linux](https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent/installation-and-operation/linux/installation/customize-oneagent-installation-on-linux)
- [Install OneAgent on Windows](https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent/installation-and-operation/windows/installation/install-oneagent-on-windows)
- [Customize OneAgent on Windows](https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-oneagent/installation-and-operation/windows/installation/customize-oneagent-installation-on-windows)
