#!/bin/bash
echo "Access Key: $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c20)"
echo "Secret Key: $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c40)"
