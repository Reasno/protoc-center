FROM curlimages/curl as build
WORKDIR /tmp
USER root
RUN apk update && apk add alpine-sdk autoconf automake libtool linux-headers
RUN curl -LO https://github.com/spiral/php-grpc/releases/download/v1.4.0/protoc-gen-php-grpc-1.4.0-linux-amd64.tar.gz \
    && tar -zxvf protoc-gen-php-grpc-1.4.0-linux-amd64.tar.gz \
    && chmod +x protoc-gen-php-grpc-1.4.0-linux-amd64/protoc-gen-php-grpc
RUN curl -sSL https://github.com/uber/prototool/releases/download/v1.10.0/prototool-Linux-x86_64 \
    -o /tmp/prototool && \
    chmod +x /tmp/prototool
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.11.2/protoc-3.11.2-linux-x86_64.zip \
   && unzip protoc-3.11.2-linux-x86_64.zip \
   && chmod +x protoc-3.11.2-linux-x86_64/bin/protoc
RUN git clone -b v1.30.0 --depth=1 https://github.com/grpc/grpc
RUN cd grpc && git submodule update --init && make grpc_php_plugin && chmod +x /tmp/grpc/bins/opt/grpc_php_plugin
FROM namely/prototool:1.28_0
ENV npm_config_unsafe_perm=true
RUN npm i -g protoc-gen-tsd
RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk
RUN apk add -f glibc-2.29-r0.apk
COPY --from=build /tmp/protoc-gen-php-grpc-1.4.0-linux-amd64/protoc-gen-php-grpc /usr/local/bin/protoc-gen-rr-php-grpc
COPY --from=build /tmp/prototool /usr/local/bin/prototool
COPY --from=build /tmp/grpc/bins/opt/grpc_php_plugin /usr/local/bin/protoc-gen-php-grpc
COPY --from=build /tmp/protoc-3.11.2-linux-x86_64/bin/protoc /usr/local/bin/protoc
