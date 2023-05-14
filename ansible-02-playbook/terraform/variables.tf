#------------------------------
##### variables for cloud #####
#------------------------------ 

variable "sa_key_file" {
  type        = string
  default     = "key.json"
  description = "Service account key file cloud"
}

variable "cloud_id" {
  type        = string
  description = "Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
}

variable "zone" {
  type        = string
  description = "Name cloud zone"
}

variable "ssh_key" {
  type        = string
  description = "ssh public key"
}

variable "custom_centos7" {
  type        = string
  description = "Custom image centos7 by packer"
}

variable "vm_hostnames" {
  type        = list(string)
  default     = [ "clickhouse", "vector", ]
  description = "List hostnames for VMs"
}

#-----------------------------------
##### variables for module vpc #####
#----------------------------------- 

variable "name" {
  type    = string
  default = "develop"
}

variable "subnets" {
  description = "Create zones && subnets"
  type = list(object(
    {
      zone = string
      cidr = string
    })
  )
  default = []
}

