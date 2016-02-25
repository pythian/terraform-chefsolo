resource "template_file" "recipe_hostsfile_workstation" {
  filename = "recipes/hosts_workstation.rb"
  vars {
    chef-client-addr = "${aws_instance.chef-client.private_ip}"
#   chef-workstation-addr = "${aws_instance.chef-workstation.private_ip}" #cycle error
  }
}

resource "template_file" "aws_credentials_file" {
  filename = "configs/aws_credentials"
  vars {
    aws_access_key = "${var.access_key}"
    aws_secret_key = "${var.secret_key}"
  }
}

resource "template_file" "aws_knife_config" {
  filename = "configs/aws_knife.rb"
}
