#include <iostream>
#include <sys/time.h>
#include <Communicator.h>
#include <cstdlib>

#include <thread>
#include <chrono>

#include <mpi.h>


unsigned long get_time_in_microseconds() {
    struct timeval tv;
    gettimeofday(&tv,NULL);
    return 1000000 * tv.tv_sec + tv.tv_usec;
}

void bcast_benchmark(FMI::Comm::Data<int>& data, FMI::Communicator& comm) {
    comm.bcast(data, 0);
}

void gather_benchmark(FMI::Comm::Data<std::vector<int>>& sendbuf, FMI::Comm::Data<std::vector<int>>& recvbuf, FMI::Communicator& comm) {
    comm.gather(sendbuf, recvbuf, 0);
}

void scatter_benchmark(FMI::Comm::Data<std::vector<int>>& sendbuf, FMI::Comm::Data<std::vector<int>>& recvbuf, FMI::Communicator& comm) {
    comm.scatter(sendbuf, recvbuf, 0);
}

void reduce_benchmark(FMI::Comm::Data<int>& data, FMI::Communicator& comm) {
    FMI::Comm::Data<int> res;
    FMI::Utils::Function<int> f([] (auto a, auto b) {return a + b;}, true, true);
    comm.reduce(data, res, 0, f);
}

void allreduce_benchmark(FMI::Comm::Data<int>& data, FMI::Communicator& comm) {
    FMI::Comm::Data<int> res;
    FMI::Utils::Function<int> f([] (auto a, auto b) {return a + b;}, true, true);
    comm.allreduce(data, res, f);
}

void scan_benchmark(FMI::Comm::Data<int>& data, FMI::Communicator& comm) {
    FMI::Comm::Data<int> res;
    FMI::Utils::Function<int> f([] (auto a, auto b) {return a + b;}, true, true);
    comm.scan(data, res, f);
}

int main(int argc, char** argv) {
    std::string benchmark(argv[1]);
    int num_peers = std::stoi(std::getenv("OMPI_COMM_WORLD_SIZE"));
    int peer_id = std::stoi(std::getenv("OMPI_COMM_WORLD_RANK"));

    MPI_Init(&argc, &argv);
    FMI::Communicator comm(peer_id, num_peers, "smi.json", "SMITest", 512);
    
    char host[64];
    int ret = gethostname(host, 64);
    printf("%d %d %s\n", num_peers, peer_id, host);

    int reps = 1001;
    long long int* results = new long long int[reps * 3];

    for (int i = 0; i < reps; i++) {
        unsigned long bef, after;
        //comm.barrier();
	MPI_Barrier(MPI_COMM_WORLD);
        if (benchmark == "bcast") {
            FMI::Comm::Data<int> data = peer_id + 1;
            bef = get_time_in_microseconds();
            bcast_benchmark(data, comm);
            after = get_time_in_microseconds();
        } else if (benchmark == "gather") {
            long recv_size = 5000;
            long individual_size = recv_size / num_peers;
            FMI::Comm::Data<std::vector<int>> recv(recv_size);
            FMI::Comm::Data<std::vector<int>> send(individual_size);
            bef = get_time_in_microseconds();
            gather_benchmark(send, recv, comm);
            after = get_time_in_microseconds();
        } else if (benchmark == "scatter") {
            long send_size = 5000;
            //long send_size = 4992;
            //long send_size = 496;
            long individual_size = send_size / num_peers;
            FMI::Comm::Data<std::vector<int>> recv(individual_size);
            FMI::Comm::Data<std::vector<int>> send(send_size);
            bef = get_time_in_microseconds();
            scatter_benchmark(send, recv, comm);
            after = get_time_in_microseconds();
        } else if (benchmark == "reduce") {
            FMI::Comm::Data<int> data = peer_id + 1;
            bef = get_time_in_microseconds();
            reduce_benchmark(data, comm);
            after = get_time_in_microseconds();
        } else if (benchmark == "allreduce") {
            FMI::Comm::Data<int> data = peer_id + 1;
            bef = get_time_in_microseconds();
            allreduce_benchmark(data, comm);
            after = get_time_in_microseconds();
        } else if (benchmark == "scan") {
            FMI::Comm::Data<int> data = peer_id + 1;
            bef = get_time_in_microseconds();
            scan_benchmark(data, comm);
            after = get_time_in_microseconds();
        }
	//std::this_thread::sleep_for(std::chrono::milliseconds(500));
	results[i*3] = bef;
	results[i*3+1] = after;
	results[i*3+2] = after - bef;
        
    }
    int max_len = 128;
    char buf[max_len];
    snprintf(buf, max_len, "res/%s_%d_%d.out", argv[1], num_peers, peer_id);
    FILE* file = fopen(buf, "w");
    for (int i = 0; i < reps; i++) {
	    fprintf(file, "%lld,%lld,%lld\n", results[i*3], results[i*3+1], results[i*3+2]);
    }
    fclose(file);

    MPI_Finalize();
    delete[] results;
}


