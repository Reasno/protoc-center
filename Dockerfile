FROM ubuntu as build
RUN curl -LO https://github.com/spiral/php-grpc/releases/download/v1.4.0/rr-grpc-1.4.0-linux-amd64.tar.gz \ 
    && unzip rr-grpc-1.4.0-linux-amd64.tar.gz \
    && chmod +x /tmp/php-grpc
FROM namely/prototool:1.28_0
ENV npm_config_unsafe_perm=true
RUN npm i -g protoc-gen-tsd
COPY --from=build /tmp/php-grpc /usr/local/bin/rr-php-grpc
