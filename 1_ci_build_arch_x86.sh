#!/bin/bash
set -e

export TARGET=i686-linux-android
export TARGET_JDK=x86

bash 2_ci_build_global.sh

