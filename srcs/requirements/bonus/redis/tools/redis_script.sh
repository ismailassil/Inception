#!/bin/bash

sysctl -w vm.overcommit_memory=1

exec redis-server --protected-mode no
