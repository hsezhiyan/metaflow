import os
from pathlib import Path

def _metaflow_kube_mounts():
    return (
       ("-v /root/.kube:/home/zservice/.kube " if (Path.home() / Path(".kube")).exists() else "")
       + ("-v /root/.aws:/home/zservice/.aws " if (Path.home() / Path(".aws")).exists() else ""))

def task_build_docker_image():
    return {
        "actions": [
            "docker build --tag metaflow-integration-testing:1.0 ."
        ],
    }

# TODO AIP-1766 Move compile_pipeline task to aip-doit-modules
def task_run_integration_tests():
    """Compiles pipeline."""
    return {
        "actions": [
            "docker run --rm "
            + _metaflow_kube_mounts()
            + "metaflow-integration-testing:1.0 "
            + "bash -c '"
            + "aws sts get-caller-identity && "
            + "export KFP_RUN_URL_PREFIX=https://kubeflow.corp.dev-k8s.zg-aip.net/ && "
            + "export KFP_SDK_NAMESPACE=metaflow-integration-testing && "
            + "export METAFLOW_DATASTORE_SYSROOT_S3=s3://aip-example-dev/metaflow/ && "
            + "export METAFLOW_DEFAULT_DATASTORE=local && "
            + "export METAFLOW_USER=hariharans@zillowgroup.com && "
            + "cd /metaflow/metaflow/plugins/kfp/tests && "
            + "python -m pytest -s -n 2 run_integration_tests.py'"
        ],
    }

"""
docker run -v $(pwd):/opt/zillow hsezhiyan/metaflow-integration-testing:1.0 bash -c 'pip install -e /opt/zillow'
"""
