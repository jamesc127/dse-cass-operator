#!/bin/bash
helm repo add k8ssandra https://helm.k8ssandra.io/stable
helm install cass-operator k8ssandra/cass-operator -n cass-operator --create-namespace
kubectl apply -n cass-operator -f ./datastax_enterprise/deploy-cassandra.yaml
kubectl apply -n cass-operator -f ./datastax_enterprise/studio-deployment.yaml
CASSANDRA_PASS=$(kubectl -n cass-operator get secret dse-gke-cluster-superuser -o json | jq -r '.data.password' | base64 --decode)
# https://github.com/k8ssandra/cass-operator
# https://github.com/k8ssandra/cass-operator/blob/master/config/samples/example-cassdc-three-nodes-single-rack.yaml
# https://github.com/k8ssandra/cass-operator/blob/bd779cd4d4101e2216d0e0ed357d8662dc8ad0e8/tests/testdata/solr-dc.yaml
# https://github.com/k8ssandra/cass-operator/blob/eb7bbb91f9bb4e93547af9821e40dfab6a024390/apis/cassandra/v1beta1/cassandradatacenter_types.go#L608-L618
# https://github.com/k8ssandra/cass-operator/blob/eb7bbb91f9bb4e93547af9821e40dfab6a024390/apis/cassandra/v1beta1/cassandradatacenter_types.go#L737-L778
# TODO add stargate