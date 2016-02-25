resource "template_file" "recipe_hosts_default" {
  filename = "recipes/hosts_default.rb"
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
    aws_region_id = "${var.region.primary}"
  }
}

