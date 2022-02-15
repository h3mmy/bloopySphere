#!/bin/bash
set -o nounset
set -o errexit

# Alternate ones include
# ipv4.icanhazip.com or ipv6.icanhazip.com
# https://ifconfig.co with the -4 flag
IP4=$(curl -s https://1.1.1.1/cdn-cgi/trace)
IP6=$(curl -s https://[2606:4700:4700::1111]/cdn-cgi/trace)


for domain in $(jq -r '.[] | @base64' ./ddns_data.json ); do
    _jq() {
        echo "${domain}" | base64 --decode | jq -r "$1"
    }

    TOKEN=$(_jq '.token')
    ZONE=$(_jq '.zone')
    RECORD_4=$(_jq '.record_4')
    RECORD_6=$(_jq '.record_6')

    zone_details=$(
        curl -s -X GET \
            "https://api.cloudflare.com/client/v4/zones?name=${ZONE}" \
            -H "Authorization: Bearer ${TOKEN}" \
            -H "Content-Type: application/json"
    )

    if echo "${zone_details}" | grep -q '\"success\":false'; then
        printf "%s - Yikes - Getting details for zone '%s' has failed\n" "$(date -u)" "${ZONE}"
        exit 1
    fi
    zone_identifier=$(echo "$zone_details" | jq -c -r '.result[0].id')

    record4=$(
        curl -s -X GET \
            "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records?name=${RECORD_4}&type=A" \
            -H "Authorization: Bearer ${TOKEN}" \
            -H "Content-Type: application/json"
    )
    old_ip4=$(echo "${record4}" | sed -n 's/.*"content":"\([^"]*\).*/\1/p')
    if [ "${IP4}" = "${old_ip4}" ]; then
        printf "%s - Success - IP Address '%s' has not changed for '%s' in zone '%s'\n" "$(date -u)" "${IP4}" "${RECORD}" "${ZONE}"
        continue
    fi

    record4_identifier=$(echo "${record4}" | sed -n 's/.*"id":"\([^"]*\).*/\1/p')
    update4=$(
        curl -s -X PUT \
            "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records/${record4_identifier}" \
            -H "Authorization: Bearer ${TOKEN}" \
            -H "Content-Type: application/json" \
            --data "{\"id\":\"${zone_identifier}\",\"type\":\"A\",\"proxied\":true,\"name\":\"${RECORD_4}\",\"content\":\"${IP4}\"}"
    )

    if echo "${update4}" | grep -q '\"success\":false'; then
        printf "%s - Yikes - Updating IP Address '%s' has failed for '%s' in zone '%s'\n" "$(date -u)" "${IP4}" "${RECORD_4}" "${ZONE}"
        exit 1
    else
        printf "%s - Success - IP Address '%s' has been updated for '%s' in zone '%s'\n" "$(date -u)" "${IP4}" "${RECORD_4}" "${ZONE}"
    fi

    record6=$(
        curl -s -X GET \
            "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records?name=${RECORD_6}&type=A" \
            -H "Authorization: Bearer ${TOKEN}" \
            -H "Content-Type: application/json"
    )
    old_ip6=$(echo "${record6}" | sed -n 's/.*"content":"\([^"]*\).*/\1/p')
    if [ "${IP6}" = "${old_ip6}" ]; then
        printf "%s - Success - IP Address '%s' has not changed for '%s' in zone '%s'\n" "$(date -u)" "${IP6}" "${RECORD_6}" "${ZONE}"
        continue
    fi

    record6_identifier=$(echo "${record6}" | sed -n 's/.*"id":"\([^"]*\).*/\1/p')
    update6=$(
        curl -s -X PUT \
            "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records/${record6_identifier}" \
            -H "Authorization: Bearer ${TOKEN}" \
            -H "Content-Type: application/json" \
            --data "{\"id\":\"${zone_identifier}\",\"type\":\"A\",\"proxied\":true,\"name\":\"${RECORD_6}\",\"content\":\"${IP6}\"}"
    )

    if echo "${update6}" | grep -q '\"success\":false'; then
        printf "%s - Yikes - Updating IP Address '%s' has failed for '%s' in zone '%s'\n" "$(date -u)" "${IP4}" "${RECORD_6}" "${ZONE}"
        exit 1
    else
        printf "%s - Success - IP Address '%s' has been updated for '%s' in zone '%s'\n" "$(date -u)" "${IP4}" "${RECORD_6}" "${ZONE}"
    fi
done
