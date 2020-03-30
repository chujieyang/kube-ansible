#!/bin/bash
if ${DEBUG};then
  set -ex
fi

pushd $(dirname $0)
mkdir -p binaries

# docker
DOCKER_VERSION=${DOCKER_VERSION:-"18.06.3"}
echo "Prepare docker ${DOCKER_VERSION} release ..."
mkdir -p binaries/docker/${DOCKER_VERSION}
grep -q "^${DOCKER_VERSION}\$" binaries/docker/${DOCKER_VERSION}/.docker 2>/dev/null || {
  curl -f --connect-timeout 20 --retry 5 --location --insecure https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz -o binaries/docker/${DOCKER_VERSION}/docker-${DOCKER_VERSION}.tgz
  tar -zxf binaries/docker/${DOCKER_VERSION}/docker-${DOCKER_VERSION}.tgz --strip-components 1 -C binaries/docker/${DOCKER_VERSION}
  rm -rf binaries/docker/${DOCKER_VERSION}/docker-${DOCKER_VERSION}.tgz
  echo ${DOCKER_VERSION} > binaries/docker/${DOCKER_VERSION}/.docker
}

# flannel
FLANNEL_VERSION=${FLANNEL_VERSION:-"0.12.0"}
echo "Prepare flannel ${FLANNEL_VERSION} release ..."
mkdir -p binaries/flannel/${FLANNEL_VERSION}
grep -q "^${FLANNEL_VERSION}\$" binaries/flannel/${FLANNEL_VERSION}/.flannel 2>/dev/null || {
  curl -f --connect-timeout 20 --retry 5 --location --insecure https://github.com/coreos/flannel/releases/download/v${FLANNEL_VERSION}/flannel-v${FLANNEL_VERSION}-linux-amd64.tar.gz -o binaries/flannel/${FLANNEL_VERSION}/flannel-v${FLANNEL_VERSION}-linux-amd64.tar.gz
  tar -zxf binaries/flannel/${FLANNEL_VERSION}/flannel-v${FLANNEL_VERSION}-linux-amd64.tar.gz -C binaries/flannel/${FLANNEL_VERSION}/ flanneld mk-docker-opts.sh
  rm -rf binaries/flannel/${FLANNEL_VERSION}/flannel-v${FLANNEL_VERSION}-linux-amd64.tar.gz
  echo ${FLANNEL_VERSION} > binaries/flannel/${FLANNEL_VERSION}/.flannel
}

# ectd
ETCD_VERSION=${ETCD_VERSION:-"3.4.5"}
echo "Prepare etcd ${ETCD_VERSION} release ..."
mkdir -p binaries/etcd/${ETCD_VERSION}
grep -q "^${ETCD_VERSION}\$" binaries/etcd/${ETCD_VERSION}/.etcd 2>/dev/null || {
  curl -f --connect-timeout 20 --retry 5 --location --insecure https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -o binaries/etcd/${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz
  tar -zxf binaries/etcd/${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz --strip-components 1 -C binaries/etcd/${ETCD_VERSION}/ etcd-v${ETCD_VERSION}-linux-amd64/etcd etcd-v${ETCD_VERSION}-linux-amd64/etcdctl 
  rm -rf binaries/etcd/${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz
  echo ${ETCD_VERSION} > binaries/etcd/${ETCD_VERSION}/.etcd
}

# kubernetes
KUBE_VERSION=${KUBE_VERSION:-"1.18.0"}
echo "Prepare kubernetes ${KUBE_VERSION} release ..."
mkdir -p binaries/kubernetes/${KUBE_VERSION}
grep -q "^${KUBE_VERSION}\$" binaries/kubernetes/${KUBE_VERSION}/.kubernetes 2>/dev/null || {
 curl -f --connect-timeout 20 --retry 5 --location --insecure "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-apiserver" -o binaries/kubernetes/${KUBE_VERSION}/kube-apiserver
 curl -f --connect-timeout 20 --retry 5 --location --insecure "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-controller-manager" -o binaries/kubernetes/${KUBE_VERSION}/kube-controller-manager
 curl -f --connect-timeout 20 --retry 5 --location --insecure "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-scheduler" -o binaries/kubernetes/${KUBE_VERSION}/kube-scheduler
 curl -f --connect-timeout 20 --retry 5 --location --insecure "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" -o binaries/kubernetes/${KUBE_VERSION}/kubectl
 curl -f --connect-timeout 20 --retry 5 --location --insecure "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-proxy" -o binaries/kubernetes/${KUBE_VERSION}/kube-proxy
 curl -f --connect-timeout 20 --retry 5 --location --insecure "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubelet" -o binaries/kubernetes/${KUBE_VERSION}/kubelet
 echo ${KUBE_VERSION} > binaries/kubernetes/${KUBE_VERSION}/.kubernetes
}