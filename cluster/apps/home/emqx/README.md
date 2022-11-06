# Helm Release

I've switched away from using the emqx operator due to it not correctly mutating the CRD from v1beta2 to v1beta3. I didn't have the patience to dive in and fix it. I've been busy.

## Notes

* Ingresses are defined in [cluster/apps/networking/traefik/routers/home-emqx.yaml](https://github.com/h3mmy/bloopysphere/blob/main/cluster/apps/networking/traefik/routers/home-emqx.yaml)

---
For posterity here are notes from when I was using the operator for people who want a reference. I'll leave the CRD here but disabled. I've removed the operator yamls.

## EMQX Broker

Depends on `/cluster/core/emqx-operator` as management of CRDS is delegated to it. See [emqx/emqx-operator](https://github.com/emqx/emqx-operator).

Reference for the EmqxBroker can be found [here](https://github.com/emqx/emqx-operator/tree/main/docs/en_US/reference)

### Configuration

[Reference](https://www.emqx.io/docs/en/v4.4/configuration/configuration.html)

By default, EMQX maps environment variables with prefix `EMQX_` to key-value pairs in configuration files.

Mapping rules from environment variable name to config key

* Prefix `EMQX_` is removed
* Upper case letters are mapped to lower case letters
* Double underscore `__` is mapped to `.`

### Authentication

I am using "password_based" authentication via postgresql (See [Documentation](https://www.emqx.io/docs/en/v5.0/security/authn/postgresql.html)). I strongly prefer not having a scattering of auth methods and once I have keycloak revamped and re-enabled I'll be using that. Authentik lacks the amount of customization I need. Theoretically, you can have a sops file with a user list, and have a job with a short postgres script to keep it in sync with the db.

The "Authentication Query" is qhat emqx uses to get the users

```sql
SELECT password_hash, salt, is_superuser FROM users where username = ${username} LIMIT 1
```

To "Add" a new user, the query would look like this. Note this is using a sha256 hash, whereas I personally am using bcrypt

```sql
INSERT INTO mqtt_user(username, password_hash, salt, is_superuser) VALUES ('user123', 'bede90386d450cea8b77b822f8887065e4e5abf132c2f9dccfcc7fbd4cba5e35', 'salt', true);
```

You can do this manually, or set up a job to reconcile against a sops file, or other automation. I haven't settled on a preferred approach yet. I've been busy. If you want to try something, feel free to tag me in a discussion, or PR.
