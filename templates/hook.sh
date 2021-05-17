#!/bin/bash
# {{ ansible_managed }}

set -euo pipefail
{% if item == 'deploy' %}

for domain in ${RENEWED_DOMAINS}; do
    case "${domain}" in
{% for domain in certbot_certs %}
{% if domain['deploy-hook'] is defined %}
        "{{ domain['domains'][0] }}")
            {{ domain['deploy-hook'] | indent(12, false) | trim }}
        ;;
{% endif %}
{% endfor %}
        *)
            # noop
            :
        ;;
    esac
done
{% endif %}
{% if hostvars[inventory_hostname]['certbot_'+item+'_hook'] is defined %}

{{ hostvars[inventory_hostname]['certbot_'+item+'_hook'] | trim }}
{% endif %}
