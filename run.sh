#/bin/bash
source /host/usr/lib/os-release
echo "RHEL_VERSION: $RHEL_VERSION"
echo "OPENSHIFT_VERSION: $OPENSHIFT_VERSION"

curl "https://www.redhat.com/security/data/oval/v2/RHEL8/openshift-$OPENSHIFT_VERION.oval.xml.bz2" -o "openshift.oval.xml.bz2" -s
curl "https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-$RHEL_VERSION-eus.oval.xml.bz2" -o "rhel-eus.oval.xml.bz2" -s

bzip2 -d *.oval.xml.bz2

# Add all the relevant OVAL content from the openshift OVAL file into the rhel-eus one and save it as rhcos.oval.xml
cat rhel-eus.oval.xml | xmlstarlet edit -N x="http://oval.mitre.org/XMLSchema/oval-definitions-5" \
 --subnode '//x:definitions' --type text -n '' --value "$(xmlstarlet sel -N x='http://oval.mitre.org/XMLSchema/oval-definitions-5' -t -c '//x:definitions/*' openshift.oval.xml)" \
 --subnode '//x:objects' --type text -n '' --value "$(xmlstarlet sel -N x='http://oval.mitre.org/XMLSchema/oval-definitions-5' -t -c '//x:objects/*' openshift.oval.xml)" \
 --subnode '//x:states' --type text -n '' --value "$(xmlstarlet sel -N x='http://oval.mitre.org/XMLSchema/oval-definitions-5' -t -c '//x:states/*' openshift.oval.xml)" \
 --subnode '//x:states' --type text -n '' --value "$(xmlstarlet sel -N x='http://oval.mitre.org/XMLSchema/oval-definitions-5' -t -c '//x:states/*' openshift.oval.xml)" \
 | xmlstarlet unescape > rhcos.oval.xml

oscap-chroot /host oval eval rhcos.oval.xml
