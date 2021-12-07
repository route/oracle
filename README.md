### Set up OpenVPN server on Ubuntu 20.04 for free for a lifetime in Oracle cloud

Yes you heard it right, for a lifetime! Oracle Cloud has a [tremendous proposal](https://www.oracle.com/cloud/free/), on
their Free Tier you can use "Always Free" services including [Arm Ampere A1 Compute](https://www.oracle.com/cloud/compute/arm/)
instances. Yea you can create instances with up to 24 Gb of memory and 4 CPU cores. It can be one or a few it's up to
you, but it should be in the specified limits.

We are going to create OpenVPN server using [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and
[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). Make sure you have them
installed.

At this point you have Oracle account if not [set it up](https://signup.cloud.oracle.com/?language=en&sourceType=:ow:o:p:feb:0916FreePageBannerButton&intcmp=:ow:o:p:feb:0916FreePageBannerButton),
and it's time to create API keys. Go to your profile and click "Add API Key". Copy what you are given and download pem key.

Run commands below:

```shell
git clone git@github.com:route/oracle.git
cd oracle/instances/vpn
cp environment.example environment
```

Paste values Oracle provided to `environment`. Copy Oracle's pem key to `terraform/config/ssh` folder and set the name
in `PRIVATE_KEY_NAME`. Fill in `INSTANCE_SSH_PUBLIC_KEY`, it's used to ssh into the server using you public ssh key.
Fill in `OPENVPN_EASY_RSA_*` variables with arbitrary data needed for certificates. Config files are generated for
clients listed in `OPENVPN_CLIENTS` variable. Set as many names as you'd like to have people. By default, we create
1 Cpu x 2 Gb machine. If all is set then run:

```shell
./configure
```

After running this you'll have a server up and running and two openvpn config files `linux.ovpn` and `mac.ovpn`
downloaded in clients folder. Now you can use them to browse internet privately. For linux you can set up OpenVPN tunnel
in settings, for mac I prefer [Viscosity](https://www.sparklabs.com/viscosity/).

`configure` shell script is quite idempotent it's fine to change a variable and run it multiple times, it won't create
additional machines or add new services. If you need to add one more client, change environment and run:
`./configure client`. 
