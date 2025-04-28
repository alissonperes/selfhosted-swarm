# Local Docker Swarm Monitoring and Management Stack

This repository contains Docker Swarm stack files for setting up a **self-hosted observability and management platform** across two nodes.  
It includes monitoring, visualization, management, and proxy services — all orchestrated via Docker Swarm.

---

## Stack Overview

| Stack File     | Purpose                                                                 |
|----------------|-------------------------------------------------------------------------|
| `observe.yaml` | Deploys monitoring tools: Prometheus, cAdvisor, Node Exporter, Process Exporter |
| `tools.yaml`   | Deploys visualization and management tools: Grafana, Portainer (with Agent) |
| `proxy.yaml`   | Deploys Traefik as a reverse proxy and edge router                         |

---

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
- ⚡ Fast setup using Docker Swarm stack files
- ♻️ Persistent storage for Prometheus, Grafana, and Portainer configurations

## Getting Started

**Requirements:**
- Docker and Docker Swarm initialized on one or more nodes
- Shared network across nodes
- Basic domain setup (optional, for HTTPS with Traefik)

### Deploy the stacks

1. **Proxy Stack** (Traefik):

    ```bash
    docker stack deploy -c proxy.yaml proxy
    ```

2. **Monitoring Stack** (Prometheus, Node Exporter, cAdvisor, Process Exporter):

   ```bash
   docker stack deploy -c observe.yaml observe
   ```

3. **Tools Stack** (Grafana, Portainer):

   ```bash
   docker stack deploy -c tools.yaml tools
   ```

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

