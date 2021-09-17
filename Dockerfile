FROM quay.io/compliance-operator/openscap-ocp

LABEL \
    name="rhcos-scan" \
    run="podman run --privileged -v /:/host run.sh" \
    io.k8s.display-name="OpenSCAP container for OCP4 node vulnerability scans" \
    io.k8s.description="OVAL security scanner for scanning hosts through a host mount"

RUN true \
    && microdnf install -y bzip2 \
    && microdnf clean all \
    && true

COPY run.sh /opt

WORKDIR /opt

ENTRYPOINT ./run.sh
