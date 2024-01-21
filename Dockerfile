FROM alpine:edge

WORKDIR /app

# Install Python and other dependencies
RUN apk add --no-cache docker curl wget bash
# Install kubectl
COPY ./lib/kubectl.sh /tmp/
RUN bash /tmp/kubectl.sh  


COPY . /app
