# Global Accelerator

## Introduction

Create a Global Static IP set using Global Accelerator service.

This IP can be assigned to a Load Balancer, or directly to a EC2 instance.

## Prerequisites

- Non-root AWS user with enough credentials

## Getting Started

### Usage

### Inputs

Name                                 | Description                                           | Type     | Default  |
-------------------------------------|-------------------------------------------------------|----------|----------|
name                                 | Name used for the Global Accelerator                  | string   | `n/a`


### Outputs

Name                                   | Description
---------------------------------------|-------------
ga_dns_name                            | Global Accelerator DNS name
ga_ip_sets                             | Global Accelerator IP sets
