function retcell = push_on_back(newitem,existing_cell)
if iscell(newitem)
    
    if isempty(existing_cell)
        retcell = newitem;
    else
        retcell = {existing_cell{:} newitem{:}};
        
    end
    
    
else
    if isempty(existing_cell)
        retcell = {newitem};
    else
        retcell = {existing_cell{:} newitem };
        
    end
    
end