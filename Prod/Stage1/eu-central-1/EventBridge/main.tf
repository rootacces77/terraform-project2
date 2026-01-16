############################################
# EventBridge Rule (every 1 minute)
############################################
resource "aws_cloudwatch_event_rule" "every_1_min" {
  name                = "every-1-min"
  description         = "Trigger lambdaA and lambdaB every 1 minute"
  schedule_expression = "rate(1 minute)"
}

############################################
# Targets (lambdaA + lambdaB)
############################################
resource "aws_cloudwatch_event_target" "lambdaA" {
  rule      = aws_cloudwatch_event_rule.every_1_min.name
  target_id = "lambdaA"
  arn       = var.lambdaA_arn

  # Optional fixed payload
  input = jsonencode({
    records = [
      { producer = "lambdaA", seed = "schedule", n = 1 }
    ]
  })
}

resource "aws_cloudwatch_event_target" "lambdaB" {
  rule      = aws_cloudwatch_event_rule.every_1_min.name
  target_id = "lambdaB"
  arn       = var.lambdaB_arn

  input = jsonencode({
    records = [
      { producer = "lambdaB", seed = "schedule", n = 1 }
    ]
  })
}

############################################
# اجازه EventBridge to invoke Lambdas
############################################
resource "aws_lambda_permission" "allow_eventbridge_lambdaA" {
  statement_id  = "AllowEventBridgeInvokeLambdaA"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdaA_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_1_min.arn
}

resource "aws_lambda_permission" "allow_eventbridge_lambdaB" {
  statement_id  = "AllowEventBridgeInvokeLambdaB"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdaB_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_1_min.arn
}