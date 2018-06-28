% % buflo 
clear;
% 1:packet number

parfor_progress(1*5)

vec = zeros(1,43);
vec(1:3) = 1;
closed_world(vec,101);


%2:ngram
 vec = zeros(1,43);
 vec(5) = 3;
 vec(6) = 2;
 vec(7) = 5;
 vec(8) = 1;
 vec(9) = 6;
 vec(10) = 5;
 vec(11) = 2;
 vec(12) = 4;
closed_world(vec,102);


% 3: bursts


vec = zeros(1,43);
vec(13) = 1;
vec(14) = 2;
vec(15:16) = 3;
vec(17:23) = 1;

closed_world(vec,103);

% 4: first 20 packets
vec = zeros(1,43);
vec(24:43) = 1;
closed_world(vec,104);



% 0: total
vec = zeros(1,43);
vec(1) = 4 
vec(5) = 5
vec(6) = 2
vec(8) = 1
vec(9) = 3
vec(11) = 2
vec(12) = 6
vec(13) = 2
vec(14) = 1
vec(17) = 2

closed_world(vec, 100);




parfor_grogress(0);
