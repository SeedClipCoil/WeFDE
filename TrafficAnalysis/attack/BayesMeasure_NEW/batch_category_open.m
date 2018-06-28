% % batch run
clear;
PL = 4;

% 1:packet number
parfor i = 1:PL

done = 0;
while done == 0
    vec = zeros(1,43);
    vec(1:3) = 1;
    done = FastDirect_open_world(vec,101);
end

done = 0;
while done == 0
%2:ngram
 vec = zeros(1,43);
 vec(5) = 2;
 vec(6) = 2;
 vec(7) = 2;
 vec(8) = 1;
% vec(9) = 2;
 vec(10) = 3;
% vec(11) = 1;
 vec(12) = 4;
done = FastDirect_open_world(vec,102);
end

done = 0;
while done == 0
% 3: bursts
vec = zeros(1,43);
vec(13) = 9;
vec(14) = 4;
vec(15:16) = 8;
vec(17) = 2;
vec(18) = 1;
vec(19) = 6;
vec(20) = 10;
vec(21) = 5;
vec(22) = 7;
vec(23) = 3;

done = FastDirect_open_world(vec,103);

end


done = 0;
while done == 0
% 4: first 20 packets
vec = zeros(1,43);
vec(24:43) = 1:20;
done = FastDirect_open_world(vec,104);
end



% batch total information leakage
done = 0;
while done == 0
vec = zeros(1,43);
vec(1) = 5;
vec(2) = 5;
vec(4) = 6;
vec(6) = 5;
vec(7) = 5;
vec(8) = 5;
vec(10) = 10;
vec(12) = 5;
vec(13) = 27;
vec(14) = 5;
vec(16) = 5;
vec(17) = 29;
vec(18) = 5;
vec(19) = 14;
vec(20) = 22;
vec(21) = 7;
vec(22) = 13;
vec(23) = 25;
vec(24) = 14;
vec(25) = 28;
vec(26) = 16;
vec(27) = 2;
vec(28) = 24;
vec(29) = 26;
vec(30) = 17;
vec(31) = 21;
vec(32) = 20;
vec(33) = 12;
vec(34) = 15;
vec(35) = 8;
vec(36) = 19;
vec(37) = 1;
vec(38) = 9;
vec(39) = 3;
vec(40) = 4;
vec(41) = 23;
vec(42) = 18;
vec(43) = 11;
done = FastDirect_open_world(vec,100);
end



end