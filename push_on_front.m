function retcell = push_on_front(newitem,existing_cell)
if iscell(newitem)
    
    if isempty(existing_cell)
        retcell = newitem;
    else
        retcell = {newitem{:} existing_cell{:}};
        
    end
    
    
else
    if isempty(existing_cell)
        retcell = {newitem};
    else
        retcell = {newitem existing_cell{:}};
        
    end
    
end