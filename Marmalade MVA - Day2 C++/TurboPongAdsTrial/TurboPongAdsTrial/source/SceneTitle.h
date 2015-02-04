//
//  SceneTitle.h
//  Stage1
//
//  Created by james on 28/08/2014.
//
//

#ifndef __Stage1__SceneTitle__
#define __Stage1__SceneTitle__

#include "Scene.h"

#include <Iw2D.h>
#include <IwGx.h>
#include <IwGxFont.h>

class SceneTitle : public Scene
{
public:
    virtual void Load ();
    virtual void Unload ();
    
    virtual void Update (float deltaT);
    virtual void Draw ();
    
	virtual void OnEnter();
	virtual void OnBackButtonPressed();
private:
	void initStars();
	void updateStars(float deltaT);
	void drawStars();
private:
	CIwGxFont* titleFont;
	CIwGxFont* headerFont;

	struct star
	{
		CIwFVec2 pos;
		CIwFVec2 vel;
	};

	static const int STAR_COUNT = 128;

	star m_Stars[STAR_COUNT];
};


#endif /* defined(__Stage1__SceneTitle__) */

