/* create the host security group */
resource "aws_security_group" "sg_theseeker_access" {
  name = "sg_theseeker_access"
  description = "Allow inbound access to theseeker"
  
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
