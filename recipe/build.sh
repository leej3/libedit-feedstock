#!/bin/bash

if [[ ! $BOOTSTRAPPING == yes ]]; then
  # Get an updated config.sub and config.guess
  cp $BUILD_PREFIX/share/libtool/build-aux/config.* .

  export CFLAGS="${CFLAGS} -I${PREFIX}/include"
  export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
else
  export CFLAGS="${CFLAGS} -I${PREFIX}/include -I/usr/include"
  export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -L/usr/lib64"
fi

set -ex

./configure --prefix=${PREFIX} \
            --host=${HOST} \
            --disable-static

make -j ${CPU_COUNT} ${VERBOSE_AT}
make install

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  make check
fi

# This conflicts with a file in readline
rm -f ${PREFIX}/share/man/man3/history.3
