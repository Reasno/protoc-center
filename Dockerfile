FROM namely/prototool:1.28_0
USER root
RUN npm i -g protoc-gen-tsd
RUN curl -SL https://github.com/spiral/php-grpc/releases/download/v1.4.0/rr-grpc-1.4.0-linux-amd64.tar.gz | tar -xJC /usr/local/bin
