import os, sys
import adaptive
import multiprocessing




#trace_path = "datadir/1-short"
#histogram_path = "HistogramStats/bglist_0.1.txt"
#dst_path = "output"
#
#adaptive.AdaptiveDefense(trace_path, histogram_path, dst_path)



SRC_DIR = list()
DST_DIR = list()
SRC_DIR.append("TrafficAnalysis/Dataset/closed/top100/")
SRC_DIR.append("TrafficAnalysis/Dataset/openworld/non_monitor_0-500/")
SRC_DIR.append("TrafficAnalysis/Dataset/openworld/non_monitor_500-1500/")
SRC_DIR.append("TrafficAnalysis/Dataset/openworld/non_monitor_1500-2000/")

#DST_DIR = "TrafficAnalysis/attack/KNN/Dataset/defenses/"
#DST_DIR = "TrafficAnalysis/defense/WTF/vanilla--/"
HIST_DIR = "TrafficAnalysis/defense/WTF/HistogramStats/"

DST_DIR.append("TrafficAnalysis/Dataset/closew_defense/top100/")
DST_DIR.append("TrafficAnalysis/Dataset/openw_defense/non_monitor_0-500/")
DST_DIR.append("TrafficAnalysis/Dataset/openw_defense/non_monitor_500-1500/")
DST_DIR.append("TrafficAnalysis/Dataset/openw_defense/non_monitor_1500-2000/")




def processBatch(src_path, dst_path, hist_path, batch):
    for each_file in batch:
        src = src_path + each_file
        dst = dst_path + each_file
        adaptive.AdaptiveDefense(src, hist_path, dst)


def main(src_path, dst_path, hist_path):

    if not os.path.isdir(dst_path):
        os.makedirs(dst_path)

    files = os.listdir(src_path)

    BATCH_NUM = 7 

    batch = [[]]*BATCH_NUM

    for idx, each_file in enumerate(files):
        if "feature" not in each_file:
            if int( each_file.split('-')[1] ) < 20: # not too many to handle
                i = idx % BATCH_NUM
                batch[i].append(each_file)

    pjobs = []
    for each_batch in batch:
        p = multiprocessing.Process(target=processBatch, args=(src_path, dst_path, hist_path, each_batch,))
        pjobs.append(p)
        p.start()
    for eachp in pjobs:
        eachp.join()
    print "finished!"





if __name__ == "__main__":
    i = sys.argv[1]
    hpath = HIST_DIR + "bglist_0." + i + ".txt"
    for j in range(0,4): 
        spath = SRC_DIR[j]
        dpath = DST_DIR[j] + "WTF_0."+ i + "/"
        main(spath, dpath, hpath)
