idf_component_register(SRCS "wifi_prov.c" 
                       INCLUDE_DIRS "."
                       PRIV_REQUIRES nvs_flash wifi_provisioning generic_io esp_pm)