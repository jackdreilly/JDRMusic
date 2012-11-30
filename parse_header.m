function header_struct = parse_header(hstring)
strip_ends();
parse_tempo();
parse_clef();
parse_key();
parse_time();


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
        header_struct.Clef = hstring(1:comma-1);
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
        comma = findfirst(hstring,'/');
        header_struct.Time.NumberOfBeats = hstring(1:comma - 1);
        header_struct.Time.BeatValue = hstring(comma + 1:end);
    end

end