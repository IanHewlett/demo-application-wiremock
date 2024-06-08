#!/usr/bin/env just --justfile

@_default:
  just --list

#create-configmaps:
#  kubectl create configmap -n {{namespace}} mappings --from-file=./app/mappings --dry-run=client -o yaml > ./base/configmap-mappings.yaml
#  kubectl create configmap -n {{namespace}} responses --from-file=./app/__files --dry-run=client -o yaml > ./base/configmap-responses.yaml

#create-opa-configmap:
#  kubectl create configmap -n {{namespace}} opa-policy --from-file=./config/policy.rego --dry-run=client -o yaml > ./base/configmap-opa-policy.yaml

get-vars instance:
  @vault kv get -format=json -namespace=admin secret/svc/env-values/{{instance}} | jq -r '.data.data."{{instance}}"' | yq -p json -o yaml > inputs.yaml

test-spec instance: (get-vars instance)
  inspec exec spec --tags=spec --input-file inputs.yaml
