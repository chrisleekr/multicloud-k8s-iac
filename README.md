# Kubernetes for Node.js (REST API) + Vue.js (Frontend/Backend) + MySQL Boilerplate

This project demonstrates simple IaC (Infrastructure as Code) for [NVM boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate) to Minikube.

This is not for a production use.

## Prerequisites

- [Minikube v1.13.1](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [Kubernetes v.1.19.2](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm v3.3.4](https://helm.sh/docs/intro/install/)
- [Terraform v0.13.3](https://learn.hashicorp.com/tutorials/terraform/install-cli)

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
- Sample Helm charts to deploy multiple micro-services

## Repository: Node.js + Vue.js + MySQL Boilerplate

- [https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate)

## Todo

- [ ] Update MySQL with a replicated stateful application
- [ ] Add HorizontalPodAutoscaler

## Troubleshooting

### Failed to enable ingress in Mac OS

```bash
$ minikube addons enable ingress
❌  Exiting due to MK_USAGE: Due to networking limitations of driver docker on darwin, ingress addon is not supported.
Alternatively to use this addon you can use a vm-based driver:

   'minikube start --vm=true'

To track the update on this work in progress feature please check:
https://github.com/kubernetes/minikube/issues/7332
$ minikube stop
$ minikube delete
$ minikube start --vm=true
$ minikube addons enable ingress
```
