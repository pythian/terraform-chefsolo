# theseeker
Amazon test host for bootstrap and playbook/recipe testing; deployed via terrafrom templates.

Create a file called terraform.tfvars with the following private content:

  access_key="" # your AWS access key id
  secret_key="" # your AWS secret access key
  keypair="" # name of your ec2 keypair
  keyfile="" # path to your ec2 keypair's  private key

Most configuration values are in the variables.rf template.

# chef-solo bootstrapping
When chef-solo server is launched, it will be bootstrapped with the Chef DK and the chef-repo directory will be copied to the ec2-user's home directory. The chef-repo can be modified and the default runlist update by moifying solo.json. When the chef-solo-server is up, chef-solo is called to configure a web server and then archive the cookbooks directory and share from the web server for other clients to pull from.

# to do
Add a chef client template that fetches its repository from the chef-solo-server.
