FROM curlimages/curl as build
WORKDIR /tmp
RUN curl -LO https://github.com/spiral/php-grpc/releases/download/v1.4.0/protoc-gen-php-grpc-1.4.0-linux-amd64.tar.gz \
    && tar -zxvf protoc-gen-php-grpc-1.4.0-linux-amd64.tar.gz \
    && chmod +x protoc-gen-php-grpc-1.4.0-linux-amd64/protoc-gen-php-grpc
RUN curl -sSL https://github.com/uber/prototool/releases/download/v1.10.0/prototool-Linux-x86_64 \
    -o /tmp/prototool && \
    chmod +x /tmp/prototool
FROM namely/prototool:1.28_0
ENV npm_config_unsafe_perm=true
RUN npm i -g protoc-gen-tsd
COPY --from=build /tmp/protoc-gen-php-grpc-1.4.0-linux-amd64/protoc-gen-php-grpc /usr/local/bin/rr-php-grpc
COPY --from=build /tmp/prototool /usr/local/bin/prototool
