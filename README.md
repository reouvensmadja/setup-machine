# setup-machine

```
export GCP_PROJECT_ID=$(gcloud config get-value project)
export GCP_REGION="us-east-4"
export GKE_CLUSTER_NAME="cloud-k8s-prod"
curl -o ~/script.sh https://raw.githubusercontent.com/reouvensmadja/setup-machine/main/setup-vm-k8s-env.sh

chmod +x ~/script.sh
cd ~
./script.sh 
```
