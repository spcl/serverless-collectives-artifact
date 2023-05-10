#!/bin/bash
mkdir -p out/

#benchmark=$1
#benchmarks=($benchmark)
#benchmarks=(reduce allreduce scan)
benchmarks=(allreduce bcast gather reduce scan scatter)
#benchmarks=(scan scatter)
#benchmarks=(allreduce)
#benchmarks=(scan)
#exp_peers=(2 4 8 16 32)
#exp_peers=(64 128)
exp_peers=(128 256)
for peers in "${exp_peers[@]}"
do
    for benchmark in "${benchmarks[@]}"
    do
        #for rep in {1..30}; do
        for rep in {1..30}; do
          ssh -i ~/polybox/work/Resources/keys/aws-ec2-europe-central.pem ubuntu@3.66.218.227 "cd /home/ubuntu/TCPunchorig/server/build_dbg && ./tcpunchd 10000 > out.log 2> err.log &"
          ARRAY=()
          timestamp=$(date +%s)
          echo "$benchmark $timestamp $rep"
          for peernum in $(seq 1 $peers);
              do
              peer_id=$(($peernum - 1))
              #aws lambda invoke --region eu-central-1 --cli-read-timeout 600 --function-name smibenchmark_tcp --cli-binary-format raw-in-base64-out --payload '{"reps": 30, "timestamp": "'$timestamp'", "numPeers": '"$peers"', "peerID":'"$peer_id"', "benchmark":"'$benchmark'" }' "out_s3/${benchmark}_${peers}_$peer_id.json" > "out_tcp/${benchmark}_${peers}_$peer_id.out" &
              aws lambda invoke --region eu-central-1 --cli-read-timeout 600 --function-name smibenchmark_tcp --cli-binary-format raw-in-base64-out --payload '{"reps": 2, "timestamp": "'$timestamp'", "numPeers": '"$peers"', "peerID":'"$peer_id"', "benchmark":"'$benchmark'" }' "out_tcp/${benchmark}_${peers}_${peer_id}_${rep}.json" > "out_tcp/${benchmark}_${peers}_${peer_id}_${rep}.out" &
              PID=$!
              ARRAY+=($PID)
          done
          #sleep 600
          for i in "${ARRAY[@]}"; do

            echo "Wait $i"
            wait $i

          done
          ssh -i ~/polybox/work/Resources/keys/aws-ec2-europe-central.pem ubuntu@3.66.218.227 "killall tcpunchd"
        done
    done
done
