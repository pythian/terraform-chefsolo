/* set up a chef-client host for cookbook testing */

resource "aws_instance" "chef-client" {

  /* set the initial key for the instance */
  key_name = "${var.keypair}"

  /* select the appropriate AMI */
  ami = "${lookup(var.ami, var.region.primary)}"
  instance_type = "${var.insttype.chef-client}"

  /* delete the volume on termination */
  root_block_device {
    delete_on_termination = true #clean up the EBS volume when we're done
  }

  /* add to the security groups */
  vpc_security_group_ids = ["${aws_security_group.sg_chef-client_access.id}"]

  tags {
    Name = "chef-client"
    Platform = "${var.ami.platform}"
    Tier = "client"
  }

  /* provisioners */

}

output "public_dns" {
  value = "${aws_instance.chef-client.private_dns}"
}
