FROM rocker/rstudio

COPY add_accounts /etc/cont-init.d/add_accounts
COPY add_cert /etc/cont-init.d/add_cert

CMD ["/init"]
