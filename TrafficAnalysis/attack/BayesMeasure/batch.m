% % batch run 
% clear;
% % 1:packet number
% vec = zeros(1,43);
% vec(1:3) = 1;
% category_measure(vec,1);
% 
% 2: bursts

% vec = zeros(1,43);
% vec(13) = 5;
% vec(14:18) = 1;
% vec(19) = 3;
% vec(20) = 4;
% vec(21:22) = 6;
% vec(23) = 2;

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

category_measure(vec,2);
% 
% %3:ngram
%  vec = zeros(1,43);
%  vec(8) = 1;
%  vec(10) = 2;
%  vec(5:7) = 3;
%  vec(12) = 4;
% category_measure(vec,3);



% % 4: first 20 packets
% vec = zeros(1,43);
% vec(24:43) = 1:20;
% category_measure(vec,4);