# theseeker
Amazon test host for bootstrap and playbook/recipe testing; deployed via terrafrom templates.

Create a file called terraform.tfvars with the following private content:

  access_key="" # your AWS access key id
  secret_key="" # your AWS secret access key
  keypair="" # name of your ec2 keypair
  keyfile="" # path to your ec2 keypair's  private key


# chef-solo bootstrapping

