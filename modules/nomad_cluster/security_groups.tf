# creates security group to group access rules under - named with a random UUId and suffix (why?)
resource "aws_security_group" "nomad" {
  name        = "${random_id.environment_name.hex}-nomad-sg"
  description = "Nomad servers"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "loadbalancer" {
  name        = "${random_id.environment_name.hex}-nomad-sg-loadbalancer"
  description = "Application Load Balancer"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "bastionhost" {
  name        = "${random_id.environment_name.hex}-nomad-sg-bastionhost"
  description = "bastionhost"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingres-ssh" {
  security_group_id = aws_security_group.bastionhost.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.bastionhost.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.allowed_inbound_cidrs
}


resource "aws_security_group_rule" "ALBingress" {
  security_group_id = aws_security_group.loadbalancer.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}
#nieuw
resource "aws_security_group_rule" "ALBingressapp" {
  security_group_id = aws_security_group.loadbalancer.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}
#nieuw
resource "aws_security_group_rule" "ALBingresscustomerfrontend" {
  security_group_id = aws_security_group.loadbalancer.id
  type              = "ingress"
  from_port         = 8079
  to_port           = 8079
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}

resource "aws_security_group_rule" "ALBingressb2bfrontend" {
  security_group_id = aws_security_group.loadbalancer.id
  type              = "ingress"
  from_port         = 8999
  to_port           = 8999
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}


resource "aws_security_group_rule" "ALBegress" {
  security_group_id = aws_security_group.loadbalancer.id
  type              = "egress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}

resource "aws_security_group_rule" "nomad_ssh" {
  security_group_id = aws_security_group.nomad.id
  type              = "ingress"
  from_port         = 22  
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.bastionhost.id
}
resource "aws_security_group_rule" "grafana" {
  security_group_id = aws_security_group.nomad.id
  type              = "egress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
   cidr_blocks       = var.allowed_inbound_cidrs
}

#nieuw
resource "aws_security_group_rule" "customerfrontendingress" {
  security_group_id = aws_security_group.nomad.id
  type              = "ingress"
  from_port         = 8079
  to_port           = 8079
  protocol          = "tcp"
   cidr_blocks       = var.allowed_inbound_cidrs
}
resource "aws_security_group_rule" "customerfrontendegress" {
  security_group_id = aws_security_group.nomad.id
  type              = "egress"
  from_port         = 8079
  to_port           = 8079
  protocol          = "tcp"
   cidr_blocks       = var.allowed_inbound_cidrs
}


resource "aws_security_group_rule" "prometheuseg" {
  security_group_id = aws_security_group.nomad.id
  type              = "egress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
   cidr_blocks       = var.allowed_inbound_cidrs
}




resource "aws_security_group_rule" "prometheusin" {
  security_group_id = aws_security_group.nomad.id
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}


# rule to allow egress from 443 to 443 externally
resource "aws_security_group_rule" "nomad_external_egress_https" {
  security_group_id = aws_security_group.nomad.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# rule to allow egress from 80 to 80 externally
resource "aws_security_group_rule" "httpingress" {
  security_group_id = aws_security_group.nomad.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "httpingressv2" {
  security_group_id = aws_security_group.nomad.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# rule to allow egress from 80 to 80 externally
resource "aws_security_group_rule" "httpegress" {
  security_group_id = aws_security_group.nomad.id
  type              = "egress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "httpegress8081" {
  security_group_id = aws_security_group.nomad.id
  type              = "egress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "httpingress8081" {
  security_group_id = aws_security_group.nomad.id
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}



# rule to allow egress from 80 to 80 externally
resource "aws_security_group_rule" "nomad_external_egress_http" {
  security_group_id = aws_security_group.nomad.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}


# rule to allow internal egress from 8300 to 8600 TCP
resource "aws_security_group_rule" "consul_internal_egress_tcp" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8600
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

# rule to allow internal egress from 8300 to 8600 UDP
resource "aws_security_group_rule" "consul_internal_egress_udp" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8600
  protocol                 = "udp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Consul RPC.
resource "aws_security_group_rule" "consul_rpc" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Consul Serf TCP.
resource "aws_security_group_rule" "consul_serf_tcp" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 8301
  to_port                  = 8302
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Consul Serf UDP.
resource "aws_security_group_rule" "consul_serf_udp" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 8301
  to_port                  = 8302
  protocol                 = "udp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Consul API.
resource "aws_security_group_rule" "consul_api_tcp" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// Permit access from allowed inbound CIDRs.
resource "aws_security_group_rule" "consul_api_ingress" {
  security_group_id = aws_security_group.nomad.id
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}

// This rule allows Consul DNS.
resource "aws_security_group_rule" "consul_dns_tcp" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Consul DNS.
resource "aws_security_group_rule" "consul_dns_udp" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "udp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Nomad API.
resource "aws_security_group_rule" "nomad_api_tcp" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// Permit access from allowed inbound CIDRs.
resource "aws_security_group_rule" "nomad_api_ingress" {
  security_group_id = aws_security_group.nomad.id
  type              = "ingress"
  from_port         = 4646
  to_port           = 4646
  protocol          = "tcp"
  cidr_blocks       = var.allowed_inbound_cidrs
}

// This rule allows Nomad ingress RPC.
resource "aws_security_group_rule" "nomad_ingress_rpc" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Nomad egress RPC.
resource "aws_security_group_rule" "nomad_egress_rpc" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "egress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Nomad ingress TCP Serf WAN
resource "aws_security_group_rule" "nomad_tcp_ingress_serf" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Nomad egress TCP Serf WAN
resource "aws_security_group_rule" "nomad_tcp_egress_serf" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "egress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Nomad ingress UDP Serf WAN
resource "aws_security_group_rule" "nomad_udp_ingress_serf" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "ingress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "udp"
  source_security_group_id = aws_security_group.nomad.id
}

// This rule allows Nomad egress UDP Serf WAN
resource "aws_security_group_rule" "nomad_udp_egress_serf" {
  security_group_id        = aws_security_group.nomad.id
  type                     = "egress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "udp"
  source_security_group_id = aws_security_group.nomad.id
}
