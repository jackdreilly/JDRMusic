function length_struct = get_note_length(instring)
whole_part = get_whole_part();
n_dots = get_n_dots();

length_struct.WholePart = whole_part;
length_struct.NDots = n_dots;


    function n_dots = get_n_dots()
        if ~has_sym(instring, '.')
            n_dots = 0;
        elseif ~has_sym(instring, '..')
            n_dots = 1;
        else
            n_dots = 2;
        end
        
    end


    function wp = get_whole_part()
        if ~has_sym(instring,'.')
            wp = instring;
        else
            dot = findfirst(instring,'.');
            wp = instring(1:dot-1);
        end
    end


end


