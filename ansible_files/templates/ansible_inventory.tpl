#Robin node vars
[robin_systems]
${gcp_robin1_endpoint}
${gcp_robin2_endpoint}
${gcp_robin3_endpoint}

#F5 BIG-IP Group with associated host vars
[F5_systems]
# Must be in the form of <public IP> vs_ip=<private ip of the F5>
${gcp_F51_public_ip} vs_ip=${gcp_F51_private_ip}  
${gcp_F52_public_ip} vs_ip=${gcp_F52_private_ip}  
${gcp_F53_public_ip} vs_ip=${gcp_F53_private_ip} 

[robin_systems:vars]
# Enter in the user associated with the instance ssh key registered in GCP
ansible_user=f5user
# The location of the instance ssh key.
ansible_ssh_private_key_file=/drone/src/gcp/gcp_ssh_key

[all:vars]
# ep_list is used for defining the upstreams in the NGINX configuration. It can be given a default value and can be overriden later using set_fact in a role i.e. NGINX endpoints creation role
ep_list1=default('undefined')
ep_list2=default('undefined')
ep_list3=default('undefined')


# https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html