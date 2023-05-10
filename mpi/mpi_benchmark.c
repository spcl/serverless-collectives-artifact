#include <mpi.h>
#include <stdio.h>
#include <sys/time.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

unsigned long get_time_in_microseconds() {
    struct timeval tv;
    gettimeofday(&tv,NULL);
    return 1000000 * tv.tv_sec + tv.tv_usec;
}

void bcast_benchmark(int bcast_value) {
    int bcast_result;
    MPI_Bcast(&bcast_result, 1, MPI_INT, 0, MPI_COMM_WORLD);
}

void gather_benchmark(void* send_buf, int send_count, void* recv_buf, int recv_count) {
    MPI_Gather(send_buf, send_count, MPI_INT, recv_buf, recv_count, MPI_INT, 0, MPI_COMM_WORLD);
}

void scatter_benchmark(void* send_buf, int send_count, void* recv_buf, int recv_count) {
    MPI_Scatter(send_buf, send_count, MPI_INT, recv_buf, recv_count, MPI_INT, 0, MPI_COMM_WORLD);
}

void reduce_benchmark(int red_value) {
    int reduction_result;
    MPI_Reduce(&red_value, &reduction_result, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
}

void allreduce_benchmark(int red_value) {
    int reduction_result;
    MPI_Allreduce(&red_value, &reduction_result, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
}

void scan_benchmark(int red_value) {
    int reduction_result;
    MPI_Scan(&red_value, &reduction_result, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
}

int main(int argc, char** argv) {
    MPI_Init(NULL, NULL);

    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    char host[64];
    int ret = gethostname(host, 64);
    printf("%d %d %s\n", world_size, world_rank, host);

    int reps = 1001;
    long long int* results = malloc(sizeof(long long int)*(reps * 3));

    for (int i = 0; i < reps; i++) {
        unsigned long bef, after;
        MPI_Barrier(MPI_COMM_WORLD);
        if (strcmp(argv[1], "bcast") == 0) {
            bef = get_time_in_microseconds();
            bcast_benchmark(world_rank + 1);
            after = get_time_in_microseconds();
        } else if (strcmp(argv[1], "gather") == 0) {
            long recv_size = 5000;
            long individual_size = recv_size / world_size;
            int* buffer = malloc(individual_size * sizeof(int));
            void * recv_buffer;
            if (world_rank == 0)
                recv_buffer = malloc(recv_size * sizeof(int));
            bef = get_time_in_microseconds();
            gather_benchmark(buffer, individual_size, recv_buffer, individual_size);
            after = get_time_in_microseconds();
            free(buffer);
            if (world_rank == 0)
                free(recv_buffer);
        } else if (strcmp(argv[1], "scatter") == 0) {
            long send_size = 5000;
            long individual_size = send_size / world_size;
            int* buffer;
            if (world_rank == 0)
                buffer = malloc(send_size * sizeof(int));
            int* recv_buffer = malloc(individual_size * sizeof(int));
            bef = get_time_in_microseconds();
            scatter_benchmark(buffer, individual_size, recv_buffer, individual_size);
            after = get_time_in_microseconds();
            free(recv_buffer);
            if (world_rank == 0)
                free(buffer);
        } else if (strcmp(argv[1], "reduce") == 0) {
            bef = get_time_in_microseconds();
            reduce_benchmark(world_rank + 1);
            after = get_time_in_microseconds();
        } else if (strcmp(argv[1], "allreduce") == 0) {
            bef = get_time_in_microseconds();
            allreduce_benchmark(world_rank + 1);
            after = get_time_in_microseconds();
        } else if (strcmp(argv[1], "scan") == 0) {
            bef = get_time_in_microseconds();
            scan_benchmark(world_rank + 1);
            after = get_time_in_microseconds();
        }

        //if (i > 0) {
        //    if (world_rank == 0) {
        //        if (strcmp(argv[1], "gather") == 0) {
        //            printf("%d,%d,%lu\n", world_rank, i, after);
        //        } else {
        //            printf("%d,%d,%lu\n", world_rank, i, bef);
        //        }
        //    } else {
        //        if (strcmp(argv[1], "gather") == 0) {
        //            printf("%d,%d,%lu\n", world_rank, i, bef);
        //        } else {
        //            printf("%d,%d,%lu\n", world_rank, i, after);
        //        }
        //    }
        //}
	results[i*3] = bef;
	results[i*3+1] = after;
	results[i*3+2] = after - bef;
    }

    int max_len = 128;
    char buf[max_len];
    snprintf(buf, max_len, "res/%s_%d_%d.out", argv[1], world_size, world_rank);
    FILE* file = fopen(buf, "w");
    for (int i = 0; i < reps; i++) {
	    fprintf(file, "%lld,%lld,%lld\n", results[i*3], results[i*3+1], results[i*3+2]);
    }
    fclose(file);
    free(results);
    

    MPI_Finalize();
}


