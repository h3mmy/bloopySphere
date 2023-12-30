# Grafana Notifier

This is making use of the [flux-grafana-provider](https://fluxcd.io/docs/components/notification/provider/#grafana)

I was working on a script to generate a token dynamically but ran out of time so I made one manually since I still have persistence enabled for grafana. I will not be able to make it ephemeral again until this is sorted.

Since #4108 I am using keycloak for Grafana authentication. This is kaput until I adjust this workload to get credentials from keycloak and use that to authenticate with grafana. Should be much easier than dealing with grafana persistence. Can keep it ephemeral now
