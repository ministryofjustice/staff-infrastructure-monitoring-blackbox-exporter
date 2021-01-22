ARG SHARED_SERVICES_ACCOUNT_ID
FROM ${SHARED_SERVICES_ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/blackbox-exporter:prom-blackbox-exporter-v0-17-0

COPY ./blackbox.yml /etc/blackbox_exporter/blackbox.yml

CMD [ "--config.file=/etc/blackbox_exporter/blackbox.yml" ]

EXPOSE 9115
