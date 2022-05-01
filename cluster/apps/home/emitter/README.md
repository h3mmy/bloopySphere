# Emitter
[Project Page](https://github.com/emitter-io/emitter)

## Warning
This is an experiment. I am working on an incubator chart for this. I have a lot on my plate so this will take a while. In the meantime this is to get acquainted with the functionality.

## Notes
- Deploys as a Stateful Set
- Requires a license, which can be generated. I allowed it to autogenerate on first launch attempt and then copied it in manually after. This can be automated. Additionally the emitter.conf file can be mounted via configMap or other medium with described parameters. There is also an option to override via HashiCorp Vault
- Repo has Dockerfile. lacks ARM image. Need to figure out how to 'patch' it for kah/container-images. My ARM node is already tainted with NoSchedule so I will simply ignore adding any tolerations here
