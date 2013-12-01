#!/bin/bash

GIT_URL="git://github.com/pekepeke/dotfiles.git"
LOCAL_DIR="$HOME/.github-dotfiles"
BACKUP_FILES=".bash_profile .bashrc .screenrc .vimrc"
SKIP_FILES=". .. .git setup.sh"
COPY_FILES=""

opt_uninstall=0

usage() {
  local prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]

-h   : show usage
-u   : uninstall
EOM
  exit 1
}

matchin() {
  local SRC=$1
  shift
  for K in $*; do
    if [ "x$SRC" = "x$K" ]; then
      return 0
    fi
  done
  return 1
}

purge_files() {
  local RED="\033[1;31m"
  local DEFAULT="\033[00m"

  for f in $(find ~ -maxdepth 1 -type l -name '.*'); do
    if [ ! -e "$(readlink $f)" ] ; then
      echo -e ${RED}rm "$f"${DEFAULT}
      rm "$f"
    fi
  done
}

exec_install() {
  local RED="\033[1;31m"
  local GREEN="\033[1;32m"
  local YELLOW="\033[1;33m"
  local BLUE="\033[1;34m"
  local GRAY="\033[1;37m"
  local DEFAULT="\033[00m"
  if [ ! -e $(basename $0) ]; then
    if [ ! -e $LOCAL_DIR ]; then
      git clone ${GIT_URL} ${LOCAL_DIR}
    fi
    cd ${LOCAL_DIR}
  fi

  local CDIR=$(pwd)

  if [ ! -e $HOME/.rc-org ]; then
    mkdir $HOME/.rc-org
    for F in "$BACKUP_FILES" ;do
      echo -e "${RED}mv $HOME/$F $HOME/.rc-org${DEFAULT}"
      mv $HOME/$F $HOME/.rc-org
    done
  fi
  local skipfiles=""
  local execfiles=""
  for F in .?* ;do
    if matchin "$F" $SKIP_FILES ; then
      # echo -e "${GRAY}skip object $F${DEFAULT}"
      skipfiles="$skipfiles\n${GRAY}skip object $F${DEFAULT}"
    elif [ -e "$HOME/$F" ]; then
      # echo -e "${GRAY}skip $F${DEFAULT}"
      skipfiles="$skipfiles\n${GRAY}skip $F${DEFAULT}"
    elif matchin "$F" $COPY_FILES ; then
      execfiles="$execfiles\n${GREEN}cp $CDIR/$f $HOME${DEFAULT}"
      cp $CDIR/$f $HOME
    else
      execfiles="$execfiles\n${YELLOW}ln -s $CDIR/$F $HOME${DEFAULT}"
      ln -s $CDIR/$F $HOME
    fi
  done
  [ x"$skipfiles" != x"" ] && echo -e $skipfiles
  [ x"$execfiles" != x"" ] && echo -e $execfiles

  if [ -e "$CDIR/.gitmodules" ]; then
    git submodule init
    git submodule update
  fi
}

exec_uninstall() {
  local files
  local fpath
  if [ -e $LOCAL_DIR ]; then
    files=$(find $LOCAL_DIR -maxdepth 1 -mindepth 1)
  else
    files=$(find ~/ -type l -name '.*' -maxdepth 1 -mindepth 1)
  fi

  for f in $files; do
    fpath=~/$(basename $f)
    if [ -e $fpath ]; then
      echo rm $fpath
      rm $fpath
    fi
  done
  for f in $(find ~/.rc-org -maxdepth 1 -mindepth 1); do
    fpath= ~/$(basename $f)
    echo "cp -p $f $fpath"
    cp -p $f $fpath
  done

  cat <<EOM

### please exec following commands

rm $LOCAL_DIR

EOM
}

main() {
  cd $(dirname $0)

  purge_files

  if [ $opt_uninstall = 1 ]; then
    exec_uninstall
  else
    exec_install
  fi

}

while getopts "hu" opt; do
  case $opt in
    h)
      usage ;;
    # v) ;;
    u) opt_uninstall=1;;
  esac
done
shift `expr $OPTIND - 1`
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

