function res = IndConvert(in,dim,seq_num)

% first dim <-> highest weight 


res = zeros(dim,1);

box = in;
for cur=0:(dim-1)
     res(dim-cur) = rem(box,seq_num);
     box = floor(box/seq_num);
    
end

end