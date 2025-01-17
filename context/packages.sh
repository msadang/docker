#!/bin/bash

if [ "$EXTRA_APT_PACKAGES" ]; then
    if ! grep -i "ubuntu" /etc/os-release > /dev/null; then
      echo "EXTRA_APT_PACKAGES var provided in a non-Ubuntu environment."
      echo "Exiting..."
      exit 1
    fi
    echo "EXTRA_APT_PACKAGES environment variable found. Installing packages."
    apt update -y || exit $?
    timeout ${APT_TIMEOUT:-600} apt install -y --no-install-recommends $EXTRA_APT_PACKAGES || exit $?
fi

if [ "$EXTRA_YUM_PACKAGES" ]; then
    if ! grep -iE "centos|rocky" /etc/os-release > /dev/null; then
      echo "EXTRA_YUM_PACKAGES var provided in a non-Centos environment."
      echo "Exiting..."
      exit 1
    fi
    echo "EXTRA_YUM_PACKAGES environment variable found. Installing packages."
    yum check-update -y || exit $?
    timeout ${YUM_TIMEOUT:-600} yum install -y $EXTRA_YUM_PACKAGES || exit $?
fi

if [ -e "/opt/rapids/environment.yml" ]; then
    echo "environment.yml found. Installing packages"
    timeout ${CONDA_TIMEOUT:-600} conda env update -f /opt/rapids/environment.yml || exit $?
fi

if [ "$EXTRA_CONDA_PACKAGES" ]; then
    echo "EXTRA_CONDA_PACKAGES environment variable found. Installing packages."
    timeout ${CONDA_TIMEOUT:-600} conda install -y $EXTRA_CONDA_PACKAGES || exit $?
fi

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found. Installing packages.".
    timeout ${PIP_TIMEOUT:-600} pip install $EXTRA_PIP_PACKAGES || exit $?
fi
