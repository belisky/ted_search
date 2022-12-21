#!/bin/bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-east-1.amazonaws.
docker build -t nobel_tedsearch .
docker tag nobel_tedsearch:latest 644435390668.dkr.ecr.us-east-1.amazonaws.com/nobel_tedsearch:latest
docker push 644435390668.dkr.ecr.us-east-1.amazonaws.com/nobel_tedsearch:latest