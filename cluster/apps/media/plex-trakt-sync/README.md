# Plex Trakt Sync

Project page [Github](https://github.com/Taxel/PlexTraktSync)

_Yes the config file has to be `.yml` and not `.yaml`_ 🤷🏽‍♀️

There is no way to authenticate declaritively and the codeowner seems resistant to add any non-interactive method. So you need to manually exec into the container for this to be useful and it defeats the purpose a bit.

To run manual login, scale the deployment to zero and run this. Replace values with ones appropriate for your specific deployment

```bash
kubectl -n media run -it --rm --image=ghcr.io/taxel/plextraktsync:latest --overrides='{"spec": {"volumes": [{"name": "config", "persistentVolumeClaim": {"claimName": "plex-trakt-sync-config-v1"}},{"name": "config-yaml", "configMap": {"name": "plex-tract-sync-configmap"}}],"containers": [{"name": "app", "stdin": true, "tty": true,"image": "ghcr.io/taxel/plextraktsync:latest","volumeMounts": [{"name": "config", "mountPath": "/app/config"},{"name": "config-yaml", "mountPath": "/app/config/config.yml","subPath": "config.yml", "readOnly": true}]}]}}' plextraktsync-manual -- login
```
