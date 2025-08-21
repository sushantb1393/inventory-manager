Got it, Atul! Here’s a ready-to-drop **GitHub Actions → Docker Hub** CI/CD that builds and pushes your image to `atuljkamble/inventory-manager` from your repo `github.com/atulkamble/inventory-manager`.

# 1) Add GitHub Secrets (repo → Settings → Secrets and variables → Actions)

* `DOCKERHUB_USERNAME` → your Docker Hub username (`atuljkamble`)
* `DOCKERHUB_TOKEN` → a Docker Hub **Access Token** (from Docker Hub → Account Settings → Security)

# 2) Create workflow file

Save this as: `.github/workflows/dockerhub.yml`

```yaml
name: Build & Push to Docker Hub

on:
  push:
    branches: [ "main" ]
    tags: [ "v*" ]
  pull_request:
    branches: [ "main" ]

permissions:
  contents: read

env:
  IMAGE_NAME: atuljkamble/inventory-manager

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
      # If your Dockerfile is in a subfolder, add `with: { path: "<subdir>" }`
        uses: actions/checkout@v4

      # OPTIONAL: Run unit tests if a test runner exists (auto-skips if not found)
      - name: Detect Python tests
        id: detect_pytests
        run: |
          if [ -f "pytest.ini" ] || [ -d "tests" ]; then
            echo "has_tests=true" >> $GITHUB_OUTPUT
          else
            echo "has_tests=false" >> $GITHUB_OUTPUT
          fi

      - name: Set up Python (for tests)
        if: steps.detect_pytests.outputs.has_tests == 'true'
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install deps & run pytest
        if: steps.detect_pytests.outputs.has_tests == 'true'
        run: |
          if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
          pip install pytest
          pytest -q

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Docker Hub login
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Extract metadata (tags, labels)
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=ref,event=tag
            type=sha,format=long
            type=raw,value=latest,enable=${{ github.ref == 'refs/heads/main' }}

      - name: Build & Push
        uses: docker/build-push-action@v6
        with:
          context: .
          file: ./Dockerfile
          push: true
          platforms: linux/amd64
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # OPTIONAL: Image vulnerability scan (post-push) using Trivy
  trivy:
    needs: build-and-push
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
    steps:
      - name: Run Trivy on pushed image
        uses: aquasecurity/trivy-action@0.28.0
        with:
          image-ref: ${{ env.IMAGE_NAME }}:latest
          format: 'table'
          exit-code: '0'     # don’t fail the pipeline; set to '1' to block on vulns
          ignore-unfixed: true
```

### What this does

* Triggers on:

  * **Push to `main`** → builds & pushes `latest`, branch, and SHA tags.
  * **Tags like `v1.0.0`** → builds & pushes version tag.
  * **PRs** → builds and pushes a temporary PR tag (doesn’t use `latest`).
* Auto-detects Python tests and runs them if a `tests/` folder or `pytest.ini` exists.
* Uses build cache to speed up subsequent builds.
* Publishes multi-tagged images (e.g., `latest`, `main`, `sha-…`, `v1.2.3`).
* Optionally scans the resulting `:latest` image with Trivy.

# 3) (Optional) Add a `.dockerignore`

Create `.dockerignore` to keep images lean:

```
.git
.gitignore
README.md
LICENSE
*.md
__pycache__/
*.pyc
.env
venv/
node_modules/
dist/
build/
```

# 4) Verify your Dockerfile

Ensure your project has a valid `Dockerfile` at repo root (or update the `file:` path in the workflow). For a Flask app example:

```dockerfile
# Dockerfile
FROM python:3.11-slim
WORKDIR /app

# Faster installs
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
EXPOSE 5000
# Update if your entrypoint differs
CMD ["python", "app.py"]
```

# 5) Local tag & push parity (optional)

If you want to mirror the workflow locally:

```bash
docker login -u "$DOCKERHUB_USERNAME"
docker build -t atuljkamble/inventory-manager:dev .
docker push atuljkamble/inventory-manager:dev
```

---

If you prefer **Jenkins** instead of GitHub Actions, say the word and I’ll drop a declarative `Jenkinsfile` with webhooks to the same Docker Hub repo.
