FROM vault

COPY vault-config.json /vault/config/

COPY vault-data.tar /vault/backup/

RUN tar xvf /vault/backup/vault-data.tar

EXPOSE 8200

ENTRYPOINT ["vault"]
