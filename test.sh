oc set env dc almighty-performance RATE=120 DURATION=30s
sleep 10
oc scale --replicas=1 dc almighty-performance
sleep 10
oc scale --replicas=0 dc almighty-performance

oc logs dc/almighty-performance --follow
