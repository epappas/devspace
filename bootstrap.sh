#!/bin/sh
#
# Copyright 2015 Evangelos Pappas <epappas@evalonlabs.com>
#
# Refer to devspace README.md
#
# Contributors:
# - Evangelos Pappas
#
# Enjoy!

DRY_MODE=0
LOCAL_MODE=0
DEVSPACE_LOCAL_PATH='.'
DEVSPACE_TARGET_PATH=/opt/chef/devspace
SSH_ARGS='-t'
SSH_ACC=''
SSH_HOST=''
USER='root'
GROUP='root'
SUDO="sudo -i -u $USER"
SUDO2="sudo -u $USER"
GEM_BIN="/opt/chefdk/embedded/bin/gem"
BERKS_BIN="/opt/chefdk/embedded/bin/berks"
export USE_SYSTEM_GECODE=1

set -e

execute(){
  if [ $DRY_MODE -ne 0 ]; then
      echo "$@"
  else
      echo "----> $@"
      $@
  fi
}

do_ssh() {
  execute ssh $SSH_ARGS $SSH_ACC@$SSH_HOST "$@"
}

safe_do(){
  if [ $LOCAL_MODE -ne 0 ]; then
    execute $SUDO $@
  else
    do_ssh $SUDO $@
  fi
}

unsafe_do(){
  if [ $LOCAL_MODE -ne 0 ]; then
    execute $SUDO2 $@
  else
    do_ssh $SUDO2 $@
  fi
}

safe_f_stat(){
  if [ $LOCAL_MODE -ne 0 ]; then
    echo $(stat $1 2>&1 >/dev/null)
  else
    echo $(safe_do stat $1 \> /dev/null 2\>\&1)
  fi
}

safe_transfer(){
  if [ $LOCAL_MODE -ne 0 ]; then
    execute $SUDO2 cp -rf $@
    execute $SUDO chown -R $USER:$GROUP $2
  else
    execute scp -r $1 $SSH_ACC@$SSH_HOST:$2
    do_ssh $SUDO chown -R $USER:$GROUP $2
  fi
}

check_conn(){
  if [ $LOCAL_MODE -ne 0 ]; then
    echo 'ok'
  else
    echo $(execute ssh -q $SSH_ACC@$SSH_HOST exit && echo 'ok')
  fi
}

commend(){
  if [ $DRY_MODE -ne 0 ]; then
      echo "# " $@
  else
      echo $@
  fi
}

install_deps(){
  safe_do apt-get -y update
  # safe_do apt-get -y upgrade
  safe_do apt-get -y install g++ curl git build-essential \
    ruby-dev ruby1.9.1-full libxslt-dev libxml2-dev \
    ruby-dep-selector libqtcore4 libqtgui4 libqt4-dev libboost-dev \
    libgecode-dev
}

install_chef(){
  case "$(uname -a)" in
    *x86_64*) # A normal case, as always!
      if [ ! -z "$(safe_f_stat /opt/chefdk)" ]; then
        # url="https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.6.0-1_amd64.deb"
        url="https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.6.2-1_amd64.deb"
        pkg="/tmp/`basename \`echo $url\``"

        safe_do wget "$url" -O "$pkg"

        safe_do dpkg -i --force-overwrite "$pkg"
        safe_do apt-get -f install
        safe_do rm -f "$pkg"
      fi
      ;;
    *armv7l*) # raspberry pi FTW!
      safe_do apt-get install chef
      GEM_BIN="gem"
      BERKS_BIN="berks"
      ;;
    *) # no idea what to do here, lets just trust the community
      safe_do apt-get install chef
      GEM_BIN="gem"
      BERKS_BIN="berks"
      ;;
  esac
}

install_gem_deps(){
  case "$(uname -a)" in
    *x86_64*) # A normal case, as always!
      safe_do $GEM_BIN install --no-rdoc --no-ri ruby-shadow knife-solo foodcritic
      if [ ! -z "$(safe_f_stat  /usr/local/bin/berks)" ]; then
        safe_do rm /usr/local/bin/berks
        safe_do ln -s $BERKS_BIN /usr/local/bin
      fi
      ;;
    *armv7l*) # raspberry pi FTW!
      safe_do $GEM_BIN install --no-rdoc --no-ri ruby-shadow knife-solo foodcritic berkshelf
      ;;
    *) # no idea what to do here, lets just trust the community
      safe_do $GEM_BIN install --no-rdoc --no-ri ruby-shadow knife-solo foodcritic berkshelf
      ;;
  esac
}

install_devspace(){
  safe_do mkdir -p $DEVSPACE_TARGET_PATH
  safe_transfer $DEVSPACE_LOCAL_PATH $DEVSPACE_TARGET_PATH
  unsafe_do /usr/local/bin/berks vendor $DEVSPACE_TARGET_PATH/cookbooks
}

run_devspace(){
  unsafe_do chef-client -c $DEVSPACE_TARGET_PATH/.chef/client.rb -j $DEVSPACE_TARGET_PATH/nodes/server.json
}

run_main(){
  install_deps
  install_chef
  install_gem_deps
  install_devspace
  run_devspace
}

if [ $# -eq 0 ]; then
  exit 0
fi

if [ ! -z "$(echo $@ | grep -e "--dry")" ]; then
  shift
  DRY_MODE=1
fi

if [ ! -z "$(echo $@ | grep -e "--local")" ]; then
  shift
  LOCAL_MODE=1
fi

SSH_ACC=$1
SSH_HOST=$2

run_main
