# Routers

I initially wanted to use an IngressRoute to leverage some extra perks. However, k8s_gateway does not pick up IngressRoutes and thus hairpins traffic. This is not desirable for an IAM service. Hence the addition of the Ingress.

The IngressRoute is currently only for reference.
