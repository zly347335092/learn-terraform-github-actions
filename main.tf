terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "= 1.162.0"
    }
  }

  cloud {
    organization = "zly"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "alicloud" {
  region = "cn-shanghai"
}

data "alicloud_images" "ubuntu" {
  most_recent = true
  name_regex  = "^ubuntu_18.*64"
}

module "ecs_cluster" {
  source  = "alibaba/ecs-instance/alicloud"

  number_of_instances = 1

  name                        = "my-ecs-cluster"
  use_num_suffix              = true
  image_id                    = data.alicloud_images.ubuntu.ids.0
  instance_type               = "ecs.s6-c1m2.large"
  vswitch_id                  = "vsw-uf62xl11nl5nq34qt4znb"
  security_group_ids          = ["sg-2vc4r8v7gd43watyfjr0"]
  associate_public_ip_address = true
  internet_max_bandwidth_out  = 10

  password = "Asd123456"

  system_disk_category = "cloud_ssd"
  system_disk_size     = 50

  tags = {
    Created      = "Terraform"
    Environment = "dev14"
  }
}
output "web-address" {
  value = "${module.ecs_cluster.*.this_instance_id}"
}
