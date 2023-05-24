# Policy examples...

data "aws_iam_policy_document" "example01_1" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "example01_1" {
  # ... other configuration ...

  policy = data.aws_iam_policy_document.example01.json
}

resource "aws_iam_policy" "example02_1" {
  # ... other configuration ...

  policy = file("policy.json")
}

