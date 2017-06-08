#!/bin/bash

# Assumptions:
# - already have brew installed
# - already have xcode and command-line tools installed
# - running from root of the already cloned tf-coriander repo

set -e
set -x

brew install autoconf automake libtool shtool gflags python3

if [[ ! -d env3 ]]; then {
    python3 -m venv env3
} fi

source env3/bin/activate
pip install numpy

if [[ ! -d soft ]]; then {
    mkdir soft
} fi

set +e
bazelversion=none
bazelversion=$(bazel --batch version | grep 'Build label')
set -e

if [[ ${bazelversion} != 'Build label: 0.4.5' ]]; then {
    pushd soft
    if [[ ! -f bazel-0.4.5-installer-darwin-x86_64.sh ]]; then {
        wget https://github.com/bazelbuild/bazel/releases/download/0.4.5/bazel-0.4.5-installer-darwin-x86_64.sh -O tmp-bazel-0.4.5-installer-darwin-x86_64.sh
        mv tmp-bazel-0.4.5-installer-darwin-x86_64.sh bazel-0.4.5-installer-darwin-x86_64.sh
    } fi
    sh ./bazel-0.4.5-installer-darwin-x86_64.sh --user
    popd
} fi

pushd soft
if [[ ! -d llvm-4.0 ]]; then {
    if [[ ! -f clang+llvm-4.0.0-x86_64-apple-darwin.tar.xz ]]; then {
        wget http://llvm.org/releases/4.0.0/clang+llvm-4.0.0-x86_64-apple-darwin.tar.xz -O tmp-clang+llvm-4.0.0-x86_64-apple-darwin.tar.xz
        mv tmp-clang+llvm-4.0.0-x86_64-apple-darwin.tar.xz clang+llvm-4.0.0-x86_64-apple-darwin.tar.xz
    } fi
    rm -Rf clang+llvm-4.0.0-x86_64-apple-darwin
    tar -xf clang+llvm-4.0.0-x86_64-apple-darwin.tar.xz
    mv clang+llvm-4.0.0-x86_64-apple-darwin llvm-4.0
} fi
popd
