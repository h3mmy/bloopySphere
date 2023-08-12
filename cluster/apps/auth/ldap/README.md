# LDAP

## Manual Steps

UI login failed. Tried various things troubleshooting. This is what worked:

- `kubectl -n auth scale --replicas=0 deploy lldap`
- `kubectl -n auth exec -it po/lldap-postgres-1 -- /bin/sh`
- `psql -U postgres`
- `\connect lldap`
- `delete from users;`
- `\q`
- `exit`
- `kubectl -n auth scale --replicas=0 deploy lldap`
- Attempted login worked!

Next I proceeded with configuration

- Create workload-service-account for keycloak via lldap UI
