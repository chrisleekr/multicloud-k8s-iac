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
   $ minikube addons enable metrics-server
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

## With this project, you can find

- Sample Terraform
- Sample Helm charts to deploy multiple containerised micro-services

## Micro-services Repository: Node.js + Vue.js + MySQL Boilerplate

- [https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate](https://github.com/chrisleekr/nodejs-vuejs-mysql-boilerplate)

## Presslabs MySQL Operator

To see orchestrator, run following port forward.

```bash
$ kubectl -nnvm-db port-forward service/presslabs-mysql-operator 8080:80
```

![image](https://user-images.githubusercontent.com/5715919/100513791-ed9ff900-31c3-11eb-80c6-7a3d332d272d.png)

And open [http://localhost:8080](http://localhost:8080)

To see operator logs, run following command

```bash
$ kubectl -nnvm-db logs presslabs-mysql-operator-0 -c operator -f
```

To access mysql, run following command

```bash
$ kubectl -nnvm-db port-forward mysql-cluster-mysql-0 3307:3306
$ mysql -h127.0.0.1 -uroot -proot -P3307 boilerplate
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

grafana_admin_password = ynSVNykpU72RM5x6
```

For example, as above, if admin password `ynSVNykpU72RM5x6` then you can login Grafana with `admin`/`ynSVNykpU72RM5x6`.

![image](https://user-images.githubusercontent.com/5715919/100513860-4a031880-31c4-11eb-8ef2-04202055aa78.png)

## Todo

- [x] Update MySQL with a replicated stateful application - Use presslabs/mysql-operator
- [x] Add HorizontalPodAutoscaler
- [x] Add Prometheus and Grafana
- [x] Expose MySQL write node for migration to avoid api migration failure
