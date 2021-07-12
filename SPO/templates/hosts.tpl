[bastion]
${bastion}

[monitoring]
${monitoring}

[monitoring:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -i ~/.ssh/spokey.pem -W %h:%p -q ubuntu@${bastion}"'
ansible_ssh_user=ubuntu

[relays]
${relay1}
${relay2}
${relay3}

[relays:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -i ~/.ssh/spokey.pem -W %h:%p -q ubuntu@${bastion}"'
ansible_ssh_user=ubuntu