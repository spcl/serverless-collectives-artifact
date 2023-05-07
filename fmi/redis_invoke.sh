#!/bin/bash
mkdir -p out/

#benchmarks=(reduce allreduce scan)
benchmarks=(allreduce bcast gather reduce scan scatter)
#benchmarks=(allreduce)
#benchmarks=(scan)
exp_peers=(2 4 8 16 32 64 128)
for peers in "${exp_peers[@]}"
do
    for benchmark in "${benchmarks[@]}"
    do
        ARRAY=()
        timestamp=$(date +%s)
        echo "$benchmark $timestamp"
        for peernum in $(seq 1 $peers);
            do
            peer_id=$(($peernum - 1))
            aws lambda invoke --region eu-central-1 --cli-read-timeout 600 --function-name smibenchmark_redis --cli-binary-format raw-in-base64-out --payload '{"timestamp": "'$timestamp'", "numPeers": '"$peers"', "peerID":'"$peer_id"', "benchmark":"'$benchmark'" }' "out_redis/${benchmark}_${peers}_$peer_id.json" > "out_redis/${benchmark}_${peers}_$peer_id.out" &
            PID=$!
            ARRAY+=($PID)
        done
        #sleep 600
        for i in "${ARRAY[@]}"; do

          echo "Wait $i"
          wait $i

        done
    done
done
