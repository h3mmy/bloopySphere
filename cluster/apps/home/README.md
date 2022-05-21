# Namespace: home

This namespace is intended to be for home oriented things including home-automation

Currently implementing:
* [zwavejs2mqtt](https://artifacthub.io/packages/helm/k8s-at-home/zwavejs2mqtt) for managing zwave devices. Uses websockets for home-assistant, but mqtt for other apps such as node-red.
* [ser2sock](https://artifacthub.io/packages/helm/k8s-at-home/ser2sock), for exposing zwave/zigbee adapters as tcp/ip resources. May move to [akri](https://github.com/project-akri/akri) in the future
* [network-ups-tools](https://networkupstools.org) for UPS monitoring
[emqx](https://www.emqx.io) for MQTT brokering

Note: Apps may be in use that aren't currently part of the cluster and this may seem confusing. Reach out with any questions via a 'Discussion' issue. I'm usually good about responding. If I don't, one of my robots will.
