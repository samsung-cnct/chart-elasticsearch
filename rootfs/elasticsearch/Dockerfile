# Copyright 2016 Samsung SDS Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Base image: https://github.com/pires/docker-jre
FROM quay.io/pires/docker-jre:8u151
LABEL MAINTAINER="Jim Conner <snafu.x@gmail.com>"
LABEL DESCRIPTION="Elasticsearch container for Samsung SDS"

# Export HTTP & Transport
EXPOSE 9200 9300

ENV ES_VERSION 5.6.3

# Install Elasticsearch.
RUN apk add --no-cache --update elasticsearch>$ES_VERSION bash ca-certificates su-exec util-linux curl
RUN apk add --no-cache -t .build-deps gnupg openssl \
  && cd /tmp \
  && echo "===> Install Elasticsearch..." \
  && ls -lah \
  && mv /usr/share/java/elasticsearch /elasticsearch \
  && adduser -DH -s /sbin/nologin elasticsearch \
  && echo "===> Creating Elasticsearch Paths..." \
  && for path in \
    /elasticsearch/config \
    /elasticsearch/config/scripts \
    /elasticsearch/plugins \
  ; do \
  mkdir -p "$path"; \
  chown -R elasticsearch:elasticsearch "$path"; \
  done \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

ENV PATH /elasticsearch/bin:$PATH

WORKDIR /elasticsearch

# Copy configuration
COPY config /elasticsearch/config

# Copy run script
COPY run.sh /
RUN chown elasticsearch:elasticsearch /run.sh
RUN chmod +x /run.sh

# Set environment variables defaults
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"
ENV CLUSTER_NAME elasticsearch-default
ENV DISCOVERY_SERVICE elasticsearch-discovery
ENV NODE_MASTER true
ENV NODE_DATA true
ENV NODE_INGEST true
ENV HTTP_ENABLE true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV MAX_LOCAL_STORAGE_NODES 1
ENV SHARD_ALLOCATION_AWARENESS ""
ENV SHARD_ALLOCATION_AWARENESS_ATTR ""
ENV MEMORY_LOCK true

# Volume for Elasticsearch data
VOLUME ["/usr/share/elasticsearch"]

ADD limits.conf /etc/security/limits.conf

CMD ["/run.sh"]
