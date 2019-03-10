#!/bin/bash

#export INFRA_HOST=infra-0.amq1ocp.quicklab.pnq2.cee.redhat.com
#export MASTER_HOST=master-0.amq1ocp.quicklab.pnq2.cee.redhat.com

echo "using INFRA_HOST $INFRA_HOST"
echo "using MASTER_HOST $MASTER_HOST"


ssh -i ~/.ssh/quicklab_cloud_key.pem -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" quicklab@$INFRA_HOST

#create a directory for the pv(s)
sudo mkdir -p /home/data/pv0001
sudo mkdir -p /home/data/pv0002

sudo chmod -R 777 /home/data/

#add to exports file
sudo echo "/home/data/pv0001 *(rw,sync)" >> /etc/exports
sudo echo "/home/data/pv0002 *(rw,sync)" >> /etc/exports

echo "created entries in export file"
# Enable the new exports without bouncing the NFS service
sudo exportfs -a


#By default, SELinux does not allow writing from a pod to a remote NFS server. The NFS volume mounts correctly, but is read-only.
#To enable writing in SELinux on each node:
# -P makes the bool persistent between reboots.
sudo setsebool -P virt_use_nfs 1
sudo service nfs start
sudo chkconfig nfs on

# disable firewall
sudo iptables -F
sudo service iptables save
echo "done security section"

#back to local shell
exit

#copy up yaml file to
scp -i ~/.ssh/quicklab_cloud_key.pem -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" nfs-pv1.yaml quicklab@$MASTER_HOST:/home/quicklab
scp -i ~/.ssh/quicklab_cloud_key.pem -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" nfs-pv2.yaml quicklab@$MASTER_HOST:/home/quicklab

echo "copied pv yaml files to master"

#log in to master
ssh -i ~/.ssh/quicklab_cloud_key.pem -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" quicklab@$MASTER_HOST
oc login -u system:admin

# create the pv object in openshift
oc create -f nfs-pv1.yaml
oc create -f nfs-pv2.yaml

# list pv object
oc get pv
