# Embed the server root certificate into the final binary
#
# (If this was a component, we would set COMPONENT_EMBED_TXTFILES here.)
idf_component_register(SRCS "http_post.c"
                    INCLUDE_DIRS "."
                    EMBED_TXTFILES server_root_cert.pem
                    PRIV_REQUIRES nvs_flash esp_https_server wifi_prov esp_wifi esp_timer)
