# Bootstrap the AWS account with CloudFormation

This stage is to bootstrap the AWS account with CloudFormation to manage the `infrastructure-deployer-role` which is used to deploy the infrastructure from Terraform.

## How to bootstrap the AWS account

### Step 1: (Click-Ops) Create the bootstrap policy/role once only

#### Why I created the `bootstrap` role Click-Ops and why I need to do it?

Since the bootstrap role has powerful IAM permissions that can create/modify roles and policies, I decided:

- Manage the `bootstrap` role using Click-Ops without giving the user powerful permissions.
- By creating the separate `bootstrap` role, it makes easier to audit and monitor the sensitive operations.
- The `bootstrap` role is restricted to assume by authorized infrastructure administrators (users with the 'team:platform' tag). This ensures that only trusted team members can make changes to the AWS account's IAM configuration.
- The `bootstrap` role is only used for the purpose of creating/modifying CloudFormation/IAM resources. It is not used for any other purpose for the principle of least privilege.

#### How to create the `bootstrap` role

1. The IAM user must have a tag `team:platform` in the IAM user.
2. Go to the AWS console -> IAM role
3. Click on Policies -> Create policy
4. Paste the following policy:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "cloudformation:CreateStack",
           "cloudformation:UpdateStack",
           "cloudformation:DeleteStack",
           "cloudformation:DescribeStacks",
           "cloudformation:ListStacks",
           "cloudformation:GetTemplateSummary",
           "cloudformation:ValidateTemplate",
           "cloudformation:CreateChangeSet",
           "cloudformation:ExecuteChangeSet",
           "cloudformation:DescribeChangeSet",
           "cloudformation:DeleteChangeSet"
         ],
         "Resource": "*"
       },
       {
         "Effect": "Allow",
         "Action": [
           "iam:CreateRole",
           "iam:DeleteRole",
           "iam:GetRole",
           "iam:GetRolePolicy",
           "iam:PutRolePolicy",
           "iam:DeleteRolePolicy",
           "iam:AttachRolePolicy",
           "iam:DetachRolePolicy",
           "iam:UpdateRole",
           "iam:UpdateAssumeRolePolicy",
           "iam:ListRolePolicies",
           "iam:ListAttachedRolePolicies",
           "iam:PassRole"
         ],
         "Resource": "*"
       },
       {
         "Effect": "Allow",
         "Action": [
           "s3:CreateBucket",
           "s3:DeleteBucket",
           "s3:ListBucket",
           "s3:PutEncryptionConfiguration",
           "s3:PutBucket*"
         ],
         "Resource": "*"
       },
       {
         "Effect": "Allow",
         "Action": [
           "dynamodb:CreateTable",
           "dynamodb:DeleteTable",
           "dynamodb:DescribeTable"
         ],
         "Resource": "*"
       }
     ]
   }
   ```

5. Click on "Next"
6. Fill in the role name as `bootstrap-policy`
7. Click on "Create policy"

8. Go to Roles -> Click on `Create role`
9. Select `Custom trust policy`
10. Paste the following policy:

    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::120569602166:root"
          },
          "Action": "sts:AssumeRole",
          "Condition": {
            "StringEquals": {
              "aws:PrincipalTag/team": "platform"
            }
          }
        }
      ]
    }
    ```

11. Click on `Next`
12. Check `bootstrap-policy` permission-policy`
13. Click on `Next`
14. Fill in the role name as `bootstrap-role`
15. Click on `Create role`

### Step 2: (Once-off/On-demand) Bootstrap the account using CloudFormation only if the `infrastructure-deployer-role` needs to be updated

#### What does this CloudFormation stack do?

This CloudFormation stack will create/update the `infrastructure-deployer-role` which is used to deploy the infrastructure from Terraform.

The role `infrastructure-deployer-role` is configured to:

- have the necessary permissions to deploy the infrastructure from Terraform.
- assume the role by authorized infrastructure administrators (users with the 'team:platform' tag).

#### How to deploy the CloudFormation stack

This step is to create the CloudFormation stack, which provisions the `infrastructure-deployer-role`.

Run the following command:

```bash
task aws:bootstrap:validate
task aws:bootstrap:deploy
```
