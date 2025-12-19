#!/bin/bash

# Generate comprehensive theory for each topic
# Each theory file will be ~5000-15000 lines with:
# - Basic level: Fundamentals with C/C++ comparison
# - Intermediate level: Advanced patterns and design rationale  
# - Advanced level: Deep implementation details and optimization

echo "Generating comprehensive Go theory with C/C++ comparisons..."
echo "Each topic will have detailed design rationale..."

# List of all topics
declare -a TOPICS=(
    "01_basics_and_syntax:Basics and Syntax"
    "02_data_types_and_variables:Data Types and Variables"
    "03_operators_and_expressions:Operators and Expressions"
    "04_control_flow:Control Flow"
    "05_functions:Functions"
    "06_arrays_and_slices:Arrays and Slices"
    "07_maps:Maps"
    "08_structs:Structs"
    "09_pointers:Pointers"
    "10_methods_and_interfaces:Methods and Interfaces"
    "11_error_handling:Error Handling"
    "12_packages_and_modules:Packages and Modules"
    "13_concurrency:Concurrency"
    "14_channels:Channels"
    "15_file_io:File I/O"
    "16_testing:Testing"
    "17_reflection:Reflection"
    "18_generics:Generics"
    "19_memory_management:Memory Management"
    "20_advanced_patterns:Advanced Patterns"
)

for topic in "${TOPICS[@]}"; do
    IFS=':' read -r dir title <<< "$topic"
    echo "Processing: $title"
    
    # Ensure structure exists
    mkdir -p "$dir/basic/examples"
    mkdir -p "$dir/intermediate/examples"
    mkdir -p "$dir/advanced/examples"
    
    # Create claude.md for topic context
    cat > "$dir/claude.md" << CLAUDE
# $title - Working Context

This directory contains comprehensive Go learning materials for **$title**.

## Structure

- \`basic/\` - Fundamental concepts with C/C++ comparisons
- \`intermediate/\` - Advanced usage and design patterns
- \`advanced/\` - Deep dives and optimizations

## Learning Approach

Start with \`basic/theory.md\` which explains:
- Core Go concepts
- How they differ from C/C++
- Why Go made these design choices
- Practical examples throughout

Progress to intermediate and advanced as you master basics.

## Key Focus

Understanding **why** Go chose each design, not just **what** it is.
Every feature is explained in comparison to C/C++ with design rationale.
CLAUDE

    echo "  - Created claude.md"
done

echo "Structure complete! Now theory files need detailed content."
