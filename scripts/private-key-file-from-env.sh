#!/usr/bin/env bash

# Create a ssh private key file from a repository secret for CD purpose
echo "$SSH_PRIVATE_KEY" > /tmp/ssh_private_key
chmod 600 /tmp/ssh_private_key
