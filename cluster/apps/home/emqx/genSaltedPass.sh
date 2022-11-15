#!/usr/bin/env bash
while IFS="," read -r user pass
do
  salt=$(uuidgen)
  saltedpass=$(echo -n "${salt}${pass}" | openssl dgst -sha256 | sed 's/^.* //')
  echo "INSERT INTO mqtt_user(username, password_hash, salt, is_superuser) VALUES ('$user', '$saltedpass', '$salt', true);"
done < emqx_user_list.txt
