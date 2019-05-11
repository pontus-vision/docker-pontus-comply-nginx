FROM node as builder
WORKDIR /
RUN  git clone  --depth 1 --single-branch --branch master https://github.com/pontusvision/pontus-lgpd-gui.git
RUN cd pontus-lgpd-gui && \
     ./build-local.sh

#FROM pontusvisiongdpr/pontus-ca-base as ca
#RUN /create-ca.sh



FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /opt/pontus/pontus-gui-lgpd
COPY --from=builder /pontus-lgpd-gui/build /opt/pontus/pontus-gui-lgpd/lib
#COPY --from=ca /create-keys.sh /
#COPY --from=ca /create-ca.sh /
#COPY --from=ca /etc/pki /etc/pki
RUN useradd -u 1000 -s /bin/bash pontus

EXPOSE 18443
CMD  /usr/sbin/nginx

