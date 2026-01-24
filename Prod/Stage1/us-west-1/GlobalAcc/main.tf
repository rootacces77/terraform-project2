
#############################
# Global Accelerator
#############################
resource "aws_globalaccelerator_accelerator" "this" {
  name            = "app-ga"
  ip_address_type = "IPV4"
  enabled         = true

  tags = { Name = "app-ga" }
}

#############################
# Listener (TCP or UDP)
#############################
resource "aws_globalaccelerator_listener" "this" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.id
  protocol        = "UDP"

  # Optional: CLIENT_IP preserves source IP to the endpoint where supported/needed.
  # For many NLB setups you can leave NONE.
  client_affinity = "NONE"

  port_range {
    from_port = var.listener_port
    to_port   = var.listener_port
  }
}

#############################
# Endpoint Group -> NLB
#############################
resource "aws_globalaccelerator_endpoint_group" "this" {
  listener_arn = aws_globalaccelerator_listener.this.id

  # Optional: traffic dial within this endpoint group
  traffic_dial_percentage = 100

  endpoint_configuration {
    endpoint_id = var.nlb_arn
    weight      = 100

    # Optional; keep explicit if you want predictable behavior.
    # client_ip_preservation_enabled = false
  }
}