#!/bin/zsh

# Output file for mu1 data
DATA_FILE="mu1_data_other.txt"

# Remove old file if it exists
rm -f $DATA_FILE

NONZERO_COUNT=0
# Debugging counter for nonzero values
DEBUG_COUNT=0

echo "Testing random probability values:"

# Use a single awk process for better random number generation
awk 'BEGIN {
    srand();
    for (j = 1; j <= 4500; j++) {
        rand_value = rand();
        if (rand_value > 0.98) {
            # Generate Laplace sample
            u = rand() - 0.5;
            if (u < 0) {
                laplace = 0.5 * log(1 + 2 * u);
            } else {
                laplace = -0.5 * log(1 - 2 * u);
            }
            printf "%d %.6f\n", j, laplace;
        } else {
            printf "%d 0\n", j;
        }
    }
}' > $DATA_FILE

# Count nonzero values
NONZERO_COUNT=$(awk '$2 != 0 {count++} END {print count}' $DATA_FILE)

# Debugging output
echo "Total nonzero mu1 values: $NONZERO_COUNT"
echo "Preview of generated data:"
head -20 $DATA_FILE