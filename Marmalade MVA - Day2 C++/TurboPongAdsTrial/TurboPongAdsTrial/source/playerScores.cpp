#include "playerScores.h"

#include <string.h>
#include <assert.h>

std::vector<playerScore> g_PlayerScores;

//Populate the high scores table with some initial data 
void InitScores ()
{
	{
		playerScore nScore = { "James", 1000 };
		g_PlayerScores.push_back(nScore);
	}
	{
		playerScore nScore = { "Lee", 900 };
		g_PlayerScores.push_back(nScore);
	}
	{
		playerScore nScore = { "Anna", 800 };
		g_PlayerScores.push_back(nScore);
	}
	{
		playerScore nScore = { "Tom", 700 };
		g_PlayerScores.push_back(nScore);
	}
	{
		playerScore nScore = { "Dan", 600 };
		g_PlayerScores.push_back(nScore);
	}
}

int GetScoreCount ()
{
	return g_PlayerScores.size();
}
playerScore &GetScore (int scoreIDX)
{
	assert (scoreIDX < GetScoreCount());
	return g_PlayerScores[scoreIDX];
}


void SubmitScoreToCloud(int score)
{
	//Submit score to cloud service 
}