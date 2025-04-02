locals {
  eks_oidc_url = replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}
