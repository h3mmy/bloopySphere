This is a basic layout for my cluster files
```
.
└── cluster/
    ├── apps/
    |   └── ...
    ├── base/
    |   ├── flux-system/
    |   |   ├── charts/
    |   |   ├── git-repos/
    |   |   └── ...
    |   └── ...
    ├── core/
    |   ├── namespaces/
    |   └── ...
    └── crds/
        └── ...
```
The apps/ dir contains all the apps in the cluster. I have them striated by namespace.
The base/ dir contains the flux-system and kustomize 'roots' so to speak. This is what 'drives' the gitops of the cluster.
The core/ dir contains all resources that are prerequisites to namespaces and workloads.
The crds/ dir contains ...well CRDS for various things that need to be indepently defined but don't exactly belong in the other categories. Some people just add this as part of core/ which is also valid.

Note: Each subfolder has it's own root kustomization.yaml which aren't strictly necessary as you can configure kustomize to work without them. I like having them because it makes it super easy to enable/disable entire subfolders on the fly.
