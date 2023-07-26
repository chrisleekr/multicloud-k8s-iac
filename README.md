# Kubernetes sample project for Node.js (REST API) + Vue.js (Frontend/Backend) + MySQL Boilerplate

This project provides an example of Infrastructure as Code (IaC) for deploying the [NVM boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate) to Google Kubernetes Engine (GKE) or Minikube. Please note that this is a sample project and is not intended for production use.

## Prerequisites

Before getting started, please ensure that you have the following software installed:

- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Docker](https://docs.docker.com/engine/install/)
- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)

## With this project, you can find

This project includes the following features:

- Sample Terraform scripts for deploying to Google Kubernetes Engine or Minikube
- Sample Helm charts for deploying multiple containerized microservices

## Provision a cluster with Google Kubernetes Engine (GKE)

To provision a cluster with GKE, follow these steps:

1. Launch the orchestrator by running the following command:

   ```bash
   npm run docker:exec
   ```

2. Make the orchestrator accessible to the GKE cluster by running the following command:

   ```bash
   gcloud auth application-default login --no-launch-browser
   ```

3. Run the Terraform commands by navigating to the appropriate directory and running the following commands:

   ```bash
   cd workspaces/google/terraform/
   terraform workspace list
   terraform workspace select sample-gke-iac
   terraform init
   terraform plan
   terraform apply
   ```

   After applying Terraform, it will output the load balancer IP address.

   ```bash
   load_balancer_ip_address = "12.123.123.12"
   ```

4. Add an A record to your domain’s DNS records. In this repo, it was [nvm.chrislee.kr](http://nvm.chrislee.kr).

### Retrieving the Kubernetes Context

To retrieve the Kubernetes context, run the following commands:

   ```bash
   gcloud projects list
   gcloud container clusters list
   gcloud container clusters get-credentials <cluster name> --region australia-southeast2 --project <project id>
   ```

## Provision with Minikube

To provision a cluster with Minikube, follow these steps:

1. Start Minikube by running the following command:

   ```bash
   minikube start --addons ingress,metrics-server
   ```

   Wait until the Minikube cluster is provisioned.

2. Launch the orchestrator by running the following command:

   ```bash
   npm run docker:exec
   ```

3. Make the orchestrator accessible to the Minikube cluster by running the following script:

   ```bash
   /srv/workspaces/minikube/scripts/set-kube-context.sh
   ```

4. Run the Terraform commands by navigating to the appropriate directory and running the following commands:

   ```bash
   cd /srv/workspaces/minikube/terraform
   terraform init
   terraform plan
   terraform apply
   ```

5. Update your host file with the following entry:

   ```bash
   vim /etc/hosts
   127.0.0.1   nvm-boilerplate.local
   ```

   Then, port-forward the nginx service to your host machine by running the following command:

   ```bash
   kubectl port-forward -ningress-nginx svc/ingress-nginx-controller 80:80
   ```

   You may need root permission, so use `sudo` if required.

6. Open a new browser and navigate to [nvm-boilerplate.local](http://nvm-boilerplate.local)

## Microservices Repository: Node.js + Vue.js + MySQL Boilerplate

For more information about the microservices used in this project, please visit [https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate)

## Accessing MySQL with Oracle MySQL Operator

To access MySQL, run the following commands:

```bash
# Get root password
$ kubectl -nmysql get secrets mysql-innodbcluster-cluster-secret -oyaml
$ echo "<rootPassword>" | base64 -d

# Port forward
$ kubectl -nmysql port-forward svc/mysql-innodbcluster 6446:6446

# Access to R/W MySQL
$ mysql -h127.0.0.1 -uroot -p -P6446 boilerplate
```

## Using Horizontal Pod Autoscaler

To view information about Horizontal Pod Autoscaler, run the following command:

```bash
kubectl get hpa --all-namespaces
```

If you see `<unknown>/50%` when using Minikube, make sure you have enabled metrics-server by running this command:

```bash
minikube addons enable metrics-server
```

## Monitoring with Prometheus & Grafana

You can access Grafana via `<http://nvm-boilerplate.local/grafana` when using Minikube.

After the deployment is completed, you will see output similar to the following:

```text
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

grafana_admin_password = <sensitive>
mysql_boilerplate_password = <sensitive>
mysql_root_password = <sensitive>
```

You can retrieve the Grafana admin password by running the following command:

```bash
terraform output grafana_admin_password
```

With the password, you can log in to Grafana using `admin`/`<Password>`.

![image](https://user-images.githubusercontent.com/5715919/100513860-4a031880-31c4-11eb-8ef2-04202055aa78.png)

## Todo

- [x] Update MySQL with a replicated stateful application - Use presslabs/mysql-operator
- [x] Add HorizontalPodAutoscaler
- [x] Add Prometheus and Grafana
- [x] Expose MySQL write node for migration to avoid api migration failure
- [x] Replaced presslab/mysql-operator to Oracle MySQL operator/InnoDB cluster
- [x] Support Google Kubernetes Engine
