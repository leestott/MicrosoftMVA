//
//  Scene.h
//  Stage1
//
//  Created by james on 28/08/2014.
//
//

#ifndef __Stage1__Scene__
#define __Stage1__Scene__

class Scene
{
public:
    virtual void Load () = 0;
    virtual void Unload () = 0;
    
    virtual void Update (float deltaT) = 0;
    virtual void Draw () = 0;
    
    virtual void OnEnter () {}
    virtual void OnExit () {}

	virtual void OnBackButtonPressed() {}
	virtual void OnPause() {}
	virtual void OnResume() {}

    virtual ~Scene() {}
};

#endif /* defined(__Stage1__Scene__) */
