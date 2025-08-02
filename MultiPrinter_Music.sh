#!/bin/bash

# Printer IP Addresses
REMOTE_HOSTS=("root@10.35.11.64" "root@10.35.11.65")
# SONG_ARGS=("C0[0.0625]/D0[0.0625]" "C0[0.0625]/D0[0.0625]")
SONG_ARGS=("default" "default")
OCTAVE_SHIFT_ARGS=(6 6)
# PRINTER_DIR="/data/test_bash"
PRINTER_DIR="/data/form_symphony_multi3"
NOTES_TO_MOTORS_SCRIPT="Notes_to_MotorMoves.py"

# LOCAL_SCRIPT="/data/test_bash/blank.py"

# Make bash script to scp onto printer 
PRINTER_BASH_SCRIPT="run_python_script.sh"

# Write new bash script 
cat << EOF > "$PRINTER_BASH_SCRIPT"
#!/bin/bash
export ENV_VAR
echo $ENV_VAR
echo "Running script ..."

# # Set basic Formlabs environment variables
# export FL_CALIBRATION="/data/calibration"
# export FL_CONFIG="/data/config"

# Change to the script directory (same as when running locally)
cd ${PRINTER_DIR}

python3 ${NOTES_TO_MOTORS_SCRIPT} "\$1" \$2
echo "Finished running script"
EOF

ARGS_INDEX=0
# Copy from local to scripts to printers
for host in "${REMOTE_HOSTS[@]}"; do 
    echo "About to scp local scripts to remote printer"
    
    # First, ensure the remote directory exists and is actually a directory
    ssh "$host" "rm -f ${PRINTER_DIR} && mkdir -p ${PRINTER_DIR}"
    
    # Debug: Check what's in the remote directory before copying
    echo "Remote directory contents before copying:"
    ssh "$host" "ls -la ${PRINTER_DIR}"
    
    scp "./${NOTES_TO_MOTORS_SCRIPT}" ${host}:${PRINTER_DIR}
    scp "./${PRINTER_BASH_SCRIPT}" ${host}:${PRINTER_DIR}
    scp "./frequency_to_notes.csv" ${host}:${PRINTER_DIR}
    
    # Debug: Check what's in the remote directory after copying
    echo "Remote directory contents after copying:"
    ssh "$host" "ls -la ${PRINTER_DIR}"
    
    echo "Successfully copied local to remote."
done 

# Run scripts in parallel at each printer
for host in "${REMOTE_HOSTS[@]}"; do 
    echo "Executing script on $host in parallel ..."
    
    # Debug: Check if the script file exists and its type
    echo "Checking script file on $host:"
    ssh "$host" "file ${PRINTER_DIR}/${PRINTER_BASH_SCRIPT}"
    ssh "$host" "ls -la ${PRINTER_DIR}/${PRINTER_BASH_SCRIPT}"
    
    ssh "$host" "chmod 755 ${PRINTER_DIR}/${PRINTER_BASH_SCRIPT}" &
    ssh "$host" "bash -l -c '${PRINTER_DIR}/${PRINTER_BASH_SCRIPT} ${SONG_ARGS[$ARGS_INDEX]} ${OCTAVE_SHIFT_ARGS[$ARGS_INDEX]}'" &
    ((ARGS_INDEX++))
    echo "Args: $ARGS_INDEX"
done

wait
echo "All scripts executed"