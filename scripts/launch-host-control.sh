#!/bin/bash

# Activate the virtual environment
source /etc/webhook/.venv/bin/activate

# Run the Python3 script with arguments
python3 /etc/webhook/scripts/host-control.py "$@"

# Deactivate the virtual environment
deactivate