FROM node as builder
WORKDIR /

RUN  git clone  --depth 1    --single-branch  --branch master https://github.com/pontusvision/pontus-lgpd-gui.git && \
     cd pontus-lgpd-gui && \
     ./build-local.sh

RUN  git clone --depth 1 --single-branch --branch master https://github.com/pontusvision/pontus-gdpr-gui.git && \
     cd pontus-gdpr-gui && \
     ./build-local.sh

#FROM pontusvisiongdpr/pontus-ca-base as ca
#RUN /create-ca.sh

FROM  node:7 as discovery-ui
WORKDIR /

RUN git clone --single-branch --depth 1  --branch pontus-2.5.1  https://github.com/pontus-vision/pontusvision-extract-discovery.git && \
    cd pontusvision-extract-discovery/dataprep-webapp && \
    npm install -g strip-ansi npm && \
    npm install

RUN cd pontusvision-extract-discovery/dataprep-webapp && \
    npm  run-script build:dist

FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /opt/pontus/pontus-gui-lgpd
RUN mkdir -p /opt/pontus/pontus-gui-gdpr
RUN mkdir -p /opt/pontus/pontus-gui-discovery

RUN useradd -u 1000 -s /bin/bash pontus 

COPY --from=builder /pontus-lgpd-gui/build /opt/pontus/pontus-gui-lgpd/lib
COPY --from=builder /pontus-gdpr-gui/build /opt/pontus/pontus-gui-gdpr/lib
COPY --from=discovery-ui /pontusvision-extract-discovery/dataprep-webapp/build /opt/pontus/pontus-gui-discovery/lib

#COPY --from=ca /create-keys.sh /
#COPY --from=ca /create-ca.sh /
#COPY --from=ca /etc/pki /etc/pki

RUN chown -R pontus: /opt/pontus

#USER 1000

EXPOSE 18443
CMD  /usr/sbin/nginx -g "daemon off;"

