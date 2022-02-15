# DataStax Enterprise Cass-Operator Deployment on GKE
## TL;DR
- End to end, this will deploy a GKE Cluster, DSE Cluster, & DSE Studio using the `cass-operator`
## Prerequsites
- GCP account 
- Permissions to a GCP Project where GKE clusters can be deployed
- gcloud sdk
    - ensure gcloud is at the latest version
    - [Configure Cluster Access for kubectl](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl)
- kubectl
- helm
- awk
- jq
## Setup
- Clone the repo and provide execute permissions to the four shell scripts via something like `chmod +x`
- Ensure your local machine has all the above prerequisites
- Note the DSE cluster name in `./datastax_enterprise/deploy-cassandra.yaml`
- Run the shell scripts in order (00-01) to deploy the k8s environment and DSE Cluster
- Script 00 takes three arguments to deploy the GKE cluster
  - Your GCP project name (where you have permissions to deploy a GKE cluster)
  - The name you want to give your GKE cluster (like `my-name-dse-cdc-test`)
  - The GCP region in which you want to deploy your cluster (e.g. `us-central1-c`)
## DSE Studio
- Set up a new connection to the DSE Cluster in the Studio UI 
- External load balancer URL is located in the GCP console under `Services & Ingress`
- Give the connection whatever Name you would like
- For the Host use `{NAME OF YOUR CLUSTER}-dc1-service.default.svc.cluster.local`
- Leave the Port at `9042`
- The Username is `{NAME OF YOUR CLUSTER}-superuser`

Run the following to retrieve the `{NAME OF YOUR CLUSTER}-superuser` password and copy/paste it into the Password field.
```shell
CLUSTER_NAME={NAME OF YOUR CLUSTER}
CASSANDRA_PASS=$(kubectl -n cass-operator get secret $CLUSTER_NAME-superuser -o json | jq -r '.data.password' | base64 --decode)
echo $CASSANDRA_PASS
```
## Tear Down
- Run script 03 with the same three arguments to tear down your GKE cluster
  - Your GCP project name (where you have rights to deploy a GKE cluster)
  - The name you gave your GKE cluster
  - The GCP region you deployed your cluster
### Known Issues
- On two occasions the `pulsar-bookkeeper`pod has become stuck initializing with 0 restarts. RCA ongoing.
