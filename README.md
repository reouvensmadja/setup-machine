# setup-machine

```
export GCP_PROJECT_ID=$(gcloud config get-value project)
export GCP_REGION="<region>"
export GKE_CLUSTER_NAME="<cluster_name>"
curl -o ~/script.sh https://raw.githubusercontent.com/reouvensmadja/setup-machine/main/setup-vm-k8s-env.sh

chmod +x ~/script.sh
cd ~
./script.sh 
```
