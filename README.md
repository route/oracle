### Set up OpenVPN server on Ubuntu 20.04 for free for a lifetime in Oracle cloud

Yes you heard it right, for a lifetime! Oracle Cloud has a [tremendous proposal](https://www.oracle.com/cloud/free/), on
their Free Tier you can use "Always Free" services including [Arm Ampere A1 Compute](https://www.oracle.com/cloud/compute/arm/)
instances. Yea you can create instances with up to 24 Gb of memory and 4 CPU cores. It can be one or a few it's up to
you, but it should be in the specified limits.

We are going to create OpenVPN server using [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and
[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). Make sure you have them
installed.

At this point you have Oracle account (if not [set it up](https://signup.cloud.oracle.com/?language=en&sourceType=:ow:o:p:feb:0916FreePageBannerButton&intcmp=:ow:o:p:feb:0916FreePageBannerButton)),
and it's time to create API keys. Go to your profile and click "Add API Key". Copy what you are given and download pem key.

Run these commands:
* `git clone git@github.com:route/oracle.git`
* `cd oracle/instances/vpn/terraform`
* `cp terraform.tfvars.example terraform.tfvars`
  paste values Oracle provided and copy pem key to the `config/ssh` folder, set `private_key_path` with the name of your
  pem key. Fill in `instance_ssh_public_key`, it's used to ssh into the server using you public ssh key. By default, we
  create: 1 Cpu x 1 Gb machine.
* `terraform init`
* `terraform apply`

At this point you have a server and IP address in the output, copy it, we'll need it for Ansible.

* `cd ../ansible`
* `cp hosts.example hosts`
  paste IP address and fill in easy_rsa_* variables with arbitrary data needed for certificates. `*.ovpn` config files
  are generated for clients listed in clients variable. Generate as many as you'd like to have people.
* `./bin/setup`
* `./bin/clients`

After running these commands you'll have two openvpn config files `linux.ovpn` and `mac.ovpn` downloaded in clients
folder. Now you can use them to browse internet privately. For linux you can set up OpenVPN tunnel in settings, for mac
I prefer [Viscosity](https://www.sparklabs.com/viscosity/).
