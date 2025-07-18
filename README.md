# Local Docker Swarm Monitoring and Management Stack

This repository contains Docker Swarm stack files for setting up a **self-hosted observability and management platform** across two nodes.  
It includes monitoring, visualization, management, and proxy services — all orchestrated via Docker Swarm.

## Stack Overview

| Stack File     | Purpose                                                                 |
|----------------|-------------------------------------------------------------------------|
| `observe.yaml` | Deploys monitoring tools: Prometheus, cAdvisor, Node Exporter, Process Exporter |
| `tools.yaml`   | Deploys visualization and management tools: Grafana, Portainer (with Agent) |
| `proxy.yaml`   | Deploys Traefik as a reverse proxy and edge router                         |


## Services

### Monitoring
- **Prometheus** — Centralized monitoring and metrics scraping.
- **Node Exporter** — Host machine metrics (CPU, memory, disk, network).
- **cAdvisor** — Container performance and resource usage metrics.
- **Process Exporter** — Exports information about individual system processes.

### Visualization
- **Grafana** — Dashboards built from Prometheus metrics.

### Management
- **Portainer** — Web UI to manage Docker Swarm resources.
- **Portainer Agent** — Node-level agent for Portainer cluster visibility.

### Proxy and Routing
- **Traefik** — Dynamic reverse proxy with HTTPS support for exposing internal services.

## Features

- 📈 Full observability of nodes and containers  
- 🔐 Secure HTTPS access via Traefik  
- 🖥️ Easy management through Portainer's web interface  
- ⚡ Automated deployment using Ansible and Docker  
- ♻️ Persistent storage for Prometheus, Grafana, and Portainer configurations  

## Deployment

Deployment is now automated using **Ansible inside a Docker container**. A helper script handles the full setup process.

### Prerequisites

- Docker and Docker Swarm initialized on all target nodes
- SSH access to each node (configured in `inventory.ini`)
- Shared overlay network for services
- Optional domain setup for HTTPS with Traefik

### How It Works

1. `./deploy.sh` builds the Docker image for the Ansible runner.
2. The Ansible container executes the playbook `deploy-all.yml`.
3. The playbook copies required files (YAML and J2 templates) to target nodes.
4. Docker stacks are deployed via `docker stack deploy` on the target nodes.

> **Note:** No `.j2` templates are currently in use, but the playbook is structured to support them in future enhancements.

### Run the Deployment

```bash
cd ansible
./deploy.sh
```

This will:
- Build the Ansible Docker image
- Run the Ansible playbook inside the container
- Deploy all configured stacks to your Swarm cluster

## Documentation

- [Services Overview](./SERVICES.md) — In-depth explanations of each service, their configurations, and roles.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Traefik](https://traefik.io/)
- [Portainer](https://www.portainer.io/)
- [cAdvisor](https://github.com/google/cadvisor)
- [Node Exporter](https://github.com/prometheus/node_exporter)
- [Ansible](https://docs.ansible.com/ansible/latest/)
- [HomePage](https://gethomepage.dev/)
