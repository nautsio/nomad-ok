#!/bin/bash
JOB=$1
TASK=$2

# This obviously only works if there is just one port exposed per task.
for ALLOC in $(curl -s "$NOMAD_ADDR/v1/job/$JOB/allocations" | jq -r '.[] | select(.TaskStates.'"$TASK"'.State != "dead") | .ID'); do
  curl -s "$NOMAD_ADDR/v1/allocation/$ALLOC" | jq -r '.TaskResources.'"$TASK"' | .Networks[0].IP + ":" + (.Networks[0].DynamicPorts[0].Value | tostring)'
done
