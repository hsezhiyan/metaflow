FROM hsezhiyan/metaflow-integration-testing:1.0
COPY . /metaflow
RUN pip install -e /metaflow
