# theseeker
Amazon test host for bootstrap and playbook/recipe testing; deployed via terrafrom templates.

Create a file called terraform.tfvars with the following private content:

  access_key="" # your AWS access key id\n
  secret_key="" # your AWS secret access key\n
  keypair="" # name of your ec2 keypair\n
  keyfile="" # path to your ec2 keypair's  private key

Most configuration values are in the variables.rf template.

# chef-solo-server bootstrapping
Runs 'knife solo prepare' on the localhost using the ec2-user's private key.
Runs 'knife solo init' to create the initial chef-solo repository.
Creates the chef-solo-workstation recipe, configures and runs it on the local host.

See the knife-solo documentation [here](http://matschaffer.github.io/knife-solo/).

# chef-solo usage
Implement cookbooks and recipes as needed in the chef-repo (for example, chef-solo-workstation will be deployed in template theseeker.tf).
Bring up a target host for management in AWS using the same EC2 keypair as the chef-solo server.
Ensure that there is a 'nodes/<hostname>.json' file with the hostname of the target, specifying its run list at minimum. Something like:

  {
    "run_list": [
      "recipe[chef-solo-workstation::default]"
    ]
  }

Use 'knife solo prepare user@hostname -i ~/.ssh/mykey' to install chef on the target host using knife solo.
Use 'knife solo cook user@hostname -i ~/.ssh/mykey' to upload the chef-repo and execute the run list against the target host.
