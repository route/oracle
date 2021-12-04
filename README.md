### Set up OpenVPN server on Ubuntu 20.04 for free for a lifetime in Oracle cloud

Yes you heard it right, for a lifetime! Oracle Cloud has a [tremendous proposal](https://www.oracle.com/cloud/free/), on
their Free Tier you can use "Always Free" services including [Arm Ampere A1 Compute](https://www.oracle.com/cloud/compute/arm/)
instances. Yea you can create instances with up to 24 Gb of memory and 4 CPU cores. It can be one or a few it's up to
you but it should be in the specified limits.

Set up the account because we are going to create OpenVPN server using modern tools like
[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and
[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). Be sure you have them in
the system.

At this point you'll have an account and it's time to create API keys. Go to you profile and click "Add API Key". Copy
what you are given and save it somewhere we'll need it later.

* `git clone git@github.com:route/oracle.git`
* `cd oracle/instances/vpn/terraform`
* `cp terraform.tfvars.example terraform.tfvars`
  paste values Oracle provided and copy pem key to the `config/ssh` folder. Set `private_key_path` with your ssh public
  key, which will be used to ssh into your server. By default we create: 1cpu x 1Gb machine.
* `terraform init`
* `terraform apply`

At this point you have a server and IP address, copy it we'll need it for Ansible.

* `cd ../ansible`
* `cp hosts.example hosts`
  paste IP address in two places and fill in easy_rsa variables with arbitrary data needed for certificates.
  `*.ovpn` config files are generated for clients listed in clients variable. Generate as many as you'd like to have
  people.
* `./bin/setup`
* `./bin/clients`

After running these steps you'll have two openvpn config files `linux.ovpn` and `mac.ovpn` downloaded in clients folder.
Now you can use them to serve internet privately. For linux you can setup OpenVPN tunnel ins settings for mac I prefer
[Viscosity](https://www.sparklabs.com/viscosity/).
