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
  provisioner "remote-exec" {
    inline = [
#    "sudo su -c 'curl -L https://www.opscode.com/chef/install.sh | bash'",
    "sudo yum update -y",
    "sudo yum install git -y",
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      key_file = "${var.keyfile}"
    }
  }
}

output "public_dns" {
  value = "${aws_instance.theseeker.public_dns}"
}
