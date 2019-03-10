createPV.sh script for creating a pv on quicklab env.

IMPORTANT (before you start)
0)insure quicklab_cloud_key.pem is setup as expected

1)update nfs-pv1.yaml and nfs-pv2.yaml with correct INFRA_HOST IP (REPLACE_WITH_INFRA_HOST_IP)

2)export correct hostname for INFRA and MASTER hosts
export INFRA_HOST=XXXX
export MASTER_HOST=XXXX


Run "./createpv.sh" to create a PV. This will create the nfs mount and the PV objects in openshift.

Run "oc create -f pvc-claim1.yaml" to create a claim object that will be bound to one of the PV(s)

Run "oc volume dc/mysimplejavaexample --add --name=v1 --mount-path=/opt/etc --type=persistentVolumeClaim --claim-name=claim1" to add the claim1 object to an existing deployment config.
