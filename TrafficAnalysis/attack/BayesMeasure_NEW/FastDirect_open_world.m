function DONE = FastDirect_open_world(vec, findex)

DONE = 1;
addpath('ToolBox');


% parameters

mcarlo_num = 5000;


reader_closed = TrainMatrixReader('dataset_open_world/monitored/no_defense/');
reader_open = TrainMatrixReader('dataset_open_world/non_monitored/0-2000/');


Tmatrix{1} = reader_closed.TrainMatrix;
label{1} = reader_closed.Label;
Tmatrix{2} = reader_open.TrainMatrix;
label{2} = reader_open.Label;

prior = PriorWebsites('Open_World_Zipf', reader_closed.Rank, reader_open.Rank);

info = EvaluatorMachine(Tmatrix, label, vec, prior);


% decide which webIdx to evaluate
path_webIdx = strcat('debug/web_pool_', int2str(findex), '.mat');
if exist(path_webIdx) == 2
    %exist
    pool = importdata(path_webIdx);
    for i = 1: length(pool)
        if pool(i) == 0
            pool(i) = 1;
            webIdx = i;
            save(path_webIdx, 'pool');
            DONE = 0;
            break;
        end
    end
else
    % no exist
    pool = zeros(1,length(info.WebsiteList));
    pool(1) = 1;
    webIdx = 1;
    save(path_webIdx, 'pool');
    DONE = 0;
end






% whetehr SampleList Exists: is not a matter!
if DONE ~= 1
    info.GenerateSamples(mcarlo_num);
    result = info.Evaluate(webIdx);
    pathname = strcat('debug/f', int2str(findex), '-w', int2str(webIdx), '.mat');
    save(pathname, 'result');
end



end
