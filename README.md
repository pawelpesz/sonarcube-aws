# sonarqube-aws

## IAM policy requirements for the Terraform user

AWS Managed policies:

* `AmazonEC2FullAccess`
* `AmazonECS_FullAccess`
* `AmazonRDSFullAccess`
* `CloudWatchLogsFullAccess`
* `ElasticLoadBalancingFullAccess`
* `IAMFullAccess` (temporary solution)

Customer managed policies:

* `sonarqube-terraform-*` (created by the `bucket` submodule)
* `SonarqubePolicy` (defined in the corresponding JSON file)
