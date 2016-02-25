resource "template_file" "recipe_hosts_default" {
  filename = "recipes/hosts_default.rb"
  vars {
    chef-client-addr = "${aws_instance.chef-client.private_ip}"
#   chef-workstation-addr = "${aws_instance.chef-workstation.private_ip}" #cycle error
  }
}

resource "template_file" "knife_config_file" {
  filename = "configs/knife.rb"
}

