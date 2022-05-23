FROM prom/blackbox-exporter:v0.17.0

COPY ./blackbox.yml /etc/blackbox_exporter/blackbox.yml

CMD [ "--config.file=/etc/blackbox_exporter/blackbox.yml" ]

EXPOSE 9115
