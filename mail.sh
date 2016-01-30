#!/bin/bash

STACK=$1
FROM=$2
TO=$3
PROJECT=$4
DOMAIN=$5

cat << EOF > stacks/${STACK}/message.txt
Dear ${STACK},

A personal training environment for the Scalable Container Scheduling Open Kitchen has been created for your pleasure.
This mail contains the necessary hostname information and credentials to let you access your environment.
All you need is an SSH client. Optionally a local Nomad binary can be used to query the Nomad cluster or submit jobs from your local machine.

Your SSH private key is attached to this mail. Save as 'ssh-key' and connect with:

$ ssh -i ssh-key user@nomad-01.${DOMAIN}

Alternatively the external ip addresses of all servers can be used, see server list:
NAME                 ZONE           MACHINE_TYPE PREEMPTIBLE INTERNAL_IP EXTERNAL_IP     STATUS
$(make -s list STACK=${STACK} PROJECT=${PROJECT})

User 'user' has privileges to run docker commands, and sudo as root if necessary.
Try out 'nomad node-status' to see which servers are in the cluster.

All server nodes also expose HTTP endpoints for Nomad and Consul, E.g.

* http://nomad-01.${DOMAIN}:4646/v1/nodes
* http://nomad-01.${DOMAIN}:8500/ui/

NB. The environment will be destroyed after the Open Kitchen, so if you want to save your work do so before leaving.

Best regards,

Erik Veld, Bastiaan Bakker
EOF

makemime -j                                                           \
          \(                                                          \
            -m "multipart/mixed"                                      \
            -a "Mime-Version: 1.0"                                    \
            -a "From: <${FROM}>"                                      \
            -a "To: <${TO}>"                                          \
            -a "Subject: Nomad Open Kitchen training environment"     \
            \(                                                        \
              -c "text/plain; charset=iso-8859-1"                     \
              stacks/${STACK}/message.txt                             \
            \)                                                        \
          \)                                                          \
          -o /dev/stdout                                              \
          \(                                                          \
            -c "application/x-pem-file"                               \
            -a "Content-Disposition: attachment; filename=ssh-key"    \
            stacks/${STACK}/ssh-key                                   \
          \)
