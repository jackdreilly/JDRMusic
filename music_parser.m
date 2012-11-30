function music_parser(infile)
% YOU NEED TO TAKE CARE OF RESTS
% fix right around where the time signature happens twice - FIGURE IT OUT
%% GLOBALS
clear READ_ID WRITE_ID PHRASE_STRUCT HEADER_STRUCT STAFF_STRUCT STAFF_COUNTER
global READ_ID WRITE_ID PHRASE_STRUCT HEADER_STRUCT STAFF_STRUCT STAFF_COUNTER
%%
start_up()
create_structs();
write_to_file();
wrap_up();

%Electric Bass (finger)
%Electric Guitar (clean)
%Acoustic Grand Piano


%% helper functions
    function start_up()
        READ_ID = fopen([infile '.jdr'],'rt');
        WRITE_ID = fopen('ahk_file.ahk','wt');
        STAFF_COUNTER = 0;
    end

    function create_structs()
        [PHRASES HEADERS STAFFS] = distribute_file();
        create_phrase_struct(PHRASES);
        create_header_struct(HEADERS);
        create_staff_struct(STAFFS);
        
        
        function [PHRASES HEADERS STAFFS] = distribute_file()
            PHRASES = {}; HEADERS = {}; STAFFS = {};
            load_in = textscan(READ_ID,'%s','delimiter','\n');
            load_in = load_in{1};
            for i = 1:length(load_in)
                cur_string = load_in{i};
                if ~isempty(cur_string)
                    colon = findfirst(cur_string,':');
                    type_tag = cur_string(1:colon-1);
                    cur_string = strip_to(cur_string,colon + 1);
                    switch type_tag
                        case 'phrase'
                            PHRASES = push_on_back(cur_string,PHRASES);
                        case 'header'
                            HEADERS = push_on_back(cur_string,HEADERS);
                        case 'staff'
                            STAFFS = push_on_back(cur_string,STAFFS);
                    end
                    
                end
            end
        end
    end

    function write_to_file()
        ahk_startup();
        ahk_staffs();
    end
    function wrap_up()
        fclose(READ_ID);
        fclose(WRITE_ID);
        %status = dos('C:\\Users\\Jack Reilly\\Documents\\MATLAB\\music project\\ahk_file.ahk');
    end


end