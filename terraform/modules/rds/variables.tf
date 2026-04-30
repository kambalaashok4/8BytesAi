variable "name"  { 
    type = string 
    description = "Prefix for all resource names"
    }


variable "isolated_subnet_ids"{ 
    type = list(string) 
    description = "List of isolated subnet IDs for the RDS instance"
    }

variable "rds_sg_id" { 
    type = string 
    description = "Security group ID for the RDS instance" 
    }


variable "db_name"{ 
    type = string
    default = "appdb" 
    }
variable "db_username" { 
    type = string
    default = "appuser" 
    }
variable "instance_class"     { 
    type = string
     default = "db.t3.micro" 
    }
variable "allocated_storage"  { 
    type = number
    default = 20 
    }
variable "multi_az"           { 
    type = bool
    default = false 
    }
variable "deletion_protection"{ 
    type = bool 
    default = false 
    }
variable "sns_alarm_arn" { 
    type = string
     default = "" 
    }

variable "tags" { 
    type = map(string)
     default = {} 
    }

