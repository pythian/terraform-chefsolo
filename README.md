# theseeker
Amazon test host for bootstrap and playbook/recipe testing; deployed via terrafrom templates.

Create a file called terraform.tfvars with the following private content:

  access_key="" # your AWS access key id
  secret_key="" # your AWS secret access key
  keypair="" # name of your ec2 keypair
  keyfile="" # path to your ec2 keypair's  private key

Most configuration values are in the variables.rf template.

# chef-solo bootstrapping
Working on knife-solo init bootstrapping. Need to create chef-solo-server recipe.

# to do
Add a chef client template that fetches its repository from the chef-solo-server.
