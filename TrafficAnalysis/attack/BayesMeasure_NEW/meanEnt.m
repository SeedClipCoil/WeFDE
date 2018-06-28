function ent = meanEnt(ent_cell)
web_num = length(ent_cell);

ent = 0;
counter = 0;
for i = 1:web_num
    ent = ent + sum( ent_cell{i} );
    counter = counter + length( ent_cell{i} );
end


ent = ent/counter;
end