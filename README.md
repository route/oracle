### Set up OpenVPN server on Ubuntu 20.04 for free for a lifetime in Oracle cloud

Yes you heard it right, for a lifetime! Oracle Cloud has a [tremendous proposal](https://www.oracle.com/cloud/free/), on
their Free Tier you can use "Always Free" services including [Arm Ampere A1 Compute](https://www.oracle.com/cloud/compute/arm/)
instances. Yea you can create instances with up to 24 Gb of memory and 4 CPU cores. It can be one or a few it's up to
you, but it should be in the specified limits.

We are going to create OpenVPN server using [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and
[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). Make sure you have them
installed, as I won't go into installation details here.

At this point, you'll have set [Oracle account](https://signup.cloud.oracle.com/?language=en&sourceType=:ow:o:p:feb:0916FreePageBannerButton&intcmp=:ow:o:p:feb:0916FreePageBannerButton),
and it's time to create API keys. Go to your "Profile" ➞ "API keys" and click "Add API Key". Copy what you are given and
download pem key to `~/.oci` folder.

Run commands below:

```shell
git clone git@github.com:route/oracle.git && \
  cd oracle && \
  cp tf.env.example tf.env && \
  cp compute/vpn/ovpn.env.example compute/vpn/ovpn.env
```

Open it with your favorite editor and paste values Oracle provided to `tf.env`. Fill in `INSTANCE_SSH_PUBLIC_KEY` as
well, it's used to ssh into the server using your public ssh key. By default, we create 1 Cpu x 2 Gb machine.

Go to `compute/vpn` as well and fill in values for OpenVPN file `ovpn.env`. Set `OPENVPN_EASY_RSA_*` variables with
arbitrary data needed for certificates. Config files are generated for clients listed in `OPENVPN_CLIENTS` variable. Set
as many names as you'd like to have people.

If all is set then run:

```shell 
./configure
```

After running this you'll have a server up and running and two openvpn config files `linux.ovpn` and `mac.ovpn`
downloaded in `compute/vpn/ansinle/clients` folder. Now you can use them to browse internet privately. For linux you can
set up OpenVPN tunnel in settings, for mac I prefer [Viscosity](https://www.sparklabs.com/viscosity/).

If you'd like to add more clients, change `ovpn.env` and run `(cd compute/vpn && ./configure run openvpn_clients)` 
