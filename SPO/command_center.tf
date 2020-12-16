
#############
# Terraform
#############

#############
# Variables
#############
locals {
  my_home_ip           = file("${path.module}/my_home_ip.txt")
  relay_instance_type  = "t3a.small"
  ami_region1_ubuntu20 = "ami-07dd19a7900a1f049"
  ami_region2_ubuntu20 = "ami-07fbdcfe29326c4fb"
  ami_region3_ubuntu20 = "ami-0f2dd5fc989207c82"
}

locals {
  aws_region_1 = "us-west-2"
  aws_region_2 = "ap-southeast-2"
  aws_region_3 = "ap-northeast-1"
  aws_region_4 = "eu-central-1"
  aws_region_5 = "sa-east-1"
}

#############
# Create AWS Provider in each Region
#############
provider "aws" {
  alias  = "region1"
  region = local.aws_region_1
}
provider "aws" {
  alias  = "region2"
  region = local.aws_region_2
}
provider "aws" {
  alias  = "region3"
  region = local.aws_region_3
}
# provider "aws" {
#   alias  = "region4"
#   region = local.aws_region_4
# }
# provider "aws" {
#   alias  = "region5"
#   region = local.aws_region_5
# }

#############
# Create VPCs
#############
resource "aws_vpc" "region1" {
  provider   = aws.region1
  cidr_block = "10.0.0.0/16"
  tags = {
    "SPO" = "region1"
  }
}
resource "aws_vpc" "region2" {
  provider   = aws.region2
  cidr_block = "10.1.0.0/16"
  tags = {
    "SPO" = "region2"
  }
}
resource "aws_vpc" "region3" {
  provider   = aws.region3
  cidr_block = "10.2.0.0/16"
  tags = {
    "SPO" = "region3"
  }
}
# resource "aws_vpc" "region4" {
#   provider   = aws.region4
#   cidr_block = "10.3.0.0/28"
#   tags = {
#     "SPO" = "region4"
#   }
# }
# resource "aws_vpc" "region5" {
#   provider   = aws.region5
#   cidr_block = "10.4.0.0/28"
#   tags = {
#     "SPO" = "region5"
#   }
# }

#############
# Create VPC Peering (and Acceptors) from Region1 to Regions 2,3,4,5
#############
resource "aws_vpc_peering_connection" "region1_to_region2" {
  provider      = aws.region1
  vpc_id        = aws_vpc.region1.id
  peer_owner_id = aws_vpc.region2.owner_id
  peer_vpc_id   = aws_vpc.region2.id
  peer_region   = local.aws_region_2
  tags = {
    "SPO" = "region1"
  }
}
resource "aws_vpc_peering_connection" "region1_to_region3" {
  provider      = aws.region1
  vpc_id        = aws_vpc.region1.id
  peer_owner_id = aws_vpc.region3.owner_id
  peer_vpc_id   = aws_vpc.region3.id
  peer_region   = local.aws_region_3
  tags = {
    "SPO" = "region1"
  }
}
# resource "aws_vpc_peering_connection" "region1_to_region4" {
#   provider      = aws.region1
#   vpc_id        = aws_vpc.region1.id
#   peer_owner_id = aws_vpc.region4.owner_id
#   peer_vpc_id   = aws_vpc.region4.id
#   peer_region   = local.aws_region_4
#   tags = {
#     "SPO" = "region1"
#   }
# }
# resource "aws_vpc_peering_connection" "region1_to_region5" {
#   provider      = aws.region1
#   vpc_id        = aws_vpc.region1.id
#   peer_owner_id = aws_vpc.region5.owner_id
#   peer_vpc_id   = aws_vpc.region5.id
#   peer_region   = local.aws_region_5
#   tags = {
#     "SPO" = "region1"
#   }
# }
resource "aws_vpc_peering_connection_accepter" "region1_to_region2" {
  provider                  = aws.region2
  vpc_peering_connection_id = aws_vpc_peering_connection.region1_to_region2.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
resource "aws_vpc_peering_connection_accepter" "region1_to_region3" {
  provider                  = aws.region3
  vpc_peering_connection_id = aws_vpc_peering_connection.region1_to_region3.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

#############
# Create VPC Peering from Region2 to Regions 3,4,5
#############
resource "aws_vpc_peering_connection" "region2_to_region3" {
  provider      = aws.region2
  vpc_id        = aws_vpc.region2.id
  peer_owner_id = aws_vpc.region3.owner_id
  peer_vpc_id   = aws_vpc.region3.id
  peer_region   = local.aws_region_3
  tags = {
    "SPO" = "region2"
  }
}
# resource "aws_vpc_peering_connection" "region2_to_region4" {
#   provider      = aws.region2
#   vpc_id        = aws_vpc.region2.id
#   peer_owner_id = aws_vpc.region4.owner_id
#   peer_vpc_id   = aws_vpc.region4.id
#   peer_region   = local.aws_region_4
#   tags = {
#     "SPO" = "region2"
#   }
# }
# resource "aws_vpc_peering_connection" "region2_to_region5" {
#   provider      = aws.region2
#   vpc_id        = aws_vpc.region2.id
#   peer_owner_id = aws_vpc.region5.owner_id
#   peer_vpc_id   = aws_vpc.region5.id
#   peer_region   = local.aws_region_5
#   tags = {
#     "SPO" = "region2"
#   }
# }
resource "aws_vpc_peering_connection_accepter" "region2_to_region3" {
  provider                  = aws.region3
  vpc_peering_connection_id = aws_vpc_peering_connection.region2_to_region3.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

#############
# Create VPC Peering from Region3 to Regions 4,5
#############
# resource "aws_vpc_peering_connection" "region3_to_region4" {
#   provider      = aws.region3
#   vpc_id        = aws_vpc.region3.id
#   peer_owner_id = aws_vpc.region4.owner_id
#   peer_vpc_id   = aws_vpc.region4.id
#   peer_region   = local.aws_region_4
#   tags = {
#     "SPO" = "region3"
#   }
# }
# resource "aws_vpc_peering_connection" "region3_to_region5" {
#   provider      = aws.region3
#   vpc_id        = aws_vpc.region3.id
#   peer_owner_id = aws_vpc.region5.owner_id
#   peer_vpc_id   = aws_vpc.region5.id
#   peer_region   = local.aws_region_5
#   tags = {
#     "SPO" = "region3"
#   }
# }

#############
# Create VPC Peering from Region4 to Region 5
#############
# resource "aws_vpc_peering_connection" "region4_to_region5" {
#   provider      = aws.region4
#   vpc_id        = aws_vpc.region4.id
#   peer_owner_id = aws_vpc.region5.owner_id
#   peer_vpc_id   = aws_vpc.region5.id
#   peer_region   = local.aws_region_5
#   tags = {
#     "SPO" = "region4"
#   }
# }


#############
# Create Private Subnets
#############
resource "aws_subnet" "region1_private" {
  provider   = aws.region1
  vpc_id     = aws_vpc.region1.id
  cidr_block = "10.0.0.0/28"
  tags = {
    "SPO" = "region1"
  }
}
resource "aws_subnet" "region2_private" {
  provider   = aws.region2
  vpc_id     = aws_vpc.region2.id
  cidr_block = "10.1.0.0/28"
  tags = {
    "SPO" = "region2"
  }
}
resource "aws_subnet" "region3_private" {
  provider          = aws.region3
  availability_zone = "ap-northeast-1a" #TODO
  vpc_id            = aws_vpc.region3.id
  cidr_block        = "10.2.0.0/28"
  tags = {
    "SPO" = "region3"
  }
}
# resource "aws_subnet" "region4_private" {
#   provider   = aws.region4
#   vpc_id     = aws_vpc.region4.id
#   cidr_block = "10.3.0.0/28"
#   tags = {
#     "SPO" = "region4"
#   }
# }
# resource "aws_subnet" "region5_private" {
#   provider   = aws.region5
#   vpc_id     = aws_vpc.region5.id
#   cidr_block = "10.4.0.0/28"
#   tags = {
#     "SPO" = "region5"
#   }
# }

#############
# Create Public Subnets
#############
resource "aws_subnet" "region1_public_relay" {
  provider                = aws.region1
  vpc_id                  = aws_vpc.region1.id
  cidr_block              = "10.0.1.0/28"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.igw1]
  tags = {
    "SPO"  = "region1"
    "node" = "relay"
  }
}
resource "aws_subnet" "region1_public_bastion" {
  provider                = aws.region1
  vpc_id                  = aws_vpc.region1.id
  cidr_block              = "10.0.2.0/28"
  map_public_ip_on_launch = false
  depends_on              = [aws_internet_gateway.igw1]
  tags = {
    "SPO"  = "region1"
    "node" = "bastion"
  }
}
resource "aws_subnet" "region1_public_monitoring" {
  provider                = aws.region1
  vpc_id                  = aws_vpc.region1.id
  cidr_block              = "10.0.3.0/28"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.igw1]
  tags = {
    "SPO"  = "region1"
    "node" = "monitoring"
  }
}
resource "aws_subnet" "region2_public_relay" {
  provider                = aws.region2
  vpc_id                  = aws_vpc.region2.id
  cidr_block              = "10.1.1.0/28"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.igw2]
  tags = {
    "SPO" = "region2"
  }
}
resource "aws_subnet" "region3_public_relay" {
  provider                = aws.region3
  availability_zone       = "ap-northeast-1a" #TODO
  vpc_id                  = aws_vpc.region3.id
  cidr_block              = "10.2.1.0/28"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.igw3]
  tags = {
    "SPO" = "region3"
  }
}
# resource "aws_subnet" "region4_public" {
#   provider   = aws.region4
#   vpc_id     = aws_vpc.region4.id
#   cidr_block = "10.3.1.0/28"
#   tags = {
#     "SPO" = "region4"
#   }
# }
# resource "aws_subnet" "region5_public" {
#   provider   = aws.region5
#   vpc_id     = aws_vpc.region5.id
#   cidr_block = "10.4.1.0/28"
#   tags = {
#     "SPO" = "region5"
#   }
# }

#############
# Create Internet Gateways
#############
resource "aws_internet_gateway" "igw1" {
  provider = aws.region1
  vpc_id   = aws_vpc.region1.id
  tags = {
    "SPO" = "region1"
  }
}
resource "aws_internet_gateway" "igw2" {
  provider = aws.region2
  vpc_id   = aws_vpc.region2.id
  tags = {
    "SPO" = "region2"
  }
}
resource "aws_internet_gateway" "igw3" {
  provider = aws.region3
  vpc_id   = aws_vpc.region3.id
  tags = {
    "SPO" = "region3"
  }
}
# resource "aws_internet_gateway" "igw4" {
#   provider = aws.region4
#   vpc_id   = aws_vpc.region4.id
#   tags = {
#     "SPO" = "region4"
#   }
# }
# resource "aws_internet_gateway" "igw5" {
#   provider = aws.region5
#   vpc_id   = aws_vpc.region5.id
#   tags = {
#     "SPO" = "region5"
#   }
# }

#############
# Create Route Tables (subnets must be associated with one RT)
#############
resource "aws_route_table" "rt1" {
  provider = aws.region1
  vpc_id   = aws_vpc.region1.id
  # default_route_table_id = aws_vpc.region1.default_route_table_id

  # Public Routes for internet access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  # Private Routes to all other VPC Peering regions
  route {
    cidr_block                = aws_vpc.region2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.region1_to_region2.id
  }

  route {
    cidr_block                = aws_vpc.region3.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.region1_to_region3.id
  }

  # # Private Routes to all other VPC Peering regions
  # # route {
  # #   cidr_block                = aws_vpc.region4.cidr_block
  # #   vpc_peering_connection_id = aws_vpc_peering_connection.region1_to_region4.id
  # # }
  # # route {
  # #   cidr_block                = aws_vpc.region5.cidr_block
  # #   vpc_peering_connection_id = aws_vpc_peering_connection.region1_to_region5.id
  # # }

  tags = {
    "SPO" = "region1"
  }
}
resource "aws_route_table_association" "rt1_bastion" {
  provider       = aws.region1
  subnet_id      = aws_subnet.region1_public_bastion.id
  route_table_id = aws_route_table.rt1.id
}
resource "aws_route_table_association" "rt1_monitoring" {
  provider       = aws.region1
  subnet_id      = aws_subnet.region1_public_monitoring.id
  route_table_id = aws_route_table.rt1.id
}
resource "aws_route_table_association" "rt1_relay" {
  provider       = aws.region1
  subnet_id      = aws_subnet.region1_public_relay.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table" "rt2" {
  provider = aws.region2
  vpc_id   = aws_vpc.region2.id
  # default_route_table_id = aws_vpc.region2.default_route_table_id

  # Public Routes for internet access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw2.id
  }

  # Private Routes to all other VPC Peering regions
  route {
    cidr_block                = aws_vpc.region1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.region1_to_region2.id
  }

  route {
    cidr_block                = aws_vpc.region3.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.region2_to_region3.id
  }

  # # Private Routes to all other VPC Peering regions
  # # route {
  # #   cidr_block                = aws_vpc.region4.cidr_block
  # #   vpc_peering_connection_id = aws_vpc_peering_connection.region2_to_region4.id
  # # }
  # # route {
  # #   cidr_block                = aws_vpc.region5.cidr_block
  # #   vpc_peering_connection_id = aws_vpc_peering_connection.region2_to_region5.id
  # # }

  tags = {
    "SPO" = "region2"
  }
}
resource "aws_route_table_association" "rt2_relay" {
  provider       = aws.region2
  subnet_id      = aws_subnet.region2_public_relay.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_route_table" "rt3" {
  provider = aws.region3
  vpc_id   = aws_vpc.region3.id
  # default_route_table_id = aws_vpc.region3.default_route_table_id

  # Public Routes for internet access
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw3.id
  }

  # Private Routes to all other VPC Peering regions
  route {
    cidr_block                = aws_vpc.region1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.region1_to_region3.id
  }

  route {
    cidr_block                = aws_vpc.region2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.region2_to_region3.id
  }

  # # Private Routes to all other VPC Peering regions
  # # route {
  # #   cidr_block                = aws_vpc.region4.cidr_block
  # #   vpc_peering_connection_id = aws_vpc_peering_connection.region3_to_region4.id
  # # }
  # # route {
  # #   cidr_block                = aws_vpc.region5.cidr_block
  # #   vpc_peering_connection_id = aws_vpc_peering_connection.region3_to_region5.id
  # # }

  tags = {
    "SPO" = "region3"
  }
}
resource "aws_route_table_association" "rt3_relay" {
  provider       = aws.region3
  subnet_id      = aws_subnet.region3_public_relay.id
  route_table_id = aws_route_table.rt3.id
}

#############
# Create NACLs
#############
resource "aws_network_acl" "region1_public_bastion" {
  provider = aws.region1
  vpc_id   = aws_vpc.region1.id
  # default_network_acl_id = aws_vpc.region1.default_network_acl_id
  subnet_ids = [aws_subnet.region1_public_bastion.id]

  # ingress rules to only allow incoming SSH from my home PC
  ingress { # SSH
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.my_home_ip
    from_port  = 22
    to_port    = 22
  }
  ingress { # Return Traffic allowed from anywhere
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  ingress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # egress rules to allow ubuntu package updates
  egress { # DNS
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }
  egress { # HTTP
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress { # HTTPS
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # egress return SSH traffic to home IP
  egress { # SSH
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = local.my_home_ip
    from_port  = 0
    to_port    = 65535
  }

  # egress rules for SSH to all other private subnets
  egress { # SSH
    protocol   = "tcp"
    rule_no    = 330
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 22
    to_port    = 22
  }
  egress { # SSH
    protocol   = "tcp"
    rule_no    = 340
    action     = "allow"
    cidr_block = aws_vpc.region2.cidr_block
    from_port  = 22
    to_port    = 22
  }
  egress { # SSH
    protocol   = "tcp"
    rule_no    = 350
    action     = "allow"
    cidr_block = aws_vpc.region3.cidr_block
    from_port  = 22
    to_port    = 22
  }
  egress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "SPO"  = "region1"
    "node" = "bastion"
    "host" = "ubuntu"
  }
}

resource "aws_network_acl" "region1_public_monitoring" {
  provider   = aws.region1
  vpc_id     = aws_vpc.region1.id
  subnet_ids = [aws_subnet.region1_public_monitoring.id]

  # ingress rules to only allow incoming connections from my home PC
  ingress { # Grafana
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = local.my_home_ip
    from_port  = 80
    to_port    = 80
  }
  ingress { # Prometheus
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = local.my_home_ip
    from_port  = 9090
    to_port    = 9090
  }
  ingress { # Return Traffic
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  ingress { # SSH from bastion
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 22
    to_port    = 22
  }
  ingress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # egress rules to allow ubuntu package updates
  egress { # DNS
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }
  egress { # HTTP
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress { # HTTPS
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # egress return SSH traffic to home IP
  egress { # SSH
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = local.my_home_ip
    from_port  = 0
    to_port    = 65535
  }
  egress { # SSH return traffic to Bastion TODO
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 0
    to_port    = 65535
  }
  egress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  egress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = aws_vpc.region2.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  egress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 420
    action     = "allow"
    cidr_block = aws_vpc.region3.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  egress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "SPO"  = "region1"
    "node" = "monitoring"
    "host" = "ubuntu"
  }
}

resource "aws_network_acl" "region1_public_relay" {
  provider   = aws.region1
  vpc_id     = aws_vpc.region1.id
  subnet_ids = [aws_subnet.region1_public_relay.id]

  # Cardano public Relay ingress rules from anywhere on port #
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # Return Traffic
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  ingress { # SSH from bastion
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 22
    to_port    = 22
  }
  ingress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  ingress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # egress rules to allow ubuntu package updates
  egress { # DNS
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }
  egress { # HTTP
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress { # HTTPS
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress { # SSH return traffic to Bastion TODO
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 0
    to_port    = 65535
  }
  egress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "SPO"  = "region1"
    "node" = "relay1"
    "host" = "ubuntu"
  }
}
resource "aws_network_acl" "region2_public_relay" {
  provider   = aws.region2
  vpc_id     = aws_vpc.region2.id
  subnet_ids = [aws_subnet.region2_public_relay.id]

  # Cardano public Relay ingress rules from anywhere on port #
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # Return Traffic
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  ingress { # SSH from bastion
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 22
    to_port    = 22
  }
  ingress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  ingress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # egress rules to allow ubuntu package updates
  egress { # DNS
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }
  egress { # HTTP
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress { # HTTPS
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress { # SSH return traffic to Bastion TODO
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 0
    to_port    = 65535
  }
  egress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "SPO"  = "region2"
    "node" = "relay2"
    "host" = "ubuntu"
  }
}
resource "aws_network_acl" "region3_public_relay" {
  provider   = aws.region3
  vpc_id     = aws_vpc.region3.id
  subnet_ids = [aws_subnet.region3_public_relay.id]

  # Cardano public Relay ingress rules from anywhere on port #
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # Return Traffic
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  ingress { # SSH from bastion
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 22
    to_port    = 22
  }
  ingress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  ingress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # egress rules to allow ubuntu package updates
  egress { # DNS
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }
  egress { # HTTP
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress { # HTTPS
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress { # SSH return traffic to Bastion TODO
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 0
    to_port    = 65535
  }
  egress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "SPO"  = "region3"
    "node" = "relay3"
    "host" = "ubuntu"
  }
}

resource "aws_network_acl" "region1_private" {
  provider   = aws.region1
  vpc_id     = aws_vpc.region1.id
  subnet_ids = [aws_subnet.region1_private.id]

  # ingress rules
  ingress { # SSH
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 22
    to_port    = 22
  }
  # ingress { # Cardano Block Producer
  #   protocol   = "tcp"
  #   rule_no    = 100
  #   action     = "allow"
  #   cidr_block = aws_vpc.region1.cidr_block
  #   from_port  = 6001
  #   to_port    = 6001
  # }
  ingress { # Cardano Relay in Region 2
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = aws_vpc.region2.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # Cardano Relay in Region 3
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = aws_vpc.region3.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  ingress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # egress rules to other Region Private subnets
  egress { # Prometheus Node Exporter to Region2 Private subnet
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_vpc.region2.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  egress { # Prometheus Node Exporter to Region3 Private subnet
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = aws_vpc.region3.cidr_block
    from_port  = 9100
    to_port    = 9100
  }

  egress { # Cardano Relay to Region2 Private subnet
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = aws_vpc.region2.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  egress { # Cardano Relay to Region3 Private subnet
    protocol   = "tcp"
    rule_no    = 230
    action     = "allow"
    cidr_block = aws_vpc.region3.cidr_block
    from_port  = 6001
    to_port    = 6001
  }

  egress { # SSH to Region2 Private subnet
    protocol   = "tcp"
    rule_no    = 240
    action     = "allow"
    cidr_block = aws_vpc.region2.cidr_block
    from_port  = 22
    to_port    = 22
  }
  egress { # SSH to Region3 Private subnet
    protocol   = "tcp"
    rule_no    = 250
    action     = "allow"
    cidr_block = aws_vpc.region3.cidr_block
    from_port  = 22
    to_port    = 22
  }

  # SSH Return Traffic
  egress { # SSH
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 0
    to_port    = 65535
  }

  # egress { # SSH to Region4 Private subnet
  #   protocol   = "tcp"
  #   rule_no    = 200
  #   action     = "allow"
  #   cidr_block = aws_vpc.region4.cidr_block
  #   from_port  = 22
  #   to_port    = 22
  # }
  # egress { # SSH to Region5 Private subnet
  #   protocol   = "tcp"
  #   rule_no    = 200
  #   action     = "allow"
  #   cidr_block = aws_vpc.region5.cidr_block
  #   from_port  = 22
  #   to_port    = 22
  # }
  egress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "SPO"  = "region1"
    "node" = "bastion"
    "host" = "ubuntu"
  }
}

resource "aws_network_acl" "region2_private" {
  provider = aws.region2
  vpc_id   = aws_vpc.region2.id
  # default_network_acl_id = aws_vpc.region2.default_network_acl_id
  subnet_ids = [aws_subnet.region2_private.id]

  # ingress rules
  ingress { # SSH
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 22
    to_port    = 22
  }
  ingress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  ingress { # Cardano Relay in Region 1
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # Cardano Relay in Region 3
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = aws_vpc.region3.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Egress
  egress { # return SSH traffic to bastion
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 0
    to_port    = 65535
  }
  egress { # Cardano Relay to Region1 Private subnet
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  egress { # Cardano Relay to Region3 Private subnet
    protocol   = "tcp"
    rule_no    = 230
    action     = "allow"
    cidr_block = aws_vpc.region3.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  egress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "SPO"  = "region2"
    "node" = "relay2"
    "host" = "ubuntu"
  }
}

resource "aws_network_acl" "region3_private" {
  provider = aws.region3
  vpc_id   = aws_vpc.region3.id
  # default_network_acl_id = aws_vpc.region3.default_network_acl_id
  subnet_ids = [aws_subnet.region3_private.id]

  # ingress rules
  ingress { # SSH
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 22
    to_port    = 22
  }
  ingress { # Prometheus Node Exporter
    protocol   = "tcp"
    rule_no    = 410
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 9100
    to_port    = 9100
  }
  ingress { # Cardano Relay in Region 1
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # Cardano Relay in Region 2
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = aws_vpc.region2.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  ingress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Egress
  egress { # Egress return SSH traffic to bastion
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 0
    to_port    = 65535
  }
  egress { # Cardano Relay to Region1 Private subnet
    protocol   = "tcp"
    rule_no    = 220
    action     = "allow"
    cidr_block = aws_vpc.region1.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  egress { # Cardano Relay to Region2 Private subnet
    protocol   = "tcp"
    rule_no    = 230
    action     = "allow"
    cidr_block = aws_vpc.region2.cidr_block
    from_port  = 6001
    to_port    = 6001
  }
  egress { # block everything else
    protocol   = "all"
    rule_no    = 999
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "SPO"  = "region3"
    "node" = "relay3"
    "host" = "ubuntu"
  }
}

#############
# Create Security Groups
#############
resource "aws_security_group" "bastion" {
  provider    = aws.region1
  name        = "SPO Bastion"
  description = "Bastion SG"
  vpc_id      = aws_vpc.region1.id

  # Ingress only from home IP
  ingress {
    description = "SSH from my_home_ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_home_ip]
  }

  # Egress rules for Ubuntu package updates
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules for SSH to other nodes
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block, aws_vpc.region2.cidr_block, aws_vpc.region3.cidr_block]
  }

  tags = {
    "SPO"  = "region1"
    "node" = "bastion"
    "host" = "ubuntu"
  }
}
resource "aws_security_group" "monitoring" {
  provider    = aws.region1
  name        = "SPO Monitoring"
  description = "Monitoring SG"
  vpc_id      = aws_vpc.region1.id

  # Ingress SSH from Bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block]
  }

  # Ingress only from home IP
  ingress {
    description = "Grafana from my_home_ip"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.my_home_ip]
  }
  ingress {
    description = "Prometheus from my_home_ip"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [local.my_home_ip]
  }

  # Egress rules for Ubuntu package updates
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { # Prometheus Node Exporter
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block, aws_vpc.region2.cidr_block, aws_vpc.region3.cidr_block]
  }

  tags = {
    "SPO"  = "region1"
    "node" = "monitoring"
    "host" = "ubuntu"
  }
}
resource "aws_security_group" "relay1" {
  provider    = aws.region1
  name        = "SPO Relay1"
  description = "Relay1 SG"
  vpc_id      = aws_vpc.region1.id

  # Ingress SSH from Bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block]
  }

  # Ingress from anywhere for Cardano
  ingress {
    description = "Cardano from anywhere"
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Prometheus Node Exporter
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block]
  }

  # Egress rules for Ubuntu package updates
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress to my other SPO Relays
  egress {
    description = "my other Cardano relays"
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region2.cidr_block, aws_vpc.region3.cidr_block]
  }

  tags = {
    "SPO"  = "region1"
    "node" = "relay1"
    "host" = "ubuntu"
  }
}
resource "aws_security_group" "relay2" {
  provider    = aws.region2
  name        = "SPO Relay2"
  description = "Relay2 SG"
  vpc_id      = aws_vpc.region2.id

  # Ingress SSH from Bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block]
  }

  # Ingress from anywhere for Cardano
  ingress {
    description = "Cardano from anywhere"
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Prometheus Node Exporter
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block]
  }

  # Egress rules for Ubuntu package updates
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress to my other SPO Relays
  egress {
    description = "my other Cardano relays"
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block, aws_vpc.region3.cidr_block]
  }

  tags = {
    "SPO"  = "region2"
    "node" = "relay2"
    "host" = "ubuntu"
  }
}
resource "aws_security_group" "relay3" {
  provider    = aws.region3
  name        = "SPO Relay3"
  description = "Relay3 SG"
  vpc_id      = aws_vpc.region3.id

  # Ingress SSH from Bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block]
  }

  # Ingress from anywhere for Cardano
  ingress {
    description = "Cardano from anywhere"
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Prometheus Node Exporter
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block]
  }

  # Egress rules for Ubuntu package updates
  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress to my other SPO Relays
  egress {
    description = "my other Cardano relays"
    from_port   = 6001
    to_port     = 6001
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.region1.cidr_block, aws_vpc.region2.cidr_block]
  }

  tags = {
    "SPO"  = "region3"
    "node" = "relay3"
    "host" = "ubuntu"
  }
}

#############
# Create Auto Scaling Groups
#############

#############
# Create SSH Key Pair
#############
resource "aws_key_pair" "deployer1" {
  provider   = aws.region1
  key_name   = "SPO-bastion-key"
  public_key = file("${path.module}/public_key.txt")
}
resource "aws_key_pair" "deployer2" {
  provider   = aws.region2
  key_name   = "SPO-bastion-key"
  public_key = file("${path.module}/public_key.txt")
}
resource "aws_key_pair" "deployer3" {
  provider   = aws.region3
  key_name   = "SPO-bastion-key"
  public_key = file("${path.module}/public_key.txt")
}

#############
# Create Bastion EC2 Instance (Public)
#############
resource "aws_instance" "bastion" {
  provider = aws.region1
  ami      = local.ami_region1_ubuntu20 # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  instance_type = "t3a.small"
  key_name      = "SPO-bastion-key"

  subnet_id              = aws_subnet.region1_public_bastion.id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    "SPO"  = "region1"
    "node" = "bastion"
    "host" = "ubuntu"
  }
}
resource "aws_eip" "bastion" {
  provider = aws.region1
  vpc      = true

  instance   = aws_instance.bastion.id
  depends_on = [aws_internet_gateway.igw1]

  tags = {
    Name   = "Bastion"
    "SPO"  = "region1"
    "node" = "bastion"
    "host" = "ubuntu"
  }
}

#############
# Create Monitoring/Ansible EC2 Instance (Public)
#############
resource "aws_instance" "monitoring" {
  provider = aws.region1
  ami      = local.ami_region1_ubuntu20 # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  instance_type = "t3a.small"
  key_name      = "SPO-bastion-key"

  subnet_id              = aws_subnet.region1_public_monitoring.id
  vpc_security_group_ids = [aws_security_group.monitoring.id]

  tags = {
    "SPO"  = "region1"
    "node" = "bastion"
    "host" = "ubuntu"
  }
}
resource "aws_eip" "monitoring" {
  provider = aws.region1
  vpc      = true

  instance   = aws_instance.monitoring.id
  depends_on = [aws_internet_gateway.igw1]

  tags = {
    Name   = "Monitoring"
    "SPO"  = "region1"
    "node" = "monitoring"
    "host" = "ubuntu"
  }
}

#############
# Create Relay Node EC2 Instances and Elastic IPs (Public)
#############
resource "aws_instance" "relay1" {
  provider = aws.region1
  ami      = local.ami_region1_ubuntu20 # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  instance_type = local.relay_instance_type
  key_name      = "SPO-bastion-key"

  subnet_id              = aws_subnet.region1_public_relay.id
  vpc_security_group_ids = [aws_security_group.relay1.id]

  tags = {
    "SPO"  = "region1"
    "node" = "relay1"
    "host" = "ubuntu"
  }
}
resource "aws_eip" "relay1" {
  provider = aws.region1
  vpc      = true

  instance   = aws_instance.relay1.id
  depends_on = [aws_internet_gateway.igw1]

  tags = {
    Name   = "Relay1"
    "SPO"  = "region1"
    "node" = "relay1"
    "host" = "ubuntu"
  }
}

resource "aws_instance" "relay2" {
  provider = aws.region2
  ami      = local.ami_region2_ubuntu20 # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  instance_type = local.relay_instance_type
  key_name      = "SPO-bastion-key"

  subnet_id              = aws_subnet.region2_public_relay.id
  vpc_security_group_ids = [aws_security_group.relay2.id]

  tags = {
    "SPO"  = "region2"
    "node" = "relay2"
    "host" = "ubuntu"
  }
}
resource "aws_eip" "relay2" {
  provider = aws.region2
  vpc      = true

  instance   = aws_instance.relay2.id
  depends_on = [aws_internet_gateway.igw2]

  tags = {
    Name   = "Relay2"
    "SPO"  = "region2"
    "node" = "relay2"
    "host" = "ubuntu"
  }
}

resource "aws_instance" "relay3" {
  provider          = aws.region3
  availability_zone = "ap-northeast-1a"          #TODO
  ami               = local.ami_region3_ubuntu20 # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  instance_type = local.relay_instance_type
  key_name      = "SPO-bastion-key"

  subnet_id              = aws_subnet.region3_public_relay.id
  vpc_security_group_ids = [aws_security_group.relay3.id]

  tags = {
    "SPO"  = "region3"
    "node" = "relay3"
    "host" = "ubuntu"
  }
}
resource "aws_eip" "relay3" {
  provider = aws.region3
  vpc      = true

  instance   = aws_instance.relay3.id
  depends_on = [aws_internet_gateway.igw3]

  tags = {
    Name   = "Relay3"
    "SPO"  = "region3"
    "node" = "relay3"
    "host" = "ubuntu"
  }
}


#############
# Create EBS Volumes for Cardano Nodes
#############

#############
# Create Block Producer EC2 Instance (Private)
#############

#############
# Copy Terraform inventory to Ansible Host
#############

#############
# Create ECR Repos
#############

#############
# Create S3 Bucket for EBS Snapshots
#############







################################################################
#                             Outputs                          #
################################################################
output "bastion_public_ip" {
  value = aws_eip.bastion.public_ip
}
output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

output "monitoring_public_ip" {
  value = aws_eip.monitoring.public_ip
}
output "monitoring_private_ip" {
  value = aws_instance.monitoring.private_ip
}

output "relay1_public_ip" {
  value = aws_eip.relay1.public_ip
}
output "relay1_private_ip" {
  value = aws_instance.relay1.private_ip
}
output "relay2_public_ip" {
  value = aws_eip.relay2.public_ip
}
output "relay2_private_ip" {
  value = aws_instance.relay2.private_ip
}
output "relay3_public_ip" {
  value = aws_eip.relay3.public_ip
}
output "relay3_private_ip" {
  value = aws_instance.relay3.private_ip
}

output "prometheus_url" {
  value = "${aws_eip.monitoring.public_ip}:9090"
}


# 
# Ansible
# 
# https://www.redhat.com/sysadmin/harden-new-system-ansible
# Install Prometheus-node-exporter on all nodes
# Install Docker
