module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cloud-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Allow database access only in my IP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    // cidr_blocks = ["${var.home_ip}/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "cloud-datastore"

  engine                      = "postgres"
  engine_version              = "16.1"
  instance_class              = "db.t3.micro"
  family                      = "postgres16"
  username                    = "root"
  password                    = var.password
  allocated_storage           = 20
  manage_master_user_password = false
  publicly_accessible         = true
  create_db_subnet_group      = true
  subnet_ids                  = module.vpc.public_subnets
  vpc_security_group_ids      = [aws_security_group.database.id]

  deletion_protection = true

  depends_on = [module.vpc]
}
