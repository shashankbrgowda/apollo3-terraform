resource "openstack_compute_instance_v2" "server" {
  name = "apollo3-docker-test"
  image_id = var.image
  flavor_id = var.flavor
  availability_zone = var.availability_zone
  key_pair = var.keypair
  security_groups = var.security_groups

  network {
    name = var.network
  }
}

resource "openstack_networking_floatingip_v2" "floatingip" {
  pool = "public"
  depends_on = [openstack_compute_instance_v2.server]
}

resource "openstack_compute_floatingip_associate_v2" "floatingip_associate" {
  floating_ip = openstack_networking_floatingip_v2.floatingip.address
  instance_id = openstack_compute_instance_v2.server.id
  depends_on = [
    openstack_compute_instance_v2.server,
    openstack_networking_floatingip_v2.floatingip
  ]
}

resource "null_resource" "provisioner" {
  depends_on = [openstack_compute_floatingip_associate_v2.floatingip_associate]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("mongo.pem")
    host        = openstack_networking_floatingip_v2.floatingip.address
  }

  provisioner "file" {
    source      = "docker"
    destination = "/home/ubuntu/"
  }

  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod -R 755 /home/ubuntu/docker",
      "chmod 755 /home/ubuntu/docke/docker-compose.yml",
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)\"  -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "cd ~",
      "sudo docker-compose up -d",
      "sudo docker-compose cp ./docker/config/config.json jbrowse-web:/usr/local/apache2/htdocs/"
    ]
  }
}