FROM fluent/fluentd:v0.12-debian
RUN apt-get -y update && \
		apt-get -y install ruby-dev make gcc

WORKDIR /home/fluent

# Add the ES forwarder
RUN gem install fluent-plugin-elasticsearch

RUN mkdir -p /var/log/modsec && \
		touch /var/log/modsec/audit.log

# Add fluentd-modsec plugin
COPY fluentd-modsecurity /tmp/fluentd-modsecurity
RUN cd /tmp/fluentd-modsecurity && \
		gem build fluent-plugin-modsecurity.gemspec && \
		fluent-gem install ./fluent-plugin-modsecurity-*.gem && \
		rm -rf /tmp/fluentd-modsecurity-master && \
		rm -rf *.zip

COPY config /home/fluent/config
CMD ["fluentd", "-c", "/home/fluent/config/fluent.conf"]
