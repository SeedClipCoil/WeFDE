% % tamaraw 
clear;
% 1:packet number

parfor_progress(1*5)

vec = zeros(1,43);
vec(1:3) = 1;
closed_world(vec,201);


%2:ngram
 vec = zeros(1,43);
 vec(5) = 1;
 vec(6) = 1;
 vec(7) = 1;
 vec(8) = 2;
 vec(9) = 1;
 vec(10) = 2;
 vec(11) = 4;
 vec(12) = 3;
closed_world(vec,202);


% 3: bursts


vec = zeros(1,43);
vec(13) = 1;
vec(14) = 2;
vec(15:16) = 3;
vec(17:23) = 1;

closed_world(vec,203);

% 4: first 20 packets
vec = zeros(1,43);
vec(24:43) = 1;
closed_world(vec,204);



% 0: total
vec = zeros(1,43);
vec(1) = 1 
vec(2) = 1
vec(3) = 1
vec(5) = 1
vec(6) = 1
vec(8) = 2
vec(10) = 2
vec(11) = 4
vec(12) = 3
vec(13) = 4
vec(14) = 5
vec(17) = 4

closed_world(vec, 200);




parfor_grogress(0);
