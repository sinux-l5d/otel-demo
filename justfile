cluster := "otel-demo"

# Create the kind cluster
create-cluster:
    kind create cluster --config kind.yaml --name "{{ cluster }}" --wait 1m

# Delete the kind cluster
delete-cluster:
    kind delete cluster --name "{{ cluster }}"

# Apply objects from ./k8s
apply:
    kubectl apply -f ./k8s

# Sync helmfile with cluster
helm:
    helmfile sync --kube-context kind-{{ cluster }}

# Apply ./k8s and sync helmfile
deploy: helm apply

all: delete-cluster create-cluster deploy
