# Nomad Open Kitchen environment
This is the environment that will be used to showcase [Nomad](https://www.nomadproject.io) in the [Xebia](https://www.xebia.com) Open Kitchen about [Managing Scalable Docker Container Platforms with Nomad](https://xebia.com/events/open-kitchen-managing-scalable-docker-container-platforms-with-nomad) on the 27th of January 2016.

The environment that is created on [Google Compute Engine](https://cloud.google.com/compute) contains:
* 3 Nomad server nodes.
* 2 Autoscaling groups for the Nomad client nodes.
* A network containing all the nodes belonging to the environment.
* Internal DNS for the Nomad servers. (e.g. nomad-01.stack.local)
* External DNS for the Nomad servers. (e.g. nomad-01.stack.gce.nauts.io)

## Getting started
Before we get started we need to load the modules that are used in this setup:
```
make get
```

To check what changes would be applied and view the plan:
```
make plan STACK=<name>
make show STACK=<name>
```

To create the environment:
```
make apply STACK=<name>
```

To view your stack or all stacks:
```
make list STACK=<name>
make list-all STACK=<name>
```

To refresh the state of the stack:
```
make refresh STACK=<name>
```

To destroy the environment:
```
make destroy STACK=<name>
```

## To view the presentation
Run the presenter binary corresponding to your operating system.
```
presenter.linux serve slides.md   // Linux
presenter.osx serve slides.md     // Mac OSX
presenter.exe serve slides.md     // Windows
```
