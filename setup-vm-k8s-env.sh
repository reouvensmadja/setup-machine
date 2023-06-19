#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Create a directory for local binaries if it doesn't exist
if [ ! -d "$HOME/bin" ]; then
  mkdir "$HOME/bin"
fi

# Add the local binaries directory to the PATH if not already present
if ! echo "$PATH" | grep -q "$HOME/bin"; then
  echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$HOME/.bashrc"
  source "$HOME/.bashrc"
fi

# Install Git if not already installed
if ! command_exists git; then
  echo "Installing Git..."
  sudo apt-get update
  sudo apt-get install -y git
else
  echo "Git is already installed."
fi

# Clone the repository
if [ ! -d "SM" ]; then
  echo "Cloning the repository..."
  git clone https://github.com/redislabsdev/SM.git
else
  echo "The repository is already cloned."
fi

# Install kubectl if not already installed
if ! command_exists kubectl; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  mv kubectl "$HOME/bin/"
else
  echo "kubectl is already installed."
fi

# Install kubectl completion if not already installed
if ! command_exists kubectl completion; then
  echo "Installing kubectl completion..."
  kubectl completion bash > "$HOME/.kubectl-completion"
  echo "source '$HOME/.kubectl-completion'" >> "$HOME/.bashrc"
else
  echo "kubectl completion is already installed."
fi

# Download kubectl-aliases if not already present
if [ ! -f "$HOME/.kubectl_aliases" ]; then
  echo "Downloading kubectl-aliases..."
  curl -L https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/.kubectl_aliases -o "$HOME/.kubectl_aliases"
else
  echo "kubectl-aliases is already downloaded."
fi

# Source kubectl-aliases inside .bashrc
echo "source '$HOME/.kubectl_aliases'" >> "$HOME/.bashrc"

# Source SM k8s aliases
if [ -f "SM/k8s/.bashrc_sm_aliases" ]; then
  echo "Sourcing SM k8s aliases..."
  echo "source '$(pwd)/SM/k8s/.bashrc_sm_aliases'" >> "$HOME/.bashrc"
else
  echo "SM k8s aliases not found. Make sure you have cloned the SM repository."
fi

# Export KUBECONFIG
echo 'export KUBECONFIG="$HOME/.kube/config"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# Run gcloud command to get credentials for the specified cluster
echo "Running gcloud command to get cluster credentials..."
gcloud container clusters get-credentials $GKE_CLUSTER_NAME --region $GCP_REGION --project $GCP_PROJECT_ID
echo "Dev environment setup complete!"