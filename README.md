This is a hourly travis-ci ([![Build Status](https://travis-ci.org/Joshua-Anderson/atom-uploader.svg?branch=master)](https://travis-ci.org/Joshua-Anderson/atom-uploader)) job that checks if there is a new version of atom available.

If there is a new version it uploads it to a bintray debian repository.

To setup the apt repository, run:

``` shell
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 99246077F3B16285
$ sudo apt-add-repository 'deb https://dl.bintray.com/joshua-anderson/atom wheezy main'
$ sudo apt-get update
$ sudo apt-get install atom
```
