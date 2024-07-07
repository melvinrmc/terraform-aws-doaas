resource "aws_security_group" "doaas-allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.doaas-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id            = aws_security_group.doaas-allow_ssh.id
  referenced_security_group_id = aws_security_group.doaas-allow_public_ssh.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ping" {
  security_group_id            = aws_security_group.doaas-allow_ssh.id
  referenced_security_group_id = aws_security_group.doaas-allow_public_ssh.id
  from_port                    = 8
  ip_protocol                  = "icmp"
  to_port                      = 0
}

resource "aws_security_group" "doaas-allow_public_ssh" {
  name        = "allow_public_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.doaas-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_public_ssh_ipv4" {
  security_group_id = aws_security_group.doaas-allow_public_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.doaas-allow_public_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.doaas-vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.doaas-vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
