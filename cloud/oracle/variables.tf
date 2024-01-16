variable "oracle_private_key_path" {
  type        = string
  description = "Path to the private key used for OCI authentication"
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint of the public key used for OCI authentication"
}

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID for OCI authentication"
}

variable "user_ocid" {
  type        = string
  description = "User OCID for OCI authentication"
}

variable "region" {
  type        = string
  description = "OCI region"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "OCI core vcn CIDR"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.0.0/24"
  description = "Public subnet CIDR"
}

variable "vcn_dns" {
  type    = string
  default = "defaultvcn"
}

variable "public_subnet_dns" {
  type    = string
  default = "public"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key used for SSH access"
}

variable "availability_domain" {
  type        = string
  description = "Set the correct availability domain. See how to find the availability domain in the README"
}

variable "compartment_ocid" {
  type        = string
  description = "Set the correct compartment OCID. See how to find the compartment OCID in the README"
}
