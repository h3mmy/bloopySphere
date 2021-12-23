<div align="center">

<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="center" width="144px" height="144px"/>

### A home Kubernetes cluster :sailboat:

_... managed with Flux and Renovate_ :robot:

</div>

<br/>

<div align="center">

[![k3s](https://img.shields.io/badge/k3s-v1.22.5-brightgreen?style=for-the-badge&logo=kubernetes&logoColor=white)](https://k3s.io/)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=for-the-badge)](https://github.com/pre-commit/pre-commit)
[![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovatebot&logoColor=white)](https://github.com/renovatebot/renovate)


</div>

<div align="center">

[![Mozilla HTTP Observatory Grade](https://img.shields.io/mozilla-observatory/grade-score/bloopnet.xyz?publish&style=for-the-badge)]()

[![GitHub last commit](https://img.shields.io/github/last-commit/h3mmy/bloopySphere?style=for-the-badge)]()

[![GitHub branch checks state](https://img.shields.io/github/checks-status/h3mmy/bloopySphere/main?style=flat-square)]()

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/h3mmy/bloopySphere/Deploy%20Keycloak%20Theme%20to%20GHCR?label=Keycloak%20Theme&style=for-the-badge)]()


</div>

---

## :book:&nbsp; Overview

This is my home Kubernetes cluster. [Flux](https://github.com/fluxcd/flux2) watches this Git repository and makes the changes to my cluster based on the manifests in the [cluster](./cluster/) directory. [Renovate](https://github.com/renovatebot/renovate) also watches this Git repository and creates pull requests when it finds updates to Docker images, Helm charts, and other dependencies.

For more information, head on over to my [docs](https://h3mmy.github.io/bloopySphere/).

## :handshake:&nbsp; Community

Thanks to all the people who donate their time to the [Kubernetes @Home](https://github.com/k8s-at-home/) community.
