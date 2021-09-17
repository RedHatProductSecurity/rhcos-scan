#/bin/bash
source /host/usr/lib/os-release
echo "RHEL_VERSION: $RHEL_VERSION"
echo "OPENSHIFT_VERSION: $OPENSHIFT_VERSION"

curl "https://www.redhat.com/security/data/oval/v2/RHEL8/openshift-$OPENSHIFT_VERION.oval.xml.bz2" -o "openshift.oval.xml.bz2" -s
curl "https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-$RHEL_VERION-eus.oval.xml.bz2" -o "rhel-eus.oval.xml.bz2" -s

bzip2 -d *.oval.xml.bz2

cat openshift.oval.xml rhel-eus.oval.xml > rhcos.oval.xml

oscap-chroot /host oval eval rhcos.oval.xml
