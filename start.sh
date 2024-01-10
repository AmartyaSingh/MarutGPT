#!/bin/bash

# Check if there are any arguments
if [ $# -gt 0 ]; then
    # Start the script with arguments in the background
    python3.10 run_localGPT_API.py "$@" &
else
    python3.10 run_localGPT_API.py &
fi

PYTHON_PID=$(pgrep -f run_localGPT_API.py)

# Wait for the first script to start listening on port 5110
while ! nc -z localhost 5110; do   
  sleep 1 # wait for 1 second before check again
done

echo "runLocalGPT_API.py is up and running"

# Start the second script
python3.10 localGPTUI/localGPTUI.py

# Function to handle Ctrl+C (SIGINT)
function handle_sigint {
    echo "Terminating Python process ($PYTHON_PID)"
    kill $PYTHON_PID
    exit
}

# Set up the trap for Ctrl+C
trap handle_sigint SIGINT

# Optional: wait for the first script to end (if needed)
wait $FIRST_PID
