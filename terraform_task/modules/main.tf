terraform {
  required_version = ">=0.12"
}

resource "aws_eip" "one" {
vpc = true
instance = aws_instance.my-instance[count.index].id
count =  2 
}

resource "random_integer" "randOne" { 
  min = 5
  max = 150
}
resource "random_integer" "randTwo" { 
  min = 160
  max = 245
}

resource "aws_instance" "my-instance" {
  ami           = "ami-0767046d1677be5a0"
  instance_type = "t2.micro"
  availability_zone = "eu-central-1a"
  count         =  2
  private_ip = var.ip[count.index]
  subnet_id  =var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name = "terraform-key"
  user_data = file("C:/Users/israelf/Desktop/tasks/work_tasks/terraform_task/modules/script.sh")
  tags = {
    Name = var.instance_name[count.index]
  }
		  		        
}