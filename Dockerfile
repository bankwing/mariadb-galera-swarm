FROM mariadb:10.1.22

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
      curl \
      pigz \
      pv \
    && curl -sSL -o /tmp/qpress.tar http://www.quicklz.com/qpress-11-linux-x64.tar \
    && tar -C /usr/local/bin -xf /tmp/qpress.tar qpress \
    && chmod +x /usr/local/bin/qpress \
    && rm -rf /tmp/* /var/cache/apk/* /var/lib/apt/lists/*

COPY conf.d/*                /etc/mysql/conf.d/
COPY *.sh                    /usr/local/bin/
COPY bin/galera-healthcheck  /usr/local/bin/galera-healthcheck
COPY primary-component.sql   /

EXPOSE 3306 4444 4567 4567/udp 4568 8080 8081

HEALTHCHECK CMD /usr/local/bin/healthcheck.sh

ENTRYPOINT ["start.sh"]
