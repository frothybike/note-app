resource "aws_s3_bucket" "static_pages" {
  bucket = "note-app-static_pages"

  tags = {
    Name = "note-app-static_pages"
  }
}

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_pages.id
  policy = data.aws_iam_policy_document.policy_document.json
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.static_pages.arn,
      "${aws_s3_bucket.static_pages.arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.note_app_cfront.arn]
    }
  }
}