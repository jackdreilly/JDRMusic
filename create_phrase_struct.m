function create_phrase_struct(phrases)
% The solution we have here is in the note structure, we have a string
% field, which holds all of the information about the note, besides the
% properties of it, at that point


global PHRASE_STRUCT;

PHRASE_STRUCT = struct([]);
nPhrases = length(phrases);

for i = 1:nPhrases
    Property_struct = initialize_PStruct();
    cur_phrase = phrases{i};
    get_phrase_name();
    initialize_note_array();
    note_cell = get_note_cell();
    nNotes = length(note_cell);
    for j = 1:nNotes
        cur_note = note_cell{j};
        if is_note(cur_note)
            add_note();
        elseif is_property(cur_note)
            modify_p_struct();
        else
            tack_on_phrase();
        end
    end
    
    
end


%% Helper Functions

    function add_note()
        pre_modify_note();
        new_note = create_fake_note(cur_note);
        post_modify_note();
        add_new_note();
        function add_new_note()
            PHRASE_STRUCT(i).NoteArray = [PHRASE_STRUCT(i).NoteArray new_note];
        end
        
        function new_note = create_fake_note(cur_note)
            new_note.Staccato = false;
            new_note.Tie = false;
            new_note.Slur = false;
            new_note.Octave = 0;
            new_note.String = cur_note;
        end
        
        function post_modify_note()
            mod_octave();
            mod_tie();
            mod_slur();
            mod_staccato();
            
            function  mod_octave()
                new_note.Octave = Property_struct.Octave;
            end
            
            function mod_tie()
                switch Property_struct.Tie
                    case true
                        new_note.Tie = true;
                    case false
                        new_note.Tie = false;
                    case 'Once'
                        new_note.Tie = true;
                        Property_struct.Tie = false;
                end
            end
            
            function mod_staccato()
                switch Property_struct.Staccato
                    case true
                        new_note.Staccato = true;
                    case false
                        new_note.Staccato = false;
                    case 'Once'
                        new_note.Staccato = true;
                        Property_struct.Staccato = false;
                end
            end
            
            function mod_slur()
                switch Property_struct.Slur
                    case true
                        new_note.Slur = true;
                    case false
                        new_note.Slur = false;
                    case 'Once'
                        new_note.Slur = true;
                        Property_struct.Slur = false;
                end
            end
            
        end
        
        function pre_modify_note()
            mod_pitch();
            mod_length();
            
            
            function mod_pitch()
                if Property_struct.Pitch
                    cur_note = [Property_struct.Pitch '.' cur_note];
                end
            end
            function mod_length()
                if Property_struct.Length
                    cur_note = [cur_note '.'  Property_struct.Length ];
                end
            end
        end
        
    end
    function initialize_note_array()
        PHRASE_STRUCT(i).NoteArray = [];
    end
    function tack_on_phrase()
        inPhrase_Notes = get_inphrase_notes();
        PHRASE_STRUCT(i).NoteArray = [PHRASE_STRUCT(i).NoteArray inPhrase_Notes];
        
        
        function ipn = get_inphrase_notes()
            for k = 1:length(PHRASE_STRUCT)
                cur_name = PHRASE_STRUCT(k).PhraseName;
                if strcmp(cur_note,cur_name)
                    ipn = PHRASE_STRUCT(k).NoteArray;
                    return;
                end
            end
        end
    end
    function modify_p_struct()
        strip_cn();
        split_cn();
        tag = get_tag();
        modifier = get_modifier();
        modify_it();
        
        function strip_cn()
            cur_note = cur_note(2:end-1);
        end
        function modify_it()
            switch tag
                case 'octave'
                    switch modifier
                        case 'up'
                            Property_struct.Octave = Property_struct.Octave + 1;
                        case 'down'
                            Property_struct.Octave = Property_struct.Octave - 1;
                    end
                case 'tie'
                    switch modifier
                        case 'once'
                            Property_struct.Tie = 'Once';
                        case 'on'
                            Property_struct.Tie = true;
                        case 'off'
                            Property_struct.Tie = false;
                    end
                case 'staccato'
                    switch modifier
                        case 'once'
                            Property_struct.Staccato = 'Once';
                        case 'on'
                            Property_struct.Staccato = true;
                        case 'off'
                            Property_struct.Staccato = false;
                    end
                case 'slur'
                    switch modifier
                        case 'once'
                            Property_struct.Slur = 'Once';
                        case 'on'
                            Property_struct.Slur = true;
                        case 'off'
                            Property_struct.Slur = false;
                    end
                case 'pitch'
                    switch modifier
                        case 'off'
                            Property_struct.Pitch = false;
                        otherwise
                            Property_struct.Pitch = modifier;
                    end
                case 'length'
                    switch modifier
                        case 'off'
                            Property_struct.Length = false;
                        otherwise
                            Property_struct.Length = modifier;
                    end
            end
        end
        
        
        function split_cn()
            us = findfirst(cur_note,'_');
            cur_note = {cur_note(1:us-1) cur_note(us+1:end)};
        end
        
        function tag = get_tag()
            tag = cur_note{1};
        end
        function m = get_modifier()
            m = cur_note{2};
        end
    end
    function Property_struct = initialize_PStruct()
        Property_struct.Staccato = false;
        Property_struct.Tie = false;
        Property_struct.Slur = false;
        Property_struct.Pitch = false;
        Property_struct.Length = false;
        Property_struct.Octave = 0;
    end
    function note_cell  = get_note_cell()
        intermediate = textscan(cur_phrase,'%s');
        note_cell = intermediate{1};
    end
    function get_phrase_name()
        
        colon = findfirst(cur_phrase,':');
        phrase_name = cur_phrase(1:colon-1);
        PHRASE_STRUCT(i).PhraseName = phrase_name;
        cur_phrase = strip_to(cur_phrase,colon+1);
    end
    function bool = is_property(cn)
        bool = (cn(1) == '{');
    end
    function bool = is_note(cn)
        bool = is_single_note(cn) || is_chord(cn);
        
        
        function bool = is_single_note(cn)
            bool = ~isnan(str2double(cn(1))) || (cn(1) == '~');
        end
        
        
        function bool = is_chord(instring)
            if isautochord(instring) || iscustomchord(instring)
                bool = true;
            else
                bool = false;
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
            
        end
    end
end