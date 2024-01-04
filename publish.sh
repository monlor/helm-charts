#!/bin/bash

set -e

helm lint charts/*

# rm -rf ./*.tgz

helm package charts/*  --destination package

helm repo index --url https://monlor.github.io/helm-charts/package/ package

mv -f package/index.yaml .

cat index.yaml
