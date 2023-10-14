# IAM Modules

## Keycloak

Assigning Roles

```text
There are many ways that roles can be assigned to manage Keycloak. Here are a couple of common scenarios accompanied by suggested roles to assign. This is not an exhaustive list, and there is often more than one way to assign a particular set of permissions.

    Managing the entire Keycloak instance: Assign the admin role to a user or service account within the master realm.
    Managing the entire foo realm: Assign the realm-admin client role from the realm-management client to a user or service account within the foo realm.
    Managing clients for all realms within the entire Keycloak instance: Assign the create-client client role from each of the realm clients to a user or service account within the master realm. For example, given a Keycloak instance with realms master, foo, and bar, assign the create-client client role from the clients master-realm, foo-realm, and bar-realm.
```

Client Credentials Grant Setup (recommended)

```text
    Create a new client using the openid-connect protocol. This client can be created in the master realm if you would like to manage your entire Keycloak instance, or in any other realm if you only want to manage that realm.
    Update the client you just created:
        Set Access Type to confidential.
        Set Standard Flow Enabled to OFF.
        Set Direct Access Grants Enabled to OFF
        Set Service Accounts Enabled to ON.
    Grant required roles for managing Keycloak via the Service Account Roles tab in the client you created in step 1
```
