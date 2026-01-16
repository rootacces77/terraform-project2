variable "name_prefix" {
    type = string
    default = "prefix"
  
}

variable "kinesis_stream_a_arn" {
    type = string
    description = "Kinesis Stream A ARN"
  
}

variable "kinesis_stream_b_arn" {
    type = string
    description = "Kinesis Stream B ARN"
  
}

variable "bucket_A_arn" {
    type = string
    description = "Bucket A ARN"
  
}

variable "bucket_B_arn" {
    type = string
    description = "Bucket B ARN"
  
}