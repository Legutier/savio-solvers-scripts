#!/bin/bash

folder=$1
absolute_path=$(pwd -P)
slurm_files=$(find "$absolute_path/$folder" -maxdepth 1 -name "slurm*.out" -exec readlink -f {} \;)
file_count=$(echo "$slurm_files" | wc -l)
echo "Slurm files: $file_count"
touch results.csv
echo "name,total_pagerank_time,max_constraints_on_pagerank,max_pagerank_time,solve_time,is_sat,pagerank_calls,decisions,conflicts,formula_constraints,restarts,constraints_learned," > results.csv
for file in $slurm_files;do
	while IFS= read -r line
	do
		if [[ $line =~ \.opb,([^,]*,){11} ]]; then
			echo $line >> results.csv
		fi
	done < "$file"
done