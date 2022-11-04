FROM vault

COPY vault-config.json /vault/config/

COPY vault-data.tar /vault/backup/

EXPOSE 8200

ENTRYPOINT ["vault"]
