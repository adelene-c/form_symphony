#!/bin/bash

# Printer IP Addresses
REMOTE_HOSTS=("root@10.35.11.64" "root@10.35.11.65")
SONG_ARGS=("Song1" "Song2")
# LOCAL_SCRIPT="/data/test_bash/blank.py"

# Make bash script to scp onto printer 
PRINTER_BASH_SCRIPT="run_python_script.sh"

# Write new bash script 
cat << 'EOF' > "$PRINTER_BASH_SCRIPT"
#!/bin/bash
echo "Running script ..."
python3 /data/test_bash/blank.py "$1"
echo "Finished running script"
EOF

ARGS_INDEX=0
# Copy from local to scripts to printers
for host in "${REMOTE_HOSTS[@]}"; do 
    echo "About to scp local scripts to remote printer"
    
    # First, ensure the remote directory exists and is actually a directory
    ssh "$host" "rm -f /data/test_bash && mkdir -p /data/test_bash"
    
    # Debug: Check what's in the remote directory before copying
    echo "Remote directory contents before copying:"
    ssh "$host" "ls -la /data/test_bash"
    
    scp "./blank.py" ${host}:/data/test_bash
    scp "./${PRINTER_BASH_SCRIPT}" ${host}:/data/test_bash
    scp "./frequency_to_notes.csv" ${host}:/data/test_bash
    
    # Debug: Check what's in the remote directory after copying
    echo "Remote directory contents after copying:"
    ssh "$host" "ls -la /data/test_bash"
    
    echo "Successfully copied local to remote."
done 

# Run scripts in parallel at each printer
for host in "${REMOTE_HOSTS[@]}"; do 
    echo "Executing script on $host in parallel ..."
    
    # Debug: Check if the script file exists and its type
    echo "Checking script file on $host:"
    ssh "$host" "file /data/test_bash/${PRINTER_BASH_SCRIPT}"
    ssh "$host" "ls -la /data/test_bash/${PRINTER_BASH_SCRIPT}"
    
    ssh "$host" "chmod 755 /data/test_bash/${PRINTER_BASH_SCRIPT}" &
    ssh "$host" "bash /data/test_bash/${PRINTER_BASH_SCRIPT} ${SONG_ARGS[$ARGS_INDEX]}" &
    ((ARGS_INDEX++))
    echo "Args: $ARGS_INDEX"
done

wait
echo "All scripts executed"