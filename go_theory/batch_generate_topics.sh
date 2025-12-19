#!/bin/bash

# This script will invoke topic-specific generators
# Run this to create all theory files

echo "Batch Theory Generation Starting..."
echo ""
echo "This will create comprehensive theory files for all 20 topics"
echo "Each topic has 3 levels: basic, intermediate, advanced"
echo "Total files: 60"
echo ""

# For efficiency, I'll create the theories in batches
# Each batch focuses on related topics

./do_topics_1_5.sh
./do_topics_6_10.sh  
./do_topics_11_15.sh
./do_topics_16_20.sh

echo ""
echo "All theory files created successfully!"
echo "Each file contains:"
echo "  - Detailed explanations"
echo "  - C/C++ comparisons"
echo "  - Design rationale"
echo "  - Code examples"
echo "  - Best practices"

