from mido import MidiFile

# A list of the 12 notes in a chromatic scale
NOTE_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

def pitch_to_note_name(pitch_number):
    """
    Converts a MIDI pitch number to its musical note name and octave.

    Args:
        pitch_number (int): The MIDI pitch number (0-127).

    Returns:
        str: A string representing the note (e.g., "C4", "A#5").
    """
    if not 0 <= pitch_number <= 127:
        return "Invalid Pitch"

    note_index = pitch_number % 12
    note_name = NOTE_NAMES[note_index]
    octave = (pitch_number // 12) - 1

    return f"{note_name}{octave}"

def midi_to_notes_and_durations(midi_file_path):
    """
    Reads a MIDI file and translates it into a list of notes with their durations,
    ensuring that 'note_on' and 'note_off' events are matched by both pitch and channel.

    Args:
        midi_file_path (str): The path to the MIDI file.

    Returns:
        list: A list of dictionaries, where each dictionary contains
              'pitch', 'channel', 'note_name', and 'duration_in_seconds'.
              Returns an empty list if an error occurs.
    """
    try:
        midi_file = MidiFile(midi_file_path)
        notes = []
        # Use a dictionary to keep track of active notes, keyed by (pitch, channel)
        active_notes = {}
        current_time = 0.0
        instrument_channels = [None]*len(midi_file.tracks)

        for track in midi_file.tracks:
            for msg in track:
                current_time += msg.time
<<<<<<< HEAD
                if msg.type=="program_change":
                    instrument_channels[i]=[[msg.program, msg.channel]]
                #if (msg.type != 'note_on' and msg.type != 'note_off') and i==1 and msg.type=="program_change":
                #    print(msg)
                #if (msg.type == 'note_on' or msg.type == 'note_off')  and i==1:
                #    print(str(msg) + " " + str(current_time))

=======
                
                # We only care about note messages
>>>>>>> 483fc1d424f97006ebcc97d1bd62453df41ce8b7
                if msg.type == 'note_on' and msg.velocity > 0:
                    # A note_on event with non-zero velocity is the start of a note.
                    # We use a tuple (pitch, channel) as the unique key
                    note_key = (msg.note, msg.channel)
                    active_notes[note_key] = {'start_time': current_time}

                elif msg.type == 'note_off' or (msg.type == 'note_on' and msg.velocity == 0):
                    # A note_off or note_on with zero velocity is the end of a note.
                    note_key = (msg.note, msg.channel)
                    
                    if note_key in active_notes:
                        # If a corresponding start note exists in our dictionary, calculate duration
                        start_time = active_notes[note_key]['start_time']
                        duration = current_time - start_time
                        
                        # Store the completed note's data
                        notes.append({
                            'pitch': msg.note,
                            'note_name': pitch_to_note_name(msg.note),
                            'channel': msg.channel,
                            'duration': duration
                        })

                        # Remove the note from the active_notes dictionary
                        del active_notes[note_key]
        print(instrument_channels)
        return notes
    except FileNotFoundError:
        print(f"Error: The file '{midi_file_path}' was not found.")
        return []
    except Exception as e:
        print(f"An error occurred: {e}")
        return []

<<<<<<< HEAD
def Notes2String(n_list):
    if not n_list: return ""
    song_string = ""
    for note in n_list:
        if note['channel']==5 or note['channel']==4:
            song_string = song_string + note['note_name']+"["+str(note['duration'])+"]/"
    
    #returns everthing but the last character which will be a leftover note delimiter
    return song_string[:-1]

=======
>>>>>>> 483fc1d424f97006ebcc97d1bd62453df41ce8b7
if __name__ == '__main__':
    midi_file = 'RickRoll.mid'  # Replace with your file name
    note_list = midi_to_notes_and_durations(midi_file)

    if note_list:
        print("Notes, Pitches, Durations, and Channels:")
        for note_data in note_list:
            if note_data['channel']==8:
                print(f"Note: {note_data['note_name']}, Pitch: {note_data['pitch']}, "
                    f"Duration: {note_data['duration']:.4f} seconds, Channel: {note_data['channel']}")
    else:
        print("No notes found or an error occurred.")