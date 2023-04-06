resource "aws_cloudwatch_log_group" "log-group" {
  name = var.aws_log_group
}

resource "aws_cloudwatch_log_stream" "log-stream" {
  name           = "log-stream"
  log_group_name = aws_cloudwatch_log_group.log-group.name
}
