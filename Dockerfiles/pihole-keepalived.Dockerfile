FROM cbcrowe/pihole-unbound:2023.01.10
RUN apt update && apt install -y keepalived sqlite3 sudo git rsync ssh
