FROM grafana/grafana:latest

EXPOSE 3000

COPY grafana.ini /etc/grafana/grafana.ini

CMD ["grafana-server", "--config=/etc/grafana/grafana.ini"]