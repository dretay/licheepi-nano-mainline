#!/bin/bash

container run --user $(id -u) --memory 4g --cpus 8 --rm -it  -v $PWD/:/workdir/work br-build /workdir/br-build.sh

