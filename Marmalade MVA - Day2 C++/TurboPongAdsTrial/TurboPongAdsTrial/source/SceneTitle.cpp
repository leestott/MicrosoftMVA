//
//  SceneTitle.cpp
//  Stage1
//
//  Created by james on 28/08/2014.
//
//

#include "SceneTitle.h"

#include "SceneManager.h"
#include "playerScores.h"

#include <s3eKeyboard.h>
#include <s3ePointer.h>

extern bool IsTrial();
extern void UnlockGame();

void SceneTitle::Load ()
{
	headerFont = (CIwGxFont*)IwGetResManager()->GetResNamed("Serif_12", "CIwGxFont");
	titleFont = (CIwGxFont*)IwGetResManager()->GetResNamed("Serif_24", "CIwGxFont");
}

void SceneTitle::OnBackButtonPressed()
{
	SceneManager::QuitGame();
}

void SceneTitle::OnEnter()
{
	initStars();
}

void SceneTitle::initStars()
{
	int width = IwGxGetScreenWidth();
	int height = IwGxGetScreenHeight();

	for (int cStar = 0; cStar < STAR_COUNT; ++cStar)
	{
		m_Stars[cStar].pos = CIwFVec2((float)(rand() % width), (float)(rand() % height));
		m_Stars[cStar].vel = CIwFVec2(0, (float)((rand() % 50) + 30));
	}
	
}

void SceneTitle::updateStars(float deltaT)
{
	int width = IwGxGetScreenWidth();
	int height = IwGxGetScreenHeight();

	for (int cStar = 0; cStar < STAR_COUNT; ++cStar)
	{
		m_Stars[cStar].pos += m_Stars[cStar].vel * deltaT;

		if (m_Stars[cStar].pos.y > height)
		{
			m_Stars[cStar].pos = CIwFVec2((float)(rand() % width), 0);
			m_Stars[cStar].vel = CIwFVec2(0, (float)((rand() % 50) + 30));
		}
	}
}

void SceneTitle::drawStars()
{
	for (int cStar = 0; cStar < STAR_COUNT; ++cStar)
	{
		CIwColour starCol; 
		starCol.SetGrey(m_Stars[cStar].vel.y * 2);

		Iw2DSetColour(starCol);
		Iw2DFillRect(m_Stars[cStar].pos, CIwFVec2(2, 2));
	}

	Iw2DSetColour(0xFFFFFFFF);
}

void SceneTitle::Update (float deltaT)
{
	if (s3ePointerGetState(S3E_POINTER_BUTTON_SELECT) & S3E_POINTER_STATE_RELEASED)
	{
		if (s3ePointerGetY() > IwGxGetScreenHeight() - 100 && IsTrial())
		{
			UnlockGame(); 		
		}
		else
		{
			SceneManager::SetScene(SceneManager::SceneIDs::keSceneIngame);
		}
	}

	updateStars(deltaT);
}

void SceneTitle::Draw ()
{
	drawStars();

	//
	//	Draw all of the labels
	//
	IwGxFontSetCol(0xffffffff);

	{
		int labelLeft = 0;
		int labelRight = (int16)IwGxGetScreenWidth();
		int top = (IsTrial()) ? 100 : 0;

		//WE ARE CHANGING THE FONT HERE!!
		IwGxFontSetFont(titleFont);
		IwGxFontSetAlignmentVer(IW_GX_FONT_ALIGN_TOP);
		IwGxFontSetAlignmentHor(IW_GX_FONT_ALIGN_CENTRE);
		IwGxFontSetRect(CIwRect(0, top, labelRight, 0));
		IwGxFontDrawText("TURBO PONG");
	}

	{
		int labelLeft = 0;
		int labelRight = (int16)IwGxGetScreenWidth();
		int bottom = (IsTrial()) ? (int16)IwGxGetScreenHeight() - 150 : (int16)IwGxGetScreenHeight();

		//WE ARE CHANGING THE FONT HERE!!
		IwGxFontSetFont(headerFont);
		IwGxFontSetAlignmentVer(IW_GX_FONT_ALIGN_BOTTOM);
		IwGxFontSetAlignmentHor(IW_GX_FONT_ALIGN_CENTRE);

		IwGxFontSetRect(CIwRect(labelLeft, bottom, labelRight, 0));
		IwGxFontDrawText("Tap here to start...");
	}

	if (IsTrial())
	{
		int labelLeft = 0;
		int labelRight = (int16)IwGxGetScreenWidth();
		int bottom = (int16)IwGxGetScreenHeight();

		//WE ARE CHANGING THE FONT HERE!!
		IwGxFontSetFont(headerFont);
		IwGxFontSetAlignmentVer(IW_GX_FONT_ALIGN_BOTTOM);
		IwGxFontSetAlignmentHor(IW_GX_FONT_ALIGN_CENTRE);

		IwGxFontSetRect(CIwRect(labelLeft, bottom, labelRight, 0));
		IwGxFontDrawText("Tap Here To Purchase");
	}

	const int kCenterOffset = 40;
	const int kRowSpacing = 32;
	int listTop = ((int16)IwGxGetScreenHeight() / 2) - ((kRowSpacing * GetScoreCount()) / 2) + kCenterOffset;

	//Only show the score if we actually have one!
	for ( int scoreIdx = 0; scoreIdx < GetScoreCount(); scoreIdx++ )
	{
		playerScore & cScore = GetScore(scoreIdx);

		int labelLeft = 0;
		int labelRight = (int16)IwGxGetScreenWidth();
		int top = listTop + scoreIdx * kRowSpacing;

		char labelText[32];
		sprintf(labelText, "%-16s %i", cScore.name, cScore.score);

		//WE ARE CHANGING THE FONT HERE!!
		IwGxFontSetFont(headerFont);
		IwGxFontSetAlignmentVer(IW_GX_FONT_ALIGN_MIDDLE);
		IwGxFontSetAlignmentHor(IW_GX_FONT_ALIGN_CENTRE);

		IwGxFontSetRect(CIwRect(labelLeft, top, labelRight, 0));
		IwGxFontDrawText(labelText);
	}
}

void SceneTitle::Unload ()
{
    //delete image;
}