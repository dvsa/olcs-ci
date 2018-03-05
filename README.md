Jenkins Configuration and scripts
---------------------------------

Key Inspector
-------------

Requires that the submodule for gt-secrets is initialized and updated. This can be done by a recursive clone:
```
git clone git@repo.shd.ci.nonprod.dvsa.aws:olcs/olcs-ci.git --recursive
```

Or, for an existing clone, with the following commands:

```
git submodule init
git submodule update 
```
