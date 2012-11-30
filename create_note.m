function note_struct = create_note(instring,mode)
%% GLOBALS

%%

if is_chord(instring)
    if isautochord(instring)
        note_struct = create_autochord(instring,mode);
    else
        note_struct = create_custom_chord(instring,mode);
    end
else
    note_struct = create_single_note(instring,mode);
end
end

%% Helper Functions

function bool = is_chord(instring)
if isautochord(instring) || iscustomchord(instring)
    bool = true;
else
    bool = false;
end
end

function bool = iscustomchord(instring)
if instring(1) == '['
    bool = true;
else
    bool = false;
end
end


function isauto = isautochord(instring)
if (instring(1) == '*')
    isauto = true;
else
    isauto = false;
end
end

function c_struct = create_autochord(instring,mode)
% list of commands
strip_off_c();
Root = get_root();
get_spec();
get_length();

%% helper functions

    function strip_off_c()
        instring = instring(2:end);
    end
    function root = get_root()
        if ~has_sym(instring,'_')
            stopsym = findfirst(instring,'.');
        else
            stopsym = findfirst(instring,'_');
        end
        pitch_string = instring(1:stopsym - 1);
        root = make_pitch_struct(pitch_string);
        instring = strip_to(instring,stopsym+1);
    end
    function get_spec()
        dot = findfirst(instring,'.');
        spec = instring(1:dot - 1);
        pitch_matrix = get_pitches_autochord();
        c_struct.Pitches = pitch_matrix;
        instring = strip_to(instring, dot + 1);
        
        
        function pm = get_pitches_autochord()
            % returns array of pitch structures relative to song root
            type = get_type();
            add_cell = parse_adds();
            root12 = convert_to_12(Root,mode);
            pm = de_relate(root12,add_cell);
            
            function pm = de_relate(r,ac)
                for i = 1:length(ac)
                    pm(i) = r + ac{i} - 1;
                end
            end
            
            
            
            function ac = parse_adds()
                % returns array of 12 step pitches relative to chord root
                ac = {};
                if ~isempty(spec)
                    while has_sym(spec,'/')
                        slash = findfirst(spec,'/');
                        cur_string = spec(1:slash-1);
                        pitch = make_pitch_struct(cur_string);
                        modify_from_chord_type();
                        pitch12 = convert_to_12(pitch,'Ionian');
                        ac = push_on_front(pitch12,ac);
                        spec = strip_to(spec,slash+1);
                    end
                    cur_string = spec;
                    pitch = make_pitch_struct(cur_string);
                    modify_from_chord_type();
                    pitch12 = convert_to_12(pitch,'Ionian');
                    ac = push_on_front(pitch12,ac);
                end
                add_type_pitches()
                
                
                
                function add_type_pitches()
                    ac = push_on_front(1,ac);
                    switch type
                        case 'maj'
                            new_ac = {5 8};
                        case 'dom'
                            new_ac = {5 8};
                        case 'm'
                            new_ac = {4 8};
                        case 'dim'
                            new_ac = {4 7 10};
                    end
                    ac = push_on_front(new_ac,ac);
                end
                
                
                function modify_from_chord_type()
                    if pitch.ScaleNumber == 7 && isempty(pitch.Accidental)
                        switch type
                            case 'm'
                                pitch.Accidental = 'Flat';
                            case 'dom'
                                pitch.Accidental = 'Flat';
                        end
                    end
                end
                
                
            end
            
            
            function type = get_type()
                if has_sym(spec,'maj')
                    type = 'maj';
                    spec = strip_to(spec,4);
                elseif has_sym(spec,'dim')
                    type = 'dim';
                    spec = strip_to(spec,4);
                elseif has_sym(spec,'m')
                    type = 'm';
                    spec = strip_to(spec,2);
                    
                else
                    type = 'dom';
                end
            end
        end
    end

    function get_length()
        l_struct = get_note_length(instring);
        c_struct.Length = l_struct;
    end
end


function c_struct = create_custom_chord(instring,mode)
strip_beg();
parse_chord();
get_length();

    function get_length()
        l_struct = get_note_length(instring);
        c_struct.Length = l_struct;
    end

    function parse_chord()
        ac = {};
        while has_sym(instring,'_')
            slash = findfirst(instring,'_');
            cur_string = instring(1:slash-1);
            pitch = make_pitch_struct(cur_string);
            pitch12 = convert_to_12(pitch,mode);
            ac = push_on_front(pitch12,ac);
            instring = strip_to(instring,slash+1);
        end
        slash = findfirst(instring,'.');
        cur_string = instring(1:slash-2);
        pitch = make_pitch_struct(cur_string);
        pitch12 = convert_to_12(pitch,mode);
        ac = push_on_front(pitch12,ac);
        ac = convert_to_array(ac);
        c_struct.Pitches = ac;
        instring = strip_to(instring,slash+1);
    end

    function out = convert_to_array(ac)
        for i = 1:length(ac)
            out(i) = ac{i};
        end
    end

    function strip_beg()
        instring = instring(2:end);
    end
end

function c_struct = create_single_note(instring,mode)
parse_note();
get_length();

    function get_length()
        l_struct = get_note_length(instring);
        c_struct.Length = l_struct;
    end

    function parse_note()
        slash = findfirst(instring,'.');
        cur_string = instring(1:slash-1)
        pitch = make_pitch_struct(cur_string)
        pitch12 = convert_to_12(pitch,mode);
        c_struct.Pitches = pitch12;
        instring = strip_to(instring,slash+1);
    end
end


