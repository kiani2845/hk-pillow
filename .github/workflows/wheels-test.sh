#!/bin/bash
set -e

if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install fribidi
    export PKG_CONFIG_PATH="/usr/local/opt/openblas/lib/pkgconfig"
    if [ -f /opt/homebrew/lib/libfribidi.dylib ]; then
        sudo cp /opt/homebrew/lib/libfribidi.dylib /usr/local/lib
    fi
elif [ "${AUDITWHEEL_POLICY::9}" == "musllinux" ]; then
    apk add curl fribidi
else
    yum install -y fribidi
fi

if [ "${AUDITWHEEL_POLICY::9}" != "musllinux" ]; then
  # TODO Update condition when NumPy supports free-threading
  if [ $(python3 -c "import sysconfig;print(sysconfig.get_config_var('Py_GIL_DISABLED'))") == "1" ]; then
    python3 -m pip install numpy --index-url https://pypi.anaconda.org/scientific-python-nightly-wheels/simple
  else
    python3 -m pip install numpy
  fi
fi

if [ ! -d "test-images-main" ]; then
    curl -fsSL -o pillow-test-images.zip https://github.com/python-pillow/test-images/archive/main.zip
    unzip pillow-test-images.zip
    mv test-images-main/* Tests/images
fi

# Runs tests
python3 selftest.py
python3 -m pytest Tests/check_wheel.py
python3 -m pytest
