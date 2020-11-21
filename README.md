# Kubernetes sample project for Node.js (REST API) + Vue.js (Frontend/Backend) + MySQL Boilerplate

This project demonstrates simple IaC (Infrastructure as Code) for [NVM boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate) to Minikube.

This is a Kubernetes sample project, not for a production use.

## Prerequisites

- [Minikube v1.15.1](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Kubernetes v.1.19.4](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm v3.4.1](https://helm.sh/docs/intro/install/)
- [Terraform v0.13.5](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## How to test in your Minikube

1. Start minikube

   ```bash
   $ minikube start
   $ minikube addons enable ingress
   ```

2. Go to `terraform` folder
3. Run Terraform commands

   ```bash
   $ terraform init
   $ terraform plan
   $ terraform apply
   ```

4. Update hosts file

   ```bash
   $ ./script/update-hosts.sh
   ```

## With this project, you can find

- Sample Terraform
- Sample Helm charts to deploy multiple containerised micro-services

## Micro-services Repository: Node.js + Vue.js + MySQL Boilerplate

- [https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate)

## Presslabs MySQL Operator

To see orchestrator, run following port forward and open [http://localhost:8080](http://localhost:8080)

```bash
$ kubectl -nnvm-db port-forward service/presslabs-mysql-operator 8080:80
```

To see operator logs, run following command

```bash
$ kubectl -nnvm-db logs presslabs-mysql-operator-0 -c operator -f
```

To access mysql, run following command

```bash
$ kubectl -nnvm-db port-forward mysql-cluster-mysql-0 3307:3306
$ mysql -h127.0.0.1 -uroot -proot -P3307 boilerplate
```

## Todo

- [x] Update MySQL with a replicated stateful application - Use presslabs/mysql-operator
- [ ] Expose MySQL write node for migration to avoid api migration failure
- [ ] Add HorizontalPodAutoscaler
- [ ] Add Prometheus and Grafana
