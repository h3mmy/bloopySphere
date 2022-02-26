#!/bin/bash
set -o nounset
set -o errexit

# Alternate ones include
# ipv4.icanhazip.com or ipv6.icanhazip.com
# https://ifconfig.co with the -4 flag
IP4=$(dig +short txt ch whoami.cloudflare @1.1.1.1 | tr -d '"')
IP6_PREFIX=$(dig +short txt ch whoami.cloudflare @2606:4700:4700::1111 | cut -d ':' -f1-4 | tr -d '"')

#IP4_HTTP=$(curl -s https://1.1.1.1/cdn-cgi/trace)
#IP6_PREFIX_HTTP=$(curl -s "https://[2606:4700:4700::1111]/cdn-cgi/trace" | cut -d ':' -f1-4)


for domain in $(jq -r '.[] | @base64' ./ddns_data.json); do
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
        printf "%s - Success - IP Address '%s' has not changed for '%s' in zone '%s'\n" "$(date -u)" "${IP4}" "${RECORD_4}" "${ZONE}"
    else
        record4_identifier=$(echo "${record4}" | sed -n 's/.*"id":"\([^"]*\).*/\1/p')
        update4=$(
            curl -s -X PUT \
                "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records/${record4_identifier}" \
                -H "Authorization: Bearer ${TOKEN}" \
                -H "Content-Type: application/json" \
                --data "{\"id\":\"${zone_identifier}\",\"type\":\"A\",\"proxied\":true,\"name\":\"${RECORD_4}\",\"content\":\"${IP4}\"}"
        )

        if echo "${update4}" | grep -q '\"success\":false'; then
            printf "%s - Yikes - Updating IP Address '%s' has failed for '%s' in zone '%s' oldip=%s\n" "$(date -u)" "${IP4}" "${RECORD_4}" "${ZONE}" "${old_ip4}"
            exit 1
        else
            printf "%s - Success - IP Address '%s' has been updated for '%s' in zone '%s'\n" "$(date -u)" "${IP4}" "${RECORD_4}" "${ZONE}"
        fi
    fi

    # IPv6
    record6=$(
        curl -s -X GET \
            "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records?name=${RECORD_6}&type=AAAA" \
            -H "Authorization: Bearer ${TOKEN}" \
            -H "Content-Type: application/json"
    )
    # We only check if the prefix has changed and retain the postfix/suffix/device-id
    # the suffix is set by my internal network policies
    old_IP6_PREFIX=$(echo "${record6}" | sed -n 's/.*"content":"\([^"]*\).*/\1/p' | cut -d ':' -f1-4)
    IP6_POSTFIX=$(echo "${record6}" | sed -n 's/.*"content":"\([^"]*\).*/\1/p' | cut -d ':' -f5-8)
    if [ "${IP6_PREFIX}" = "${old_IP6_PREFIX}" ]; then
        printf "%s - Success - IP Address '%s' has not changed for '%s' in zone '%s'\n" "$(date -u)" "${IP6_PREFIX}" "${RECORD_6}" "${ZONE}"
        continue
    fi

    record6_identifier=$(echo "${record6}" | sed -n 's/.*"id":"\([^"]*\).*/\1/p')
    update6=$(
        curl -s -X PUT \
            "https://api.cloudflare.com/client/v4/zones/${zone_identifier}/dns_records/${record6_identifier}" \
            -H "Authorization: Bearer ${TOKEN}" \
            -H "Content-Type: application/json" \
            --data "{\"id\":\"${zone_identifier}\",\"type\":\"AAAA\",\"proxied\":true,\"name\":\"${RECORD_6}\",\"content\":\"${IP6_PREFIX}${IP6_POSTFIX}\"}"
    )

    if echo "${update6}" | grep -q '\"success\":false'; then
        printf "%s - Yikes - Updating IP Address '%s' has failed for '%s' in zone '%s'\n" "$(date -u)" "${IP6_PREFIX}${IP6_POSTFIX}" "${RECORD_6}" "${ZONE}"
        exit 1
    else
        printf "%s - Success - IP Address '%s' has been updated for '%s' in zone '%s'\n" "$(date -u)" "${IP6_PREFIX}${IP6_POSTFIX}" "${RECORD_6}" "${ZONE}"
    fi
done
