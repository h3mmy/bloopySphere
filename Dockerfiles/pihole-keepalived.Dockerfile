FROM cbcrowe/pihole-unbound:2022.07.1
RUN apt update && apt install -y keepalived sqlite3 sudo git rsync ssh
