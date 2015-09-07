This is a hourly travis-ci ([![Build Status](https://travis-ci.org/Joshua-Anderson/atom-uploader.svg?branch=master)](https://travis-ci.org/Joshua-Anderson/atom-uploader)) job that checks if there is a new version of atom available

If there is a new version it uploads it to package cloud (vivid and utopic distributions).

To setup the apt repository, go to https://packagecloud.io/joshua-anderson/atom or follow these instructions:

``` shell
$ curl -s https://packagecloud.io/install/repositories/joshua-anderson/atom/script.deb.sh | sudo bash
$ sudo apt-get install atom
```
