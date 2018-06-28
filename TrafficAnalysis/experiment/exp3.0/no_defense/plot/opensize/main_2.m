 
addpath('../../../../../attack/InfoMeasure/ToolBox/')
addpath('../../../post-process/');

exper = importdata('openw_top2000_category1_topn100_bstrap0.mat');


rank = exper.rank;
Mflag = exper.Mflag;
JobResults = exper.results.JobResults;


% plot monitored samples evaluted at non-monitored kernels


ws_collect = {};
for world_size = 500:100:2000
    prior = topnPrior(rank, Mflag, world_size);
    m_collect = [];
    for wi = 1:length(Mflag)
        if Mflag(wi) == 0 && rank(wi) <= world_size
            % wi is non-monitored and in rank, to measure
            for si = 1:length(JobResults{wi})
                sample_prob = JobResults{wi}{si};
                temp = Probability(sample_prob, prior, Mflag);
                m_collect = [m_collect, temp(1)];
            end
        end
    end
    ws_collect{world_size} = m_collect;
end
    
for per = [95,85,75]
    py = [];
    py50 = [];
    for world_size = 500:100:2000
        py = [py, prctile(ws_collect{world_size}, per)];
        py50 = [py50, prctile(ws_collect{world_size}, 50)];
    end
    if per == 95
        ciplot(py50, py, 500:100:2000, 'r');
        hold on;
    elseif per == 85
        ciplot(py50, py, 500:100:2000, 'b');
    else
        ciplot(py50, py, 500:100:2000, 'g');
    end
    %    plot(500:100:2000, py);
    hold on;
end

plot(500:100:2000, py50, 'r');



