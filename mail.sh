#!/bin/bash

STACK=$1
FROM=$2
TO=$3
cat << EOF
From: <${FROM}>
To: <${TO}>
Subject: Nomad Open Kitchen training environment

Dear ${STACK},

A personal training environment for the Scalable Container Scheduling Open Kitchen
has been created for your pleasure.
This mail contains the necessary hostname information and credentials to let you
access your environment.
All you need is an SSH client. Optionally a local Nomad binary can be used to query
the Nomad cluster or submit jobs from your local machine.

Your SSH private key is:
$(cat stacks/$1/ssh-key)

Save as 'ssh-key' and connect with:

$ ssh -i ssh-key user@nomad-01.${STACK}.gce.nauts.io

Alternatively the external ip addresses of all servers can be used, see server list:
NAME                 ZONE           MACHINE_TYPE PREEMPTIBLE INTERNAL_IP EXTERNAL_IP     STATUS
$(make -s list STACK=$STACK)

User 'user' has privileges to run docker commands, and sudo as root if necessary.
Try out 'nomad node-status' to see which servers are in the cluster.

All server nodes also expose HTTP endpoints for Nomad and Consul, E.g.

* http://nomad-01.$STACK.gce.nauts.io:4646/v1/nodes
* http://nomad-01.$STACK.gce.nauts.io:8500/ui/

NB. The environment will be destroyed after the Open Kitchen, so if you want to save
your work do so before leaving.

Best regards,

Erik Veld, Bastiaan Bakker
EOF
