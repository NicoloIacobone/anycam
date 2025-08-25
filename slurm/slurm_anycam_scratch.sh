#!/bin/bash
#
# Specify job name.
#SBATCH --job-name=anycam
#
# Specify output file.
#SBATCH --output=anycam_%j.log
#
# Specify error file.
#SBATCH --error=anycam_%j.err
#
# Specify open mode for log files.
#SBATCH --open-mode=append
#
# Specify time limit.
#SBATCH --time=00:20:00
#
# Specify number of tasks.
#SBATCH --ntasks=1
#
# Specify number of CPU cores per task.
#SBATCH --cpus-per-task=4
#
# Specify memory limit per CPU core.
#SBATCH --mem-per-cpu=8192
#
# Specify number of required GPUs.
#SBATCH --gpus=rtx_4090:2

echo "=== Job starting on $(hostname) at $(date) ==="
# DATE_VAR=$(date +%Y%m%d%H%M%S)

# Load modules.
module load stack/2024-06 python/3.11 cuda/12.4 eth_proxy

# Activate virtual environment for SpatialTrackerV2.
source /cluster/scratch/niacobone/anycam/myenv/bin/activate
echo "Activated Python venv: $(which python)"

# Execute
cd /cluster/scratch/niacobone/anycam

for video in /cluster/work/igp_psr/niacobone/examples/edge_case/*.mp4; do
    video_name=$(basename "$video" .mp4)
    echo "Processing video: $video_name"
    python anycam/scripts/anycam_demo_nico_1.py ++video_name="$video_name"
    echo "----------------------------------"
done

echo "=== Job finished at $(date) ==="
