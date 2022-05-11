data "aws_ssm_parameter" "db_username" {
  name = "db-username"
}

data "aws_ssm_parameter" "db_password" {
  name = "db-password"
}

resource "aws_db_instance" "application_db" {
  instance_class       = "db.t4g.micro"
  engine               = "postgres"
  username             = data.aws_ssm_parameter.db_username.value
  password             = data.aws_ssm_parameter.db_password.value
  allocated_storage    = 20
  engine_version       = "14.1"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible  = true
  skip_final_snapshot  = true
}
