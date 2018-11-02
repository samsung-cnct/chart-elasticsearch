{{ define "hello.sh.tpl" }}

#!/bin/bash

echo 'Starting vault-setup.'

# strict mode
set -euo pipefail

home_dir=$(pwd)
# create Certificate Authority in home_dir
${home_dir}/bin/elasticsearch-certutil ca -v --out elastic-stack-ca.p12 --pass ''
# create certificate in /usr/elasticsearch/data
${home_dir}/bin/elasticsearch-certutil cert -v --ca elastic-stack-ca.p12 --ca-pass '' --pass '' --out /usr/share/elasticsearch/config/elastic-certificates.p12 
chown elasticsearch /usr/share/elasticsearch/config/elastic-certificates.p12
chmod 700 /usr/share/elasticsearch/config/elastic-certificates.p12

# no kubectl command!
yum -y install kubernetes

# install HashiCorp Vault
cd bin
wget https://releases.hashicorp.com/vault/0.11.3/vault_0.11.3_linux_amd64.zip
unzip vault_0.11.3_linux_amd64.zip
cd ..

#vault_ip=$(kubectl get service vault-service -nlogging -ojsonpath='{$.spec.clusterIP}')
export vault_dns=$(kubectl get services vault-service -nlogging -o jsonpath="{.status.loadBalancer.ingress..hostname}")
export VAULT_ADDR=http://${vault_dns}:8200
export VAULT_TOKEN=roottoken

vault status
vault kv put secret/hello foo=world

{{ end }}