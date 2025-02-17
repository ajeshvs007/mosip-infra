#!/bin/sh
# Usage: ./upload_md.sh <mosip-data repo path> [kubeconfig file]
# Default kubeconfig file is $HOME/.kube/config
if [ $# -ge 2 ]
  then
    export KUBECONFIG=$2
fi

read -p "Enter IAM username: " iam_user

# This username is hardcoded in sql scripts
DB_PWD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath={.data.postgresql-password} | base64 --decode)
DB_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
DB_PORT=5432
XLS_FOLDER_PATH=$1/data-dml/mosip_master/xlsx

while true; do
    read -p "WARNING: All existing masterdata will be erased. Are you sure?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        echo Uploading ..
        cd lib
        python upload_masterdata.py $DB_HOST $DB_PWD $iam_user $XLS_FOLDER_PATH  --tables_file table_order
        break
      else
        break
    fi
done
