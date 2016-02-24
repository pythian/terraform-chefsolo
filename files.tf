resource "template_file" "recipe_hosts_default" {
  filename = "recipes/hosts_default.rb"
  vars {
    chef-client-addr = "${aws_instance.chef-client.private_dns}"
  }
}

