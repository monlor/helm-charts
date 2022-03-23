#!/bin/bash

set -e

helm lint charts/*

helm package charts/*

helm repo index --url https://monlor.github.io/helm-charts/ .

cat index.yaml
