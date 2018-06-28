% % batch run 
clear;
% 1:packet number

parfor_progress(51*4)

vec = zeros(1,43);
vec(1:3) = 1;
closed_world(vec,1);

% 2: bursts


vec = zeros(1,43);
vec(13) = 10;
vec(14) = 2;
vec(15:16) = 8;
vec(17) = 9;
vec(18) = 4;
vec(19) = 7;
vec(20) = 3;
vec(21) = 1;
vec(22) = 6;
vec(23) = 5;

closed_world(vec,2);

%3:ngram
 vec = zeros(1,43);
 vec(8) = 1;
 vec(10) = 2;
 vec(5:7) = 3;
 vec(12) = 4;
closed_world(vec,3);



% 4: first 20 packets
vec = zeros(1,43);
vec(24:43) = 1:20;
closed_world(vec,4);
parfor_grogress(0);
