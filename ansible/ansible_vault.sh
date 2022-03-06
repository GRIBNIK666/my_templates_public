##ansible_vault.info
ansible-vault <args>
#
    create              Create new vault encrypted file
    decrypt             Decrypt vault encrypted file
    edit                Edit vault encrypted file
    view                View vault encrypted file
    encrypt             Encrypt YAML file
    encrypt_string      Encrypt a string
    rekey               Re-key a vault encrypted file
#
#Encrypting file (pref .YAML) with password (single!)
ansible-vault encrypt inventory-test #Password: Test
#After inventory file is encrypted you have to "ask for password" to provide ansible with password
ansible-playbook install_apache_multi-distrib.yml \
    --ask-vault-pass
#
#DEcrypting file with password (returns to original state)
ansible-vault decrypt inventory-test #Password: Test
#Create password file and specify path
mkdir .ansible
touch .ansible/ansible-key.txt
echo 'test' >> ./.ansible/ansible-key.txt
ansible-playbook install_apache_multi-distrib.yml \
    --vault-password-file ./.ansible/ansible-key.txt
#EDIT encrypted file using ansible vault
ansible-vault edit install_apache_multi-distrib.yml
#CHANGE password for encrypted file
ansible-vault rekey install_apache_multi-distrib.yml
#GET password from sh script #doesn't work)
    #mv ansible-key.txt ansible-key.sh
    #    #contents
    #    echo 'test'
    #    #
    #chmod +x ./.ansible/ansible-key.sh #make executable
    #    
    #    ansible-playbook install_apache_multi-distrib.yml --vault-password-file ./.ansible/ansible-key.sh
#
