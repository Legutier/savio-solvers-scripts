for folder in $1*; do
	file_path=$folder
	echo "Number of files: $(ls $file_path -1 | wc -l)"
	files_number=$(ls $file_path -1 | wc -l)

	runs=$((files_number / max_jobs))
	if (( $files_number % $max_jobs != 0 ))
	then
        	((runs+=1))
	fi
	echo "runs: $runs"
	total_seconds=$(( seconds_per_solution * runs ))
	seconds=$((total_seconds % 60))
	total_minutes=$((total_seconds / 60))
	minutes=$((total_minutes % 60))
	total_hours=$((total_minutes / 60))
	hours=$((total_hours))
	echo "total run time: ${hours}:${minutes}:${seconds}"
	file_number=$(find "${scratch_path}/$folder" -maxdepth 1 -name "*.opb" -exec readlink -f {} \; | wc -l)
	if (($file_number > 0))
	then
		echo "processing $file_number files on $folder"
		sbatch --time ${hours}:${minutes}:${seconds} orchestrator.sh $file_path $seconds_per_solution $max_jobs
	fi
done
