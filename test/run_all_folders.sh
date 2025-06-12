#!/bin/bash

# Define paths
COLLECTION="test/ALLautomation.postman_collection.json"
ENVIRONMENT="test/TNLearnerAIStaging.postman_environment.json"
DATA="test/languages.csv"
OUTPUT_DIR="test/reports"

# Make sure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Get current date and time
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# List of folders to run
FOLDERS=("ULP" "getContent" "getsetResult")

# Declare iteration count per folder (default is full dataset)
declare -A ITERATIONS
ITERATIONS["ULP"]=1
ITERATIONS["getContent"]=7
ITERATIONS["getsetResult"]=7

# Loop through each folder
for FOLDER in "${FOLDERS[@]}"; do
    echo "Running folder: $FOLDER"

    HTML_REPORT="${OUTPUT_DIR}/${FOLDER}_report_${TIMESTAMP}.html"

    # Get iteration count (if set), else leave blank for default behavior
    ITERATION_COUNT="${ITERATIONS[$FOLDER]}"
    ITERATION_FLAG=""
    if [ -n "$ITERATION_COUNT" ]; then
        ITERATION_FLAG="--iteration-count $ITERATION_COUNT"
    fi

    newman run "$COLLECTION" \
        --folder "$FOLDER" \
        -e "$ENVIRONMENT" \
        -d "$DATA" \
        $ITERATION_FLAG \
        -r htmlextra \
        --reporter-htmlextra-export "$HTML_REPORT" \
        --reporter-htmlextra-title "${FOLDER} Test Report" \
        --reporter-htmlextra-browserTitle "${FOLDER} API Test" \
        --reporter-htmlextra-titleSize 3 \
        --reporter-htmlextra-showOnlyFails false \
        --reporter-htmlextra-showEnvironmentData true \
        --reporter-htmlextra-logs true \
        --reporter-htmlextra-showFolder=true \
        --reporter-htmlextra-omitHeaders=false

    echo "Reports generated for $FOLDER:"
    echo "- HTML: $HTML_REPORT"

    echo "-----------------------------------------------------"

    # Optional: open report automatically
    # xdg-open "$HTML_REPORT"
done
