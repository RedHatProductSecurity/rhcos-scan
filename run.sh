#/bin/bash
source /host/usr/lib/os-release

if [ -z "${RHEL_VERSION}" -o -z "$OPENSHIFT_VERSION" ]; then
  echo "RHEL_VERSION or OPENSHIFT_VERSION not set in /usr/lib/os-release"
  exit 1
fi

echo "RHEL_VERSION: $RHEL_VERSION"
echo "OPENSHIFT_VERSION: $OPENSHIFT_VERSION"

if [ "$RHEL_VERSION" = 8.3 ]; then
  echo "OCP versions 4.7 before 4.7.24 used an unreleased version of RHEL-eus (8.3)."
  exit 1
fi

curl "https://www.redhat.com/security/data/oval/v2/RHEL8/openshift-$OPENSHIFT_VERSION.oval.xml.bz2" -o "openshift.oval.xml.bz2" -s
curl "https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-$RHEL_VERSION-eus.oval.xml.bz2" -o "rhel-eus.oval.xml.bz2" -s

bzip2 -d *.oval.xml.bz2

oscap-chroot /host oval eval --report "openshift-$OPENSHIFT_VERSION.html" openshift.oval.xml
oscap-chroot /host oval eval --report "rhel-eus-$RHEL_VERSION.html" rhel-eus.oval.xml
