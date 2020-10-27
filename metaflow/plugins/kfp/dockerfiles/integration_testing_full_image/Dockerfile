FROM hsezhiyan/metaflow-integration-testing:1.1
COPY . /home/zservice/metaflow
# COPY .kube /home/zservice/.kube
# RUN mkdir /home/zservice/.kube
# RUN touch /home/zservice/.kube/config
RUN pip install -e /home/zservice/metaflow
