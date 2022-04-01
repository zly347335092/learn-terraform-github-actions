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
  region = "beijing"
}

data "alicloud_images" "ubuntu" {
  most_recent = true
  name_regex  = "^ubuntu_18.*64"
}

  
resource "alicloud_instance" "instance" {
  # cn-beijing
  availability_zone = "cn-chengdu-a"
  security_groups = ["sg-2vc4r8v7gd43watyfjr0"]

  # series III
  instance_type        = "ecs.s6-c1m2.large"
  system_disk_category = "cloud_ssd"
  image_id             = data.alicloud_images.ubuntu.ids.0
  instance_name        = "test_foo"
  vswitch_id = "vsw-2vckzmhrxxoce4orouajw"
  internet_max_bandwidth_out =10
  password = "Asd123456"
}
  
output "web-address" {
  value = "${alicloud_instance.instance.id}"
}
