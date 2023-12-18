idf_component_register(SRCS "generic_io.c"
                    INCLUDE_DIRS "."
                    PRIV_REQUIRES bme680 driver wifi_prov)
