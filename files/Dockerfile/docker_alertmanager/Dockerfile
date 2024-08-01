FROM bitnami/alertmanager:latest

RUN mkdir -p /alertmanager

COPY alertmanager.yml /alertmanager/alertmanager.yml

EXPOSE 9093

CMD ["--config.file=/alertmanager/alertmanager.yml"]