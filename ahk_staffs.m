function ahk_staffs()
global WRITE_ID STAFF_STRUCT STAFF_COUNTER

nstaffs = length(STAFF_STRUCT);

for i = 1:nstaffs
    STAFF_COUNTER = STAFF_COUNTER + 1;
    cur_staff = STAFF_STRUCT(i);
    cur_header = cur_staff.Header;
    cur_key = cur_header.Key;
    cur_phrase = cur_staff.Phrase;
    ahk_header(cur_header,WRITE_ID);
    nnotes = length(cur_phrase.NoteArray);
    for j = 1:nnotes
        cur_note = cur_phrase.NoteArray(j);
        ahk_note();
    end
    
end

    function ahk_note()
        staccato = cur_note.Staccato;
        slur = cur_note.Slur;
        tie = cur_note.Tie;
        note_octave = cur_note.Octave;
        pitches = cur_note.Pitches;
        length_note = cur_note.Length;
        start_command = get_start_command();
        end_command = get_end_command();
        pitch_command = get_pitch_command();
        command_string = [start_command pitch_command end_command];
        print_command_string();
        
        
        function print_command_string()
            fprintf(WRITE_ID,'Send, %s\n',command_string);
        end
        
        
        
        function pc = get_pitch_command()
            n_pitches = length(pitches);
            for k = 1:n_pitches
                cur_pitch = pitches(k);
                acc = get_accidental(cur_pitch,cur_key);
                acc_command = get_accidental_command();
                letter_up  = get_letter_up();
                letter_down = get_letter_down();
                dot_command = get_dot_command();
                enter_command = get_enter_command();
                pc = [letter_up acc_command dot_command enter_command letter_down];
            end
            
            function ec = get_enter_command()
                if k>1
                    ec = '{CTRLDOWN}{ENTER}{CTRLUP}';
                else
                    ec = '{ENTER}';
                end
            end
            
            function ac = get_accidental_command()
                switch acc
                    case 'Natural'
                        ac = '7';
                    case 'Flat'
                        ac = '8';
                    case 'Sharp'
                        ac = '9';
                    case 'None'
                        ac = '';
                end
            end
            
            function dc = get_dot_command()
                note_dot = length_note.NDots;
                switch note_dot
                    case 1
                        dc = '.';
                    case 2
                        dc = '..';
                end
            end
            function lu = get_letter_up()
                lu = '';
                switch cur_pitch.Letter
                    case 'A'
                        ind = 0;
                    case 'B'
                        ind = 1;
                    case 'C'
                        ind = 2;
                    case 'D'
                        ind = 3;
                    case 'E'
                        ind = 4;
                    case 'F'
                        ind = 5;
                    case 'G'
                        ind = 6;
                end
                
                while ind > 0
                    lu = [lu '{UP}'];
                    ind = ind - 1;
                end
            end
            
            function ld = get_letter_down()
                ld = '';
                switch cur_pitch.Letter
                    case 'A'
                        ind = 0;
                    case 'B'
                        ind = 1;
                    case 'C'
                        ind = 2;
                    case 'D'
                        ind = 3;
                    case 'E'
                        ind = 4;
                    case 'F'
                        ind = 5;
                    case 'G'
                        ind = 6;
                end
                
                while ind > 0
                    ld = [ld '{DOWN}'];
                    ind = ind - 1;
                end
            end
            
        end
        
        function lc = get_length_command()
            note_size = length_command.WholePart;
            note_dot = length_command.NDots;
            lc = '';
            switch note_dot
                case 1
                    lc = [lc '.'];
                case 2
                    lc = [lc '..'];
            end
            switch note_size
                case 1
                    lc = [lc '1'];
                case 2
                    lc = [lc '2'];
                case 4
                    lc = [lc '3'];
                case 8
                    lc = [lc '4'];
                case 16
                    lc = [lc '5'];
                case 32
                    lc = [lc '6'];
            end
        end
        
        
        function sc = get_start_command()
            sc = '';
            if staccato
                sc = [sc ','];
            end
            if slur
                sc = [sc ';'];
            end
            if tie
                sc = [sc '/'];
            end
            copy_octave = note_octave;
            while copy_octave < 0
                sc = [sc '{CTRLDOWN}{DOWN}{CTRLUP}'];
                copy_octave = copy_octave + 1;
            end
            while copy_octave > 0
                sc = [sc '{CTRLDOWN}{UP}{CTRLUP}'];
                copy_octave = copy_octave - 1;
            end
            note_size = str2double(length_note.WholePart);
            switch note_size
                case 1
                    lc = '1';
                case 2
                    lc = '2';
                case 4
                    lc = '3';
                case 8
                    lc = '4';
                case 16
                    lc = '5';
                case 32
                    lc = '6';
            end
            sc = [sc lc];
        end
        function ec = get_end_command()
            ec = '';
            copy_octave = note_octave;
            while copy_octave < 0
                ec = [ec '{CTRLDOWN}{UP}{CTRLUP}'];
                copy_octave = copy_octave + 1;
            end
            while copy_octave > 0
                ec = [ec '{CTRLDOWN}{DOWN}{CTRLUP}'];
                copy_octave = copy_octave - 1;
            end
        end
        function acc = get_accidental(cp,ck)
            fs_mat = get_fs_mat(ck);
            listed_acc = cp.Accidental;
            listed_letter = cp.Letter;
            switch listed_letter
                case 'A'
                    ind = 1;
                case 'B'
                    ind = 2;
                case 'C'
                    ind = 3;
                case 'D'
                    ind = 4;
                case 'E'
                    ind = 5;
                case 'F'
                    ind = 6;
                case 'G'
                    ind = 7;
            end
            key_acc = fs_mat(ind);
            switch listed_acc
                case 'Flat'
                    if key_acc == -1
                        acc = 'None';
                    else
                        acc = 'Flat';
                    end
                case 'Sharp'
                    if key_acc == 1
                        acc = 'None';
                    else
                        acc = 'Sharp';
                    end
                case 'Natural'
                    if key_acc == 0
                        acc = 'None';
                    else
                        acc = 'Natural';
                    end
            end
        end
        
    end
end




function fs_mat = get_fs_mat(key)
letter = key.Letter;
mode = key.Mode;
acc = key.Accidental;
nat_mat = [0 0 1 0 0 1 1;
    0 1 1 0 1 1 1;
    0 0 0 0 0 0 0;
    0 0 1 0 0 0 1;
    0 0 1 1 0 1 1;
    0 0 0 -1 0 0 0;
    0 0 0 0 0 0 1];
flat_mat = [1 1 0 1 1 0 0;
    0 1 0 0 1 0 0;
    1 1 1 1 1 1 1;
    1 1 0 1 1 0 1;
    1 1 0 0 1 0 0;
    1 1 1 1 1 1 1;
    1 1 1 1 1 0 1].*-1;
sharp_mat = zeros(7);
sharp_mat(3,:) = ones(1,7);
sharp_mat(6,:) = [1 0 1 1 1 1 1];

mode_mat = [0 0 0 0 0 0 0;
    0 0 -1 0 0 0 -1;
    0 -1 -1 0 0 -1 -1;
    0 0 0 1 0 0 0;
    0 0 0 0 0 0 -1;
    0 0 -1 0 0 -1 -1;
    0 -1 -1 0 -1 -1 -1];

switch acc
    case 'Sharp'
        m = sharp_mat;
    case 'Flat'
        m = flat_mat;
    case 'Natural'
        m = nat_mat;
end

switch letter
    case 'A'
        n = 1;
    case 'B'
        n = 2;
    case 'C'
        n = 3;
    case 'D'
        n = 4;
    case 'E'
        n = 5;
    case 'F'
        n = 6;
    case 'G'
        n = 7;
end

switch mode
    case 'Ionian'
        p = 1;
    case 'Dorian'
        p = 2;
    case 'Phrygian'
        p = 3;
    case 'Lydian'
        p = 4;
    case 'Mixolydian'
        p = 5;
    case 'Aeolian'
        p = 6;
    case 'Locrian'
        p = 7;
end

shiftmat = snake(mode_mat(p,:),n - 1);
fs_mat = m(n,:) + shiftmat;
end