FROM apache/airflow:2.0.1-python3.8

ARG PYTHON_MAJOR_MINOR_VERSION="3.8"
ENV PYTHON_MAJOR_MINOR_VERSION=${PYTHON_MAJOR_MINOR_VERSION}

RUN pip install awscli \
                apache-airflow-providers-tableau==1.0.0 \
                apache-airflow-providers-apache-druid==1.1.0 \
                envyaml==1.7.210310

# Modifications to the make image compatible with ami Support Arbitrary User IDs
USER root

# directories to be modified
RUN chgrp -R 0 /home/airflow && chmod -R g=u /home/airflow

RUN chgrp -R 0 ${AIRFLOW_HOME} && chmod -R g=u ${AIRFLOW_HOME}

# airflow users python site-packages must be available to arbitrary user
RUN echo "/home/airflow/.local/lib/python${PYTHON_MAJOR_MINOR_VERSION}/site-packages" > /usr/local/lib/python${PYTHON_MAJOR_MINOR_VERSION}/site-packages/airflow.pth

RUN chmod g=u /etc/passwd
