terraform {
  required_version = ">= 0.14.0"
      required_providers {
        openstack = {
          source  = "terraform-provider-openstack/openstack"
          version = "~> 1.48.0"
        }
    }
}

provider "openstack" {
  user_name   = "shabr@ebi.ac.uk"
  tenant_name = "ensembl-havana-infra-44056159"
  auth_url    = "https://uk1.embassy.ebi.ac.uk:5000/"
  region      = "RegionOne"
  application_credential_id = "application_credential_id"
  application_credential_secret = "application_credential_secret"
}
