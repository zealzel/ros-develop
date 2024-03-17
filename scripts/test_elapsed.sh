#!/usr/local/bin/bash
source utils.sh
# declare -A elapsed_times
stage_names=()
elapsed_times=()

script_start_time=$(date +%s)

# Example Stage 1
stage1_start_time=$(date +%s)
sleep 1  # Simulating stage 1 work
calculate_and_store_time $stage1_start_time "Stage 1"

# Example Stage 2
stage2_start_time=$(date +%s)
sleep 2  # Simulating stage 2 work
calculate_and_store_time $stage2_start_time "Stage 2"

# Example Stage 2
stage3_start_time=$(date +%s)
sleep 1  # Simulating stage 2 work
calculate_and_store_time $stage3_start_time "Stage 3"

# Example Stage 2
stage4_start_time=$(date +%s)
sleep 3  # Simulating stage 2 work
calculate_and_store_time $stage4_start_time "Stage 4"

# You can add more stages in a similar manner...

# Print summary at the end
script_end_time=$(date +%s)
calculate_and_store_time $script_start_time "Total Script Time"
print_elapsed_summary
