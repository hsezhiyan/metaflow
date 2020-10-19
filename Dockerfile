FROM hsezhiyan/metaflow-integration-testing:1.0
COPY . /metaflow
RUN pip install -e /metaflow
RUN aws sts get-caller-identity
# RUN aws sts assume-role --role-arn arn:aws:iam::867983855862:role/deploy-kubeflow-pipeline-editors --role-session-name s3-access-session
RUN export KFP_RUN_URL_PREFIX=https://kubeflow.corp.dev-k8s.zg-aip.net/ && \
    export KFP_SDK_NAMESPACE=metaflow-integration-testing && \
    export METAFLOW_DATASTORE_SYSROOT_S3=s3://aip-example-stage/metaflow/ && \
    export METAFLOW_DEFAULT_DATASTORE=local && \
    export METAFLOW_USER=hariharans@zillowgroup.com && \
    cd /metaflow/metaflow/plugins/kfp/tests && \
    python -m pytest -s -n 2 run_integration_tests.py