FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /opt/pontus/pontus-gui-lgpd
RUN mkdir -p /opt/pontus/pontus-gui-gdpr
RUN mkdir -p /opt/pontus/pontus-gui-discovery

RUN useradd -u 1000 -s /bin/bash pontus 

COPY --chown=pontus:pontus --from=pontusvisiongdpr/pontus-gdpr-comply-lib /opt/pontus/pontus-gui-gdpr/lib /opt/pontus/pontus-gui-gdpr/lib
COPY --chown=pontus:pontus --from=pontusvisiongdpr/pontus-lgpd-comply-lib /opt/pontus/pontus-gui-lgpd/lib /opt/pontus/pontus-gui-lgpd/lib
COPY --chown=pontus:pontus --from=pontusvisiongdpr/pontus-extract-discovery-gui /opt/pontus/pontus-gui-discovery/lib /opt/pontus/pontus-gui-discovery/lib

#COPY --from=ca /create-keys.sh /
#COPY --from=ca /create-ca.sh /
#COPY --from=ca /etc/pki /etc/pki

#RUN chown -R pontus: /opt/pontus

#USER 1000

EXPOSE 18443
CMD  /usr/sbin/nginx -g "daemon off;"

