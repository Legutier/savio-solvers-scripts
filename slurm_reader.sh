folder=$1
absolute_path=$(pwd -P)
slurm_files=$(find "$absolute_path/$folder" -maxdepth 1 -name "slurm*.out" -exec readlink -f {} \;)
echo "slurm files: $($slurm_files | wc -l)"
