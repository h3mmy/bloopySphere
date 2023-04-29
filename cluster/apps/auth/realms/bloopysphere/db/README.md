# Database

For this instance I am using [cloudnative-pg](https://github.com/cloudnative-pg/cloudnative-pg) for the postgres database. The backing storage will just be `local-path` as it is kind of wasteful to use ceph for backing storage since the cnpg operator will be replicating it anyway.

 Backups will be done into a ceph-rgw object-store. For this an `ObjectBucketClaim` is created. The `rook-ceph-operator` will provision the bucket and then add a configMap and secret to the bucket namespace which will contain credentials that can be used by the backup process. See [ObjectBucketClaim Documentation](https://rook.io/docs/rook/v1.9/Storage-Configuration/Object-Storage-RGW/ceph-object-bucket-claim/)
