#!/bin/bash

# Printer IP Addresses
REMOTE_HOSTS=("root@10.35.11.64" "root@10.35.11.65") # "root@10.35.11.30")
# SONG_ARGS=("C0[0.0625]/D0[0.0625]" "C0[0.0625]/D0[0.0625]")
# Get current UTC timestamp in seconds
bpm=60
song1="C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/A0[0.125]/A0[0.1875]/G0[0.375]/C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/G0[0.125]/G0[0.1875]/F0[0.375]/E0[0.0625]/D0[0.125]/C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/F0[0.25]/G0[0.125]/E0[0.1875]/D0[0.0625]/C0[0.25]/G0[0.25]/F0[0.5]"
song2="E0[0.0625]/F0[0.0625]/A0[0.0625]/F0[0.0625]/C1[0.125]/C1[0.1875]/B0[0.375]/E0[0.0625]/F0[0.0625]/A0[0.0625]/F0[0.0625]/B0[0.125]/B0[0.1875]/A0[0.375]/G0[0.0625]/F0[0.125]/E0[0.0625]/F0[0.0625]/A0[0.0625]/F0[0.0625]/A0[0.25]/B0[0.125]/G0[0.1875]/F0[0.0625]/E0[0.25]/B0[0.25]/A0[0.5]"

# song2="C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/A0[0.125]/A0[0.1875]/G0[0.375]/C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/G0[0.125]/G0[0.1875]/F0[0.375]/E0[0.0625]/D0[0.125]/C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/F0[0.25]/G0[0.125]/E0[0.1875]/D0[0.0625]/C0[0.25]/G0[0.25]/F0[0.5]"
# song1="F#4[1.44]/C#4[1.44]/D#4[1.44]/A#4[1.44]/C4[1.44]/F4[1.44]/D#4[1.44]/G#4[1.44]/F#4[1.44]/D#4[1.44]/C#4[1.44]/A#4[1.44]/F#4[0.192]/C#4[0.192]/D#4[0.192]/A#4[0.192]/F#4[0.096]/C#4[0.096]/D#4[0.096]/A#4[0.096]/C5[0.96]/G#4[0.96]/D#4[0.96]/F#4[1.44]/C#4[1.44]/D#4[1.44]/A#4[1.44]/C4[1.44]/F4[1.44]/D#4[1.44]/G#4[1.44]/F#4[1.44]/D#4[1.44]/C#4[1.44]/A#4[1.44]/F#4[0.192]/C#4[0.192]/D#4[0.192]/A#4[0.192]/F#4[0.096]/C#4[0.096]/D#4[0.096]/A#4[0.096]/C5[0.96]/G#4[0.96]/D#4[0.96]/F2[0.04]/F2[0.04]/F2[0.04]/G#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/C#3[0.04]/D#3[0.04]/D#3[0.04]/F2[0.04]/F2[0.04]/F2[0.04]/G#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/C#3[0.04]/D#3[0.04]/D#3[0.04]/F2[0.04]/F2[0.04]/F2[0.04]/G#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/C#3[0.04]/D#3[0.04]/D#3[0.04]/F2[0.04]/F2[0.04]/F2[0.04]/G#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/C#3[0.04]/D#3[0.04]/F#4[1.44]/C#4[1.44]/D#4[1.44]/A#4[1.44]/C4[1.44]/F4[1.44]/D#4[1.44]/G#4[1.44]/F#4[1.44]/D#4[1.44]/C#4[1.44]/A#4[1.44]/F#4[0.192]/C#4[0.192]/D#4[0.192]/A#4[0.192]/F#4[0.096]/C#4[0.096]/D#4[0.096]/A#4[0.096]/C5[0.96]/G#4[0.96]/D#4[0.96]"
# song2="F#4[1.44]/C#4[1.44]/D#4[1.44]/A#4[1.44]/C4[1.44]/F4[1.44]/D#4[1.44]/G#4[1.44]/F#4[1.44]/D#4[1.44]/C#4[1.44]/A#4[1.44]/F#4[0.192]/C#4[0.192]/D#4[0.192]/A#4[0.192]/F#4[0.096]/C#4[0.096]/D#4[0.096]/A#4[0.096]/C5[0.96]/G#4[0.96]/D#4[0.96]/F#4[1.44]/C#4[1.44]/D#4[1.44]/A#4[1.44]/C4[1.44]/F4[1.44]/D#4[1.44]/G#4[1.44]/F#4[1.44]/D#4[1.44]/C#4[1.44]/A#4[1.44]/F#4[0.192]/C#4[0.192]/D#4[0.192]/A#4[0.192]/F#4[0.096]/C#4[0.096]/D#4[0.096]/A#4[0.096]/C5[0.96]/G#4[0.96]/D#4[0.96]/F2[0.04]/F2[0.04]/F2[0.04]/G#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/C#3[0.04]/D#3[0.04]/D#3[0.04]/F2[0.04]/F2[0.04]/F2[0.04]/G#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/C#3[0.04]/D#3[0.04]/D#3[0.04]/F2[0.04]/F2[0.04]/F2[0.04]/G#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/C#3[0.04]/D#3[0.04]/D#3[0.04]/F2[0.04]/F2[0.04]/F2[0.04]/G#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/A#2[0.04]/C#3[0.04]/D#3[0.04]/F#4[1.44]/C#4[1.44]/D#4[1.44]/A#4[1.44]/C4[1.44]/F4[1.44]/D#4[1.44]/G#4[1.44]/F#4[1.44]/D#4[1.44]/C#4[1.44]/A#4[1.44]/F#4[0.192]/C#4[0.192]/D#4[0.192]/A#4[0.192]/F#4[0.096]/C#4[0.096]/D#4[0.096]/A#4[0.096]/C5[0.96]/G#4[0.96]/D#4[0.96]"
now=$(date -u +%s)

# Target time = now + 15 seconds
target=$((now + 30))

len=${#REMOTE_HOSTS[@]}

TIME_ARGS=()
BPM_ARGS=()
for ((i = 0; i < len; i++)); do
    TIME_ARGS+=("$target")
    BPM_ARGS+=("$bpm")
done

# TIME_ARGS=("$target" "$target") #"$target")
SONG_ARGS=("$song1" "$song2") # "default")
OCTAVE_SHIFT_ARGS=(6 6) # 6)
# PRINTER_DIR="/data/test_bash"
PRINTER_DIR="/data/form_symphony_multi"
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

python3 ${NOTES_TO_MOTORS_SCRIPT} --start-time "\$1" --song "\$2" --octave-shift "\$3" --bpm "\$4"
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
    ssh "$host" "bash -l -c '${PRINTER_DIR}/${PRINTER_BASH_SCRIPT} ${TIME_ARGS[$ARGS_INDEX]} ${SONG_ARGS[$ARGS_INDEX]} ${OCTAVE_SHIFT_ARGS[$ARGS_INDEX]} ${BPM_ARGS[$ARGS_INDEX]}'" &
    # ssh "$host" "bash -l -c \"python3 '${PRINTER_DIR}/${NOTES_TO_MOTORS_SCRIPT}' --start-time ${TIME_ARGS[$ARGS_INDEX]} --song '${SONG_ARGS[$ARGS_INDEX]}' --octave-shift ${OCTAVE_SHIFT_ARGS[$ARGS_INDEX]} --bpm ${BPM_ARGS[$ARGS_INDEX]}\"" &

    ((ARGS_INDEX++))
    echo "Args: $ARGS_INDEX"
done

wait
echo "All scripts executed"