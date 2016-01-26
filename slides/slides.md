<br />
<br />
# Nomad Open Kitchen
<center>January 27th, 2016</center>
<br />
<br />
<br />
<br />
Bastiaan Bakker [bastiaan@nauts.io](mailto:bastiaan@nauts.io)   
Erik Veld [erik@nauts.io](mailto:erik@nauts.io)

!SLIDE

# Less pets, more cattle
<pre markdown="0">
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

# Immutable infrastructure

!NOTE Immutable infrastructure provides stability, efficiency, and fidelity to your applications through automation and the use of the immutability pattern from programming: once you instantiate something, you never change it. Instead, you replace it with another instance to make changes or ensure proper behavior.

!SUB

- All components of a running system are in a **known state**
- **Simplify change management**
- **Better understanding** across the whole delivery chain
- Add **resiliency, flexibility, portability** and better safeguards
- **Expect failures** and have a reliable process to rectify them simply

<br />
*“Enable the reconstruction of the business from nothing but a source code repository, an application data backup, and bare metal resources”* - Jesse Robins

!SLIDE

# Infrastructure as code

!NOTE Infrastructure as code, or programmable infrastructure, means writing code to manage configurations and automate provisioning of infrastructure in addition to deployments, this means you write code to provision and manage your server, in addition to automating processes.
!NOTE It differs from infrastructure automation, which just involves replicating steps multiple times and reproducing them on several servers
!NOTE Don't log in to a new machine and configure it
!NOTE Write code to describe the desired state
!NOTE Manage infrastructure via source control
!NOTE Apply testing to infrastructure

!SUB

- **Remove manual steps** prone to errors
- Enables **collaboration**
- Infrastructure components can be **versioned**
- Each execution has a **predictable outcome**

<br />
*“A single person can start 100 machines at the press of a button, and have them properly configured”* - Boyd Hemphill

!SLIDE

# Resources & Scheduling

!NOTE Schedule a task only on nodes that have enough resources available to run that task. These can be CPU cycles, memory, disk, etc, but also network ports the task wants to bind. Extra constraints or requirements can be described that will decide where a task is run. A resource manager/scheduler will also take care of relocating the task in case of failures.

!SLIDE

# Nomad

!SUB

Nomad is a tool for **managing a cluster of machines and running applications on them**. Nomad **abstracts away machines** and the location of applications, and instead **enables users to declare what they want to run** and Nomad handles where they should run and how to run them.

!SUB

# Erik
show architecture in infographic ...

!SUB

- **Job, Task & Taskgroup**: A Job is a specification of tasks that Nomad should run. It consists of Taskgroups, which themselves contain one ore more Tasks.
- **Allocation**: An Allocation is a placement of a Task on a node.
- **Evaluation**: Evaluations are the mechanism by which Nomad makes scheduling decisions.
- **Node, Agent, Server & Client**: A Client of Nomad and a Node are a machine that tasks can be run on. Nomad servers are the brains of the cluster. An Agent can be run in either Client or Server mode.
- **Task Driver**: A Driver represents the basic means of executing your Tasks.

!SLIDE

# The setup (Erik)

diagram with the gce setup (3x sys1 - nomad + consul) (2x farm - nomad) (nomad @ .local / .gce.nauts.io) (1x network)

!SUB

- how to ssh to the machines
- how to reach nomad
- how to check if things go as planned

!SLIDE

# Jobs

!SUB

# Job types
- **Service**: The service scheduler is designed for scheduling long lived services that should never go down.
- **Batch**: Batch jobs are much less sensitive to short term performance fluctuations and are short lived, finishing in a few minutes to a few days. They can be scheduled and recurring.
- **System**: The system scheduler is used to register jobs that should be run on all clients that meet the job's constraints.

!SUB
# Task drivers
- **Docker**: Run a Docker container
- **Rkt**: Run a Rkt container
- **Exec**: Execute a command for a task using the underlying isolation primitives of the operating system to limit the tasks access to resources
- **Rawexec**: Execute a command for a task without any isolation
- **Java**: Run a downloaded Java jar file
- **Qemu**: Start a Virtual Machine

!SUB

# Creating
Nomad can initialize an example job for us which we can then modify to our own requirements:

```
$ nomad init
Example job file written to example.nomad

$ cat example.nomad
# There can only be a single job definition per file.
# Create a job with ID and Name 'example'
job "example" {
    # Run the job in the global region, which is the default.
    # region = "global"
...
```

!SUB

- change the docker image to nautsio/helloworld
- set the version to v1
- set the group to hello
- task helloworld-v1
- add some tags (hello, v1)
- add port 80
- save it as helloworld-v1.nomad

!SUB

# Launching
Use the run command of the Nomad CLI:
```
$ nomad run helloworld-v1.nomad
==> Monitoring evaluation "3d823c52-929a-fa8b-c50d-1ac4d00cf6b7"
    Evaluation triggered by job "hellloworld-v1"
    Allocation "f67a-72a4-5a13" created: node "5b7c-a959-dfd9", group "hello"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "3d823c52-929a-fa8b-c50d-1ac4d00cf6b7" finished with status "complete"
```

<br />
You can also submit a job in JSON format to the HTTP API endpoint:
```
$ curl -X POST -d @helloworld-v1.json $NOMAD_ADDR/v1/jobs
```

!SUB
# Inspecting
Find out where our job is running:
```
$
```

<br />
Check that the job is running properly by calling it:
```
$ curl http://<ip>
```

!SUB

# Constraints (Erik)
By specifying constraints you can dictate a set of rules that Nomad will follow when placing your jobs. These constraints can be on resources, self applied metadata and other configured attributes.

- Hardware
- Meta
- Location
- Anti-affinity

!SUB

## Restarting (Erik)
- Restart policies
- Intervals

Very few tasks are immune to failure and the addition of restart policies recognizes that and allows users to rely on Nomad to keep the task running through transient failures.
Exercises
Add a restart policy to the job.
Kill one of the job instances by executing the
docker kill <job> command.

!SUB

## Scaling (Erik)
- Change the number of instances, redeploy the job, see the number of instances scale
- Make the number too large and see that the extra instances don't get placed

!SUB

## Updating (Erik)
- Change a value, do a rolling update

Now lets try changing settings in the job file and see what happens when we resubmit the job.
Questions
What happens if we change the version?
What happens if we scale up/down?
What happens if we add a constraint that would disallow placement of the already placed job?

!SLIDE

## Monitoring with Sysdig

*“Sysdig Cloud is the first and only __monitoring, alerting, and troubleshooting
  solution__ designed from the ground up to provide unprecedented visibility into
  __containerized infrastructures__.”*

<br />
We'll integrate Sysdig Cloud to get a quick overview of our cluster and the
containers running in it.

!SUB

- Sysdig runs as a **metrics collecting** agent on every node
- The agent employs a custom **kernel module** to collect interesting events
- The agent **aggegates** the metrics and **forwards** them to Sysdig Cloud
- The agent authenticates to Sysdig Cloud with a **per-account ACCESS_KEY**
- Both the agent and kernel module can be deployed as a single *very privileged* docker container

!SUB
# Account Creation
1. Create a trial account at https://sysdig.com/sign-up/
2. Activate your account
3. Choose an installation option (doesn't matter which)
4. Copy the ACCESS_KEY

!SUB
# Running Sysdig

We have prepared a Nomad **system job** to automatically deploy Sysdig on **all nodes**, by using the **raw_exec** driver to start the Sysdig Docker container with the right **privileges and mounts**.

<br />
  1. login to server 'nomad-01'
  2. Paste ACCESS_KEY into `jobs/sysdig.nomad`
  3. Run `nomad run jobs/sysdig.nomad`

!SUB

```
$ cd jobs/
$ perl -pi -e 's/ACCESS_KEY=".*"/ACCESS_KEY="7535a00e-58aa-4073-b55e-eb0ccd22c410"/' sysdig.nomad
$ nomad run sysdig.nomad
==> Monitoring evaluation "d3d8b3e3-c1ba-7594-8cd6-868e79bb1e2b"
    Evaluation triggered by job "sysdig"
    Allocation "2633-dc54-e4d1-72de554b74e6" created: node "4554-c487-cfe6", group "sysdig"
    Allocation "0797-ac22-8c20-30fb35b2b4d9" created: node "032d-c7b7-4533", group "sysdig"
    Allocation "a2e1-e3ca-ec97-80cb37ca4af2" created: node "1019-bb6e-ca3f", group "sysdig"
    Allocation "b9b1-8fe9-bcf2-427960bb9597" created: node "7082-2fbe-90b8", group "sysdig"
    Allocation "604b-089a-4e2b-64e4c6f5c103" created: node "8460-44f2-bc69", group "sysdig"
    Allocation "d0da-1966-109d-be2d2e7be4a8" created: node "ce49-f687-d42f", group "sysdig"
    Allocation "2f5e-6345-413d-99b04a4f0ed9" created: node "f3e3-acc5-e4d7", group "sysdig"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "d3d8b3e3-c1ba-7594-8cd6-868e79bb1e2b" finished with status "complete"
```

!SLIDE

# Auto discovery
- Uses Consul to expose services and works **without bootstrapping**
- Defined **inside the job description**
- **No external tools** such as Registrator needed

<br />
```
service {
  name = "${TASKGROUP}-helloworld-v1"
  tags = ["hello", "v1"]
  port = "http"
  check {
    type = "http"
    delay = "10s"
    timeout = "2s"
  }
}
```

!SLIDE

# Food

!SLIDE

# Recap

!SLIDE

# Resource management (Bastiaan)

!SLIDE

# Things don't always go well in real life

!SUB

# Decommissioning nodes
- node drain feature
```
call node drain in CLI
```

Example of a killed node in the docker farm:
```
root@bbakker-nomad-01:~# nomad node-status
ID        Datacenter  Name                  Class   Drain  Status
0b46eda1  dc1         bbakker-farm-01-jmja  docker  false  down
e1191817  dc1         bbakker-farm-02-1q3f  docker  false  ready
9b2e3f82  dc1         bbakker-farm-01-q1ll  docker  false  ready
ecabf2fa  dc1         bbakker-farm-01-6ys5  docker  false  ready
954b5b89  sys1        bbakker-nomad-01      system  false  ready
f99014c9  sys1        bbakker-nomad-02      system  false  ready
45b2d888  sys1        bbakker-nomad-03      system  false  ready
50f3d652  dc1         bbakker-farm-02-42x5  docker  false  ready
```

- Check if google/nomad automatically removed dead nodes after 24 hrs.

!SUB

# Client failures (Bastiaan)
- are jobs correctly transferred to other nodes?

!SUB

# Master failures (Bastiaan)
- can scheduling still continue?

!SUB

# Machine failures (Bastiaan)
- can scheduling still continue?
- are jobs correctly transferred to other nodes?

!SLIDE

# Review

!SLIDE

# Drinks
