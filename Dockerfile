FROM namely/prototool:1.28_0
ENV npm_config_unsafe_perm=true
RUN npm i -g protoc-gen-tsd
RUN wget -qO- https://github.com/spiral/php-grpc/releases/download/v1.4.0/rr-grpc-1.4.0-linux-amd64.tar.gz | tar -xJC /usr/local/bin
