FROM curlimages/curl as build
WORKDIR /tmp
RUN curl -LO https://github.com/spiral/php-grpc/releases/download/v1.4.0/protoc-gen-php-grpc-1.4.0-linux-amd64.tar.gz \
    && unzip protoc-gen-php-grpc-1.4.0-linux-amd64.tar.gz \
    && chmod +x /tmp/protoc-gen-php-grpc
FROM namely/prototool:1.28_0
ENV npm_config_unsafe_perm=true
RUN npm i -g protoc-gen-tsd
COPY --from=build /tmp/php-grpc /usr/local/bin/rr-php-grpc
