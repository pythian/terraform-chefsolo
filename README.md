# chef-solo lab environment 
Amazon test workstation and client host for bootstrap and chef recipe testing; deployed via terraform templates.

# terraform templates
- Create a file called terraform.tfvars with the following private content:

  access_key="" # your AWS access key id <br />
  secret_key="" # your AWS secret access key <br />
  keypair="" # name of your ec2 keypair <br />
  keyfile="" # path to your ec2 keypair's  private key

- Most configuration values are in the variables.rf template.

See the terraform documentation [here](https://www.terraform.io/docs/).

# chef-workstation bootstrapping
The main template brings up a chef-solo workstation environment and prepares the core tool set.
- Installs knife-solo, knife-ec2 and knife-solo_data_bg gems, configures AWS/EC2 access keys from Terraform values in '.chef/knife.rb'.
- Runs 'knife solo prepare' on the chef-workstation host using the ec2-user's private key.
- Runs 'knife solo init' to create the initial chef-solo repository.
- Downloads the hostfile cookbook and renders the default recipe (adding the latest 'chef-client' address to /etc/hosts).
- Downloads the ntp cookbook and dependencies.
- Downloads the chef_handler cookbook, needed for haedless operation.
- Adds the hostsfile recipe to the run list for node localhost on the chef-workstation. 

See the knife-solo documentation [here](http://matschaffer.github.io/knife-solo/).

# chef-solo usage
To get started, connect to the chef-workstation host.
- Log in as user 'ec2-user' with your EC2 private key and the public DNS address output by Terraform.
- Change to the chef-repo directory, where knife is configured.
- Use 'knife solo cook ec2-user@localhost -i ~/.ssh/mykey' to apply the chef-client address to /etc/hosts.
- Use 'knife ec2 --local-mode server list --region us-west-2' to query the AWS instances running in the environment.
- Implement additional cookbooks, recipes and roles as needed in the chef-repo.

# chef-client provisioning
A second template brings up a target host for management in using the same EC2 keypair as the chef workstation.
Here are some useful commands to manage the environment...

- 'knife solo prepare user@chef-client -i ~/.ssh/mykey' to install chef on the target host using knife solo. <br />
- 'knife node --local-mode list' to view the configured nodes (localhost, to start). <br />
- 'knife node --local-mode add chef-client' to add the chef-client nodes to the configuration. <br />
- 'knife node --local-mode show chef-client' to view the node's configuration attributes, including the run list. <br />
- 'knife node --local-mode run_list add chef-client 'recipe[cookbook::recipe]'' to add recipes to the run list. <br />
- 'knife solo cook user@chef-client -i ~/.ssh/mykey' to upload the chef-repo and execute the run list. <br />
- 'knife solo clean user@chef-client -i ~/.ssh/mykey' to tidy up after chef-solo on the host.
