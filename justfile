cluster := "otel-demo"

# Create the kind cluster
create-cluster:
    kind create cluster --config kind.yaml --name "{{cluster}}" --wait 1m

# Delete the kind cluster
delete-cluster:
    kind delete cluster --name "{{cluster}}"

apply:
    kubectl apply -f ./k8s

helm:
    helmfile sync --kube-context kind-{{cluster}}

deploy: apply helm
