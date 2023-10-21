#!/bin/bash
VERSION_NUMBER=$(sed -ne "s/#define PRODUCT_MAJOR \\([0-9]*\\)/\\1/p" components/config/application_version.h)
REVISION_NUMBER=$(sed -ne "s/#define PRODUCT_MINOR \\([0-9]*\\)/\\1/p" components/config/application_version.h)
BUILD_NUMBER=$(sed -ne "s/#define PRODUCT_BUILD \\([0-9]*\\)/\\1/p" components/config/application_version.h)
echo "v$VERSION_NUMBER.$REVISION_NUMBER.$BUILD_NUMBER" > version.txt