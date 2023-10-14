resource "keycloak_role" "realm_base_roles" {
  for_each = {
    for role in var.realm_roles: role.name => role
    if role.composites == null
    }

  realm_id = keycloak_realm.bloopnet.id
  name = each.value.name
  description = each.value.description
  attributes = each.value.attributes
}
