# cloxp-docker

This is a docker setup for running a cloxp installation.

It will create a Ubuntu-based docker image containing nodejs/npm, java8/maven,
leiningen, and cloxp.

To install and run cloxp do

```sh
$ docker build --tag="cloxp" .
$ docker run -p 9001:9001 -t cloxp
```

The run command will start a http server on port 9001. Once the server runs, cloxp will be available at [http://localhost:9001/cloxp.html]().

### Note: Mac / boot2docker users

Since boot2docker sets up an additional VM for running docker itself you will need to forward the ports from the VM to your host machine:

```sh
VBoxManage controlvm "boot2docker-vm" natpf1 "cloxp-tcp-web-port,tcp,,9001,,9001";
```

### (Selective) persistence of containers

The container created by starting the cloxp image will not be changed by default. This means that the inital time cloxp takes to index files and the install time for maven packages will occur every time you restart the container. To persist these changes you can use the docker commit command (`docker commit CONTAINER-ID cloxp`). Alternatively you can mount directories from your native file system, for example for caching .m2: `mkdir m2; docker run -v $PWD/m2:/home/cloxp/.m2 -p 9001:9001 -t cloxp`.

<!--
mkdir -p m2; docker run -v $PWD/m2:/home/cloxp/.m2 -p 9001:9001 -i -t cloxp
VBoxManage controlvm "boot2docker-vm" natpf1 "cloxp-tcp-web-port,tcp,,9002,,9002";
VBoxManage controlvm "boot2docker-vm" natpf1 delete "cloxp-tcp-web-port";
-->