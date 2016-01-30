# Top Level Domain under which to create A records for external addresses
TLD=gce.nauts.io

# Project in GCE in which to create the infrastructure
PROJECT=innovation-day-nomad

# Default host to connect to with make ssh
HOST=nomad-01

# Sender address for emails to course participants
FROM=bbakker@xebia.com

# Default Stack ID
# If not defined here, or supplied as variable during at make invocation time
# the Makefile will generate a random stack id and store it in generated-stack-id
# rationale: two users of the same project should not use the same stack id
# by accident.
#
#STACK=
