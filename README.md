# Development Environments - Ubuntu 64 - PHP

A Ubuntu Server 64bit development environment preloaded with PHP and additional useful development tools.

The environment is built using [Packer] and provisioned by [Vagrant].

### Requirements

In order to build and run this development environment there are a few requirements needed:

  - [Packer]
  - [Vagrant] - 1.7.1+
  - [VirtualBox] - 4.3.26
  - [Cygwin] - (recommended) With at least SSH, and perhaps GIT

### Preloaded

The VM build provides the following tools preloaded:

  - [GIT] - Standard ubuntu package
  - [Cloud9 IDE] - A fully loaded web based IDE with full debugging features
  - [NVM] - Node version managment tool
  - [Node.js] - 0.12
  - [PHP] - Standard ubuntu package
  - [Apache] - Standard ubuntu package
  - [XDebug] - Standard ubuntu package
  - [MySQL] - Standard ubuntu package
  - [Memcached] - Standard ubuntu package
  - [SSMTP] - Standard ubuntu package
  - [Adminer] - 4.2.1 (MySQL)
  - [MailDev] - Standard NPM package

### Build

To build the initial vagrant box, [Packer] will need to be downloaded and extracted into the a new directory called *packer* and should look like (assuming you cloned this GIT branch into C:\vm\dev64-php) C:\vm\dev64-php\packer.

Once extracted open a new [Cygwin] terminal and navigate to the root directory of the repository and run:

```sh
$ ./build.sh
```

This can take upto an hour or so, and once completed a *.box file should be created in the data directory.

### Running

To run the development environment again use [Cygwin] and point it to the repository root and execute:

```sh
$ vagrant up
```

Once this has finished building and launching the environment use the following command to access the environment via SSH:

```sh
$ vagrant ssh
```

For more information on using [Packer] and [Vagrant] please visit the respective sites, they provide very details documents and there is plenty of information around on the web ;)

### Private IP, Shared folder and Tools

The following are the default properties setup in the Vagrantfile (these can be changed if required by editing the Vagrantfile):

  - 1 CPU
  - 1024 MB RAM
  - Private network IP - 192.168.200.101
  - Shared folder is *workspace* which points to ~/workspace within the guest VM.

Symlinking has been enabled for the shared folder, however for windows this will require granting access to create symlinks via the policy tool or running the terminal as an administrator.

Access to the web tools can be accessed via:

  - Cloud9 IDE: http://192.168.200.101:8181
  - Adminer (DB): http://192.168.200.101:8081
  - MailDev (Mail SMTP): http://192.168.200.101:1080

### Credentials

  - Ubuntu: vagrant - vagrant
  - MySQL: root - vagrant

** Happy developing. **

[git]:http://git-scm.com/
[virtualbox]:https://www.virtualbox.org/
[packer]:http://www.packer.io/
[vagrant]:http://www.vagrantup.com/
[cygwin]:http://www.cygwin.com/
[cloud9 ide]:http://cloud9.io/
[node.js]:http://nodejs.org/
[nvm]:https://github.com/creationix/nvm
[grunt cli]:https://www.npmjs.com/package/grunt-cli
[mongodb]:http://mongodb.org/
[mongo express]:https://www.npmjs.com/package/mongo-express
[maildev]:https://www.npmjs.com/package/maildev
[php]:https://php.net/
[apache]:http://www.apache.org/
[xdebug]:http://xdebug.org/
[mysql]:https://www.mysql.com/
[memcached]:http://memcached.org/
[ssmtp]:https://wiki.archlinux.org/index.php/SSMTP
[adminer]:http://www.adminer.org/
[maildev]:https://github.com/djfarrelly/maildev/
