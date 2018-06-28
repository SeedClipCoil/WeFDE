% prune and group
% mi is the mutual information matrix

clear;
load('mi.mat');

% overall 
%off_set = [3, 5, 15, 9, 11];


% ngram
%off_set = [1:4, 13:43];


% burst
off_set = [1:12, 24:43];


% 20 packet
off_set = 1:23;

true_set = [];










for i = 1:43
    if sum(off_set==i) == 0
        true_set = [true_set, i];
    end
end


% reformat
dim = length(true_set);
new = zeros(dim,dim);

for i = true_set
    for j = true_set
        new(i==true_set,j==true_set) = mi_matrix(i,j);
    end
end

% dbscan
new = 1 - new;
%cindex = DBSCAN(new, 0.6, 1)
cindex = DBSCAN(new, 0.6, 1)
