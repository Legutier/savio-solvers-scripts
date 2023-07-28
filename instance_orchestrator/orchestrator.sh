#!/bin/bash
# Job name:
#SBATCH --job-name=roundingsat-batch-run
#
# Account:
#SBATCH --account=fc_neuronident
#
# Partition:
#SBATCH --partition=savio
#
# Wall clock limit:
#SBATCH --time=30:00
#
# Specific amount of nodes
#SBATCH --nodes=1
# Ensure running parallel by processor-level
#SBATCH --exclusive
############################################
# ARGUMENTS
file_relative_path=$1
seconds_per_solution=$2
max_jobs=$3
runner=$4
module load gnu-parallel/2019.03.22
function run_instances() {
    # DEPRECATED
    max_jobs=2
    echo "jobs running: $(jobs -pr | wc -l)"
    for i in {0..2}; do
	echo "jobs running: $(jobs -pr | wc -l)"
        while (( $(jobs -pr | wc -l) >= max_jobs )); do
	    echo "max jobs running: $(jobs -pr | wc -l)"
	    echo "$(jobs -r)"
            sleep 0.1
        done
	echo "$(jobs -l)"
	echo "jobs running: $(jobs -pr | wc -l)"
        srun --time=00:00:10  --cpu-bind=sockets ./instance_runner.sh roundingsat $i &
	sleep 1
    done
    wait
}

function run_instances_v2() {
	file_rel_path=$1
	scratch_path=$(pwd -P)
	find "${scratch_path}/$file_rel_path" -name "*.opb" -maxdepth 1 -exec readlink -f {} \; |
		parallel \
		--timeout $seconds_per_solution \
		--jobs $max_jobs timeout -s SIGTERM 3600 ${scratch_path}/$runner ${scratch_path}/solver_roundingsat
}

run_instances_v2 $file_relative_path
