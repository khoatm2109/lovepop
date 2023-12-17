resource "aws_sns_topic" "lovepop_sns" {
  name = "lovepop_sns_topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.lovepop_sns.arn
  protocol  = "email"
  endpoint  = "khoatm2109@gmail.com"
}

resource "aws_sns_topic_policy" "lovepop_policy" {
  arn = aws_sns_topic.lovepop_sns.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sns:Publish",
        Resource  = aws_sns_topic.lovepop_sns.arn,
        Condition = {
          StringEquals = {
            "AWS:SourceOwner" = aws_sns_topic.lovepop_sns.arn,
          },
        },
        Sid        = "AllowPublish",
      },
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sns:Subscribe",
        Resource  = aws_sns_topic.lovepop_sns.arn,
        Condition = {
          StringEquals = {
            "AWS:SourceOwner" = aws_sns_topic.lovepop_sns.arn,
          },
        },
        Sid        = "AllowSubscribe",
      },
    ],
  })
}
