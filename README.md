Ansible role: Certbot Hooks
===========================

This role builds on top of the geerlingguy.certbot role to add
additional functionality for adding hook scripts.
Customizable deploy hook scripts can be configured per
certificate by setting the deploy-hook key which is added to
the certbot_certs dict.  Customizable pre/post hook scripts
can be configured via the new certbot_pre_hook and
certbot_post_hook variables.

Requirements
------------

This role depends on the [geerlingguy.certbot role](https://github.com/geerlingguy/ansible-role-certbot).

Role Variables
--------------

```
ENTRY POINT: main - Add certbot hook scripts

        This role builds on top of the geerlingguy.certbot role to add
        additional functionality for adding hook scripts.
        Customizable deploy hook scripts can be configured per
        certificate by setting the deploy-hook key which is added to
        the certbot_certs dict.  Customizable pre/post hook scripts
        can be configured via the new certbot_pre_hook and
        certbot_post_hook variables.

OPTIONS (= is mandatory):

- certbot_post_hook
        Contents for the post hook script
        [Default: (null)]
        type: str

- certbot_pre_hook
        Contents for the pre hook script
        [Default: (null)]
        type: str
```

Installation
------------

This role can either be installed manually with the ansible-galaxy CLI tool:

    ansible-galaxy install geerlingguy.certbot
    ansible-galaxy install git+https://github.com/wandansible/certbot.hooks,main,wandansible.certbot.hooks
     
Or, by adding the following to `requirements.yml`:

    - src: geerlingguy.certbot
    - name: wandansible.certbot.hooks
      src: https://github.com/wandansible/certbot.hooks

Roles listed in `requirements.yml` can be installed with the following ansible-galaxy command:

    ansible-galaxy install -r requirements.yml

Example Playbook
----------------

    - hosts: web_servers
      roles:
         - role: wandansible.certbot.hooks
           become: true
           vars:
             certbot_certs:
               - domains:
                   - "example.org"
                 webroot: "/var/www/html"
                 deploy-hook: |
                   systemctl reload apache2

             certbot_admin_email: "sysadmin@example.org"
             certbot_auto_renew: false
             certbot_create_if_missing: true
             certbot_create_standalone_stop_services: []
             certbot_create_command: >-
               {{ certbot_script }} certonly
               --noninteractive --agree-tos
               --webroot --webroot-path {{ cert_item.webroot }}
               --email {{ cert_item.email | default(certbot_admin_email) }}
               --pre-hook /etc/letsencrypt/renewal-hooks/pre/hook.sh
               --post-hook /etc/letsencrypt/renewal-hooks/post/hook.sh
               --deploy-hook /etc/letsencrypt/renewal-hooks/deploy/hook.sh
               -d {{ cert_item.domains | join(',') }}
