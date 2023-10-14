resource "keycloak_group" "realm_groups" {
  for_each = {
    for group in var.user_groups : group.name => group
    if group.parent_group == null
    }

  realm_id  = keycloak_realm.bloopnet.id
  name      = each.value.name
  attributes = {for k,v in each.value.attributes: k => join("##", v)}

  depends_on = [keycloak_realm.bloopnet]
}

resource "keycloak_group" "realm_subgroups" {
  for_each = {
    for group in var.user_groups : group.name => group
    if group.parent_group != null
    }

  realm_id  = keycloak_realm.bloopnet.id
  name      = each.value.name
  parent_id = keycloak_group.realm_groups[each.value.parent_group].id
  attributes = {for k,v in each.value.attributes: k => join("##", v)}

  depends_on = [keycloak_realm.bloopnet, keycloak_group.realm_groups]
}

resource "keycloak_group_roles" "group_roles" {
  for_each = { for group in var.user_groups : group.name => group}

  realm_id = keycloak_realm.bloopnet.id
  group_id = each.value.name
  role_ids = each.value.realm_roles
}
