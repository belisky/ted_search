#!/bin/bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-east-1.amazonaws.com
docker tag ts-ted_search:latest 644435390668.dkr.ecr.us-east-1.amazonaws.com/nobel_tedsearch:latest
docker tag ts-ted_nginx:latest 644435390668.dkr.ecr.us-east-1.amazonaws.com/nobel_ted_nginx:latest
docker push 644435390668.dkr.ecr.us-east-1.amazonaws.com/nobel_tedsearch:latest
docker push 644435390668.dkr.ecr.us-east-1.amazonaws.com/nobel_ted_nginx:latest