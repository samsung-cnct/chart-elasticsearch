[![pipeline status](https://git.cnct.io/common-tools/samsung-cnct_chart-elasticsearch/badges/master/pipeline.svg)](https://git.cnct.io/common-tools/samsung-cnct_chart-elasticsearch/commits/master)

# Chart for Elasticsearch

A Helm chart for Elasticsearch deployment on Kubernetes. Elasticsearch is an open source, RESTful search engine built on top of Apache Lucene and released under an Apache license. It is Java-based and can search and index document files in diverse formats.

## Purpose
Static configs for a production grade elasticsearch deploy on kubernetes. Meant for use with [this](https://quay.io/repository/samsung_cnct/elasticsearch-container) image on quay.

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

## How to install on running Kubernetes cluster with `helm`
Install Helm and the Helm registry plugin with [these](https://github.com/app-registry/appr-helm-plugin/blob/master/README.md#install-the-helm-registry-plugin) instructions.

```
helm registry install quay.io/samsung_cnct/elasticsearch-chart
```

## How to implement on running Kubernetes cluster with `kubectl`
```
kubectl create -f es-data-statefulset.yaml
kubectl create -f es-master-statefulset.yaml
kubectl create -f services.yaml
```
For cluster with kubernetes version >= 1.6, `kubectl create -f es-rbac.yaml`

## Curator
This deployment is meant for use with Elasticsearch curator to manage indices.
See the [chart](https://github.com/samsung-cnct/chart-curator) and [container](https://github.com/samsung-cnct/container-curator) for more information.

###  [Guide to Elasticsearch Index Performance](https://www.elastic.co/guide/en/elasticsearch/guide/current/indexing-performance.html)
