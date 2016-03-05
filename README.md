# Devspace
A workspace set up for node.js developers

- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
- [Usage](#usage)
- [What is installed](#what-is-installed)

## Supported Platforms
Has been tested on
- ubuntu 14.04
- cygwin (MINGW32_NT-6.1)

## Installation
- Install the latest version of [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
- Install the latest version of [Vagrant](http://www.vagrantup.com/downloads.html)
- Install the latest version of [ChefDK](https://downloads.chef.io/chef-dk/)
- Install the Vagrant Berkshelf plugin:

  ```
   $ vagrant plugin install vagrant-berkshelf
  ```

- Clone this repo

  ```
   $ git clone https://github.com/epappas/devspace.git
   $ cd devspace
  ```

- Install any dependency

  ```
   $ bundle install

   // If you don't have ruby installed in your machine, you may execute
   $ chef exec bundle install
  ```

- Create your workspace folder (by default will be binded at /workspace)

  ```
   $ mkdir /workspace
  ```

- Create a new json file under the path ./data_bags/users/[Your username].json and provide such structure:

**DON'T COMMIT THAT FILE ON master**

```JavaScript
{
    "id": "[YOU USERNAME, same as the filename eg epappas]",
    "comment": "[Your Name]",
    "groups": ["dev"],
    "shell": "/bin/bash",
    "profile": {
        "config": {
            "AWS_ACCESS_KEY_ID": "",
            "AWS_SECRET_ACCESS_KEY": ""
        }
    },
    "git": {
        "config": {
            "name": "[Your Name]",
            "email": "[Your email]",
            "editor": "vim",
            "push": "simple",
            "alias": {
                "co": "checkout",
                "ll": "log --graph --date=relative --topo-order --pretty='format:%C(yellow)%h%C(yellow)%d %Cblue%ar %Cgreenby %an%Creset -- %s'",
                "lla": "log --graph --date=relative --topo-order --pretty='format:%C(yellow)%h%C(yellow)%d %Cblue%ar %Cgreenby %an%Creset -- %s' --all"
            }
        }
    },
    "ssh": {
        "authorized_keys": [
        "[YOUR PUBLIC KEY, eg the contents of your id_rsa.pub]"
      ],
        "public_keys": {
            "id_rsa.pub": "[YOUR PUBLIC KEY, eg the contents of your id_rsa.pub, Yes it can be same as above]"
        },
        "private_keys": {
            "id_rsa": "[YOUR Private Key, eg the contents of your id_rsa or id_rsa.ppk]"
        },
        "config": [{
            "host": "github.com",
            "hostName": "github.com",
            "user": "git",
            "identitiesOnly": "yes",
            "identityFile": "/home/[Your Username, same as the id you entered at the 1st line]/.ssh/id_rsa"
        }]
    },
    "sudo": {
        "host": "ALL",
        "runas": "ALL",
        "commands": ["ALL"],
        "nopasswd": true,
        "defaults": []
    }
}
```

- Read the sections below, about which files you need to edit to make it feel like home
- Bootstrap your VM (Beter to go for a coffee or lunch, it's going to take a while)

  ```
  $ kitchen converge .
  ```

## Usage
After any change that you are making, apply them by executing

```
    $ kitchen converge .
```

To login run, in the directory of devspace

```
    $ kitchen login
```

## What is installed
Servers
- Node.js (0.10.38)
- aerospike
- nginx
- MySQL
- erlang
- couchDB

Node.js's global modules
- gulp
- mocha
- express
- bower
- jshint
- nodemon
- nvm
- pangyp

Tools
- awscli
- vim
- git

Boostraps your SSH Keys and config

Boostraps your host file

