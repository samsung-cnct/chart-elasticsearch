{{ define "elasticsearch.yml.tpl" }}
cluster.name: ${CLUSTER_NAME}
network.host: ${NETWORK_HOST}

node:
  master: ${NODE_MASTER}
  name: ${NODE_NAME}
  data: ${NODE_DATA}
  ingest: false

path:
  data: ${DATA_MOUNT}
  logs: /usr/share/elasticsearch/logs

bootstrap:
  memory_lock: ${MEMORY_LOCK}

gateway:
  #recover_after_nodes: 70-80% of running nodes
  #expected_nodes: total number of nodes
  recover_after_time: 5m

http:
  enabled: ${HTTP_ENABLE}
  compression: true
  cors:
    enabled: ${HTTP_CORS_ENABLE}
    allow-origin: ${HTTP_CORS_ALLOW_ORIGIN}

discovery:
  zen:
    ping.unicast.hosts: ${DISCOVERY_SERVICE}
    minimum_master_nodes: 2
    
action.auto_create_index: true 
xpack.security.enabled: true 
xpack.license.self_generated.type: trial 
xpack.monitoring.enabled: false

# enable and configure SSL
# .p12 file must be executable (e.g. chmod 700)
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate 
xpack.security.transport.ssl.keystore.path: elastic-certificates.p12 
xpack.security.transport.ssl.truststore.path: elastic-certificates.p12

#xpack.monitoring.exporters.my_local:
#  type: local
#  use_ingest: false

{{ end }}

