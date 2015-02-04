//
//  SceneIngame.cpp
//  Stage1
//
//  Created by james on 28/08/2014.
//
//

#include "SceneIngame.h"

#include "SceneManager.h"
#include "playerScores.h"

#include <s3eKeyboard.h>
#include <s3ePointer.h>


const int BALL_VEL = 60;
const float BALL_ACCEL = 0.1f;
const float MAX_BALL_MULT = 8.0f;

const int CENTER_LINE_DOT_SIZE = 8;
const int PLAYER_START_LIVES = 3;

CIwFVec2 PADDLE_SIZE;
CIwFVec2 PADDLE_HSIZE;

CIwFVec2 BALL_SIZE;
CIwFVec2 BALL_HSIZE;

void SceneIngame::Load ()
{
	screenFont = (CIwGxFont*)IwGetResManager()->GetResNamed("Serif_8", "CIwGxFont");
	headerFont = (CIwGxFont*)IwGetResManager()->GetResNamed("Serif_12", "CIwGxFont");
	startFont = (CIwGxFont*)IwGetResManager()->GetResNamed("Serif_16", "CIwGxFont");

	{
		CIwTexture *texture = (CIwTexture *)IwGetResManager()->GetResNamed("gem1", IW_GX_RESTYPE_TEXTURE, IW_RES_SEARCH_ALL_F);
		ball = Iw2DCreateImage(texture->GetImage());

		BALL_SIZE = CIwFVec2(ball->GetWidth(), ball->GetHeight());
		BALL_HSIZE = BALL_SIZE / 2.0f;
	}
	{
		CIwTexture *texture = (CIwTexture *)IwGetResManager()->GetResNamed("paddle", IW_GX_RESTYPE_TEXTURE, IW_RES_SEARCH_ALL_F);
		paddle = Iw2DCreateImage(texture->GetImage());

		PADDLE_SIZE = CIwFVec2(paddle->GetWidth(), paddle->GetHeight());
		PADDLE_HSIZE = PADDLE_SIZE / 2.0f;
	}
}

void SceneIngame::OnBackButtonPressed()
{
	SceneManager::SetScene(SceneManager::SceneIDs::keSceneTitle);
}

void SceneIngame::OnPause()
{
	m_PauseGameplay = true;
}
void SceneIngame::OnResume()
{
	m_PauseGameplay = false;

	if (m_StartCountdown >= 0)
	{
		//If we were starting a round when we paused, simply
		//reset the countdown timer.
		m_StartCountdown = 2.0f;
	}
	else
	{
		//If we were playing, then give the user a couple of
		//seconds before resuming.
		m_UnpauseCountdown = 3.0f;
	}	
}

void SceneIngame::OnEnter()
{
	m_PauseGameplay = false;
	m_UnpauseCountdown = 0.0f;

	m_MinLevelBounds = CIwFVec2::g_Zero;

	int width = IwGxGetScreenWidth();
	int height = IwGxGetScreenHeight();

	m_MinLevelBounds = CIwFVec2(0, 10);

	m_PlayerPaddlePos = CIwFVec2(width / 2, height - 100);
	m_AIPaddlePos = CIwFVec2(width / 2, 100);

	m_PlayerScore = 0;
	m_PlayerLIves = 3;

	startRound();
}

void SceneIngame::startRound()
{
	m_BallPosition = CIwFVec2(IwGxGetScreenWidth() / 2, IwGxGetScreenHeight() / 2);
	m_BallVelocity = CIwFVec2(BALL_VEL, BALL_VEL);

	m_StartCountdown = 2.0f;
	m_BallSpeedMult = 1.0f;
}

void SceneIngame::updateAI(float deltaT)
{
	//AI Update
	m_AIPaddlePos.x = m_BallPosition.x;
}

void SceneIngame::updateBall(float deltaT)
{
	//Takes into account resizing of the windows
	m_MaxLevelBounds = CIwFVec2(IwGxGetScreenWidth(), IwGxGetScreenHeight() - 10);

	m_BallPosition += m_BallVelocity * m_BallSpeedMult * deltaT;
	m_BallSpeedMult += BALL_ACCEL * deltaT;
	m_BallSpeedMult = (m_BallSpeedMult > MAX_BALL_MULT) ? MAX_BALL_MULT : m_BallSpeedMult;	//Clamp to 2.0f

	//Bounce the ball around the arena
	if ((m_BallPosition + BALL_HSIZE).x >= m_MaxLevelBounds.x) m_BallVelocity.x = -BALL_VEL;
	if ((m_BallPosition - BALL_HSIZE).x <= m_MinLevelBounds.x) m_BallVelocity.x = BALL_VEL;
	if ((m_BallPosition - BALL_HSIZE).y >= m_MaxLevelBounds.y)
	{
		//AI Scored
		m_PlayerLIves--;

		if (m_PlayerLIves == 0)
		{
			SubmitScoreToCloud(m_PlayerScore);
			SceneManager::SetScene(SceneManager::SceneIDs::keSceneTitle);
		}
		else
		{
			startRound();
		}
	}
	if ((m_BallPosition - BALL_HSIZE).y <= m_MinLevelBounds.y)
	{
		//Player scored... Yeah right!	
		m_PlayerScore++;
		startRound();
	}

	//
	//	Check collisions with player's and AI's paddles
	//
	if ((m_BallPosition - BALL_HSIZE).y <= m_AIPaddlePos.y &&
		ABS(m_BallPosition.x - m_AIPaddlePos.x) < 20)
	{
		m_BallVelocity.y = BALL_VEL;
	}

	if ((m_BallPosition + BALL_HSIZE).y >= m_PlayerPaddlePos.y &&
		ABS(m_BallPosition.x - m_PlayerPaddlePos.x) < 20)
	{
		//So we only score once per deflection
		if (m_BallVelocity.y > 0)
		{
			m_PlayerScore += (int)(m_BallSpeedMult * 100.0f);
			m_BallVelocity.y = -BALL_VEL;
		}
	}
}

void SceneIngame::updatePlayer(float deltaT)
{
	if (s3ePointerGetState(S3E_POINTER_BUTTON_SELECT) & S3E_POINTER_STATE_DOWN)
	{
		m_PlayerPaddlePos.x = s3ePointerGetX();
	}
}

void SceneIngame::Update (float deltaT)
{
	if (m_PauseGameplay) return;

	if (m_StartCountdown > 0)
	{ 
		m_StartCountdown -= deltaT;
	}
	else if (m_UnpauseCountdown > 0)
	{
		m_UnpauseCountdown -= deltaT;
	}
	else
	{
		updateBall(deltaT);
		updateAI(deltaT);
	}

	//We should always be able to move our paddle
	updatePlayer(deltaT);
}

void SceneIngame::drawCenterline()
{
	float lineTop = (IwGxGetScreenHeight() / 2) - (CENTER_LINE_DOT_SIZE / 2);

	for (int x = 0, width = IwGxGetScreenWidth(); x < width; x += (2 * CENTER_LINE_DOT_SIZE))
	{

		Iw2DFillRect(CIwFVec2(x, lineTop), CIwFVec2(CENTER_LINE_DOT_SIZE, CENTER_LINE_DOT_SIZE));
	}
}

void SceneIngame::Draw ()
{
	//Only draw the gameplay elements (Ball) after the countdown
	if (m_StartCountdown <= 0.0f)
	{
		drawCenterline();
		Iw2DDrawImage(ball, m_BallPosition - BALL_HSIZE);
	}

	//Always draw the paddles    
	Iw2DDrawImage(paddle, m_PlayerPaddlePos - PADDLE_HSIZE);
	Iw2DDrawImage(paddle, m_AIPaddlePos - PADDLE_HSIZE);
		

	//
	//	Draw all of the labels
	//
	IwGxFontSetCol(0xffffffff);
	IwGxFontSetFont(screenFont);
	IwGxFontSetAlignmentVer(IW_GX_FONT_ALIGN_MIDDLE);

	{
		int labelLeft = 20;
		int labelRight = ((int16)IwGxGetScreenWidth() / 2) -40;
		int top = 35;

		char scoreText[32];
		sprintf(scoreText, "Player    %i", m_PlayerScore);

		IwGxFontSetAlignmentHor(IW_GX_FONT_ALIGN_RIGHT);
		IwGxFontSetRect(CIwRect(labelLeft, top, labelRight, top));
		IwGxFontDrawText(scoreText);
	}
	{
		int labelLeft = ((int16)IwGxGetScreenWidth() / 2) + 20;
		int labelRight = (int16)IwGxGetScreenWidth() - labelLeft;
		int top = 35;

		char scoreText[32];
		sprintf(scoreText, "%i    Lives", m_PlayerLIves);

		IwGxFontSetAlignmentHor(IW_GX_FONT_ALIGN_LEFT);
		IwGxFontSetRect(CIwRect(labelLeft, top, labelRight, top));
		IwGxFontDrawText(scoreText);
	}

	{
		int labelLeft = 0;
		int labelRight = (int16)IwGxGetScreenWidth();
		int top = 15;

		//WE ARE CHANGING THE FONT HERE!!
		IwGxFontSetFont(headerFont);
		IwGxFontSetAlignmentHor(IW_GX_FONT_ALIGN_CENTRE);
		IwGxFontSetRect(CIwRect(0, top, labelRight, top));
		IwGxFontDrawText("TURBO PONG");
	}

	//
	//	Display this at the start of a round or when we are
	//	resuming from being suspended;
	//
	if (m_StartCountdown > 0.0f || m_UnpauseCountdown > 0)
	{
		int labelLeft = 0;
		int labelRight = (int16)IwGxGetScreenWidth();
		int top = (int16)IwGxGetScreenHeight() / 2 - 16;

		int roundNumber = (PLAYER_START_LIVES - m_PlayerLIves) +1;

		char labelText[32];
		if (m_StartCountdown >= 0)
		{
			sprintf(labelText, "ROUND %i", roundNumber);
		}
		else
		{ 
			sprintf(labelText, "Resume in...%i", (int)(m_UnpauseCountdown + 0.9999f));
		}

		//WE ARE CHANGING THE FONT HERE!!
		IwGxFontSetFont(startFont);
		IwGxFontSetAlignmentHor(IW_GX_FONT_ALIGN_CENTRE);

		IwGxFontSetRect(CIwRect(labelLeft, top, labelRight, 0));
		IwGxFontDrawText(labelText);
	}
}

void SceneIngame::Unload ()
{
    delete paddle;
    delete ball;
}

