import csv
import re
import time
import os
import argparse

def pitch_to_motor_speeds(mapping_csv_file_path: str):
    """
    NOT NECESSARY ANYMORE, have equation. Reads csv and then turns into dictionary of pitch to speed where speed is in mm/s
    """
    
    pitch_to_speed_dict = {}
    ## Open CSV 
    with open(mapping_csv_file_path, mode='r', newline='') as csv_file:
        csv_reader = csv.reader(csv_file)

        # header = next(csv_reader)

        # Iterate through the remaining rows 
        for row_num, row in enumerate(csv_reader, start=2):  # start=2 because we skipped header
            # Skip empty rows
            if not row or len(row) < 2:
                continue
                
            # Skip rows with empty cells
            if not row[0].strip() or not row[1].strip():
                continue
                
            pitch = float(row[1])
            speed = float(row[0])
            pitch_to_speed_dict[pitch] = speed

    # print(f"Final dictionary: {pitch_to_speed_dict}")
    return pitch_to_speed_dict
    # #Pandas version
    
    # df = pd.read_csv(mapping_csv_file_path)
    # print(df.head())

    # for index, row in df.iterrows():
    #     pitch_to_speed_dict[row['Pitch 1 (Hz)']] = row['Speed (mmps)']
    # # pitch_to_speed = df.set_index('Pitch 1 (Hz)')['Speed (mmps)'].to_dict()
    # return pitch_to_speed_dict

def notes_to_pitches(mapping_csv_file_path: str):
    """
    Reads csv and then turns into dictionary of pitch to notes
    """
    
    note_to_pitch_dict = {}
    ## Open CSV 
    with open(mapping_csv_file_path, mode='r', newline='') as csv_file:
        csv_reader = csv.reader(csv_file)

        header = next(csv_reader)

        # Iterate through the remaining rows 
        for row_num, row in enumerate(csv_reader, start=2):  # start=2 because we skipped header
            # Skip empty rows
            # print(row)

            if not row or len(row) < 2:
                continue
                
            # Skip rows with empty cells
            if not row[0].strip() or not row[1].strip():
                continue
                
            pitch = float(row[1]) # float
            note = row[0] # string
            note_to_pitch_dict[note] = pitch

    return note_to_pitch_dict

def parse_notes_and_durations(notes_and_durations: str):
    """
    Format of notes: NotePitch[length1]/NotePitch2[length2]
    """
    notes = []
    durations = []
    
    # This regex finds all occurrences of NotePitch[length]
    # This line uses a regular expression to find all note and duration pairs in the input string.
    # It looks for patterns like "C#4[0.5]" or "A3[1]", capturing the note (e.g., "C#4") and its duration (e.g., "0.5").
    # The result is a list of tuples, where each tuple contains the note and its corresponding duration as strings.
    matches = re.findall(r'([A-G][#b]?\d*)\[(\d+\.?\d*)\]', notes_and_durations)
    for note, duration in matches:
        notes.append(note)
        durations.append(float(duration))

    assert len(notes) == len(durations), "Missing a pitch or length?"
    return notes, durations


def generate_motor_moves(motor, motor_type, octave_shift, note_to_pitch_dict: dict, time_per_quarter_note: float, notes_and_durations: str):
    if motor_type == "z":
        min_pos = -225 #mm
        max_pos = 0
    notes, durations = parse_notes_and_durations(notes_and_durations)
        # inital motor move
    motor_moves = motor.make_motor_move(dist_mm=0,speed_mmps=0, accel_mmps2=0)

    # keep track of distance travelled to switch directions as needed
    curr_pos = 0
    dir = -1 # start by going down, since homing is at top

    for note, duration in zip(notes, durations):
        # get speed from dict

        # note to pitch 
        # Parse the note for the octave number and add 6 if it's 0
        match = re.match(r'^([A-G][#b]?)(\d+)$', note)
        if match:
            note_name, octave = match.groups()
            
            note = "{}{}".format(note_name, int(octave) + int(octave_shift))
            #if octave == '0':
            #    note = "{}{}".format(note_name, int(octave) + 6)
                
        pitch = note_to_pitch_dict[note]
        speed = 0.0246*pitch+0.25 # from Speeds and Pitches excel
        # speed = pitch_to_speed_dict[pitch]

        actual_duration = duration/0.25 * time_per_quarter_note # ex. 1 second for quarter note means 0.125/0.25 * time_per_quarternote
        dist = speed*actual_duration # distance = speed*time
        

        if (curr_pos+dir*dist >= max_pos or curr_pos+dir*dist <= min_pos):
            print("Switch directions")
            dir *= -1
        # if ((total_dist+dir*dist >= max_z_dist) and (dir == -1)):
        #     print("hit bottom")
        #     dir *= -1 # flip direction
        # elif ((total_dist-dir*dist < 0) and (dir == 1)):
        #     print("hit top")
        #     dir *= -1
        
        accel = 500 

        dist_dir = dir*dist
        # total_dist+=dist_dir
        curr_pos+=dist_dir
        print("Note: ", note, "Pitch:", round(pitch, 2), " Speed: ", round(speed, 2), "Travel: :", round(dist_dir, 2), "Curr Pos: ", round(curr_pos, 2))

        motor_moves = append_motor_move(motor_moves, motor, dist_dir, speed, accel)
    
    return motor_moves

def append_motor_move(motor_moves, motor, dist, speed, accel):
    motor_moves.extend(motor.make_motor_move(dist_mm=dist,
                    speed_mmps=speed,
                    accel_mmps2=accel))
     
    return motor_moves

if __name__ == "__main__":
    # test_pitch_to_speed_dict = (note_to_motor_speeds("/home/adelene-chan/Downloads/Speeds and Pitches - F3.csv"))
    # test_pitch_to_speed_dict = (pitch_to_motor_speeds("/data/form_symphony/speedsandpitches.csv"))
    
    # note_to_pitch_dict = notes_to_pitches("/home/adelene-chan/Downloads/Speeds and Pitches - Frequency to Notes - Only.csv")
    
    local_dir = os.path.dirname(os.path.abspath(__file__))
    print("Local directory:", local_dir)
    note_to_pitch_dict = notes_to_pitches(os.path.join(local_dir, "frequency_to_notes.csv"))
    # note_to_pitch_dict = notes_to_pitches("/data/form_symphony_multi/frequency_to_notes.csv")

    # # Test
    # print(test_pitch_to_speed_dict[397]) # should return 10 
    # print(note_to_pitch_dict['C0'])
    # test_pitches, test_lengths = parse_pitches_and_durations("C0[0.0625]/D0[0.0625]/F0[0.0625]/A0[0.125]/A0[0.1875]/G0[0.375]/C0[0.0625]/D0[0.0625]/F0[0.0625]/A0[0.125]/A0[0.1875]/G0[0.375]")
    # print(note_to_pitch_dict)

    # print(parse_notes_and_durations('C0[0.0625]/D0[0.0625]/F0[0.0625]/A0[0.125]/A0[0.1875]/Gb0[0.375]/C0[0.0625]/D0[0.0625]/F0[0.0625]/A0[0.125]/A0[0.1875]/G0[0.375]'))

    default_song = "C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/A0[0.125]/A0[0.1875]/G0[0.375]/C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/G0[0.125]/G0[0.1875]/F0[0.375]/E0[0.0625]/D0[0.125]/C0[0.0625]/D0[0.0625]/F0[0.0625]/D0[0.0625]/F0[0.25]/G0[0.125]/E0[0.1875]/D0[0.0625]/C0[0.25]/G0[0.25]/F0[0.5]"

    # arg parse 
    parser = argparse.ArgumentParser(description="Play a song with optional timing and pitch adjustments.")
    parser.add_argument(
        "--start-time",
        type=int,  # UNIX timestamp (e.g., 1722610500)
        default=0,
        help="Optional UTC timestamp to start execution. If omitted, starts immediately."
    )

    parser.add_argument(
        "--song",
        type=str,
        default=default_song,
        help='Notes to play, e.g., "C0[0.25]/D0[0.5]"'
    )

    parser.add_argument(
        "--octave-shift",
        type=int,
        default=0,
        help="Octave shift to apply to the notes. Can be negative or positive."
    )

    parser.add_argument(
        "--bpm",
        type=int,
        default=60,
        help="Tempo in beats per minute (default: 60)"
    )


    args = parser.parse_args()

    start_time = args.start_time
    song = args.song
    bpm = args.bpm
    octave_shift = args.octave_shift

    print("bpm: ", bpm)
    print("octave_shift: ", octave_shift)



    ### On printer 
    import logging
    import sys
    sys.path.append('/etc/formlabs/alternatives/source/lib')

    import daguerre.subsystems.stepper

    logging.basicConfig(level=logging.WARNING)

    # BEGIN imports to be used at interactive console, please keep even if unused
    import formlabs.hardware.nxkb.driver as nd  # noqa
    import formlabs.hardware.candybus.driver as md  # noqa
    # END imports to be used at interactive console, please keep even if unused

    f = md.FormlabsDBusFan('momo', 'Heater')
    t = md.FormlabsDBusTensioner()
    x = daguerre.subsystems.stepper.DaguerreRoller(md.FormlabsDBusSegmentStepper(axis='X'))
    z = daguerre.subsystems.stepper.DaguerreZ(md.FormlabsDBusSegmentStepper(axis='Z'))

    # Everything above this line is from leash.py

    ## Start by homing the motors
    z.home()
    x.home()
    print("Motors homed")

    print("Generating motor moves ...")


    # if len(sys.argv) > 1:
        
    #     if sys.argv[1] != 'None':
    #         start_time = sys.argv[1]
    #         print("start time", start_time)
    #         print("start_time type", type(start_time))
    # if len(sys.argv) > 2:
    #     # print(sys.argv[1])
    #     if sys.argv[2] == "default":
    #         song = default_song
    #     else:
    #         song = sys.argv[2]
    # else: 
    #     song = default_song
    
    # if len(sys.argv) > 4:
    #     bpm = int(sys.argv[4])
    # else:
    #     bpm = 60

    seconds_per_quarter_note = 60/bpm
    z_moves = generate_motor_moves(z, "z", octave_shift, note_to_pitch_dict, seconds_per_quarter_note, song)
    x_moves = x.make_motor_move(dist_mm=-150,
                            speed_mmps=100,
                            accel_mmps2=500,
                            t_offset_s=1)
    # x_moves = generate_motor_moves(x, "x", octave_shift, note_to_pitch_dict, seconds_per_quarter_note, song)

    combined_moves = {
        z.motor.name: z_moves,
        x.motor.name: x_moves
    }
    #/F0[0.0625]/A0[0.125]/A0[0.1875]/G0[0.375]/C0[0.0625]/D0[0.0625]/F0[0.0625]/A0[0.125]/A0[0.1875]/G0[0.375]
    steppers_object = z.motor.bus.get('com.formlabs.SegmentSteppers',
                                  '/com/formlabs/momo/SegmentSteppers')

    # Now that all the moves are ready, kick them off.
    print("Initial Z Pos: ", z.pos_mm)
    print("Sending motor moves!")

    if start_time is not None:
    # INSERT_YOUR_CODE
        start_time_float = float(start_time)
        print("start_time_float", start_time_float)
        now = time.time()
        wait_seconds = start_time_float - now
        print("waiting seconds", wait_seconds)
        if wait_seconds > 0:
            print("Waiting", wait_seconds)
            # print(f"Waiting {wait_seconds:.2f} seconds until start time ({start_time_float}) ...")
            time.sleep(wait_seconds)
        # else:
            # print(f"Start time {start_time_float} is in the past ({-wait_seconds:.2f} seconds ago), proceeding immediately.")

    steppers_object.ExecuteRelativeMovesBlocking(combined_moves)
    print("Final Z Pos: ", z.pos_mm)