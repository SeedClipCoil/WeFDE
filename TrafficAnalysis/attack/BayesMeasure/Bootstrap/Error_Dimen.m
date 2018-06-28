function [err,test] = Error_Dimen(pdf, dim, spots, step,base)
% dim, dimension for the pdf
% spot, how many spots are used
% step, the gap between each spot


test = [];
% mod system: starts from 0
total_num = spots^dim - 1;

err = zeros(total_num+1,1);

for i = 0:total_num
    if(rem(i,100)==0)
        i
    end
    point = IndConvert(i,dim,spots);
    point = point.*step+base;
    err(i+1,1) = evaluate(pdf,point);
    test = [test,point];
end


end