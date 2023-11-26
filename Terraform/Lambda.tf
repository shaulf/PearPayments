resource "aws_s3_bucket" "pearp-bucket" {
  bucket = "pearp-bucket"  # Change this to a unique bucket name
  #acl    = "private"  # Access Control List (private, public-read, public-read-write, etc.)
}

resource "aws_s3_bucket_object" "lambda_code_zip" {
  bucket = aws_s3_bucket.pearp-bucket.bucket
  key    = "src/lambdas/lambda_function.zip"  # Change the key to the desired path and filename
  #acl    = "private"
  source = "../HelloWorld-Lambda.zip"  # Path to the local file you want to upload
}

resource "aws_lambda_function" "post_function" {
  function_name = "postFunction"
  handler      = "lambda_function.lambda_handler"
  runtime      = "python3.10"
  s3_bucket    = "pearp-bucket"
  s3_key       = "src/lambdas/lambda_function.zip"
  depends_on = [aws_s3_bucket_object.lambda_code_zip]
  role         = aws_iam_role.lambda_role.arn
}

resource "aws_lambda_function" "get_function_1" {
  function_name = "getFunction1"
  handler      = "lambda_function.lambda_handler"
  runtime      = "python3.10"
  s3_bucket    = "pearp-bucket"
  s3_key       = "src/lambdas/lambda_function.zip"
  depends_on = [aws_s3_bucket_object.lambda_code_zip]
  role         = aws_iam_role.lambda_role.arn
}

resource "aws_lambda_function" "get_function_2" {
  function_name = "getFunction2"
  handler      = "lambda_function.lambda_handler"
  runtime      = "python3.10"
  s3_bucket    = "pearp-bucket"
  s3_key       = "src/lambdas/lambda_function.zip"
  depends_on = [aws_s3_bucket_object.lambda_code_zip]
  role         = aws_iam_role.lambda_role.arn
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }

    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "lambda_attach_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}