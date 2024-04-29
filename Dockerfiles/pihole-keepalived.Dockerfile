FROM cbcrowe/pihole-unbound:2024.03.2
RUN apt update && apt install -y keepalived sqlite3 sudo git rsync ssh
