#!/bin/bash

cd `dirname $0`
pod repo update LigoPrivatePods --verbose
pod update --verbose --no-repo-update
