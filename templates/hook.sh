#!/bin/bash
# {{ ansible_managed }}

set -euo pipefail

case "${RENEWED_DOMAINS}" in
{% for domain in certbot_certs %}
{% if domain[item+'-hook'] is defined %}
    "{{ domain['domains'][0] }}")
        {{ domain[item+'-hook'] | indent(8, false) }}
    ;;
{% endif %}
{% endfor %}
    *)
        # noop
        :
    ;;
esac
