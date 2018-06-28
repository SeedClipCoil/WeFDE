data = importdata('possibility_rank');
count = zeros(1,100);

for i = 1: length(data)
    count(data(i)) = count(data(i)) + 1;
end

count = count/sum(count);