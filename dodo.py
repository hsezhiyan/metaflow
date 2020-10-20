import os
from pathlib import Path

def _metaflow_kube_mounts():
    return (
        "-v /root/.metaflowconfig:/home/zservice/.metaflowconfig "
       + ("-v /root/.kube:/home/zservice/.kube " if (Path.home() / Path(".kube")).exists() else "")
       + ("-v /root/.aws:/home/zservice/.aws " if (Path.home() / Path(".aws")).exists() else ""))

# TODO AIP-1766 Move compile_pipeline task to aip-doit-modules
def task_run_integration_tests():
    """Compiles pipeline."""
    return {
        "actions": [
            "docker run --rm -v /builds/analytics/artificial-intelligence/ai-platform/aip-workflow/aip-metaflow-cicd-integration:/home/zservice "
            + "hsezhiyan/metaflow-integration-testing:1.0 "
            + "bash -c '"
            + "ls && "
            + "export KFP_RUN_URL_PREFIX=https://kubeflow.corp.dev-k8s.zg-aip.net/ && "
            + "export KFP_SDK_NAMESPACE=aip-example && "
            + "export METAFLOW_DATASTORE_SYSROOT_S3=s3://aip-example-dev/metaflow/ && "
            + "export METAFLOW_DEFAULT_DATASTORE=local && "
            + "export METAFLOW_USER=hariharans@zillowgroup.com && "
            + "pip install -e /home/zservice && "
            + "cd /home/zservice/metaflow/plugins/kfp/tests && "
            + "python -m pytest -s -n 2 run_integration_tests.py'"
        ],
    }

"""
docker run -v $(pwd):/opt/zillow hsezhiyan/metaflow-integration-testing:1.0 bash -c 'pip install -e /opt/zillow'
"""
