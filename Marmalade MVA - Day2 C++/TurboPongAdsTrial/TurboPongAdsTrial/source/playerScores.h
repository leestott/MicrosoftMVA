#ifndef playerScores_h__
#define playerScores_h__

#include <vector>

const int kMAX_USERNAME_SIZE = 63;

struct playerScore
{
	char name[kMAX_USERNAME_SIZE +1];
	int score;
};

void InitScores ();
int GetScoreCount ();
playerScore &GetScore (int scoreIDX);


void SubmitScoreToCloud(int score);
void UpdateScoresFromCloud ();

#endif // playerScores_h__
