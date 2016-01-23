<br />
<br />
# Nomad Open Kitchen
### January 27th, 2016
<br />
<br />
<br />
<br />
Bastiaan Bakker [bastiaan@nauts.io](mailto:bastiaan@nauts.io)   
Erik Veld [erik@nauts.io](mailto:erik@nauts.io)

!SLIDE

# Less pets, more cattle
<pre>
              (__)            (__)             (__)             (__)             (__)
              (oo)            (><)             (oO)             (XX)             (oo)
       /-------\/      /-------\/       /-------\/       /-------\/       /-------\/
      / |     ||      / |     ||       / |     ||       / |     ||       / |     ||
     *  ||----||     *  ||----||      *  ||W---||      *  ||w---||      *  ||V---||
        ^^    ^^        ^^    ^^         ^^    ^^         ^^    ^^         ^^    ^^
</pre>

!SUB

*__Don't__ treat your servers like puppies: they've __got names__ and __when they get sick__, __everything grinds to a halt__ while you nurse them back to health.*

*Instead treat your servers __like cattle__: you __number them__, and __when they get sick__ and you have to __shoot them__ in the head, the herd can keep moving.*

<br />
<br />
*It takes a family of three to care for a __single puppy__, but a few cowboys can drive tens of __thousands of cows__ over great distances, all while drinking whiskey.*

!SLIDE

## Immutable infrastructure
What is it?

!SUB

### Why do we want it?
- All components of a running system are in a known state
- Simplifies change management
- Promotes better understanding across the whole delivery chain
- Adds resiliency, flexibility, portability and better safeguards
- Forces you to expect failures and have a reliable process to rectify them simply

!SLIDE

## Infrastructure as code
- Operators should not log in to a new machine and configure it
- Code should be written to describe the desired state
- Manage infrastructure via source control
- Apply testing to infrastructure

<br />
*“Enable the reconstruction of the business from nothing but a source code repository, an application data backup, and bare metal resources” - Jesse Robins*

!SUB

### Why do we want it?
- Remove manual steps prone to errors
- Enables collaboration
- Infrastructure components can be versioned
- Each execution has a predictable outcome

<br />
*“A single person can start 100 machines at the press of a button, and have them properly configured” - Boyd Hemphill*

!SLIDE

## Resources & Scheduling
When you stop seeing your servers as pets and start seeing them as resources you can use to run your workloads,
you can also stop caring where they are scheduled. You care only that your workload gets processed.

!SLIDE

# Nomad

!SUB

## What is it?

!SUB

## Why do I want it?

!SUB

## How does it work?

!SUB

## Some useful terms

!SLIDE

# Getting started

!SUB

## The setup on GCE

!SUB

## Explain how to work with the components

!SLIDE
## Monitoring with Sysdig

*“Sysdig Cloud is the first and only monitoring, alerting, and troubleshooting
  solution designed from the ground up to provide unprecedented visibility into
  containerized infrastructures.”*

We'll integrate Sysdig Cloud to get a quick overview of our cluster and the
containers running in it.

!SUB
## Sysdig Agent

* Sysdig runs as a metrics collecting agent on every node.
* The agent employs a custom kernel module to collect interesting events.
* The agent aggegates the metrics and forwards them to Sysdig Cloud.
* The agent authenticates to Sysdig Cloud with a per-account ACCESS_KEY.
* Both the agent and kernel module can be deployed as a single *very privileged* docker container.

!SUB
## Sysdig Installation
### Account Creation

1. Create a trial account at https://sysdig.com/sign-up/.
2. Activate your account.
3. Choose an installation option (doesn't matter which).
4. Copy the ACCESS_KEY

!SUB
## Sysdig Installation
### Runing Sysdig in our cluster

* We have prepared a Nomad system job to automatically deploy Sysdig on all nodes.
* The job uses the *raw_exec* driver to start the Sysdig Docker container with
  the right privileges and mounts.
  1. login to server 'nomad-01'
  2. Paste ACCESS_KEY into `jobs/sysdig.nomad`
  3. Run `nomad run jobs/sysdig.nomad`.

     E.g.:

!SUB
## Sysdig Installation
### Runing Sysdig in our cluster

```
$ cd jobs/
$ perl -pi -e 's/ACCESS_KEY=".*"/ACCESS_KEY="7535a00e-58aa-4073-b55e-eb0ccd22c410"/' sysdig.nomad
$ nomad run sysdig.nomad
==> Monitoring evaluation "d3d8b3e3-c1ba-7594-8cd6-868e79bb1e2b"
    Evaluation triggered by job "sysdig"
    Allocation "8e662877-2633-dc54-e4d1-72de554b74e6" created: node "e40fb2a4-4554-c487-cfe6-efbf201543e8", group "sysdig"
    Allocation "8fb994cb-0797-ac22-8c20-30fb35b2b4d9" created: node "f74c9eda-032d-c7b7-4533-c4108bc25165", group "sysdig"
    Allocation "9a3fdfc7-a2e1-e3ca-ec97-80cb37ca4af2" created: node "675b2e09-1019-bb6e-ca3f-c32cd496f7a3", group "sysdig"
    Allocation "f0525cab-b9b1-8fe9-bcf2-427960bb9597" created: node "8a6f59ea-7082-2fbe-90b8-2b3e0d30d7ed", group "sysdig"
    Allocation "3a0dc000-604b-089a-4e2b-64e4c6f5c103" created: node "297b78a2-8460-44f2-bc69-a8faa5ab040e", group "sysdig"
    Allocation "5b7f9936-d0da-1966-109d-be2d2e7be4a8" created: node "a71a04a2-ce49-f687-d42f-52aaeeea95a1", group "sysdig"
    Allocation "6f73a61f-2f5e-6345-413d-99b04a4f0ed9" created: node "23e0d9b3-f3e3-acc5-e4d7-8f6a6169b868", group "sysdig"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "d3d8b3e3-c1ba-7594-8cd6-868e79bb1e2b" finished with status "complete"
```

!SUB
## Sysdig Cloud

![Sysdig Cloud Explore View](/img/sysdig-explore.png)

!SLIDE

# asciicast-14


# Jobs

!SUB

## Creating jobs
- HCL
- json

!SUB

## Launching jobs
- Use the CLI
- Use the HTTP api

!SUB

## Constraining jobs
- Hardware
- Meta
- Location
- Anti-affinity

!SUB

## Restarting jobs
- Restart policies
- Intervals

!SUB

## Scaling jobs
- Change the number of instances, redeploy the job, see the number of instances scale
- Make the number too large and see that the extra instances don't get placed

!SUB

## Updating jobs
- Change a value, do a rolling update

!SUB

## Auto discovery
- Uses consul to discover services
- Works without bootstrapping, nomad picks it up as soon as it recognizes consul
- Defined inside the job description
- No need for external tools (registrator)

!SLIDE

# Food

!SLIDE

# Recap
- What does nomad do for you?
- What is the added value?
- What are the experiences sofar?

!SLIDE

# Things don't always go well in real life ...

!SUB

## Decommissioning nodes

!SUB

## Client failures

!SUB

## Master failures

!SUB

## Machine failures

!SLIDE

# Looking back ...

!SLIDE

# Q & A
