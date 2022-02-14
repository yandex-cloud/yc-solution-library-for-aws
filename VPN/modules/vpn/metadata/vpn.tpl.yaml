
#cloud-config

datasource:
  Ec2:
    strict_id: false
ssh_pwauth: no
users:
  - name: admin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh-authorized-keys:
      - "${ssh_key}"
write_files:
  - content: |
      config setup
      conn Tunnel1
        auto=start
        left=%defaultroute
        leftid=${left_id}
        right=${right}
        type=tunnel
        leftauth=psk
        rightauth=psk
        keyexchange=ikev2
        ike=aes128gcm16-prfsha256-ecp256,aes256gcm16-prfsha384-ecp384!
        ikelifetime=8h
        esp=aes128gcm16-ecp256,aes256gcm16-ecp384!
        lifetime=1h
        keyingtries=%forever
        leftsubnet=${leftsubnet}
        rightsubnet=${rightsubnet}
        dpddelay=10s
        dpdtimeout=30s
        dpdaction=restart
    path: /etc/ipsec.conf
    permissions: '0644'
  - content: |
      ${left_id} ${right} : PSK "${psk}"
    path: /etc/ipsec.secrets
    permissions: '0600'
runcmd:
  - sleep 30
  - reboot
