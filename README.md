# Chart for Elasticsearch

[![Build Status](https://jenkins.migrations.cnct.io/buildStatus/icon?job=pipeline-elasticsearch/master)](https://jenkins.migrations.cnct.io/job/pipeline-elasticsearch/job/master)

A Helm chart for Elasticsearch deployment on Kubernetes. Elasticsearch is an open source, RESTful search engine built on top of Apache Lucene and released under an Apache license. It is Java-based and can search and index document files in diverse formats.

## Purpose
Static configs for a production grade elasticsearch deploy on kubernetes.

## Architecture details
master nodes:
 - 3 node statefulset
 - if scaled, need to update quorum information

 data nodes:
 - 3 node statefulset
 - scale at will

## Kubernetes Resources
master node (each):
 - 4GB
 - 1/2 CPU (500m)

data nodes (each):
 - 4GB  (first knob to turn up for performance reasons.  Do not exceed 31GB, the jvm breaks down)
 - 1/2 CPU (500m)
 - 20GB of disk (this should be increased greatly for production use)

## Installation
 ``` 
 helm repo add cnct https://charts.migrations.cnct.io 
 helm repo update
 helm install cnct/elasticsearch-chart --name=es-test --namespace=logging --debug   --set security.password="mlnpass"
 ```  

## Curator
This deployment is meant for use with Elasticsearch curator to manage indices.
See the [chart](https://github.com/samsung-cnct/chart-curator) and [container](https://github.com/samsung-cnct/chart-curator/tree/master/rootfs/curator) for more information.

###  [Guide to Elasticsearch Index Performance](https://www.elastic.co/guide/en/elasticsearch/guide/current/indexing-performance.html)
