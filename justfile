cluster := "otel-demo"
debug := "false"

[confirm("Recreate cluster and deploy everything?")]
all: delete-cluster create-cluster (load justfile_dir() / "ref-qrcode-generator.tar") deploy

alias cc := create-cluster
alias dc := delete-cluster

# Create the kind cluster
create-cluster:
    kind create cluster --config {{ justfile_dir() }}/kind.yaml --name "{{ cluster }}" --wait 1m

# Delete the kind cluster
delete-cluster:
    kind delete cluster --name "{{ cluster }}"

# Load an archive image into the cluster
load IMAGE:
    kind load image-archive --name "{{ cluster }}" "{{ IMAGE }}"

# Apply objects from ./k8s
apply filename="":
    kubectl apply -f {{ justfile_dir() }}/k8s/{{ filename }}

# Sync helmfile with cluster
helm:
    helmfile sync --kube-context kind-{{ cluster }} {{ if debug == "true" { "--debug" } else { "" } }}

# Apply ./k8s and sync helmfile
deploy: helm apply
