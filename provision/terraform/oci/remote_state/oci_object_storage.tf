resource "oci_objectstorage_object" "remote_state_bucket" {
    #Required
    bucket = var.object_bucket
    content = var.object_content
    namespace = var.object_namespace
    object = var.object_object

    #Optional
    cache_control = var.object_cache_control
    content_disposition = var.object_content_disposition
    content_encoding = var.object_content_encoding
    content_language = var.object_content_language
    content_type = var.object_content_type
    delete_all_object_versions = var.object_delete_all_object_versions
    metadata = var.object_metadata
    storage_tier = var.object_storage_tier
    opc_sse_kms_key_id = var.object_opc_sse_kms_key_id
}
