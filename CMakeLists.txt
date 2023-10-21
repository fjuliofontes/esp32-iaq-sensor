cmake_minimum_required(VERSION 3.16.0)

execute_process(COMMAND ./generate-version.sh)

#message(FATAL_ERROR "Version: $ENV{PATH}")

include($ENV{IDF_PATH}/tools/cmake/project.cmake)

project(esp32-iaq-sensor)

#--------------------------------------
# bme680
#--------------------------------------
get_filename_component(
    EXTRA_COMPONENT_DIRS
    "components/bme680" ABSOLUTE
)
list(APPEND IDF_EXTRA_COMPONENT_DIRS ${EXTRA_COMPONENT_DIRS})

#--------------------------------------
# generic_io
#--------------------------------------
get_filename_component(
    EXTRA_COMPONENT_DIRS
    "components/generic_io" ABSOLUTE
)
list(APPEND IDF_EXTRA_COMPONENT_DIRS ${EXTRA_COMPONENT_DIRS})

#--------------------------------------
# https_post
#--------------------------------------
get_filename_component(
    EXTRA_COMPONENT_DIRS
    "components/https_post" ABSOLUTE
)
list(APPEND IDF_EXTRA_COMPONENT_DIRS ${EXTRA_COMPONENT_DIRS})

#--------------------------------------
# wifi_prov
#--------------------------------------
get_filename_component(
    EXTRA_COMPONENT_DIRS
    "components/wifi_prov" ABSOLUTE
)
list(APPEND IDF_EXTRA_COMPONENT_DIRS ${EXTRA_COMPONENT_DIRS})

#--------------------------------------
# config
#--------------------------------------
get_filename_component(
    EXTRA_COMPONENT_DIRS
    "components/config" ABSOLUTE
)
list(APPEND IDF_EXTRA_COMPONENT_DIRS ${EXTRA_COMPONENT_DIRS})