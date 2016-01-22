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

!SUB

## Sysdig

!SLIDE

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
