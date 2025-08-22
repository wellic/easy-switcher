#!/usr/bin/env bash

set -uEeo pipefail
set -x


SCRIPT="$0"
cd "$(dirname "$SCRIPT")" || exit 1
SCRIPT_FULLPATH_DIR="$(pwd)"
SCRIPT_NAME="$(basename "${SCRIPT}")"
SCRIPT_FULLPATH="${SCRIPT_FULLPATH_DIR:?}/${SCRIPT_NAME:?}"

#################################################################################
PROJECT_DIR="${1:-$SCRIPT_FULLPATH_DIR}"
PROJECT_DIR="$(realpath --relative-to=$SCRIPT_FULLPATH_DIR "$PROJECT_DIR")"

project="$(basename "$PROJECT_DIR")"
if [[ $project == "." ]]; then
    project=wellic
fi
BUILD_PATH=$SCRIPT_FULLPATH_DIR/build/$project

mkdir -p "$BUILD_PATH"

echo "Building $PROJECT_DIR"
cd "$PROJECT_DIR"

rel_build_dir="$(realpath --relative-to="$PWD" "$BUILD_PATH")"
fpc -O2 -Xs -XX "-FE$rel_build_dir" easy-switcher.lpr

cd $rel_build_dir
rm easy-switcher.o
ls -al easy-switcher

cat <<EOF > install.sh
 echo '# sudo systemctl stop easy-switcher';
 echo '# sudo easy-switcher -i';
 echo '# sudo easy-switcher -c';
 echo
 set -x;
 sudo systemctl stop easy-switcher;
 sudo cp easy-switcher $(which easy-switcher) ;
 sudo systemctl start easy-switcher;
EOF

chmod +x install.sh
./install.sh 
