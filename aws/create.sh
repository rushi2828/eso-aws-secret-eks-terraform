#!/bin/bash
aws secretsmanager create-secret \
  --name demo/external-secret \
  --secret-string '{"username":"devops-user","password":"SuperSecret"}' \
  --region us-east-1
