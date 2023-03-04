# Synology NAS SNMP Exporter

[Synology MiB Guide (PDF)](https://global.synologydownload.com/download/Document/Software/DeveloperGuide/Firmware/DSM/All/enu/Synology_DiskStation_MIB_Guide.pdf)

I used a locally built copy of the generator and ran it against generator.yml to output snmp.yml. This is then converted to a configMap via kustomize and then mounted to the snmp-exporter pod.
