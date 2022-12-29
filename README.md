# Kubernetes sample project for Node.js (REST API) + Vue.js (Frontend/Backend) + MySQL Boilerplate

This project demonstrates simple IaC (Infrastructure as Code) for [NVM boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate) to Minikube.

This is a Kubernetes sample project, not for a production use.

## Prerequisites

- [Minikube v1.28.0](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Kubernetes v1.20.2](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm v3.4.1](https://helm.sh/docs/intro/install/)
- [Terraform v1.3.6](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## How to test in your Minikube

1. Start minikube

   ```bash
   $ minikube start --addons ingress,metrics-server
   ```

2. Go to `terraform` folder

3. Run Terraform commands

   ```bash
   $ terraform init
   $ terraform plan
   $ terraform apply
   ```

   or simply run bash script

   ```bash
   $ ./script/deploy.sh
   ```

4. Update hosts file

   ```bash
   $ ./script/update-hosts.sh
   ```

5. Open new browser and go to [nvm-boilerplate.local](http://nvm-boilerplate.local)

## With this project, you can find

- Sample Terraform
- Sample Helm charts to deploy multiple containerised micro-services

## Micro-services Repository: Node.js + Vue.js + MySQL Boilerplate

- [https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate)

## Oracle MySQL Operator

To access MySQL, run following command

```bash
# Get root password
$ kubectl -nmysql get secrets mysql-innodbcluster-cluster-secret -oyaml
$ echo "<rootPassword>" | base64 -d

# Port forward
$ kubectl -nmysql port-forward svc/mysql-innodbcluster 6446:6446

# Access to R/W MySQL
$ mysql -h127.0.0.1 -uroot -p -P6446 boilerplate
```

## Horizontal Pod Autoscaler

```bash
$ kubectl get hpa --all-namespaces
```

If you see `<unknown>/50%`, make sure you enabled metrics-server.

```bash
$ minikube addons enable metrics-server
```

## Prometheus & Grafana

You can access Grafana via `http://nvm-boilerplate.local/grafana`.

Once the deployment is completed, then you will see the result like below:

```text
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

grafana_admin_password = <sensitive>
mysql_boilerplate_password = <sensitive>
mysql_root_password = <sensitive>
```

You can get the password by executing the following command:

```bash
terraform output grafana_admin_password
```

With the password, you can login Grafana with `admin`/`<Password>`.

![image](https://user-images.githubusercontent.com/5715919/100513860-4a031880-31c4-11eb-8ef2-04202055aa78.png)

## Todo

- [x] Update MySQL with a replicated stateful application - Use presslabs/mysql-operator
- [x] Add HorizontalPodAutoscaler
- [x] Add Prometheus and Grafana
- [x] Expose MySQL write node for migration to avoid api migration failure
- [x] Replaced presslab/mysql-operator to Oracle MySQL operator/InnoDB cluster
