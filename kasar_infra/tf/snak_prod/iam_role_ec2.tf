data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Attache la managed policy SSM au rôle créé par le module
resource "aws_iam_role_policy_attachment" "edge_ssm_core" {
  role       = module.ec2_edge.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

/*
  *
  * - Lecture des parametres SSM sous un prefix
  * - Dechiffrement KMS des SecureStrings
  * - push des backups dans le S3
  */
data "aws_iam_policy_document" "edge_runtime_doc" {
  statement {
    sid     = "ReadRuntimeParameters"
    effect  = "Allow"
    actions = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${var.ssm_path_prefix}/*"
    ]
  }

  statement {
    sid       = "DecryptSSMParameters"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["*"]
  }

  statement {
    sid     = "PushPgDumpsToS3"
    effect  = "Allow"
    actions = ["s3:PutObject", "s3:AbortMultipartUpload", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.backup_bucket_name}",
      "arn:aws:s3:::${var.backup_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "edge_runtime" {
  name   = "snak-ec2-runtime-policy"
  policy = data.aws_iam_policy_document.edge_runtime_doc.json
}

resource "aws_iam_role_policy_attachment" "edge_runtime_attach" {
  role       = module.ec2_edge.iam_role_name
  policy_arn = aws_iam_policy.edge_runtime.arn
}

############################
# (Optionnel) Param public SSM d'exemple
############################
resource "aws_ssm_parameter" "global_domain" {
  name  = "${var.ssm_path_prefix}/global/DOMAIN_BASE"
  type  = "String"
  value = "snakagent.com"
  tags = {
    Project     = "snak"
    Environment = var.environment
  }
}
