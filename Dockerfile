FROM hsezhiyan/metaflow-integration-testing:1.0
COPY . /metaflow
COPY /root/.kube /home/zservice/.kube
RUN pip install -e /metaflow
