function out = findfirst(instring,symbol)
out = strfind(instring,symbol);
if ~isempty(out)
out = out(1);
end
end
