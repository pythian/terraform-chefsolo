/* set up a utility host for general
   cloud hackin' */

resource "aws_instance" "theseeker" {

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
  vpc_security_group_ids = ["${aws_security_group.sg_theseeker_access.id}"]

  tags {
    Name = "theseeker"
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

    /* install the Chef Development Kit */
    provisioner "remote-exec" {
      inline = [
      "sudo yum update -y",
      "sudo yum install git gcc ruby rubygems ruby-devel -y",
      "sudo gem update --system",
      "sudo gem install knife-solo",
      "knife solo prepare ec2-user@localhost -i ~/.ssh/mykey",
      "knife solo init chef-repo",
      "knife cookbook create chef-solo-workstation",
      "knife cookbook site download ntp",
      "tar xvzf ntp*.tar.gz --directory cookbooks; rm -f ntp*.tar.gz",
      "knife cookbook site download httpd",
      "tar xvzf httpd*.tar.gz --directory cookbooks; rm -f httpd*.tar.gz"
      ]
      connection {
        type = "ssh"
        user = "ec2-user"
        key_file = "${var.keyfile}"
      }
    }

    /* upload the recipes to our web server */
#    provisioner "local-exec" {
#      command = "scp -r -i ${var.keyfile} -oStrictHostKeyChecking=no ./chef-repo ec2-user@${aws_instance.theseeker.public_dns}:."
#    }
}

output "public_dns" {
  value = "${aws_instance.theseeker.public_dns}"
}
