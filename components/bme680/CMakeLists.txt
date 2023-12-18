
idf_component_register(SRCS "bsec_iot_example.c" "bsec_integration.c" "bme680.c" "bsec_serialized_configurations_iaq.c"
                       INCLUDE_DIRS "."
                       PRIV_REQUIRES nvs_flash driver esp_timer)

add_library(algobsec STATIC IMPORTED GLOBAL)
set_property(TARGET algobsec PROPERTY IMPORTED_LOCATION "${COMPONENT_DIR}/libalgobsec.a")
target_link_libraries(${COMPONENT_TARGET} PUBLIC algobsec)