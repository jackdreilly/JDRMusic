function bool = has_sym(instring,sym)
if isempty(strfind(instring,sym))
    bool = false;
else
    bool = true;
end
