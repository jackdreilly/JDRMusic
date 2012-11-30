function pitch = make_pitch_struct(cs)
% Creates a struct with fields ScaleNumber and Accidental
% Scale is a number
% Accidental is either Flat, Natural, or Sharp


if has_sym(cs,'b')
    spot = findfirst(cs,'b');
    cs = cs(1:spot - 1);
    pitch.Accidental = 'Flat';
elseif has_sym(cs,'#')
    spot = findfirst(cs,'#');
    cs = cs(1:spot - 1);
    pitch.Accidental = 'Sharp';
elseif has_sym(cs,'nat')
    spot = findfirst(cs,'nat');
    cs = cs(1:spot - 1);
    pitch.Accidental = 'Natural';
else
    pitch.Accidental = [];
end

if has_sym(cs,'~')
    pitch.ScaleNumber = 'Rest';
else
    pitch.ScaleNumber = str2double(cs);
end
end
