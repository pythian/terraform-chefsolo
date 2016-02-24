/* create the host security group */
resource "aws_security_group" "sg_chef-workstation_access" {
  name = "sg_chef-workstation_access"
  description = "Allow inbound access to the chef-workstation"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_chef-client_access" {
  name = "sg_chef-client_access"
  description = "Allow inbound access to the chef-clients from the chef-workstation"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.sg_chef-workstation_access.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
