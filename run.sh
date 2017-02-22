vegeta attack --duration ${DURATION} --rate ${RATE} --targets targets > result.bin
vegeta report -inputs result.bin
vegeta report -inputs result.bin -reporter='hist[0,20ms,40ms,60ms,100ms,200ms,1s,2s,3s]'