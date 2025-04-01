#
<!-- markdownlint-disable-next-line -->
##
<!-- markdownlint-disable-next-line -->
<div align="center">

### A home Kubernetes cluster :sailboat

_... managed with Flux and Renovate_ :robot:

</div>
<!-- markdownlint-disable-next-line -->
<br/>
<!-- markdownlint-disable-next-line -->
<div align="center">

[![k3s](https://img.shields.io/badge/k3s-v1.30.1-brightgreen?style=for-the-badge&logo=kubernetes&logoColor=white)](https://k3s.io/)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=for-the-badge)](https://github.com/pre-commit/pre-commit)
[![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovatebot&logoColor=white)](https://github.com/renovatebot/renovate)

</div>
<!-- markdownlint-disable-next-line -->
<div align="center">

[![Mozilla HTTP Observatory Grade](https://img.shields.io/mozilla-observatory/grade-score/bloopnet.xyz?publish&style=for-the-badge)](https://observatory.mozilla.org/)
[![Uptime](https://img.shields.io/uptimerobot/ratio/m790142441-faed6f7043db9c588f5e949f?style=for-the-badge)](https://uptimerobot.com)
[![GitHub last commit](https://img.shields.io/github/last-commit/h3mmy/bloopySphere?style=for-the-badge)](https://github.com/h3mmy/bloopySphere/commits/main)

[![GitHub branch checks state](https://img.shields.io/github/checks-status/h3mmy/bloopySphere/main?style=for-the-badge)](https://github.com/h3mmy/bloopySphere/actions?query=branch%3Amain)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/h3mmy/bloopySphere/deploy-keycloak-theme.yaml?branch=main&label=Keycloak%20Theme&style=for-the-badge)](https://github.com/h3mmy/bloopySphere/actions/workflows/deploy-keycloak-theme.yaml)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/h3mmy/bloopysphere/Lint?label=Lint&style=for-the-badge)](https://github.com/h3mmy/bloopySphere/actions/workflows/lint.yaml)

![Snyk Vulnerabilities for GitHub Repo](https://img.shields.io/snyk/vulnerabilities/github/h3mmy/bloopysphere?style=for-the-badge)
</div>

---

## :book:&nbsp; Overview

This is my home Kubernetes cluster. [Flux](https://github.com/fluxcd/flux2) watches this Git repository and makes the changes to my cluster based on the manifests in the [cluster](./cluster/) directory.
 [Renovate](https://github.com/renovatebot/renovate) also watches this Git repository and creates pull requests when it finds updates to Docker images, Helm charts, and other dependencies.

~~For more information, head on over to my [docs](https://h3mmy.github.io/bloopySphere/).~~
I have nested README files that should be visible as you browse the repo.

My [Gitlab](https://gitlab.com/h3mmy) has more of my projects

## Useful Snippets

List of container images in use cluster-wide

`kubectl get pods --all-namespaces -o go-template --template="{{range .items}}{{range .spec.containers}}{{.image}} {{end}}{{end}}" | sed 's/ /\n/g' | uniq > ./container_images_in_use.txt`

List of container images in use that have arm64 images available (grep -q --> grep -vq for inversion)

`kubectl get po -A -o yaml | grep 'image:' | cut -f2- -d':' | sed 's/^[[:space:]]*//g' | grep '/' | sort -u | xargs -I{} bash -c "docker manifest inspect {} | grep -q arm64 && echo {}" > ./container_images_with_arm64.txt`

Snippet for nodeAffinity for non-ARM pods

`affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: "kubernetes.io/arch"
                operator: In
                values:
                  - amd64
                  - i386
                  - i686
                  - x86`

If using a node-taint for arm nodes[1], this will allow toleration

`tolerations:

- key: "arch"
  operator: "Equal"
  value: "arm64"
  effect: "NoSchedule"`

[1]While Bootstrapping: `--kubelet-extra-args` `--register-with-taints="kubernetes.io/arch=arm64:NoSchedule"`
Else: `kubectl taint no k8s-0 kubernetes.io/arch=arm64:NoSchedule`

Other useful snippets:
`kubectl label node k8s-0 node-role.kubernetes.io/worker=true`

`kubectl apply --kustomize=./cluster/base/flux-system`

`cat ~/.config/sops/age/keys.txt |
kubectl -n flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin`

`kubectl  create namespace flux-system --dry-run=client -o yaml | kubectl apply -f -`

`kubectl get secret db-user-pass -o json | jq '.data | map_values(@base64d)'`

Loki snippets. If you know you know.

```logql
{app="traefik"} | json message_extracted="message" |  line_format "{{.message_extracted}}" | json | DownstreamStatus!=`200`
```

```logql
{app="authentik"} | json message_extracted="message"| line_format "{{.message_extracted}}" | json level="level",timestamp="timestamp",event="event" | level=`error`
```

`kubectl get namespace "monitoring" -o json   | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/"   | kubectl replace --raw /api/v1/namespaces/monitoring/finalize -f -`


Publicly available DoH server lists



https://github.com/curl/curl/wiki/DNS-over-HTTPS#publicly-available-servers

https://cln.io/blog/combined-list-of-dns-servers/

https://github.com/Sekhan/TheGreatWall

https://github.com/crypt0rr/public-doh-servers/tree/main




## :handshake:&nbsp; Community

Thanks to all the people who donate their time to the [Kubernetes @Home](https://github.com/k8s-at-home/) community.
