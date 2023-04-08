resource "aws_cloudwatch_log_group" "log-group" {
  name = var.aws_log_group

  tags = {
    Name  = format("%s_%s_log_group", var.prefix, var.aws_log_group)
    Owner = var.emailid


  }
}

resource "aws_cloudwatch_log_stream" "log-stream" {
  name           = format("%s_%s_log_stream", var.prefix, var.aws_log_group)
  log_group_name = aws_cloudwatch_log_group.log-group.name

  tags = {
    Name  = format("%s_%s_log_stream", var.prefix, var.aws_log_group)
    Owner = var.emailid
  }
}
