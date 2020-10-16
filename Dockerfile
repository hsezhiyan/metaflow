FROM hsezhiyan/metaflow-integration-testing:1.0
RUN ls ~/.aws
RUN cat ~/.aws/credentials
COPY . /metaflow
RUN pip install -e /metaflow
RUN export KFP_RUN_URL_PREFIX=https://kubeflow.corp.dev.zg-aip.net/ && \
    export KFP_SDK_NAMESPACE=aip-example && \
    export METAFLOW_DATASTORE_SYSROOT_S3=s3://aip-example-dev/metaflow && \
    export METAFLOW_DEFAULT_DATASTORE=local && \
    export METAFLOW_USER=hariharans@zillowgroup.com && \
    cd /metaflow/metaflow/plugins/kfp/tests && \
    python -m pytest -s -n 2 run_integration_tests.py