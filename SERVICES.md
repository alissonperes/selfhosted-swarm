# Monitoring Stack Overview

This document provides a comprehensive explanation of the services defined in the Docker stack file. The services are grouped into functional categories such as monitoring, visualization, orchestration, and routing. Each service is detailed with its purpose, how it is configured in the stack, and the role it plays in the system.

## Monitoring Services

The monitoring stack is composed of Prometheus, Node Exporter, and cAdvisor. These services collectively provide full visibility into the health and performance of both the host machines and the containers running in the Docker Swarm environment.

### Prometheus

Prometheus is a powerful open-source monitoring and alerting toolkit that was originally developed at SoundCloud. In this stack, Prometheus serves as the central data collection and query engine for system and application metrics. It is configured with a custom configuration file that defines scraping targets such as Node Exporter and cAdvisor.

Prometheus stores data in a time-series format and supports a powerful query language called PromQL, which allows users to extract and analyze metrics for trends, patterns, and alerting conditions. The service is configured to persist data in a dedicated Docker volume, ensuring that metrics survive container restarts. It also exposes an HTTP interface on port 9090 for querying metrics and exploring targets and alert rules.

In this deployment, Prometheus is integrated with Traefik for HTTPS-secured access via a custom domain. This enables operators to access the Prometheus web UI securely from outside the cluster.

### Node Exporter

Node Exporter is a system metrics exporter developed by the Prometheus community. It collects and exposes metrics about the host operating system, such as CPU usage, memory consumption, disk I/O, and network statistics. This service runs globally on all nodes in the Docker Swarm cluster to ensure comprehensive visibility across the entire infrastructure.

To avoid permission issues and to gather kernel-level metrics, Node Exporter mounts several directories from the host system, such as `/proc`, `/sys`, and the root filesystem. It is configured to ignore metrics from certain mount points that are either not relevant or could introduce noise into the data, such as Docker's internal directories.

By exporting these system-level metrics, Node Exporter allows Prometheus to track node resource usage over time, which is essential for capacity planning, alerting, and troubleshooting.

### cAdvisor

cAdvisor (Container Advisor) is a container monitoring tool developed by Google. It is designed to collect, aggregate, and export metrics about container performance and resource usage. These metrics include CPU usage, memory consumption, network traffic, and filesystem usage for individual containers.

cAdvisor is also deployed globally across the swarm nodes. It mounts necessary directories from the host to gain access to Docker's runtime information. These include `/var/run`, `/sys`, and `/var/lib/docker`. By doing so, it can monitor all running containers on a given host and provide granular visibility into container behavior.

The metrics exported by cAdvisor are scraped by Prometheus and complement the system-level metrics provided by Node Exporter. This combination allows for deep introspection of both the host and container layers of the system.

## Visualization Service

Grafana is used to visualize the time-series data collected by Prometheus. It provides a rich user interface to create dashboards and alerts, making monitoring data accessible and actionable.

### Grafana

Grafana is a leading open-source platform for monitoring and observability. It supports a wide variety of data sources, with Prometheus being one of the most commonly used. In this setup, Grafana is preconfigured with dashboards and data sources via a provisioning mechanism, ensuring that dashboards are consistent and automatically deployed with the service.

The Grafana container uses persistent storage to retain configuration and dashboard data. It is run under a specific user ID for security and compliance purposes. The configuration is sourced from a dedicated environment file which contains credentials and connection details.

Grafana listens on port 3000 and is exposed securely to the outside world via Traefik. This allows authorized users to log in and view real-time dashboards for infrastructure and service metrics. With Grafana, teams can monitor system health, detect anomalies, and respond to incidents more efficiently.

## Management and Orchestration

Portainer and the Portainer Agent provide a centralized and user-friendly interface for managing Docker Swarm clusters. These services simplify operational tasks such as container creation, service scaling, and volume management.

### Portainer

Portainer is a lightweight management interface that makes it easier to work with Docker and Docker Swarm. It provides an intuitive web-based UI for visualizing and managing Docker resources like containers, images, networks, and volumes.

In this stack, Portainer is deployed as a service on a manager node, with a dedicated Docker volume for persisting configuration data. It connects to the Portainer Agent using the Docker socket, enabling full visibility into cluster resources.

Portainer is accessible through multiple ports, supporting both secure (port 9443) and non-secure (port 9000) access, and an additional edge agent port (8000). Traefik is used to expose Portainer externally via a domain with HTTPS enabled, ensuring secure access.

Portainer is particularly useful for DevOps teams and system administrators who prefer a graphical interface over the CLI, and it facilitates faster onboarding for new team members.

### Portainer Agent

The Portainer Agent acts as a bridge between the Portainer UI and the Docker Engine API. It is responsible for collecting system-level information and sending it back to the Portainer server. The agent is deployed globally on all Swarm nodes and binds to the Docker socket to collect data about containers, networks, and volumes.

By distributing the agent across all nodes, Portainer can manage a multi-node cluster seamlessly from a single interface. The agent is configured to not be exposed through Traefik, keeping internal communication secure and isolated.

The agent plays a critical role in enabling Portainer to function in a Swarm environment, where services and containers can be scheduled across multiple hosts.

## Proxy and Routing

Traefik is the edge router and reverse proxy responsible for managing external access to services within the Docker Swarm cluster. It automatically discovers services using labels and configures routing rules dynamically.

### Traefik

Traefik is a modern, cloud-native edge router that supports service discovery, load balancing, SSL termination, and routing. It integrates tightly with Docker Swarm, using labels defined in service configurations to determine how traffic should be routed.

In this stack, Traefik is configured using a static configuration file, which defines entry points, providers, and certificate settings. It also mounts dynamic configuration files for fine-grained control over routing and middleware.

Traefik exposes multiple ports to support HTTP (80), HTTPS (443), its dashboard (8080, published on 8088), and an additional admin or API port (8082). It is deployed globally on manager nodes to ensure high availability and consistent routing behavior across the cluster.

Each service that needs to be exposed externally is annotated with specific Traefik labels. These labels define routing rules, internal service ports, entry points, and TLS settings. This allows Traefik to automatically update its routing table without the need for manual reconfiguration.

Traefik plays a central role in securing the platform, ensuring that only intended services are exposed and that all communication is encrypted using HTTPS.