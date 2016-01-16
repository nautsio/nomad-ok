# Nomad Open Kitchen environment
This is the environment that will be used in the Xebia Open Kitchen about "Managing Scalable Docker Container Platforms with Nomad" on the 27th of January 2016.

The environment that is created contains:
* 3 Nomad server nodes.
* 2 Autoscaling groups for the Nomad client nodes.
* A network containing all the nodes belonging to the environment.
* Internal DNS for the Nomad servers. (e.g. nomad-01.stack.local)
* External DNS for the Nomad servers. (e.g. nomad-01.stack.gce.nauts.io)

## Getting started
Before we get started we need to load the modules that are used in this setup.
```
make get
```

To check what changes would be applied, run make plan.
```
make plan STACK=<name>
```

To create the environment, run make apply.
```
make apply STACK=<name>
```

To destroy the environment, run make destroy.
```
make destroy STACK=<name>
```
