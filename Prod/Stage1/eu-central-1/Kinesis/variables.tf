variable "kinesis_streamA_name" {
    type = string
    description = "STREAM A NAME"
    default = "STREAM A"
  
}

variable "kinesis_streamB_name" {
    type = string
    description = "STREAM B NAME"
    default = "STREAM B"
  
}

variable "kinesis_retention_hours" {
    type = number
    default = 24
  
}