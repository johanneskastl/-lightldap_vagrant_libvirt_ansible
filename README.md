# lightldap_vagrant_libvirt_ansible

This Vagrant setup creates a VM and installs
[lldap](https://github.com/lldap/lldap) on it.

Default OS is openSUSE Leap 15.6. Although that can be changed in the
Vagrantfile, please beware that this will break the Ansible provisioning.

## Vagrant

1. You need vagrant obviously. And ansible. And git...
1. Fetch the box, per default this is `opensuse/Leap-15.6.x86_64`, using
   `vagrant box add opensuse/Leap-15.6.x86_64`.
1. Make sure the git submodules are fully working by issuing `git submodule init
   && git submodule update`
1. Run `vagrant up`
1. Run `vagrant ssh` to log in on the new VM. Run the following command to check
   if the `lldap.service` is running:

   ```
   systemctl status lldap
   ```

1. Run a `ldapsearch` command to check the contents of your LLDAP server:

   ```
   $ ldapsearch -H ldap://127.0.0.1:3890 -w totallynotsecure -D cn=admin,ou=people,dc=example,dc=com -b dc=example,dc=com
   # extended LDIF
   #
   # LDAPv3
   # base <dc=example,dc=com> with scope subtree
   # filter: (objectclass=*)
   # requesting: ALL
   #

   # admin, people, example.com
   dn: uid=admin,ou=people,dc=example,dc=com
   objectclass: inetOrgPerson
   objectclass: posixAccount
   objectclass: mailAccount
   objectclass: person
   uid: admin
   mail: admin@example.com
   cn: Administrator
   createtimestamp: 2024-10-09T10:48:48.510603962+00:00
   entryuuid: 14e15763-effd-36b9-ab6f-9266aacd2e46

   # lldap_admin, groups, example.com
   dn: cn=lldap_admin,ou=groups,dc=example,dc=com
   objectclass: groupOfUniqueNames
   uid: lldap_admin
   cn: lldap_admin
   member: uid=admin,ou=people,dc=example,dc=com
   uniquemember: uid=admin,ou=people,dc=example,dc=com
   entryuuid: 01002452-48e8-3d84-a208-62b6535f0a98

   # lldap_password_manager, groups, example.com
   dn: cn=lldap_password_manager,ou=groups,dc=example,dc=com
   objectclass: groupOfUniqueNames
   uid: lldap_password_manager
   cn: lldap_password_manager
   entryuuid: 73d07709-656b-3b43-ab88-053db08f150f

   # lldap_strict_readonly, groups, example.com
   dn: cn=lldap_strict_readonly,ou=groups,dc=example,dc=com
   objectclass: groupOfUniqueNames
   uid: lldap_strict_readonly
   cn: lldap_strict_readonly
   entryuuid: d8224286-e8e6-3395-92e1-be965747136f

   # search result
   search: 2
   result: 0 Success
   control: 1.2.840.113556.1.4.319 false MAUCAQQEAA==
   pagedresults: estimate=4 cookie=

   # numResponses: 5
   # numEntries: 4
   ```

1. Log out and run the `ldapsearch` command, that was printed out at the end of
   the Ansible provisioning, from your Ansible control node. This command has
   the VM's IP address in it. e.g.

   ```
   ldapsearch -H ldap://192.0.2.13:3890 -w totallynotsecure -D cn=admin,ou=people,dc=example,dc=com -b dc=example,dc=com
   ```

   The result should be the same as above.
1. Party!

## Cleaning up

The VMs can be torn down after playing around using `vagrant destroy`. This will
also remove the file containing the secret key used by LLDAP, that should be
consistent and not be changed, in case you need to re-run `vagrant provision` or
the Ansible playbooks.

## License

BSD-3-Clause

## Author Information

I am Johannes Kastl, reachable via git@johannes-kastl.de
