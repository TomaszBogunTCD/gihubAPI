#!/bin/bash
python3 main.py &
cd /app/build/web/
python3 -m http.server 55555
wait -n
exit $?