idf_component_register(SRCS "wifi_prov.c"
                    INCLUDE_DIRS "."
                    PRIV_REQUIRES esp_wifi nvs_flash wifi_provisioning)
