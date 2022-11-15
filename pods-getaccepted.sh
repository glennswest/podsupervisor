rm /tmp/pods-selected.data
touch /tmp/pods-selected.data
input="selected.data"
  while IFS= read -r line
    #echo "$line"
    podwildcard=`echo $line | cut -d' ' -f1`
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




