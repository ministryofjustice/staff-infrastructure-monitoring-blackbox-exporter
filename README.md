# Infrastructure Monitoring and Alerting Platform - Blackbox Exporter

## Table of contents

- [About the project](#about-the-project)
  - [Our repositories](#our-repositories)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Create an .env](#create-an-env)
- [Usage](#usage)
  - [Running the code for development](#running-the-code-for-development)
- [License](#license)

## About the project

This project is part of the [Infrastructure Monitoring and Alerting (IMA) Platform](https://github.com/ministryofjustice/staff-infrastructure-monitoring).
It holds the Docker image for pulling data from the Physical Devices.

[Prometheus's blackbox
exporter](https://github.com/prometheus/blackbox_exporter) is used as the base
image. It's stored in an AWS ECR repository within the MoJ's Shared Services
account that is created by the [PTTP Shared Services
Infrastructure](https://github.com/ministryofjustice/pttp-shared-services-infrastructure)
and [Staff Device Docker Base
Images](https://github.com/ministryofjustice/staff-device-docker-base-images) GitHub repositories.

### Our repositories

- [IMA Platform](https://github.com/ministryofjustice/staff-infrastructure-monitoring) - to monitor MoJ infrastructure and physical devices
- [Configuration](https://github.com/ministryofjustice/staff-infrastructure-monitoring-datasource-config) - to provision configuration for the IMA Platform
- [SNMP Exporter](https://github.com/ministryofjustice/staff-infrastructure-monitoring-snmpexporter) - to scrape data from physical devices (Docker image)
- [Blackbox Exporter](https://github.com/ministryofjustice/staff-infrastructure-monitoring-blackbox-exporter) - to probe endpoints over HTTP, HTTPS, DNS, TCP and ICMP.s (Docker image)
- [Metric Aggregation Server](https://github.com/ministryofjustice/staff-infrastructure-metric-aggregation-server) - to pull data from the SNMP exporter (Docker image)
- [Shared Services Infrastructure](https://github.com/ministryofjustice/pttp-shared-services-infrastructure) - to manage our CI/CD pipelines

## Getting started

### Prerequisites

- [AWS Command Line Interface (CLI)](https://aws.amazon.com/cli/) - to manage AWS services
- [AWS Vault](https://github.com/99designs/aws-vault) - to easily manage and switch between AWS account profiles on the command line
- [Docker](https://www.docker.com/get-started) - to containerise and run Prometheus

### Create a `.env`

1. Duplicate `.env.example` and rename the file to `.env`
2. Set values for all the variables

## Usage

### Running the code for development

To locally run Prometheus:

```
make serve
```

To manually push an image to your AWS ECR repository:

```
aws-vault exec moj-pttp-dev -- make deploy
```

To view your image within the AWS Management Console:

```
aws-vault login moj-pttp-dev
```

## License

[MIT License](LICENSE)
