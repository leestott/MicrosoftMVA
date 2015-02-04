//
//  SceneManager.cpp
//  Stage1
//
//  Created by james on 28/08/2014.
//
//

#include "SceneManager.h"

#include "SceneTitle.h"
#include "SceneIngame.h"

namespace
{
    static Scene *scenes[SceneManager::SceneIDs::keSceneCount] = {
        new SceneTitle (),
        new SceneIngame ()
    };
    
    static SceneManager::SceneIDs::Enum currentScene = SceneManager::SceneIDs::keSceneTitle;
    static SceneManager::SceneIDs::Enum nextScene = SceneManager::SceneIDs::keSceneCount;

	bool pendingQuit = false;
}

namespace SceneManager
{

void QuitGame() { pendingQuit = true; }
bool QuitRequested() { return pendingQuit;  }

void SetScene (SceneIDs::Enum newScene)
{
    nextScene = newScene;
}
    
void UpdateCurrentScene (float deltaT)
{
    if ( nextScene != SceneIDs::keSceneCount )
    {
        scenes[currentScene]->OnExit();
        scenes[nextScene]->OnEnter();
        
        currentScene = nextScene;
        nextScene = SceneIDs::keSceneCount;
    }
    
    scenes[currentScene]->Update(deltaT);
}

void DrawCurrentScene ()
{
    scenes[currentScene]->Draw();
}

SceneIDs::Enum GetCurrentSceneID () { return currentScene; }
Scene *GetCurrentScene() { return scenes[currentScene]; }

void LoadScenes ()
{
    for ( int cScene = 0; cScene < SceneManager::SceneIDs::keSceneCount; cScene++)
    {
        scenes[cScene]->Load();
    }
}

void UnloadScenes ()
{
    for ( int cScene = 0; cScene < SceneManager::SceneIDs::keSceneCount; cScene++)
    {
        scenes[cScene]->Unload();
    }
}

void OnBackButtonPressed()
{
	scenes[currentScene]->OnBackButtonPressed();
}

void OnResume()
{
	scenes[currentScene]->OnResume();
}
void OnPause()
{
	scenes[currentScene]->OnPause();
}

}