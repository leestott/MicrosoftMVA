#include "SceneManager.h"

#include "playerScores.h"

#include <Iw2D.h>
#include <IwResManager.h>
#include <IwGxFont.h>
#include <IwGx.h>

#include <s3eKeyboard.h>
#include <s3ePointer.h>

#include <s3eConfig.h>

#include <s3eAdDuplex.h>
#include <s3eWindowsPhoneStoreBilling.h >
#include <s3eWindowsStoreBilling.h>

void ResourceInit()
{
 	Iw2DInit();
    IwResManagerInit();
    IwGxFontInit();

    //Load the group containing the example font
    IwGetResManager()->LoadGroup("PongResources.group");

	SceneManager::LoadScenes();
}

void ResourceFree()
{
	SceneManager::UnloadScenes();

	Iw2DTerminate();
}

//Draw pitch (middle checkered line)
//Back button
//Startfield on titlescreen for *retro* feel

int32 PauseCallback(void* systemData, void* userData)
{
	SceneManager::OnPause();
	return 0;
}


static bool gameIsTrial = true;
bool IsTrial()
{
	return gameIsTrial;
}

void UnlockGame()
{
	s3eWindowsStoreBillingBuyFull();
}

//
//	Ad Duplex handling
//

//Used to hold the id returned in the adDuplexInitCallback
static s3eAdDuplexHandle adDuplexHandle;

//This is called by the Ad Duplex Extension when the initialization has either
//succeeded or failed.
int32 adDuplexInitCallback(void *systemData, void *userData)
{
	adDuplexHandle = (s3eAdDuplexHandle)systemData;

	//We only want to show ads when the game is in trial mode
	if (IsTrial())
	{
		s3eAdDuplexShow(adDuplexHandle);
		s3eAdDuplexPropertySet(adDuplexHandle, S3E_AD_DUPLEX_V_ALIGN, S3E_AD_DUPLEX_VALIGN_TOP);
		s3eAdDuplexPropertySet(adDuplexHandle, S3E_AD_DUPLEX_SIZE, S3E_AD_DUPLEX_SIZE_292X60);
		IwTrace(AD_DUPLEX, ("Ad duplex inited"));
	}

	return 0;
}

//Every time an Ad is served to use, this gets called. 
int32 adDuplexLoadedCallback(void *systemData, void *userData)
{
	IwTrace(AD_DUPLEX, ("Ad duplex ad loaded"));
	return 0;
}

//This is used to show or hide the Ads. We call this when we detect that
//the user has purchased the game.
void setAdsVisible(bool visible)
{
	if (visible)
	{
		s3eAdDuplexShow(adDuplexHandle);
	}
	else
	{
		s3eAdDuplexHide(adDuplexHandle);
	}
}

//This function configures Ad duplex the way we want and then called s3eAdDuplexCreate. 
void registerAdDuplex()
{
	char adDuplexID[10] = { 0 };
	if (s3eConfigGetString("AdDuplex", "AdDuplexId", adDuplexID) == S3E_RESULT_SUCCESS)
	{
		s3eAdDuplexRegister(S3E_ADDUPLEX_CALLBACK_ON_CREATED, adDuplexInitCallback, 0);
		s3eAdDuplexRegister(S3E_ADDUPLEX_CALLBACK_ON_LOADED, adDuplexLoadedCallback, 0);
		s3eAdDuplexCreate(adDuplexID);
	}
}

//Called when the app has been sent into the background and is in the process of resuming
int32 ResumeCallback(void* systemData, void* userData)
{
	SceneManager::OnResume();

	//We check when resuming whether the trial status of the app has changed since being suspended. This can
	//happen if the user purchases the game from the store while the app is suspended.
	s3eWindowsStoreBillingIsTrial(&gameIsTrial);

	setAdsVisible(IsTrial());

	return 0;
}

int main()
{
	ResourceInit();    
    InitScores();

	//This will check the status of our game at startup 
	s3eWindowsStoreBillingIsTrial(&gameIsTrial);
	registerAdDuplex();

	//Set our initial scene
    SceneManager::SetScene(SceneManager::SceneIDs::keSceneTitle);
    
	uint32 timer = (uint32)s3eTimerGetMs();

	//Register the callbacks for the pause and unpause events
	s3eDeviceRegister(S3E_DEVICE_PAUSE, (s3eCallback)PauseCallback, NULL);
	s3eDeviceRegister(S3E_DEVICE_UNPAUSE, (s3eCallback)ResumeCallback, NULL);
	

    // Loop forever, until the user or the OS performs some action to quit the app
    while (!s3eDeviceCheckQuitRequest())
    {
		//We need to call these methods to keep the state of the keyboard and any mouse/touch
		//actions valid.
		s3ePointerUpdate();
		s3eKeyboardUpdate();
		

		bool backPressed = s3eKeyboardGetState(s3eKeyBack) & S3E_KEY_STATE_PRESSED;
		if (backPressed)
		{
			SceneManager::OnBackButtonPressed();
		}

		// Check for user quit
		if (s3eDeviceCheckQuitRequest() || SceneManager::QuitRequested())
			break;

		// Calculate the amount of time that's passed since last frame
		int deltaT = uint32(s3eTimerGetMs()) - timer;
		timer += deltaT;

		// Make sure the delta-time value is safe
		if (deltaT < 0) deltaT = 0;
		if (deltaT > 100) deltaT = 100;

		//Pass in deltaT as seconds
        SceneManager::UpdateCurrentScene(deltaT / 1000.0f);

        // Clear the drawing surface
        Iw2DSurfaceClear(0xff000000);
		IwGxLightingOn();

        SceneManager::DrawCurrentScene();

        // Show the drawing surface
		IwGxFlush();
        Iw2DSurfaceShow();

        // Yield to the OS
        s3eDeviceYield(0);
    }
    
	ResourceFree();

    return 0;
}
