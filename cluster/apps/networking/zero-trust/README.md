# Zero Trust

Based on [this](https://blog.cloudflare.com/kubectl-with-zero-trust/)

Secret creds.json should be formatted like so

```json
{AccountTag: $accountTag, TunnelID: $tunnelID, TunnelName: $tunnelName, TunnelSecret: $tunnelSecret}
```

Note: AccountTag is your Account ID.

Helm-Release is a draft, untested and disabled. Using it as-is will probably not work
