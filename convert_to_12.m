function pitch12 = convert_to_12(pitch,mode)
whole = pitch.ScaleNumber;
acc = pitch.Accidental;
if isRest(whole)
    pitch12 = whole;
    return;
end
switch mode
    case 'Ionian'
        ref_mat = [1 3 5 6 8 10 12];
    case 'Dorian'
        ref_mat = [1 3 4 6 8 10 11];
    case 'Phrygian'
        ref_mat = [1 2 4 6 8 9 11];
    case 'Lydian'
        ref_mat = [1 3 5 7 8 10 12];
    case 'Mixolydian'
        ref_mat = [1 3 5 6 8 10 11];
    case 'Aeolian'
        ref_mat = [1 3 4 6 8 9 11];
    case 'Locrian'
        ref_mat = [1 2 4 6 7 9 11];
end

pitch12 = ref_mat(whole);
if isempty(acc)
    return;
end
switch acc
    case 'Flat'
        alter  = -1;
    case 'Natural'
        alter = 0;
    case 'Sharp'
        alter = 1;
end
pitch12 = pitch12 + alter;
end
