function fp = go_from_12_to_pitch(my_cur_pitch,key)
letter = key.Letter;
mode = key.Mode;
acc = key.Accidental;
fs = get_fs_mat();
switch my_cur_pitch
    case 1
        fp.Letter = 'A';
        fp.Accidental = 'Natural';
    case 2
        if fs(1) == 1;
            fp.Letter = 'A';
            fp.Accidental = 'Sharp';
        else
            fp.Letter = 'B';
            fp.Accidental = 'Flat';
        end
    case 3
        if fs(3) == -1;
            fp.Letter = 'C';
            fp.Accidental = 'Flat';
        else
            fp.Letter = 'B';
            fp.Accidental = 'Natural';
        end
    case 4
        if fs(2) == 1;
            fp.Letter = 'B';
            fp.Accidental = 'Sharp';
        else
            fp.Letter = 'C';
            fp.Accidental = 'Natural';
        end
    case 5
        if fs(3) == 1;
            fp.Letter = 'C';
            fp.Accidental = 'Sharp';
        else
            fp.Letter = 'D';
            fp.Accidental = 'Flat';
        end
    case 6
        fp.Letter = 'D';
        fp.Accidental = 'Natural';
    case 7
        if fs(4) == 1;
            fp.Letter = 'D';
            fp.Accidental = 'Sharp';
        else
            fp.Letter = 'E';
            fp.Accidental = 'Flat';
        end
    case 8
        if fs(6) == -1;
            fp.Letter = 'F';
            fp.Accidental = 'Flat';
        else
            fp.Letter = 'E';
            fp.Accidental = 'Natural';
        end
    case 9
        if fs(5) == 1;
            fp.Letter = 'E';
            fp.Accidental = 'Sharp';
        else
            fp.Letter = 'F';
            fp.Accidental = 'Natural';
        end
    case 10
        if fs(6) == 1;
            fp.Letter = 'F';
            fp.Accidental = 'Sharp';
        else
            fp.Letter = 'G';
            fp.Accidental = 'Flat';
        end
    case 11
        fp.Letter = 'G';
        fp.Accidental = 'Natural';
    case 12
        if fs(7) == 1;
            fp.Letter = 'G';
            fp.Accidental = 'Sharp';
        else
            fp.Letter = 'A';
            fp.Accidental = 'Flat';
        end
end


        
        function fs_mat = get_fs_mat()
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
end