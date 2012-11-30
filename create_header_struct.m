function create_header_struct(HEADER)
global HEADER_STRUCT

nheaders = length(HEADER);
for i = 1:nheaders
    hstring = HEADER{i};
    header_struct = struct([]);
    get_header_name()
    strip_ends();
    parse_tempo();
    parse_clef();
    parse_key();
    parse_time();
    parse_dynamics();
    parse_instrument();
    tack_on_to_main();
end

    function tack_on_to_main()
        HEADER_STRUCT = [HEADER_STRUCT header_struct];
    end

    function get_header_name()
        colon = findfirst(hstring,':');
        header_struct(1).HeaderName = hstring(1:colon - 1);
        hstring = strip_to(hstring,colon + 1);
    end

    function strip_ends()
        hstring = hstring(2:end-1);
    end
    function parse_tempo()
        comma = findfirst(hstring,',');
        header_struct.Tempo = hstring(1:comma-1);
        hstring = strip_to(hstring,comma + 1);
    end

    function parse_clef()
        comma = findfirst(hstring,',');
        clef_str = hstring(1:comma-1);
        underscore = findfirst(clef_str,'_');
        if isempty(underscore)
            header_struct.Clef.Shift = 0;
            header_struct.Clef.Type = clef_str;
        else
            shifter = clef_str(underscore+1:end);
            switch shifter
                case 'up'
                    header_struct.Clef.Shift = 1;
                case 'down'
                    header_struct.Clef.Shift = -1;
            end
            header_struct.Clef.Type = clef_str(1:underscore - 1);
        end
        hstring = strip_to(hstring,comma + 1);
    end

    function parse_key()
        header_struct.Key.Mode = [];
        parse_letter();
        parse_accidental();
        parse_mode();
        
        function parse_letter()
            header_struct.Key.Letter = hstring(1);
            hstring = strip_to(hstring,2);
        end
        
        function parse_accidental()
            comma = findfirst(hstring,' ');
            if isempty(comma)
                header_struct.Key.Mode = 'Ionian';
                comma = findfirst(hstring,',');
            else
            end
            
            cur_string = hstring(1:comma-1);
            if isempty(cur_string)
                header_struct.Key.Accidental = 'Natural';
            else
                switch cur_string
                    case 'b'
                        header_struct.Key.Accidental = 'Flat';
                    case '#'
                        header_struct.Key.Accidental = 'Sharp';
                    case 'nat'
                        header_struct.Key.Accidental = 'Natural';
                end
            end
            hstring = strip_to(hstring,comma+1);
        end
        
        function parse_mode()
            if isempty(header_struct.Key.Mode)
                comma = findfirst(hstring,',');
                header_struct.Key.Mode = hstring(1:comma - 1);
                hstring = strip_to(hstring,comma + 1);
            end
        end
    end
    function parse_time()
        slash = findfirst(hstring,'/');
        comma = findfirst(hstring,',');
        header_struct.Time.NumberOfBeats = hstring(1:slash - 1);
        header_struct.Time.BeatValue = hstring(slash + 1:comma - 1);
        hstring = strip_to(hstring,comma + 1);
    end

    function parse_dynamics()
        comma = findfirst(hstring,',');
        header_struct.Dynamics = hstring(1:comma - 1);
        hstring = strip_to(hstring,comma + 1);
    end

    function parse_instrument()
        header_struct.Instrument = hstring;
    end                

end