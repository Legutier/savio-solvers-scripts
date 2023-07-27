${scratch_path} = "/global/home/users/$USER/scratch"
slurm_files=$(find "${scratch_path}/$folder" -maxdepth 1 -name "*.opb" -exec readlink -f {} \;)
echo "slurm files: $(slurm_files | wc -l)"
