.PHONY: build cluster load deploy run clean status expose

CLUSTER_NAME := university-talk
IMAGE_NAME := university-talk:latest
CONTEXT := kind-$(CLUSTER_NAME)

# Build, create cluster, and deploy everything
run: build cluster load deploy
	@echo ""
	@echo "Presentation running at http://localhost:8080"

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) ./talk

# Create the Kind cluster
cluster:
	kind create cluster --config kind-config.yaml

# Load the image into Kind
load:
	kind load docker-image $(IMAGE_NAME) --name $(CLUSTER_NAME)

# Apply Kubernetes manifests
deploy:
	kubectl apply -f k8s/deployment.yaml --context $(CONTEXT)
	kubectl rollout status deployment/university-talk --context $(CONTEXT) --timeout=60s

# Show pod status
status:
	kubectl get pods -l app=university-talk --context $(CONTEXT)

# Tear down everything
clean:
	kind delete cluster --name $(CLUSTER_NAME)

# Expose to the internet via Cloudflare tunnel
expose:
	cloudflared tunnel --url http://localhost:8080
