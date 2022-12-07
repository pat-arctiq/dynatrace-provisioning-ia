#
# Copyright (c) 2022 iA Financial Group
#
#
#
#  Name: installs.sh
#
#  -- Installs Python locally and sets up two different Ansible versions.
#     The Ansible 2.9 is needed to install the Dynatrace OneAgent and the version 2.10
#
#  Usage:
#
#	 install.sh  [ azure | python | ansible] ...<see display_usage>...
#
#  Exit/Return Status:
#	0       setup procedure completed.
#	1       setup procedure did not complete.
#
ANSIBLE_WORKSPACE="~/ansible_ws"
#ANSIBLE_2_9="2.9.27"
ANSIBLE_2_10="2.10.7"

########################################################################################################################
# Installs Azure CLI and Azure collections for Ansible
#
########################################################################################################################

function install_azure_tools(){
  brew update && brew install azure-cli
}

####################################################################################################################
# Installs and validates Python versions with pyenv
#
####################################################################################################################

function setup_python(){

  local py_version
   brew install pyenv
#   pyenv install 3.11.0
#   pyenv install 3.10.0
   pyenv install 3.9.1

   pyenv local 3.9.1
   py_version=$(python -V) # it should give 3.9.1pip install -r requirements-azure.txt
#   pyenv local 3.10
#   py_version=$(python -V)# it should give 3.10
#   pyenv local 3.11.0
#   py_version=$(python -V) # it should give 3.11
   echo "Current local Python versions is '${py_version}'"

}

####################################################################################################################
# Installs Ansible 2.9 and 2.10
#
####################################################################################################################

function create_ansible_envs(){
  mkdir -p "${ANSIBLE_WORKSPACE}"  && cd "${ANSIBLE_WORKSPACE}"
  pyenv local 3.9.1
#  python -m venv ansible2.9
#  source ansible2.9/bin/activate
#  pip install "ansible=='${ANSIBLE_2_9}'"
#  ansible --version # it should display 2.9.27

  python -m venv ansible2.10
  source ansible2.10/bin/activate
  pip install "ansible=='${ANSIBLE_2_10}'"
  ansible --version # it should display 2.10.7
  cp ./ssh/dynatrace-az-vm ${ANSIBLE_WORKSPACE}/ansible2.10/
  cp ./*.yaml ${ANSIBLE_WORKSPACE}/ansible2.10/
  cp ../../*.yaml ${ANSIBLE_WORKSPACE}/ansible2.10/
  curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
  pip install -r requirements-azure.txt


}

####################################################################################################################
# Activates Ansible 2.10 and create a Linux machine in Azure
#
####################################################################################################################

function activate_ansible_env_for_azure_provisioning(){

  cd "${ANSIBLE_WORKSPACE}"
  source ansible2.10/bin/activate
  ansible --version # it should display 2.10
  export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
  pip install pywinrm

  alias create_azure_linuxvm="ansible-playbook ./create-linux-machine.yaml"
  alias create_azure_winvm="ansible-playbook ./create-win-machine.yaml"
  alias destroy_azure_vm="ansible-playbook ./delete_rg.yml --extra-vars  'name=myResourceGroup'"
  alias provision_oneagent-lin="ansible-playbook ./install-oneagent-on-linux.yaml -i ./inventory.yml  --ask-become-pass -vvvv"
  alias provision_oneagent-win="ansible-playbook ./install-oneagent-on-win.yaml -i ./inventory.yml  --ask-become-pass -vvvv"
#
}

function download_linux_one_agent(){
   wget  -O Dynatrace-OneAgent-Linux-1.253.245.sh "https://wna22894.live.dynatrace.com/api/v1/deployment/installer/agent/unix/default/latest?arch=x86&flavor=default" --header="Authorization: Api-Token dt0c01.F2ERUVCE5YMLLFUA6CGERT4B.EYUL7QDYT7INA62KS55HIGKST3UPPOGO6L3UGCLINX5SFB6AX2S7KIBZZTSFDUEO"
   wget https://ca.dynatrace.com/dt-root.cert.pem ; ( echo 'Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha-256"; boundary="--SIGNED-INSTALLER"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; cat Dynatrace-OneAgent-Linux-1.253.245.sh ) | openssl cms -verify -CAfile dt-root.cert.pem > /dev/null
}


####################################################################################################################
# Displays how to use the script
#
####################################################################################################################
function display_usage() {
  echo "Usage: $0 [azure python ansible]"
  echo "-azure - Installs Azure CLI"
  echo "-python - Installs Python 3.9.1 "
  echo "-ansible - Installs several versions of Ansible. Supported Ansible version is 2.10.7" 1>&2; exit 1;
  echo "-oneagent - Installs OneAgent on Windows and Linux machines" 1>&2; exit 1;

}

# main starts here
while getopts "azure:python:ansible" flag;
  do
      case "${flag}" in
          azure) echo "Installs Azure CLI"
            install_azure_tools
             ;;
          python) echo "Installs Python 3.9.1"
             setup_python
             ;;
          ansible)
            echo "Installs Ansible environments 2.10"
             create_ansible_envs
             ;;
          oneagent)
            echo "Installs OneAgent"
            activate_ansible_env_for_azure_provisioning
            ;;
          h) display_usage ;;
          \?)
              echo "Invalid option: -$OPTARG" >&2
              display_usage
              ;;
      esac
  done

git clone https://pat-arctiq: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@github.com/pat-arctiq/dynatrace-provisioning-ia.git



