resource "aws_launch_configuration" "lc" {
  name_prefix   = "lc"
  image_id      = var.image_id
  instance_type = "t2.micro"

  #user_data     = file("${path.module}/user-data.sh")

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


  associate_public_ip_address = true
  iam_instance_profile        = data.aws_iam_instance_profile.instance_profile.role_name
  security_groups             = data.aws_security_groups.ec2_sg.ids
  lifecycle {
    create_before_destroy = true
  }


  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.volume_size
    volume_type           = "gp2"
  }

  key_name = data.aws_key_pair.key.key_name

}

resource "aws_autoscaling_group" "asg" {
  depends_on = [
    aws_lb.applications_load_balancer
  ]
  name                      = "server_asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.lc.name
  #vpc_zone_identifier       = [for s in data.aws_subnet.private : s.id]
  vpc_zone_identifier       = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id]

  timeouts {
    delete = "20m"
  }

  tag {
    key                 = "Name"
    value               = "server"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.alb_target_group.arn

}