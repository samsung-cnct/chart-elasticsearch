{{ define "unencode-certificates.sh.tpl" }}

#!/bin/bash

echo 'Starting startup script.'

# strict mode
set -euo pipefail

# lazy init elastic-certificates.p12 file; try to read and if read fails create cert and write it to Vault
# an unset value comes back as as empty response return 0 (success)
export P12=/usr/share/elasticsearch/config/elastic-certificates.p12
base64 -d ${P12}.b64 > $P12

echo "Setting permissions"
# set permissions of elastic-certificates.p12
chown elasticsearch $P12
chmod 700 $P12
echo "Done with startup script."

{{ end }}