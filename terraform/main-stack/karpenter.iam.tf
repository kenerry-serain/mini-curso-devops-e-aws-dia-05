# resource "aws_iam_role" "karpenter_controller" {
#   name = var.eks_cluster.karpenter_controller_role_name
#   assume_role_policy = jsonencode({
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_oidc_url}"
#       }
#       Action = "sts:AssumeRoleWithWebIdentity"
#       Condition = {
#         StringEquals = {
#           "${local.eks_oidc_url}:aud" = "sts.amazonaws.com"
#           "${local.eks_oidc_url}:sub" = "system:serviceaccount:kube-system:karpenter"
#         }
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_policy" "karpenter_controller" {
#   name = var.eks_cluster.karpenter_controll_policy_name

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "Karpenter"
#         Effect = "Allow"
#         Action = [
#           "ssm:GetParameter",
#           "ec2:DescribeImages",
#           "ec2:RunInstances",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeLaunchTemplates",
#           "ec2:DescribeInstances",
#           "ec2:DescribeInstanceTypes",
#           "ec2:DescribeInstanceTypeOfferings",
#           "ec2:DeleteLaunchTemplate",
#           "ec2:CreateTags",
#           "ec2:CreateLaunchTemplate",
#           "ec2:CreateFleet",
#           "ec2:DescribeSpotPriceHistory",
#           "pricing:GetProducts"
#         ]
#         Resource = "*"
#       },
#       {
#         Sid      = "ConditionalEC2Termination"
#         Effect   = "Allow"
#         Action   = "ec2:TerminateInstances"
#         Resource = "*"
#         Condition = {
#           StringLike = {
#             "ec2:ResourceTag/karpenter.sh/nodepool" = "*"
#           }
#         }
#       },
#       {
#         Sid      = "PassNodeIAMRole"
#         Effect   = "Allow"
#         Action   = "iam:PassRole"
#         Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.eks_node_group.name}"
#       },
#       {
#         Sid      = "EKSClusterEndpointLookup"
#         Effect   = "Allow"
#         Action   = "eks:DescribeCluster"
#         Resource = "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${aws_eks_cluster.this.id}"
#       },
#       {
#         Sid      = "AllowScopedInstanceProfileCreationActions"
#         Effect   = "Allow"
#         Action   = ["iam:CreateInstanceProfile"]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.this.id}" = "owned"
#             "aws:RequestTag/topology.kubernetes.io/region"                    = "${data.aws_region.current.name}"
#           }
#           StringLike = {
#             "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
#           }
#         }
#       },
#       {
#         Sid      = "AllowScopedInstanceProfileTagActions"
#         Effect   = "Allow"
#         Action   = ["iam:TagInstanceProfile"]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.this.id}" = "owned"
#             "aws:ResourceTag/topology.kubernetes.io/region"                    = "${data.aws_region.current.name}"
#             "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.this.id}"  = "owned"
#             "aws:RequestTag/topology.kubernetes.io/region"                     = "${data.aws_region.current.name}"
#           }
#           StringLike = {
#             "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
#             "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"  = "*"
#           }
#         }
#       },
#       {
#         Sid    = "AllowScopedInstanceProfileActions"
#         Effect = "Allow"
#         Action = [
#           "iam:AddRoleToInstanceProfile",
#           "iam:RemoveRoleFromInstanceProfile",
#           "iam:DeleteInstanceProfile"
#         ]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.this.id}" = "owned"
#             "aws:ResourceTag/topology.kubernetes.io/region"                    = "${data.aws_region.current.name}"
#           }
#           StringLike = {
#             "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
#           }
#         }
#       },
#       {
#         Sid      = "AllowInstanceProfileReadActions"
#         Effect   = "Allow"
#         Action   = "iam:GetInstanceProfile"
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "karpenter_controller_custom_policy" {
#   policy_arn = aws_iam_policy.karpenter_controller.arn
#   role       = aws_iam_role.karpenter_controller.name
# }
