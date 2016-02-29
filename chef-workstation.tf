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
      /* render the chef-client and chef-workstation addresses recipes under the hostsfile cookbook */
      "echo \"${template_file.recipe_hostsfile_client.rendered}\" >> cookbooks/hostsfile/recipes/client.rb",
      "echo \"${template_file.recipe_hostsfile_workstation.rendered}\" >> cookbooks/hostsfile/recipes/workstation.rb",

      /* render the ~/.aws/credentials file, set file perms to protect it, and render the configuration update for knife */
      "mkdir ~/.aws; echo \"${template_file.aws_credentials_file.rendered}\" > ~/.aws/credentials; chmod 600 ~/.aws/credentials",
      "echo \"${template_file.aws_knife_config.rendered}\" >> .chef/knife.rb",

      /* add recipes to the runlist for the local host containing the chef client and workstation addresses to the run list, and execute */
      "knife node --local-mode run_list add localhost 'recipe[hostsfile::workstation]','recipe[hostsfile::client]'",
      "knife solo cook localhost -i ~/.ssh/mykey; knife solo clean localhost -i ~/.ssh/mykey",

      /* hack to move node localhost to node chef-workstation, now that we have a resolvable name for our local node */
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
