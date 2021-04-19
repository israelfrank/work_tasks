
variable "subnet_id" {
 type = string 
}

variable "instance_name" {
  type    = list(string)
  default = ["test","test1"]
}

variable "ip" {
  type    = list
  default = ["192.168.10.30" , "192.168.10.20"]
}

variable "vpc_security_group_ids" {
  type = list 
}

# variable "number_ip_one" {
#   type = number
#   default = random_integer.randOne.result
# }

# variable "number_ip_" {
#   type = number
#   default = random_integer.randTwo.result
# }


