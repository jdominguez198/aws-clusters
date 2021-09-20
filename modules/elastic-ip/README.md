# Elastic IPs pair for using them as Static IPs

## Introduction

Create two Elastic IP set for using them as Static IPs.

This IP can be assigned to a Network Load Balancer, or directly to a EC2 instance.

## Getting Started

### Usage

You can consume this module using the following block:

```
module "my_elastic_ips" {
  source = "../../modules/elastic-ip"

  name = "Example Name"
}
```
 
### Inputs

Name            | Description                                     | Type     | Default  |
----------------|-------------------------------------------------|----------|----------|
name            | Name used for the Elastic IPs pair              | string   | `n/a`

### Outputs

Name                      | Description
--------------------------|-------------
eip_01_id                 | Elastic IP #01 ID
eip_01_ip                 | Elastic IP #01 address
eip_02_id                 | Elastic IP #02 ID
eip_02_ip                 | Elastic IP #02 address
