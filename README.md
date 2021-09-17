# rhcos-scan

A client for scanning a Red Hat CoreOS (RHCOS) instance for security vulnerabilities. 

## How it works

This client first determines which RPM Repositories where used to install RPMs into the RHCOS instance, it then maps those to OVAL files. Once the correct OVAL files are determined the client uses [openscap](https://github.com/OpenSCAP/openscap) to scan each RHCOS host for known vulnerabilies. If any of the RHCOS host fail a scan the whole scan is failed.

## Known Issues

This client does not provide remediation advise, instead it only determines if any RPMs installed on the RHCOS host have any known vulnerabilities. [Upgrade](https://docs.openshift.com/container-platform/4.8/updating/understanding-the-update-service.html) to the latest OpenShift Container Platform version in order to remediate any vulnerabilities found. Optionally enable over the air updates to keep the RHCOS instances up to date with security patches.

