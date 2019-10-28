clear
x=1
while [ $x -le 2 ]
  do
    sudo curl -skn https://$(hostname -f):9200/_cluster/health?pretty
    sleep 2
    clear
    sudo curl -skn "https://$(hostname -f):9200/_cat/allocation?v&s=dp"
    sleep 5
    clear
    sudo curl -skn "https://$(hostname -f):9200/_cat/nodes?v&s=n"
    sleep 5
    clear
    sudo curl -skn "https://$(hostname -f):9200/_cat/fielddata?v&fields=_id"
    sleep 5
    clear
    sudo curl -skn https://$(hostname -f):9200/_tasks | jq -r '.nodes[].tasks[].action'
    sleep 2
    clear
#    sudo curl -skn https://$(hostname -f):9200/_cluster/settings?pretty\&flat_settings=true
#    sleep 2
#    clear
    #sudo curl -skn https://$(hostname -f):9200/_cat/recovery | grep -v 100.0
    echo -e "bytes_percent\tfiles_percent\tindex"
    echo -e "-------------\t-------------\t-----"
    sudo curl -skn GET "https://$(hostname -f):9200/_cat/recovery?active_only=true&s=bp" | awk '{print $18"\t\t"$14"\t\t"$1}'
    sleep 2
    clear
  done

# Notes:
#
# Commands to allow a rolling restart of services w/o the cluster trying to rebalance
# sudo curl -skn -XPUT -H 'Content-Type: application/json' https://$(hostname -f):9200/_cluster/settings -d '{ "transient" : { "cluster.routing.allocation.cluster_concurrent_rebalance" : 0}}';echo
# sudo curl -skn https://$(hostname -f):9200/_flush/synced

# Commands to shutdown the cluster (stops allocation completely)
# sudo curl -skn -XPUT -H 'Content-Type: application/json' https://$(hostname -f):9200/_cluster/settings -d '{ "transient" : { "cluster.routing.allocation.enable" : "none"}}';echo
# sudo curl -skn https://$(hostname -f):9200/_flush/synced
~                                                                
