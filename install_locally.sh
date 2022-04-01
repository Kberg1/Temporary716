set -o errexit
set -o nounset
set -o xtrace

SHA1HASH=17a75c54d292bd0923f0a1817a1b02ded37d1de1
GPG_PREFIX=gnupg-1.4.13
GPG_ARCHIVE=${GPG_PREFIX}.tar.bz2
export CC=gcc
export CFLAGS="-g -O2"

curl -O https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.13.tar.bz2
shasum -a 1 -c <(echo "${SHA1HASH}  ${GPG_ARCHIVE}")

if [ $? != 0 ]
then
  echo "WARNING: HASHES DO NOT MATCH"
  read -p -r -n 1 "Continue? [Y/n] " user_input

  if [ "$user_input" = y ] ||  [ "$user_input" = Y ]
  then
    exit 1
  fi
fi

tar xf ${GPG_ARCHIVE}
rm ${GPG_ARCHIVE}

cd ${GPG_PREFIX}
./configure --disable-dependency-tracking --disable-asm --prefix="${PWD}"
make && make check && make install
