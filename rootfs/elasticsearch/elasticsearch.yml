cluster.name: ${CLUSTER_NAME}
network.host: ${NETWORK_HOST}

node:
  data: ${NODE_DATA}
  master: ${NODE_MASTER}
  name: ${NODE_NAME}
  ingest: false

cloud:
  kubernetes:
    service: ${SERVICE}
    namespace: ${KUBERNETES_NAMESPACE}

gateway:
  #recover_after_nodes: 70-80% of running nodes
  #expected_nodes: total number of nodes
  recover_after_time: 5m

discovery.zen.hosts_provider: kubernetes
discovery.zen.minimum_master_nodes: 2

path:
  data: /usr/share/elasticsearch/data
  logs: /usr/share/elasticsearch/logs

bootstrap.memory_lock: true

xpack.security.enabled: false