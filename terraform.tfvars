resource_group_name="app-grp"
location = "North Europe"

network_security_group_rules=[
    {
      priority=300
      destination_port_range="22"
    },
    {
      priority=310
      destination_port_range="80"
    }
  ]

environment = {
  app-network = {
      virtual_network_address_space="10.0.0.0/16"
      subnets={
        images={
            subnet_address_prefix="10.0.0.0/24"
            network_interfaces=[
              {
              name="images-interface-01"
              virtual_machine_name="imagesvm01"
              script_name="install_web_images.sh"
              }
              ]
            }        
        videos={
            subnet_address_prefix="10.0.1.0/24"
            network_interfaces=[{
              name="videos-interface-01"
              virtual_machine_name="videosvm01"
              script_name="install_web_videos.sh"
              }]    
            }
            }
            
        }}
      


storage_account_details={
    account_prefix="appstore"
    account_tier="Standard"
    account_replication_type="LRS"
    account_kind="StorageV2"   
}

container_names=["scripts","data"]

blobs={
    "install_web_images.sh"={
        container_name="scripts"
        blob_location="./modules/compute/VirtualMachines/install_web_images.sh"
    }
    "install_web_videos.sh"={
        container_name="scripts"
        blob_location="./modules/compute/VirtualMachines/install_web_videos.sh"
    }
}

application_gateway_details=["app-network","app-gatewaysubnet","10.0.10.0/24"]

application_pool_details={
  images={
    network_interface_name="images-interface-01"
  }

  videos={
    network_interface_name="videos-interface-01"
  }
}
#resource_group_name = "web-grp"
#resource_group_location="North Europe"
webapp_environment={
  "uksouthplan1000010"={
        service_plan_os_type="Windows"
        service_plan_sku="S1"
        service_plan_location="UK South"
        web_app_name="webapp80000090"
  },
    "northeuropeplan1000010"={
        service_plan_os_type="Windows"
        service_plan_sku="S1"
        service_plan_location="North Europe"
        web_app_name="webapp90000090"
  }
}
