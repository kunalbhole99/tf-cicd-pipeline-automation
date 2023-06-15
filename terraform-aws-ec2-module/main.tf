resource "aws_instance" "instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip
  availability_zone           = data.aws_availability_zone.az.id
  disable_api_termination     = var.disable_api_termination
  iam_instance_profile        = data.aws_iam_instance_profile.instance_profile.role_name
  key_name                    = data.aws_key_pair.key.key_name
  #security_groups             = null
  vpc_security_group_ids = data.aws_security_groups.ec2_sg.ids
  subnet_id              = data.aws_subnet.selected.id
  #user_data              = file("${path.module}/user-data.sh")

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y ruby                        # Install Ruby (required by CodeDeploy agent)
    sudo yum install wget -y
    cd /home/ec2-user
    wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install    # Download the CodeDeploy agent installation script
    sudo chmod +x ./install                               # Make the script executable
    sudo ./install auto                              # Run the installation with automatic start on boot
    sudo service codedeploy-agent start
    sudo service codedeploy-agent status
    sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
    sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
    sudo yum install -y apache-maven
    sudo yum install java-1.8.0-openjdk-devel.x86_64 -y
    sudo yum install zip -y
    sudo yum install git -y
    git clone https://github.com/kunalbhole99/spring-boot-rds.git
    cd spring-boot-rds
    mvn clean install
    cd target
    nohup java -jar accessing-data-mysql-complete-0.0.1-SNAPSHOT.jar > /dev/null 2>&1 &
    EOF


  hibernation = false
  credit_specification {
    cpu_credits = "standard"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.volume_size
    volume_type           = "gp2"
    tags = {
      Name         = "ec2_production"
      application  = var.application
      organization = var.organization
    }
  }
  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
  tags = {
    Name         = "server"
    application  = var.application
    organization = var.organization
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "ap-south-1a"
  size              = 10
  snapshot_id       = null
  type              = "gp2"
  tags = {
    Name         = "ebs_volume"
    application  = var.application
    organization = var.organization
  }
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.instance.id
}



