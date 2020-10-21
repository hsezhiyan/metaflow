def task_build_docker_image():
    return {
        "actions": [
            "docker build -f integration_testing_image/Dockerfile -t metaflow-integration-testing:1.0 ."
        ],
    }

# TODO AIP-1766 Move compile_pipeline task to aip-doit-modules
def task_run_integration_tests():
    """Compiles pipeline."""
    return {
        "actions": [
            "docker run --rm "
            + "-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID "
            + "-e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY "
            + "-e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN "
            + "-e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION "
            + "metaflow-integration-testing:1.0 "
            + "bash -c '"
            + "cat /home/zservice/.kube/config && "
            + "aws sts get-caller-identity && "
            + "export KFP_RUN_URL_PREFIX=https://kubeflow.corp.dev-k8s.zg-aip.net/ && "
            + "export KFP_SDK_NAMESPACE=aip-example && "
            + "export METAFLOW_DATASTORE_SYSROOT_S3=s3://aip-example-dev/metaflow/ && "
            + "export METAFLOW_DEFAULT_DATASTORE=local && "
            + "export METAFLOW_USER=hariharans@zillowgroup.com && "
            + "cd /metaflow/metaflow/plugins/kfp/tests && "
            + "python -m pytest -s -n 2 run_integration_tests.py'"
        ],
    }
