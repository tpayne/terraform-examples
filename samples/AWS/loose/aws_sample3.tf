# Policy examples...

data "aws_iam_policy_document" "example01" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "example01" {
  # ... other configuration ...

  policy = data.aws_iam_policy_document.example01.json
}

resource "aws_iam_policy" "example02" {
  # ... other configuration ...

  policy = file("policy.json")
}

