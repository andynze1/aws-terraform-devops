#!/bin/bash

aws eks update-kubeconfig --name vtech-eks-cluster --region us-east-1
#aws eks update-kubeconfig --name vtech-eks-cluster --region us-east-1 --profile eks-admin