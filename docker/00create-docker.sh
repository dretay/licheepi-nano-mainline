#!/bin/bash

container build -t br-build:latest --build-arg UID=$UID --build-arg USERNAME=$USER --progress=plain -f Dockerfile .
