FROM hsezhiyan/metaflow-integration-testing:1.0
COPY . /home/zservice/metaflow
COPY .kube /home/zservice/.kube
RUN ls /home/zservice/metaflow
RUN pip install -e /home/zservice/metaflow
