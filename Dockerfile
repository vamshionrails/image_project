FROM alpine:edge

WORKDIR /app

# Install kind cluster
COPY ./configs/cluster.yaml /tmp/
COPY ./lib/kind_cluster.sh /tmp/

# Install Python and other dependencies
RUN apk add --no-cache curl bash tar gzip openssl git bash nano docker tree python3 py3-pip ca-certificates wget util-linux-misc inetutils-telnet gzip binutils curl jq 

# Copy Kube Config
RUN mkdir /root/.kube 
COPY ./configs/kube_config /tmp/
RUN cp /tmp/kube_config ~/.kube/config 


# Install kubectl
COPY ./lib/kubectl.sh /tmp/
RUN bash /tmp/kubectl.sh   

# Install cluster
COPY ./lib/kind_cluster.sh /tmp/
RUN bash /tmp/kind_cluster.sh 

# kubernetes dashboard 
COPY ./configs/kubernetes-dashboard/serviceaccount.yaml /tmp/



COPY . /app
 
