FROM hsezhiyan/metaflow-integration-testing:1.0
# RUN aws sts get-caller-identity
RUN aws sts assume-role --role-arn arn:aws:iam::137756892286:role/service-ai-platform-dev-gitlab-runner --role-session-name s3-access-session
COPY . /metaflow
RUN pip install -e /metaflow
RUN pip install 
RUN export KFP_RUN_URL_PREFIX=https://kubeflow.corp.dev-k8s.zg-aip.net/ && \
    export KFP_SDK_NAMESPACE=metaflow-integration-testing && \
    export METAFLOW_DATASTORE_SYSROOT_S3=s3://aip-example-stage/metaflow/ && \
    export METAFLOW_DEFAULT_DATASTORE=local && \
    export METAFLOW_USER=hariharans@zillowgroup.com && \
    cd /metaflow/metaflow/plugins/kfp/tests && \
    python -m pytest -s -n 2 run_integration_tests.py
    # python static_branching.py --datastore=s3 kfp run
    # python -c "import boto3; sess = boto3.Session(); print(sess.available_profiles)"