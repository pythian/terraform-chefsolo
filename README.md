# theseeker
Amazon test host for bootstrap and chef recipe testing; deployed via terraform templates.

- Create a file called terraform.tfvars with the following private content:

  access_key="" # your AWS access key id <br />
  secret_key="" # your AWS secret access key <br />
  keypair="" # name of your ec2 keypair <br />
  keyfile="" # path to your ec2 keypair's  private key

- Most configuration values are in the variables.rf template.

# chef-solo workstation bootstrapping
- Runs 'knife solo prepare' on the localhost using the ec2-user's private key.
- Runs 'knife solo init' to create the initial chef-solo repository.
- Downloads the ntp cookbook and dependencies, adds it to the run list for node localhost.
- Downloads chef_handler cookbook, needed locally for solo operations.

See the knife-solo documentation [here](http://matschaffer.github.io/knife-solo/).

# chef-solo usage
- Change to the chef-repo directory, where knife is configured.
- Use 'knife solo cook ec2-user@localhost -i ~/.ssh/mykey' to apply the configured ntp cookbook to the local host.
- Implement additional cookbooks, recipes and roles as needed in the chef-repo.
- Bring up a target host for management in AWS using the same EC2 keypair as the chef-solo server.
- Use 'knife solo prepare user@hostname -i ~/.ssh/mykey' to install chef on the target host using knife solo.
- Use 'knife node --local-mode run_list add hostname 'recipe[cookbook::recipe]'' to add recipes to the run list for the node.
- Use 'knife solo cook user@hostname -i ~/.ssh/mykey' to upload the chef-repo and execute the run list against the target host.
- Use 'knife solo clean user@hostname -i ~/.ssh/mykey' to tidy up after chef-solo on the host.
