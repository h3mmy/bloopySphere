FROM cbcrowe/pihole-unbound:2022.11.2
RUN apt update && apt install -y keepalived sqlite3 sudo git rsync ssh
