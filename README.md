# Kubernetes Playground

[![Build Status Master Branch](https://travis-ci.org/ferrarimarco/kubernetes-playground.svg?branch=master)](https://travis-ci.org/ferrarimarco/kubernetes-playground)

This project is a playground to play with Kubernetes.

## Components

1. "Controller" VM: a Vagrant box running Docker where we run an Ansible instance to configure the whole environment
1. 1x Kubernetes Master
1. 3x Kubernetes Minions
1. A hyper-converged, cloud native storage cluster managed with [GlusterFS](https://github.com/gluster/gluster-kubernetes) and [Heketi](https://github.com/heketi/heketi)
1. A monitoring solution based on [Prometheus](https://prometheus.io/) and [Grafana](https://grafana.com/)
1. [Traefik](https://traefik.io/) [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress/) to map requests to services
1. A [Docker Registry](https://docs.docker.com/registry/)

## Dependencies

1. Vagrant >= 2.1.1
1. [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
1. Virtualbox >= 5.2.8

## How to Run

After installing the dependencies, run:

1. `vagrant up`

to bootstrap the environment:

1. Vagrant will provision master and worker nodes
1. Ansible will install `docker`, `kubeadm`, `kubelet` and `kubectl` and run configuration scripts to initialize the Kubernetes cluster

### Environment-specific configuration

You can find the default configuration in [`defaults.yaml`](defaults.yaml). If you want to override any default setting, create `env.yaml` and save it in the
same directory as the `defaults.yaml`. The [`Vagrantfile`](Vagrantfile) will instruct Vagrant to load it.

### Cloud Native Storage

To deploy GlusterFS, SSH into the master and run the configuration script:

1. `vagrant ssh kubernetes-master-1.kubernetes-playground.local`
1. `sudo /vagrant/scripts/linux/bootstrap-glusterfs.sh`

### Ingress Controller

To deploy the Ingress controller, SSH into the master and run the configuration script:

1. `vagrant ssh kubernetes-master-1.kubernetes-playground.local`
1. `sudo /vagrant/scripts/linux/bootstrap-ingress-controller.sh`

The Traefik monitoring UI is accessible at `http://kubernetes-master-1.kubernetes-playground.local/monitoring/ingress`

### Helm

To initialize Helm, SSH into the master and run the configuration script:

1. `vagrant ssh kubernetes-master-1.kubernetes-playground.local`
1. `sudo /vagrant/scripts/linux/bootstrap-helm.sh`

### Monitoring

To deploy the monitoring solution, SSH into the master and run the configuration script:

1. `vagrant ssh kubernetes-master-1.kubernetes-playground.local`
1. Initialize Helm as described
1. Initialize the Ingress Controller as described
1. `sudo /vagrant/scripts/linux/bootstrap-monitoring.sh`

The monitoring dashboard is accessible at `http://kubernetes-master-1.kubernetes-playground.local/monitoring/cluster`

### Docker Registry

To deploy a private Docker Registry, SSH into the master and run the configuration script:

1. `vagrant ssh kubernetes-master-1.kubernetes-playground.local`
1. Initialize Helm as described
1. Initialize the Ingress Controller as described
1. `sudo /vagrant/scripts/linux/bootstrap-docker-registry.sh`

The registry is accessible at `https://registry.kubernetes-playground.local`

### Additional Components

1. Multiple load balanced nginx server instances
1. A busybox instance, useful for debugging and troubleshooting (run commands with `kubectl exec`. Example: `kubectl exec -ti busybox -- nslookup hostname`)

### Automatic Ansible Inventory Creation

When you run any vagrant command, an Ansible inventory (and related group_vars) will be generated in the ansible directory.
Note that the contents of those file will be overidden on each run.

### Secure Communication

We generate a self-signed wildcard certificate to use for all the ingress controllers.
