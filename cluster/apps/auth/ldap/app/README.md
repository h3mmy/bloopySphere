# glauth

Initial version yoinked from @onedr0p

## Debugging

kubectl run ephemeral-demo --image=registry.k8s.io/pause:3.1 --restart=Never

## Repo configuration

- (Optional) Add/Update `.vscode/extensions.json`

```json
    {
        "files.associations": {
            "**/kubernetes/**/*.sops.toml": "plaintext"
        }
    }
```

- (Optional) Add/Update `.gitattributes`

```text
    *.sops.toml linguist-language=JSON
```

- (Required) Add/Update `.sops.yaml`

```yaml
    - path_regex: kubernetes/.*\.sops\.toml
        key_groups:
        - age:
            - <PUBLIC_AGE_KEY>
```

## App Configuration

Below are some sample decrypted versions of the sops encrypted toml files.

> `passbcrypt` can be generated at https://gchq.github.io/CyberChef/#recipe=Bcrypt(12)To_Hex(%27None%27,0)

or via

> `htpasswd -bnBC 10 "" YOUR_PASSWORD | tr -d ':\n' | od -A n -t x1 | sed 's/ *//g' | tr -d '\n'`

- `server.sops.toml`

```toml
debug = true
[ldap]
    enabled = true
    listen = "0.0.0.0:389"
[ldaps]
    enabled = false
[api]
    enabled = true
    tls = false
    listen = "0.0.0.0:5555"
[backend]
    datastore = "config"
    baseDN = "dc=home,dc=arpa"
```

- `groups.sops.toml`

```toml
[[groups]]
    name = "svcaccts"
    gidnumber = 6500
[[groups]]
    name = "admins"
    gidnumber = 6501
[[groups]]
    name = "people"
    gidnumber = 6502
```

- `users.sops.toml`

```toml
[[users]]
    name = "search"
    uidnumber = 5000
    primarygroup = 6500
    passbcrypt = ""
    [[users.capabilities]]
        action = "search"
        object = "*"
[[users]]
    name = "h3mmy"
    mail = ""
    givenname = "Zee"
    sn = "Aslam"
    uidnumber = 5001
    primarygroup = 6502
    othergroups = [ 6501 ]
    passbcrypt = ""
