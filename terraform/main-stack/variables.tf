variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "devops-na-nuvem"
  }
}

variable "assume_role" {
  type = object({
    region   = string
    role_arn = string
  })

  default = {
    region   = "us-west-1"
    role_arn = "<YOUR_ROLE_ARN>"
  }
}

variable "vpc" {
  type = object({
    name                     = string
    cidr_block               = string
    internet_gateway_name    = string
    nat_gateway_name         = string
    public_route_table_name  = string
    private_route_table_name = string
    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
    private_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })

  default = {
    name                     = "devops-na-nuvem-vpc"
    cidr_block               = "10.0.0.0/24"
    internet_gateway_name    = "internet-gateway"
    nat_gateway_name         = "nat-gateway"
    public_route_table_name  = "public-route-table"
    private_route_table_name = "private-route-table"
    public_subnets = [{
      name                    = "public-us-west-1a"
      cidr_block              = "10.0.0.0/26"
      availability_zone       = "us-west-1a"
      map_public_ip_on_launch = true
      },
      {
        name                    = "public-us-west-1c"
        cidr_block              = "10.0.0.64/26"
        availability_zone       = "us-west-1c"
        map_public_ip_on_launch = true
    }]
    private_subnets = [{
      name                    = "private-us-west-1a"
      cidr_block              = "10.0.0.128/26"
      availability_zone       = "us-west-1a"
      map_public_ip_on_launch = false
      },
      {
        name                    = "private-us-west-1c"
        cidr_block              = "10.0.0.192/26"
        availability_zone       = "us-west-1c"
        map_public_ip_on_launch = false
    }]
  }
}

variable "eks_cluster" {

  type = object({
    name                                   = string
    role_name                              = string
    version                                = string
    enabled_cluster_log_types              = list(string)
    access_config_authentication_mode      = string
    node_group_name                        = string
    node_group_role_name                   = string
    node_group_capacity_type               = string
    node_group_instance_types              = list(string)
    node_group_scaling_config_desired_size = string
    node_group_scaling_config_max_size     = string
    node_group_scaling_config_min_size     = string
    karpenter_controller_role_name         = string
    karpenter_controll_policy_name         = string
  })

  default = {
    name                                   = "devops-na-nuvem-eks-cluster"
    role_name                              = "DevOpsNaNuvemEKSClusterRole"
    version                                = "1.31"
    enabled_cluster_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    access_config_authentication_mode      = "API_AND_CONFIG_MAP"
    node_group_role_name                   = "DevOpsNaNuvemEKSNodeGroupRole"
    node_group_name                        = "devops-na-nuvem-eks-node-group"
    node_group_capacity_type               = "ON_DEMAND"
    node_group_instance_types              = ["t3.medium"]
    node_group_scaling_config_desired_size = "2"
    node_group_scaling_config_max_size     = "2"
    node_group_scaling_config_min_size     = "2"
    karpenter_controller_role_name         = "KarpenterControllerRole"
    karpenter_controll_policy_name         = "KarpenterControllerPolicy"
  }
}

variable "ecr_repositories" {
  type = list(object({
    name                 = string
    image_tag_mutability = string
  }))

  default = [
    {
      name                 = "devops-na-nuvem/production/frontend"
      image_tag_mutability = "MUTABLE"
    },
    {
      name                 = "devops-na-nuvem/production/backend"
      image_tag_mutability = "MUTABLE"
    }
  ]
}
