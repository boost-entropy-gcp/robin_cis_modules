---

ADMIN_PASSWORD: "{{ lookup('env', 'BIGIP_PASS') }}"
ADMIN_HTTPS_PORT: "8443"
ADMIN_USER: "admin"
APP_TAG_KEY: "Application"
APP_TAG_VALUE: "${gcp_tag_value}"
ansible_user: admin
ansible_ssh_private_key_file: /drone/src/gcp/gcp_ssh_key