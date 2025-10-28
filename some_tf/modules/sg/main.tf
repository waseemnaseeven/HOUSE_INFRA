/**
  Dynamic implementation of Ingress and Egress firewall
*/
resource "aws_security_group" "this" {
    name        = var.name
    description = var.description
    vpc_id      = var.vpc_id
    
    dynamic "ingress" {
        for_each = var.ingress_rules
    content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
        description = lookup(ingress.value, "description", null)
        }
    }

    dynamic "egress" {
        for_each = length(var.egress_rules) > 0 ? var.egress_rules : [
        {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow all outbound"
        }
    ]
    content {
        from_port   = egress.value.from_port
        to_port     = egress.value.to_port
        protocol    = egress.value.protocol
        cidr_blocks = egress.value.cidr_blocks
        description = lookup(egress.value, "description", null)
        }
    }

    tags = merge({ Name = var.name }, var.tags)
}

