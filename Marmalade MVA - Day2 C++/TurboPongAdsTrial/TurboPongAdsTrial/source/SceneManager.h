//
//  SceneManager.h
//  Stage1
//
//  Created by james on 28/08/2014.
//
//

#ifndef __Stage1__SceneManager__
#define __Stage1__SceneManager__

class Scene;

namespace SceneManager
{
    struct SceneIDs
    {
        enum Enum {
            keSceneTitle,
            keSceneIngame,
            
            keSceneCount
        };
    };

	void QuitGame();
	bool QuitRequested();

    void SetScene (SceneIDs::Enum newScene);
    
    void UpdateCurrentScene (float deltaT);
    void DrawCurrentScene ();
    
    SceneIDs::Enum GetCurrentSceneID ();
    Scene *GetCurrentScene();

	void OnBackButtonPressed();
	void OnResume();
	void OnPause();

    void LoadScenes ();
    void UnloadScenes ();
}

#endif /* defined(__Stage1__SceneManager__) */
