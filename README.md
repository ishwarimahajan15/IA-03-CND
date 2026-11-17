# Jenkins CI/CD + Terraform Mini Project

**Application:** Python Flask | **CI/CD:** Jenkins Declarative Pipeline | **IaC:** Terraform Docker provider

> This package contains project files and setup instructions, not fabricated execution proof. Run the workflow and capture genuine screenshots before submitting.

## 1. Objective

The pipeline checks out source from Git, runs unit tests, builds a Docker image, validates/plans Terraform, provisions a Docker container, and checks its HTTP health endpoint.

## 2. Prerequisites

Install Docker Desktop/Engine with Compose, Git, and a web browser. Internet access is needed for initial downloads. The supplied Jenkins container mounts `/var/run/docker.sock` and is privileged. This grants powerful control over the host Docker daemon: use only on a trusted local machine, never expose it publicly, and do not run untrusted jobs.

## 3. Start Jenkins

From the project root:

```bash
docker compose up -d --build
docker compose logs -f jenkins
```

Open `http://localhost:8080`. Get the initial password:

```bash
docker exec jenkins-ci cat /var/jenkins_home/secrets/initialAdminPassword
```

Complete the setup wizard and install suggested plugins. Ensure Pipeline and Git plugins are installed. Verify tools:

```bash
docker exec jenkins-ci docker version
docker exec jenkins-ci terraform version
```

## 4. Push to GitHub

Create an empty repository, then:

```bash
git init
git add .
git commit -m "Add Jenkins CI/CD and Terraform mini project"
git branch -M main
git remote add origin https://github.com/<YOUR-USERNAME>/jenkins-terraform-mini-project.git
git push -u origin main
```

Replace the username placeholder. For a private repository, configure Jenkins credentials; never hardcode tokens in source.

## 5. Create Jenkins Pipeline job

1. Select **New Item**, name it `jenkins-terraform-mini-project`, choose **Pipeline**.
2. Under Pipeline, choose **Pipeline script from SCM**.
3. SCM: **Git**; enter your repository URL.
4. Branch: `*/main`; Script Path: `Jenkinsfile`.
5. Save and select **Build Now**.

## 6. Pipeline stages

| Stage | Purpose |
|---|---|
| Checkout | Fetches the configured Git repository |
| Test | Runs Python unit tests in a temporary Python container |
| Build Docker Image | Builds `jenkins-terraform-demo:ci` |
| Terraform Validate | Initializes provider, checks formatting, validates and plans |
| Deploy with Terraform | Creates/updates the Docker container |
| Smoke Test | Calls `/health` and fails if the service does not become healthy |

After success, open `http://localhost:5001` and `http://localhost:5001/health`.

## 7. Terraform files and commands

- `versions.tf`: Terraform and provider version constraints.
- `provider.tf`: Docker provider connection to the daemon.
- `main.tf`: variables and Docker image/container resources.
- `outputs.tf`: container name and application URLs.

The pipeline runs:

```bash
cd infrastructure
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
terraform output
```

Terraform uses declarative configuration and state to track managed resources. `plan` previews changes; `apply` provisions them. The Docker provider manages a local container here, demonstrating IaC concepts rather than provisioning a public cloud service.

To remove the managed resource after the demonstration:

```bash
cd infrastructure
terraform destroy
```

Do not delete Terraform state before destroying resources.

## 8. Concepts to explain

- **Continuous Integration:** integrating source changes and running automated tests.
- **Continuous Delivery/Deployment:** automating packaging and delivery to a running environment.
- **Jenkins Pipeline:** stages and steps stored as code in `Jenkinsfile`.
- **Docker image/container:** packaged application template and its running instance.
- **Infrastructure as Code:** describing infrastructure declaratively in version-controlled files.
- **Terraform provider/state:** provider talks to the target API; state maps configuration to real resources.
- **Plan/apply:** preview proposed changes and then execute them.

## 9. Troubleshooting

- Port 8080 conflict: change host side of `8080:8080` in `compose.yaml`.
- Port 5001 conflict: change `host_port` in `infrastructure/main.tf`.
- Docker unavailable in Jenkins: verify `docker version` inside Jenkins and confirm the socket mount.
- Permission denied on socket: inspect socket access. Do not expose unauthenticated Docker TCP.
- Git checkout failure: verify URL, branch, credentials and Git plugin.
- Terraform init failure: check internet/provider registry access and retry.
- Jenkinsfile not found: ensure it is at repository root and Script Path is `Jenkinsfile`.

## 10. Genuine screenshots to capture

Save these in `evidence/` after successful execution:

1. `01-jenkins-dashboard.png` — Jenkins dashboard and pipeline job.
2. `02-pipeline-success.png` — completed Stage View with successful stages.
3. `03-checkout-and-tests.png` — console output showing checkout and tests passing.
4. `04-docker-build.png` — Docker image build output.
5. `05-terraform-apply.png` — Terraform apply and outputs.
6. `06-docker-ps.png` — `docker ps` showing container and port mapping.
7. `07-application.png` — browser at `http://localhost:5001`.
8. `08-health.png` — browser or terminal showing successful `/health` response.

## 11. Suggested 4–6 minute demonstration

Introduce the project; show GitHub files; explain Jenkinsfile stages; show job configuration and a successful run; explain Terraform provider/resources/state; show apply output and `docker ps`; open the deployed app and health endpoint; conclude with CI/CD and IaC benefits.

## 12. Final checklist

- [ ] GitHub repository pushed and accessible to instructor
- [ ] Jenkins Pipeline job configured from Git SCM
- [ ] Pipeline completed successfully
- [ ] Unit tests passed and Docker image built
- [ ] Terraform init, validate, plan and apply completed
- [ ] Terraform-managed container is running
- [ ] Application and health endpoint verified
- [ ] Genuine screenshots added to `evidence/`
- [ ] Demonstration video recorded and link prepared
