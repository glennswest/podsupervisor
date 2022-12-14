#!/bin/bash
pwd
whoami
echo $HOME
mkdir -p /tmp/nodestate
for i in {1..12}; do
  oc get nodes |  tail -n +2  >  /tmp/nodes.data
  input="/tmp/nodes.data"
  while IFS= read -r line
  #Example data
  #control-plane-0   Ready    master   27h   v1.20.10+bbbc079
  #worker-1          NotReady   worker   8d    v1.20.10+bbbc079

  do
    #echo "$line"
    nodename=`echo $line | cut -d' ' -f1`
    nodestate=`echo $line | cut -d' ' -f2`
    readystr='Ready'
    notreadystr="NotReady"
    #If prev node state does not exist assume it was ready
    if [ ! -f /tmp/nodestate/$nodename ]
      then
       echo $readystr > /tmp/nodestate/$nodename
       fi
    prevstate=`cat /tmp/nodestate/$nodename`
    if [[ "$prevstate" == *$notreadystr* ]]; then
      if [[ "$nodestate" == *$notreadystr* ]]; then
            echo "Cleaning up $nodename"
            ./podsuper-nodecleanup.sh $nodename
            fi
         fi
    # Save state so can check for flapping
    echo $nodestate > /tmp/nodestate/$nodename
  done < "$input"
  sleep 5
done



