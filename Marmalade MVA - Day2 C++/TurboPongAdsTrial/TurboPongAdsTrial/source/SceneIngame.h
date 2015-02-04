//
//  SceneIngame.h
//  Stage1
//
//  Created by james on 28/08/2014.
//
//

#ifndef __Stage1__SceneIngame__
#define __Stage1__SceneIngame__

#include "Scene.h"

#include <Iw2D.h>
#include <IwGx.h>
#include <IwGxFont.h>

class SceneIngame : public Scene
{
public:
    virtual void Load ();
    virtual void Unload ();
    
	virtual void OnEnter();

	virtual void OnBackButtonPressed();
	virtual void OnPause();
	virtual void OnResume();

    virtual void Update (float deltaT);
    virtual void Draw ();
private:
	void updateAI(float deltaT);
	void updateBall(float deltaT);
	void updatePlayer(float deltaT);

	void startRound();

	void drawCenterline();
private:
    CIwFVec2 m_BallPosition;
    CIwFVec2 m_BallVelocity;
    
    CIwFVec2 m_MinLevelBounds;
    CIwFVec2 m_MaxLevelBounds;
    
    CIwFVec2 m_PlayerPaddlePos;
    CIwFVec2 m_AIPaddlePos;
    
	CIwGxFont* screenFont;
	CIwGxFont* headerFont;
	CIwGxFont* startFont;

    CIw2DImage* ball;
    CIw2DImage* paddle;

	int m_PlayerScore;
	int m_PlayerLIves;

	float m_BallSpeedMult;
	float m_StartCountdown;

	bool m_PauseGameplay;
	float m_UnpauseCountdown;
};

#endif /* defined(__Stage1__SceneIngame__) */
