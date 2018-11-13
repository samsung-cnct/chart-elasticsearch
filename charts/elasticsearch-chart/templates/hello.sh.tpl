{{ define "hello.sh.tpl" }}

#!/bin/bash

echo 'Starting vault-setup.'

# strict mode
set -euo pipefail

home_dir=$(pwd)

# install kubectl
yum -y install kubernetes

# install HashiCorp Vault
cd bin
wget https://releases.hashicorp.com/vault/0.11.3/vault_0.11.3_linux_amd64.zip
echo "Downloaded Vault."
unzip vault_0.11.3_linux_amd64.zip
echo "Unzipped Vault."
cd ..

echo 'Installed kubectl and vault.'

#                                                                     remove "IP:" followed by any number of blanks, leaving just the IP value
export vault_ip=$(kubectl describe pod hashicorp-vault-0 | grep IP: | sed -e 's/IP:[[:blank:]]*//')
export VAULT_ADDR=http://${vault_ip}:8200
echo "VAULT_ADDR is $VAULT_ADDR"
export VAULT_TOKEN=roottoken

# smoke test for Vault
vault status
echo "Smoke test passed."

# lazy init elastic-certificates.p12 file; try to read and if read fails create cert and write it to Vault
# an unset value comes back as as empty response return 0 (success)
export P12_DATA=$(vault kv get -field=value secret/elastic-certificates.p12)
# if P12_DATA is not empty
if [[ ! -z "$P12_DATA" ]]; then
	echo "Using stored P12 cert"
	vault kv get -field=value secret/elastic-certificates.p12 > /usr/share/elasticsearch/config/elastic-certificates.p12
else
	echo "Creating P12 cert."
	# create Certificate Authority in home_dir
	${home_dir}/bin/elasticsearch-certutil ca -v --out elastic-stack-ca.p12 --pass ''
	# create certificate in /usr/elasticsearch/data
	${home_dir}/bin/elasticsearch-certutil cert -v --ca elastic-stack-ca.p12 --ca-pass '' --pass '' --out /usr/share/elasticsearch/config/elastic-certificates.p12 
	vault kv put secret/elastic-certificates.p12 value=@/usr/share/elasticsearch/config/elastic-certificates.p12
fi

echo "Setting permissions"
# set permissions of elastic-certificates.p12 regardless of lazy-init
chown elasticsearch /usr/share/elasticsearch/config/elastic-certificates.p12
chmod 700 /usr/share/elasticsearch/config/elastic-certificates.p12
echo "Done with startup script."

{{ end }}