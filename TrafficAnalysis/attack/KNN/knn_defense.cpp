#include <iostream>
#include <fstream>
#include <cmath>
#include <string>
#include <string.h>
#include <sstream>
#include <time.h>
#include <stdlib.h>
#include <algorithm>
#include <limits>
using namespace std;

//Data parameters
int FEAT_NUM = 3043; //number of features

const int SITE_NUM = 94; // number of possible websites
const int WEIGHT_NUM = 60; //number of instances per site for distance learning
const int CLASSIFY_NUM = 40; //number of instances per site for kNN training/testing

int OPENTEST_NUM = 0; //number of open instances for kNN training/testing
int NEIGHBOUR_NUM = 1; //number of neighbors for kNN

const int RECOPOINTS_NUM = 5; //number of neighbors for distance learning

//Algorithmic Parameters
float POWER = 0.1; //not used in this code

//Only in old recommendation algorithm
const int RECOLIST_NUM = 10;
const int RECO_NUM = 1;




// used for k neighbor recording
struct Sample {
  float distance;
  int index;
  Sample *next;
};

bool inarray(int ele, int* array, int len) {
	for (int i = 0; i < len; i++) {
		if (array[i] == ele)
			return 1;
	}
	return 0;
}

void alg_init_weight(float** feat, float* weight) {
	for (int i = 0; i < FEAT_NUM; i++) {
		weight[i] = (rand() % 100) / 100.0 + 0.5;
	}
	/*float sum = 0;
	for (int j = 0; j < FEAT_NUM; j++) {
		if (abs(weight[j]) > sum) {
		sum += abs(weight[j]);
		}
	}
	for (int j = 0; j < FEAT_NUM; j++) {
		weight[j] = weight[j]/sum * 1000;
	}*/
}

float dist(float* feat1, float* feat2, float* weight, float power) {
	float toret = 0;
	for (int i = 0; i < FEAT_NUM; i++) {
		if (feat1[i] != -1 and feat2[i] != -1) {
			toret += weight[i] * abs(feat1[i] - feat2[i]);
		}
	}
	return toret;
}

void alg_recommend2(float** feat, float* weight, int start, int end) {

	float* distlist = new float[SITE_NUM * WEIGHT_NUM];
	int* recogoodlist = new int[RECOPOINTS_NUM];
	int* recobadlist = new int[RECOPOINTS_NUM];

	for (int i = start; i < end; i++) {
		printf("\rLearning distance... %d (%d-%d)", i, start, end);
		fflush(stdout);
		int cur_site = i/WEIGHT_NUM;
		int cur_inst = i % WEIGHT_NUM;

		float pointbadness = 0;
		float maxgooddist = 0;

		for (int k = 0; k < SITE_NUM*WEIGHT_NUM; k++) {
			distlist[k] = dist(feat[i], feat[k], weight, POWER);
		}
		float max = *max_element(distlist, distlist+SITE_NUM*WEIGHT_NUM);
		distlist[i] = max;
		for (int k = 0; k < RECOPOINTS_NUM; k++) {
			int ind = min_element(distlist+cur_site*WEIGHT_NUM, distlist+(cur_site+1)*WEIGHT_NUM) - distlist;
			if (distlist[ind] > maxgooddist) maxgooddist = distlist[ind];
			distlist[ind] = max;
			recogoodlist[k] = ind;
		}
		for (int k = 0; k < WEIGHT_NUM; k++) {
			distlist[cur_site*WEIGHT_NUM+k] = max;
		}
		for (int k = 0; k < RECOPOINTS_NUM; k++) {
			int ind = min_element(distlist, distlist+ SITE_NUM * WEIGHT_NUM) - distlist;
			if (distlist[ind] <= maxgooddist) pointbadness += 1;
			distlist[ind] = max;
			recobadlist[k] = ind;
		}

		pointbadness /= float(RECOPOINTS_NUM);
		pointbadness += 0.2;
		/*
		if (i == 0) {
			float gooddist = 0;
			float baddist = 0;
			printf("Current point: %d\n", i);
			printf("Bad points:\n");
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				printf("%d, %f\n", recobadlist[k], dist(feat[i], feat[recobadlist[k]], weight, POWER));	
				baddist += dist(feat[i], feat[recobadlist[k]], weight, POWER);
			}

			printf("Good points:\n");
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				printf("%d, %f\n", recogoodlist[k], dist(feat[i], feat[recogoodlist[k]], weight, POWER));
				gooddist += dist(feat[i], feat[recogoodlist[k]], weight, POWER);
			}

			printf("Total bad distance: %f\n", baddist);
			printf("Total good distance: %f\n", gooddist);
		}*/

		float* featdist = new float[FEAT_NUM];
		for (int f = 0; f < FEAT_NUM; f++) {
			featdist[f] = 0;
		}
		int* badlist = new int[FEAT_NUM];
		int minbadlist = 0;
		int countbadlist = 0;
		//printf("%d ", badlist[3]);
		for (int f = 0; f < FEAT_NUM; f++) {
			if (weight[f] == 0) badlist[f] == 0;
			else {
			float maxgood = 0;
			int countbad = 0;
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				float n = abs(feat[i][f] - feat[recogoodlist[k]][f]);
				if (feat[i][f] == -1 or feat[recobadlist[k]][f] == -1) 
					n = 0;
				if (n >= maxgood) maxgood = n;
			}
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				float n = abs(feat[i][f] - feat[recobadlist[k]][f]);
				if (feat[i][f] == -1 or feat[recobadlist[k]][f] == -1) 
					n = 0;
				//if (f == 3) {
				//	printf("%d %d %f %f\n", i, k, n, maxgood);
				//}
				featdist[f] += n;
				if (n <= maxgood) countbad += 1;
			}
			badlist[f] = countbad;
			if (countbad < minbadlist) minbadlist = countbad;	
			}
		}

		for (int f = 0; f < FEAT_NUM; f++) {
			if (badlist[f] != minbadlist) countbadlist += 1;
		}
		int* w0id = new int[countbadlist];
		float* change = new float[countbadlist];

		int temp = 0;
		float C1 = 0;
		float C2 = 0;
		for (int f = 0; f < FEAT_NUM; f++) {
			if (badlist[f] != minbadlist) {
				w0id[temp] = f;
				change[temp] = weight[f] * 0.01 * badlist[f]/float(RECOPOINTS_NUM) * pointbadness;
				//if (change[temp] < 1.0/1000) change[temp] = weight[f];
				C1 += change[temp] * featdist[f];
				C2 += change[temp];
				weight[f] -= change[temp];
				temp += 1;
			}
		}

		/*if (i == 0) {
			printf("%d %f %f\n", countbadlist, C1, C2);
			for (int f = 0; f < 30; f++) {
				printf("%f %f\n", weight[f], featdist[f]);
			}
		}*/
		float totalfd = 0;
		for (int f = 0; f < FEAT_NUM; f++) {
			if (badlist[f] == minbadlist and weight[f] > 0) {
				totalfd += featdist[f];
			}
		}

		for (int f = 0; f < FEAT_NUM; f++) {
			if (badlist[f] == minbadlist and weight[f] > 0) {
				weight[f] += C1/(totalfd);
			}
		}

		/*if (i == 0) {
			printf("%d %f %f\n", countbadlist, C1, C2);
			for (int f = 0; f < 30; f++) {
				printf("%f %f\n", weight[f], featdist[f]);
			}
		}*/

		/*if (i == 0) {
			float gooddist = 0;
			float baddist = 0;
			printf("Current point: %d\n", i);
			printf("Bad points:\n");
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				printf("%d, %f\n", recobadlist[k], dist(feat[i], feat[recobadlist[k]], weight, POWER));	
				baddist += dist(feat[i], feat[recobadlist[k]], weight, POWER);
			}

			printf("Good points:\n");
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				printf("%d, %f\n", recogoodlist[k], dist(feat[i], feat[recogoodlist[k]], weight, POWER));
				gooddist += dist(feat[i], feat[recogoodlist[k]], weight, POWER);
			}

			printf("Total bad distance: %f\n", baddist);
			printf("Total good distance: %f\n", gooddist);
		}*/
		delete[] featdist;
		delete[] w0id;
		delete[] change;
		delete[] badlist;
	}



	for (int j = 0; j < FEAT_NUM; j++) {
		if (weight[j] > 0)
			weight[j] *= (0.9 + (rand() % 100) / 500.0);
	}
	printf("\n");
	delete[] distlist;
	delete[] recobadlist;
	delete[] recogoodlist;



}

//no longer used
void alg_recommend(float** feat, float* weight, float** reco) {

	float* distlist = new float[SITE_NUM * WEIGHT_NUM];
	int* recogoodlist = new int[RECOLIST_NUM];
	int* recobadlist = new int[RECOLIST_NUM];

	for (int i = 0; i < SITE_NUM * WEIGHT_NUM; i++) {
		int cur_site = i/WEIGHT_NUM;
		int cur_inst = i % WEIGHT_NUM;

		for (int k = 0; k < SITE_NUM*WEIGHT_NUM; k++) {
			distlist[k] = dist(feat[i], feat[k], weight, POWER);
		}
		float max = *max_element(distlist, distlist+SITE_NUM*WEIGHT_NUM);
		distlist[i] = max;
		for (int k = 0; k < RECOLIST_NUM; k++) {
			int ind = min_element(distlist+cur_site*WEIGHT_NUM, distlist+(cur_site+1)*WEIGHT_NUM) - distlist;
			distlist[ind] = max;
			recogoodlist[k] = ind;
		}
		for (int k = 0; k < WEIGHT_NUM; k++) {
			distlist[cur_site*WEIGHT_NUM+k] = max;
		}
		for (int k = 0; k < RECOLIST_NUM; k++) {
			int ind = min_element(distlist, distlist+ SITE_NUM * WEIGHT_NUM) - distlist;
			distlist[ind] = max;
			recobadlist[k] = ind;
		}

		for (int f = 0; f < FEAT_NUM; f++) {
			reco[i][f] = 0;
		}

		if (i == 0) {
			float gooddist = 0;
			float baddist = 0;
			printf("Current point: %d\n", i);
			printf("Bad points:\n");
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				printf("%d, %f\n", recobadlist[k], dist(feat[i], feat[recobadlist[k]], weight, POWER));	
				baddist += dist(feat[i], feat[recobadlist[k]], weight, POWER);
			}

			printf("Good points:\n");
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				printf("%d, %f\n", recogoodlist[k], dist(feat[i], feat[recogoodlist[k]], weight, POWER));
				gooddist += dist(feat[i], feat[recogoodlist[k]], weight, POWER);
			}

			printf("Total bad distance: %f\n", baddist);
			printf("Total good distance: %f\n", gooddist);

			float* tempweight = new float[FEAT_NUM];

			for (int f = 0; f < FEAT_NUM; f++) {
				tempweight[f] = 0;
			}
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				int ind1 = recobadlist[k];
				int ind2 = recogoodlist[k];
				//float dist1 = dist(feat[i], feat[ind1], weight, POWER);
				//float dist2 = dist(feat[i], feat[ind2], weight, POWER);
				for (int f = 0; f < FEAT_NUM; f++) {
					tempweight[f] += abs(feat[i][f] - feat[ind1][f]); 
					tempweight[f] -= abs(feat[i][f] - feat[ind2][f]); 
				}
			}
			
			for (int f = 0; f < 25; f++) {
				printf("Weight %d: Value %f, Change %f\n", f, weight[f], tempweight[f]);
			}

			float sumweight = 0;

			for (int f = 0; f < FEAT_NUM; f++) {
				if (tempweight[f] < 0) tempweight[f] = 0;
				sumweight += abs(tempweight[f]);
			}

			for (int f = 0; f < FEAT_NUM; f++) {
				tempweight[f] /= sumweight;
				tempweight[f] += weight[f];
			}

			baddist = 0;
			gooddist = 0;
			printf("Bad points:\n");
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				printf("%d, %f\n", recobadlist[k], dist(feat[i], feat[recobadlist[k]], tempweight, POWER));	
				baddist += dist(feat[i], feat[recobadlist[k]], tempweight, POWER);
			}

			printf("Good points:\n");
			for (int k = 0; k < RECOPOINTS_NUM; k++) {
				printf("%d, %f\n", recogoodlist[k], dist(feat[i], feat[recogoodlist[k]], tempweight, POWER));
				gooddist += dist(feat[i], feat[recogoodlist[k]], tempweight, POWER);
			}

			printf("Total bad distance: %f\n", baddist);
			printf("Total good distance: %f\n", gooddist);
			delete[] tempweight;
		}

		for (int k = 0; k < RECOPOINTS_NUM; k++) {
			int ind1 = recobadlist[k];
			int ind2 = recogoodlist[k];
			//float dist1 = dist(feat[i], feat[ind1], weight, POWER);
			//float dist2 = dist(feat[i], feat[ind2], weight, POWER);
			for (int f = 0; f < FEAT_NUM; f++) {
				reco[i][f] += abs(feat[i][f] - feat[ind1][f]); 
				reco[i][f] -= abs(feat[i][f] - feat[ind2][f]); 
			}
		}

		
/*
		for (int rec = 0; rec < RECO_NUM; rec++) {
			int ind1 = recobadlist[0];
			int ind2 = recogoodlist[RECOLIST_NUM - rec - 1];
			float dist1 = dist(feat[i], feat[ind1], weight, POWER);
			float dist2 = dist(feat[i], feat[ind2], weight, POWER);
			for (int k = 0; k < FEAT_NUM; k++) {
				//recommend how the weight should change.
				//positive: increase weight because it's useful. more positive if more useful.
				//negative: decrease weight because it's not useful. more negative if less useful.
				float div = dist2-dist1;
				if (div < dist1/100)
					div = dist1/100; //div = (abs(dist2-dist1)/(dist2-dist1)) * dist1/100;
				reco[i + rec * WEIGHT_NUM * SITE_NUM][k] = (abs(feat[ind1][k] - feat[i][k]) - abs(feat[ind2][k] - feat[i][k]))/div;
			}
		}*/
/*
		printf("Point: %d, features %f, %f, %f\n", i, feat[i][0], feat[i][1], feat[i][2]);
		printf("Closest outside point: Ind %d, dist %f, features %f, %f, %f\n", ind1, dist1, feat[ind1][0], feat[ind1][1], feat[ind1][2]);
		printf("Most distant inside point: Ind %d, dist %f, features %f, %f, %f\n", ind2, dist2, feat[ind2][0], feat[ind2][1], feat[ind2][2]);
		for (int a = 0; a < 5; a++) {
			printf("%d ", recobadlist[a]);
		}
		printf("\n---\n");
		if (i == 137) {
			for (int j = 0; j < SITE_NUM*WEIGHT_NUM; j++) {
				printf("%f ", distlist[j]);
			}
		}
		printf("\n");*/
	}

	
	delete[] distlist;
	delete[] recobadlist;
	delete[] recogoodlist;
	
}

//no longer used
void alg_mod_weight(float* weight, float** reco) {
	float votesum = 0;
	/*for (int i = 0; i < SITE_NUM*WEIGHT_NUM*RECO_NUM; i++) {
		votesum = 0;
		for (int j = 0; j < FEAT_NUM; j++) {
			votesum += abs(reco[i][j]);
		}
		for (int j = 0; j < FEAT_NUM; j++) {
			//reco[i][j] = reco[i][j] / votesum;
		}
	}*/
	float* sumreco = new float[FEAT_NUM];
	for (int i = 0; i < FEAT_NUM; i++){
		sumreco[i] = 0;
	}
	for (int i = 0; i < SITE_NUM*WEIGHT_NUM*RECO_NUM; i++) {
		for (int j = 0; j < FEAT_NUM; j++) {
			//if (reco[i][j] > 1) reco[i][j] = 1;
			//if (reco[i][j] < -1) reco[i][j] = -1;
			sumreco[j] += reco[i][j];
		}
	}

	for (int i = 0; i < FEAT_NUM; i++) {
		sumreco[i] /= SITE_NUM*WEIGHT_NUM*RECO_NUM;
	}
/*
	for (int i = 0; i < 5; i++) {
	printf("%f ", sumreco[i]);
	}
	printf("\n");
	*/
	for (int j = 0; j < FEAT_NUM; j++) {
		weight[j] += sumreco[j] * 40;
		if (weight[j] < 0) weight[j] = 0;
	}

	/*printf("Recommendations: ");
	for (int j = 0; j < 5; j++) {
		printf("%f ", sumreco[j]);
	}
	printf("\n");*/


	for (int j = 0; j < FEAT_NUM; j++) {
		if (weight[j] > 0)
			weight[j] *= (0.5 + (rand() % 100) / 100.0);
	}

	float sum = 0;
	for (int j = 0; j < FEAT_NUM; j++) {
		if (abs(weight[j]) > sum) {
		sum += abs(weight[j]);
		}
	}
	for (int j = 0; j < FEAT_NUM; j++) {
		weight[j] = weight[j]/sum;
	}
	delete[] sumreco;
}


//no longer used
void alg_change_weight(float* featdist, float* weight, int* w0id, float* change, int changenum) {
	//Changes weight, keeping sum_k featdist[k]*weight[k] constant, weights between 0 and 1
	//change assumed to be legal, weights assumed to be legal. change aways positive
	//change legal if w0 >= average. 
	//featdist[weightnum] can't be the largest!

	
	float C1 = 0;
	float C2 = 0;

	for (int i = 0; i < changenum; i++) {
		C1 += featdist[w0id[i]] * change[i];
		C2 += change[i];
		weight[w0id[i]] -= change[i];
	}

	int w1choices = 0;
	for (int i = 0; i < FEAT_NUM; i++) {
		if (featdist[i] > C1/C2 and !inarray(i, w0id, changenum)) {
			w1choices += 1;
		}
	}
	int w1rand = (rand() % w1choices) + 1;
	int w1id = 0;

	int count = 0;
	float w1 = 0;
	for (int i = 0; i < FEAT_NUM; i++) {
		if (featdist[i] > C1/C2 and !inarray(i, w0id, changenum)) count += 1;
		if (w1rand == count) {
			w1 = featdist[i];
			w1id = i;
			break;
		}
	}

	float othersum = 0;
	int othernum = 0;
	for (int i = 0; i < FEAT_NUM; i++) {
		if (!inarray(i, w0id, changenum) and featdist[i] != 0) {
			othersum += featdist[i];
			othernum += 1;
		}
	}
	othersum /= othernum;

	//solution:
	float x1 = (C1 - othersum * C2)/(w1-othersum);
	weight[w1id] += x1;
	//printf("weight %d changed: now %f, increase %f\n", w1id, weight[w1id], x1);

	float sum = 0;
	for (int i = 0; i < FEAT_NUM; i++) {
		if (!inarray(i, w0id, changenum) and featdist[i] != 0) {
			weight[i] += (C2 - x1)/othernum;
			//sum += featdist[i] * (C2-x1)/(FEAT_NUM-2);
		}
	}
}




// update MinList
Sample *UpdateMinList(Sample *header, float distance, int index) {

  if(distance > header->distance) {
    return NULL;
  }
  
  Sample *ptr = header;
  header = header->next;

  ptr->distance = distance;
  ptr->index = index;

  // insert the ptr node
  
  Sample *ptrfront = header;
  Sample *ptrback = header;
  
  while(ptrfront != NULL) {
    if(ptrfront->distance < ptr->distance)
      break;
    ptrback = ptrfront;
    ptrfront = ptrfront->next;
  }
  
  // insert to as header
  if(ptrback == ptrfront) {
    header = ptr;
  }
  else {
    ptrback->next = ptr;
    ptr->next = ptrfront;
  }
  return header;
}


// given MinList
// return the most frequent index
int DecisionMinList(Sample *header) {
  int counter[SITE_NUM] = {0};
  Sample *cur = header;
  int i = NEIGHBOUR_NUM;
  while(i != 0) {
    counter[cur->index]++;
    cur = cur->next;
    i--;
  }

  // pick up the most frequent 
  int Max = 0;
  int MaxIndex;
  for(int i = 0; i < SITE_NUM; i++) {
    if(counter[i] > Max) {
      Max = counter[i];
      MaxIndex = i;
    }
  }

  // debug: print decisionMin Structure
//  cur = header;
//  printf("DecisionMin: ");
//  while(cur != NULL) {
//    printf("webpage index: %d-%d\n", cur->index/CLASSIFY_NUM, WEIGHT_NUM + cur->index % CLASSIFY_NUM);
//    cur = cur->next;
//  }
  return MaxIndex;
}


// sort by insert
Sample *SortedInsert(Sample *ptr, Sample *header) {
  if(header == NULL) {
    ptr->next = NULL;
    return ptr;
  }

  // sort by insert
  Sample *cur = header;
  Sample *pre = NULL;

  while(cur != NULL) {
    if(cur->distance > ptr->distance)
      break;
    pre = cur;
    cur = cur->next;
  }

  // cur is the first bigger than ptr
  if(pre == NULL) {     // insert before head
    ptr->next = cur;
    header = ptr;
  }
  else {        // insert middle or at tail
    pre->next = ptr;
    ptr->next = cur;
  }

  return header;
}


// delete nodes with the index
Sample *DeleteNodeIndex(Sample *header, int index) {
  Sample *pre = NULL;
  Sample *cur = header;

  while(cur != NULL) {
    if(cur->index == index) {
      if(pre == NULL) {
        header = cur->next;
        delete cur;
        cur = header;
      }
      else {
        pre->next = cur->next;
        delete cur;
        cur = pre->next;
      }
        
    }
    else {
      pre = cur;
      cur = cur->next;
    }
  }

  return header;

}


// an ordered list of potential websites
int *DecisionList(Sample *header) {
  // header node is itself with distance 0
  
  int *ptr = new int[SITE_NUM];
  int pos = 0;

  while(header != NULL) {
    int dec;
    dec = DecisionMinList(header);
    ptr[pos] = dec;


    // update and continue
    header = DeleteNodeIndex(header, dec);
    pos++;
  }


  return ptr;
}


// only limited to all but one cross validation
// gives a ordered list of decided labels
int KNN_Classify(int TestIndex, float **FeatureMatrix_Classify, float *weight) {
  

  // initialize linked list: ordered from min to max
  Sample *header = NULL;

  for(int i = 0; i < SITE_NUM*CLASSIFY_NUM; i++) {
    if(i != TestIndex) {
      // compute a record and initiate a node
      Sample *ptr = new Sample;
      ptr->distance = dist(FeatureMatrix_Classify[TestIndex],FeatureMatrix_Classify[i], weight, POWER);
      ptr->index = i/CLASSIFY_NUM;
  
      // sorted by insert
      header = SortedInsert(ptr, header);
    }
  }


  // an ordered list of potential websites  
  int *ptr = DecisionList(header);

/*
  for(int i = 0; i < SITE_NUM; i++) {
    if(ptr[i] == TestIndex/CLASSIFY_NUM)
      printf("%d ", i+1);
  }
*/


//  for(int i = 0; i < SITE_NUM; i++) {
//    printf("%d ", ptr[i]);
//  }
//  printf("\n");
//
  return ptr[0];


}



float accuracy(float** FeatureMatrix_Classify, float* weight) {

	float correct = 0;
	float wrong = 0;



  // TestIndex: the test case in all but one cross validation
  for(int TestIndex = 0; TestIndex < SITE_NUM*CLASSIFY_NUM; TestIndex++) {
   
//    printf("\rTestIndex = %d", TestIndex);
//    fflush(stdout);
     // testing
    int SiteIndex_Classify = KNN_Classify(TestIndex,
                                        FeatureMatrix_Classify, weight);
    int SiteIndex_True = TestIndex/CLASSIFY_NUM;
   
    if(SiteIndex_True == SiteIndex_Classify)
      correct++;
    else {
      wrong++;
//      printf("webpage %d-%d is wrongly classified as %d\n", SiteIndex_True, TestIndex % CLASSIFY_NUM + WEIGHT_NUM, SiteIndex_Classify);
//      fflush(stdout);
    }
  }


  return correct/(correct + wrong);
}



// convert string to a row in FeatureMatrix
int StringToFeatureMatrix(string str, float **FeatureMatrix, int inx) {
  
string tempstr = "";
	int feat_count = 0;
	for (int i = 0; i < str.length(); i++) {
		if (str[i] == ' ') {
			if (tempstr.c_str()[1] == 'X') {
				FeatureMatrix[inx][feat_count] = -1;
			}
			else {
				FeatureMatrix[inx][feat_count] = atof(tempstr.c_str());
			}	
			feat_count += 1;
			tempstr = "";
		}
		else {
			tempstr += str[i];
		}
	}
}




// FeatureMatrix: row is instances of web pages; column is feature type 
// freadname:     feature file name
// return:        FeatureMatrix
int ReadFeatureMatrix(string freadname, float **FeatureMatrix, int inx) {
	ifstream fread;

  // read the file
  ostringstream freadnamestream;
  fread.open(freadname.c_str());
	if (!fread.is_open()) 
    return 0;
	
  string str = "";
	getline(fread, str);
	fread.close();


      // prepare FeatureMatrix from what is read
  StringToFeatureMatrix(str, FeatureMatrix, inx);
  return 1;
}




int main(int argc, char** argv) {


	srand(time(NULL));

  string keyword = argv[1];



	float** FeatureMatrix_Weight = new float*[SITE_NUM*WEIGHT_NUM];
	float** FeatureMatrix_Classify = new float*[SITE_NUM*CLASSIFY_NUM];

	for (int i = 0; i < SITE_NUM*WEIGHT_NUM; i++) {
		FeatureMatrix_Weight[i] = new float[FEAT_NUM];
	}
	for (int i = 0; i < SITE_NUM*CLASSIFY_NUM; i++) {
		FeatureMatrix_Classify[i] = new float[FEAT_NUM];
	}


  // Feature Extractions
	for (int cur_site = 0; cur_site < SITE_NUM; cur_site++) {
		int real_inst = 0;
    string freadname;

    // prepare FeatureMatrix_Weight
		for (int cur_inst = 0; cur_inst < WEIGHT_NUM; cur_inst++) {
		  do {
      ostringstream freadnamestream;
			freadnamestream << "./Dataset/defenses/" << keyword << "/"<< cur_site << "-" << real_inst << ".feature";
			freadname = freadnamestream.str();
      real_inst++;
      }
      while(ReadFeatureMatrix(freadname, FeatureMatrix_Weight, cur_site * WEIGHT_NUM + cur_inst) == 0);
    }


    // prepare FeatureMatrix_Classify
    for(int cur_inst = 0; cur_inst < CLASSIFY_NUM; cur_inst++) {
		  do {
      ostringstream freadnamestream;
			freadnamestream << "./Dataset/defenses/" << keyword << "/" << cur_site << "-" << real_inst << ".feature";
			freadname = freadnamestream.str();
      real_inst++;
      }
      while(ReadFeatureMatrix(freadname, FeatureMatrix_Classify, cur_site * CLASSIFY_NUM + cur_inst) == 0);
    }
    
  }




	float * weight = new float[FEAT_NUM];
	float * value = new float[FEAT_NUM];

	int TRIAL_NUM = 1;
	int SUBROUND_NUM = 5;
	float maxacc = 0;

	alg_init_weight(FeatureMatrix_Weight, weight);

	float * prevweight = new float[FEAT_NUM];
	for (int i = 0; i < FEAT_NUM; i++) {
		prevweight[i] = weight[i];
	}

	clock_t t1, t2;
	alg_init_weight(FeatureMatrix_Weight, weight);
	for (int trial = 0; trial < TRIAL_NUM; trial++) {
		for (int subround = 0; subround < SUBROUND_NUM; subround++) {
			int start = (SITE_NUM * WEIGHT_NUM)/SUBROUND_NUM * subround;
			int end = (SITE_NUM * WEIGHT_NUM)/SUBROUND_NUM * (subround+1);
			alg_recommend2(FeatureMatrix_Weight, weight, start, end);
			float tp, tn;
//			t1 = clock();
      printf("..........................\n");
      fflush(stdout);
			float acc = accuracy(FeatureMatrix_Classify, weight);
//			t2 = clock();
//			printf("Time taken: %f\n", (float)(t2-t1)/(CLOCKS_PER_SEC));
			printf("Round %d-%d, accuracy: %f\n", trial,subround, acc);
		}
	}

	FILE * weightfile;
	weightfile = fopen("weights", "w");
	for (int i = 0; i < FEAT_NUM; i++) {
		fprintf(weightfile, "%f ", weight[i] * 1000);
	}
	fclose(weightfile);



  for(int i = 0; i <  SITE_NUM*WEIGHT_NUM; i++) {
    delete[] FeatureMatrix_Weight[i];
  }
  delete[] FeatureMatrix_Weight;

  for(int i = 0; i < SITE_NUM*CLASSIFY_NUM; i++) {
    delete[] FeatureMatrix_Classify[i];
  }
  delete[] FeatureMatrix_Classify;

  delete[] prevweight;
  delete[] weight;
  delete[] value;


	return 0;
}
