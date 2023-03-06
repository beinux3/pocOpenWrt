#!/bin/bash

docker build -t beinux3/debian:openWrtBuilder .

docker run -i -t beinux3/debian:openWrtBuilder /bin/bash