/* set up a utility host for general
   cloud hackin' */

resource "aws_instance" "chef-workstation" {

  /* set the initial key for the instance */
  key_name = "${var.keypair}"

  /* select the appropriate AMI */
  ami = "${lookup(var.ami, var.region.primary)}"
  instance_type = "${var.insttype.utility}"

  /* delete the volume on termination */
  root_block_device {
    delete_on_termination = false
  }

  /* add to the security groups */
  vpc_security_group_ids = ["${aws_security_group.sg_chef-workstation_access.id}"]

  tags {
    Name = "chef-workstation"
    Platform = "${var.ami.platform}"
    Tier = "utility"
  }

  /* provisioners */

    /* copy up private keyfile for chef-solo to use */
    provisioner "file" {
      source = "${var.keyfile}"
      destination = "/home/ec2-user/.ssh/mykey"
      connection {
        type = "ssh"
        user = "ec2-user"
        key_file = "${var.keyfile}"
      }
    }

    /* install knife-solo and configure for chef-solo operation */
    provisioner "remote-exec" {
      inline = [
      "chmod 600 .ssh/mykey",
      "sudo yum update -y",
      "sudo yum install zlib-devel git gcc ruby rubygems ruby-devel -y",
      "sudo gem update --system",
      "sudo gem install knife-solo",
      "sudo gem install knife-solo_data_bag",
      "sudo gem install knife-ec2",
      "knife solo init chef-repo; cd chef-repo",
      "knife solo prepare ec2-user@localhost -i ~/.ssh/mykey; rm ../install.sh",
      "sudo mkdir -p /etc/chef/ohai/hints && touch /etc/chef/ohai/hints/ec2.json",

      /* here we are rendering the chef-client recipe for configuration in /etc/hosts on the chef-workstation */
      "knife cookbook site download hostsfile",
      "tar xvzf hostsfile*.tar.gz --directory cookbooks; rm hostsfile*.tar.gz; mkdir cookbooks/hostsfile/recipes",
      "echo \"${template_file.recipe_hostsfile_client.rendered}\" >> cookbooks/hostsfile/recipes/client.rb",

      /* here we are copying the hostsfile-workstation recipe for configuration on the chef-workstation */
      "echo \"${template_file.recipe_hostsfile_workstation.rendered}\" >> cookbooks/hostsfile/recipes/workstation.rb",

      /* here we'll render and upload the ~/.aws/credentials file, and set file perms to protect them */
      "mkdir ~/.aws; echo \"${template_file.aws_credentials_file.rendered}\" > ~/.aws/credentials; chmod 600 ~/.aws/credentials",
      "echo \"${template_file.aws_knife_config.rendered}\" >> .chef/knife.rb",

      /* cookbooks needed to configure ntp, our default recipe */
      "knife cookbook site download ntp",
      "tar xvzf ntp*.tar.gz --directory cookbooks; rm ntp*.tar.gz",
      "knife cookbook site download windows", #needed for a stupid hardcoded dependency in the ntp cookbook
      "tar xvzf windows*.tar.gz --directory cookbooks; rm windows*.tar.gz",
      "knife cookbook site download chef_handler", #needed because there's no chef server
      "tar xvzf chef_handler*.tar.gz --directory cookbooks; rm chef_handler*.tar.gz",

      /* here we add the default hostsfile recipe containing the chef workstation address to the run list */
      "knife node --local-mode run_list add localhost 'recipe[hostsfile::workstation]','recipe[hostsfile::client]'",
      "knife solo cook localhost -i ~/.ssh/mykey; knife solo clean localhost -i ~/.ssh/mykey",

      /* hack to move node localhost to node chef-workstation, now that we have a resolvable name */
      "mv nodes/localhost.json nodes/chef-workstation.json"
      ]
      connection {
        type = "ssh"
        user = "ec2-user"
        key_file = "${var.keyfile}"
      }
    }
}

output "public_dns" {
  value = "${aws_instance.chef-workstation.public_dns}"
}
