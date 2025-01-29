variable "resource_group_name" {
   type = string
}
variable "location" {
  type= string
  description = "This defines the location of the resources"
}


variable "webapp_environment" {
     type = map(object({
        service_plan_os_type=string
        service_plan_sku=string
        service_plan_location=string
        web_app_name=string
     }
     ))
}
