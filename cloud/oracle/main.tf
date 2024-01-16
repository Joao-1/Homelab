resource "oci_core_vcn" "main" {
  cidr_block     = var.vpc_cidr
  compartment_id = var.compartment_ocid
  display_name   = "Default OCI core vcn"
  dns_label      = var.vcn_dns
  freeform_tags = {
    Name  = "k3s-oracle-vcn"
    scope = "cluster"
  }
}

resource "oci_core_subnet" "public" {
  cidr_block        = var.public_subnet_cidr
  compartment_id    = var.compartment_ocid
  display_name      = "${var.public_subnet_cidr} (default) PUBLIC OCI core subnet"
  dns_label         = var.public_subnet_dns
  route_table_id    = oci_core_vcn.main.default_route_table_id
  vcn_id            = oci_core_vcn.main.id
  security_list_ids = [oci_core_security_list.default.id]
  freeform_tags = {
    Name  = "k3s-oracle-vcn-subnet"
    scope = "cluster"
  }
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_ocid
  display_name   = "Internet Gateway Default OCI core vcn"
  enabled        = "true"
  vcn_id         = oci_core_vcn.main.id
  freeform_tags = {
    Name  = "k3s-oracle-vcn0-internet-gateway"
    scope = "cluster"
  }
}

resource "oci_core_default_route_table" "default" {
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main.id
  }

  manage_default_resource_id = oci_core_vcn.main.default_route_table_id
}

resource "oci_core_instance" "headscale" {
  display_name = "k3s-headscale-node"

  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  fault_domain        = "FAULT-DOMAIN-1"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    memory_in_gbs = 2
    ocpus         = 1
  }

  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"

    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }

    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }

    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip          = true
    subnet_id                 = oci_core_subnet.public.id
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }

  is_pv_encryption_in_transit_enabled = true

  metadata = {
    "ssh_authorized_keys" = file(pathexpand("~${var.public_key_path}"))
  }

  source_details {
    source_id   = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa6j7vql6xwhdbn4n4iqm3vna3tvhfev6br5cxavtafknowufr4f5q"
    source_type = "image"
  }

  freeform_tags = {
    Name  = "k3s-headscale-node"
    scope = "vpn"
  }
}

resource "oci_core_instance" "controlplane" {
  display_name = "k3s-controlplane-node"

  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  fault_domain        = "FAULT-DOMAIN-1"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    memory_in_gbs = 22
    ocpus         = 3
  }

  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"

    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }


    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }

    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip          = true
    subnet_id                 = oci_core_subnet.public.id
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }

  is_pv_encryption_in_transit_enabled = true

  metadata = {
    "ssh_authorized_keys" = file(pathexpand("~${var.public_key_path}"))
  }

  source_details {
    source_id   = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa6j7vql6xwhdbn4n4iqm3vna3tvhfev6br5cxavtafknowufr4f5q"
    source_type = "image"
  }

  freeform_tags = {
    Name  = "k3s-controlplane-node"
    scope = "cluster"
  }
}

resource "oci_core_instance" "amd-1" {
  display_name = "amd-1"

  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  fault_domain        = "FAULT-DOMAIN-1"
  shape               = "VM.Standard.E2.1.Micro"

  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"

    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }

    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }

    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip          = true
    subnet_id                 = oci_core_subnet.public.id
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }

  is_pv_encryption_in_transit_enabled = true

  metadata = {
    "ssh_authorized_keys" = file(pathexpand("~${var.public_key_path}"))
  }

  source_details {
    source_id   = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaary33sz3zxbhmekadkyawdtm56eka3yzbsyhgj6l7am574q2nomq"
    source_type = "image"
  }
}

resource "oci_core_instance" "amd-2" {
  display_name = "amd-2"

  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  fault_domain        = "FAULT-DOMAIN-2"
  shape               = "VM.Standard.E2.1.Micro"

  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"

    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }

    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }

    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip          = true
    subnet_id                 = oci_core_subnet.public.id
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = false
  }

  is_pv_encryption_in_transit_enabled = true

  metadata = {
    "ssh_authorized_keys" = file(pathexpand("~${var.public_key_path}"))
  }

  source_details {
    source_id   = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaary33sz3zxbhmekadkyawdtm56eka3yzbsyhgj6l7am574q2nomq"
    source_type = "image"
  }
}

resource "oci_core_security_list" "default" {
  vcn_id         = oci_core_vcn.main.id
  compartment_id = var.compartment_ocid

  display_name = "Default security list"

  ingress_security_rules {
    protocol = 1 # icmp
    source   = "0.0.0.0/0"

    description = "Allow icmp from  0.0.0.0/0 (anywhere)"
  }

  ingress_security_rules {
    protocol = 6 # tcp
    source   = "0.0.0.0/0"

    description = "Allow SSH from 0.0.0.0/0 (anywhere)"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = 6 # tcp
    source   = "0.0.0.0/0"

    description = "Allow Headscale connection from 0.0.0.0/0 (anywhere)"

    tcp_options {
      min = 8080
      max = 8080
    }
  }

  ingress_security_rules {
    protocol = 6 # tcp
    source   = "0.0.0.0/0"

    description = "Allow Headscale metric connection from 0.0.0.0/0 (anywhere)"

    tcp_options {
      min = 9090
      max = 9090
    }
  }

  ingress_security_rules {
    protocol = 6 # tcp
    source   = "0.0.0.0/0"

    description = "Allow Headscale HTTPS connection from 0.0.0.0/0 (anywhere)"

    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol = 6 # tcp
    source   = "0.0.0.0/0"

    description = "Allow Headscale HTTP connection from 0.0.0.0/0 (anywhere)"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = 17 # udp
    source   = "0.0.0.0/0"

    description = "Allow Headscale UDP connection from 0.0.0.0/0 (anywhere)"

    udp_options {
      min = 41641
      max = 41641
    }
  }

  ingress_security_rules {
    protocol = 17 # udp
    source   = "0.0.0.0/0"

    description = "Allow Headscale UDP connection from 0.0.0.0/0 (anywhere)"

    udp_options {
      min = 3478
      max = 3478
    }
  }


  # ingress_security_rules {
  #   protocol = 6 # udp
  #   source   = "0.0.0.0/0"

  #   description = "K3s supervisor and Kubernetes API Server"

  #   udp_options {
  #     min = 6443
  #     max = 6443
  #   }
  # }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}
