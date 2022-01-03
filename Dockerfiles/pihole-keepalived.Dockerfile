FROM cbcrowe/pihole-unbound:2021.12.1
RUN apt update && apt install -y keepalived sqlite3 sudo git rsync ssh
