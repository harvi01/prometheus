terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}


resource "null_resource" "vagrant_up" {
  provisioner "local-exec" {
    command     = "vagrant up"
    working_dir = "${path.module}" 
  }
}


resource "null_resource" "setup_vm" {
  provisioner "remote-exec" {
    inline = [
      "sudo dnf install -y epel-release",
      "sudo dnf install -y python3 python3-pip"
    ]

    connection {
      type        = "ssh"
      user        = "vagrant"
      password    = "vagrant"
      host        = "192.168.56.10" 
      port        = 22
    }
  }

  depends_on = [null_resource.vagrant_up]
}

resource "null_resource" "ansible_playbook" {
  depends_on = [null_resource.setup_vm]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./ansible/inventories/hosts ./ansible/playbook.yml -e container_runtime=docker"
  }
}
