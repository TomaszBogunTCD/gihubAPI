#!/bin/bash

# Start the first process
python3 main.py &

# Start the second process
cd /app/build/web/
python3 -m http.server 55555

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?