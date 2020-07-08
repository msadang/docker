#!/bin/bash
source activate rapids
/rapids/utils/start_jupyter.sh > /dev/null 
echo "Notebook server successfully started!"
echo "To access, head to http://localhost:8888 on your host machine."
exec "$@" 