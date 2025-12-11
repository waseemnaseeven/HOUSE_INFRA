#!/bin/bash

if curl -k -sf https://localhost:9090/-/ready; then
    echo -e ok
else 
    exit 1
fi

