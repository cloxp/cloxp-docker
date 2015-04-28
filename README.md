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


<!--
mkdir -p m2; docker run -v $PWD/m2:/home/cloxp/.m2 -p 9001:9001 -i -t cloxp
-->