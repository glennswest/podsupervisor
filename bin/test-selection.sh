oc get pod --all-namespaces -o wide | tail -n +2  >  /tmp/pods.data
rm /tmp/pods-selected.data
touch /tmp/pods-selected.data
./podsuper-getaccepted.sh
./podsuper-denypods.sh
cat /tmp/pods-selected.data
