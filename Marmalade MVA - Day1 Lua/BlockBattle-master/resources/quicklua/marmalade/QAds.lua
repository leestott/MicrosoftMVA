ads = {}
ads.currentWebView = nil
ads.currentAdProvider = nil
ads.currentAdType = nil
ads.currentAdId = nil
ads.currentAdY = nil
ads.currentAdheight = nil

function ads:isAvailable()
	if (nui:isWebViewAvailable()) then
		local platform = device:getInfo("platform")
		-- Desktop is allowed so testing can be done on simulator
		if (platform == "ANDROID" or platform == "IPHONE" or platform == "WINDOWS" or platform == "OSX") then
			return true
		end
	end

	return false
end

function ads:navigateAd(html, yPos, height)
	-- Create html to display ad
	local htmlfile = io.open("ad_html.html", "w")
	htmlfile:write(html)
	htmlfile:close()
	
	if (ads.currentWebView == nil) then
		ads.currentWebView = nui:createWebView( {
			x = 0, y = yPos, 
			w = director.displayWidth, h = height, 
			transparentBackground = true, 
			url = "ram://ad_html.html"
			} )
	else
		ads.currentWebView.isVisible = true;
		ads.currentWebView.url = "ram://ad_html.html"
		ads.currentWebView.y = yPos;
		ads.currentWebView.h = height;
	end
end

function ads:newInneractiveAd(yPos, height, adType, adId)
	local portal_id
	local platform = device:getInfo("platform")
	if (platform == "ANDROID") then
		portal_id = "559"
	elseif (platform == "IPHONE") then
		portal_id = "642"
	else
		dbg.log("Platform " .. platform .. " not supported.")
		return false
	end
	
	local interstitial
	if (adType == "banner") then
		interstitial = "false"
	elseif (adType == "interstitial") then
		interstitial = "true"
	else
		dbg.log("Unknown ad type requested: " .. adType .. ".")
		return false
	end

	-- Create html to display ad
	local html = [[
	<html>
		<head>
			<meta name="viewport" content="width=device-width, initial-scale=1.0, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
			<style>
				#iaAdContainerDiv {
					text-align: center;
				}
			</style>
		</head>
		<body>
			<script>
				var APP_ID = "]] .. adId .. [["; 
				var PORTAL = ]] .. portal_id .. [[; 
				var CATEGORY = ""; 
				var KEYWORDS = ""; 
				var GPS_COORDINATES = ""; 
				var LOCATION = ""; 
				var IMPRESSION_PIXEL = ""; 
				var CLICK_PIXEL = ""; 
				var FAILOVER = "No ad"; 
				var IS_MOBILE_WEB = false; 
				var IS_ORMMA_SUPPORT = false; 
				var IS_MRAID_SUPPORT = false; 
				var IS_INTERSTITIAL_AD = ]] .. interstitial .. [[; 
	 
				document.write("<script language='javascript' src='http://ad-tag.inner-active.mobi/simpleM2M/RequestTagAd?v=" + ((IS_ORMMA_SUPPORT) ? ((IS_MRAID_SUPPORT) ? "Stag-2.1.0&f=116" : "Stag-2.1.0&f=52") : ((IS_MRAID_SUPPORT) ? "Stag-2.1.0&f=84" : "Stag-2.0.1&f=20")) + ((IS_INTERSTITIAL_AD) ? "&fs=true" : "&fs=false") + "&aid=" + encodeURIComponent(APP_ID) + "&po=" + PORTAL + "&c=" + encodeURIComponent(CATEGORY) + "&k=" + encodeURIComponent(KEYWORDS) + ((FAILOVER) ? "&noadstring=" + encodeURIComponent(FAILOVER) : "&test=true") + "&lg=" + encodeURIComponent(GPS_COORDINATES) + "&l=" + encodeURIComponent(LOCATION) + "&mw=" + ((IS_MOBILE_WEB) ? "true" : "false") + "'><\/script>"); 
			</script>
		</body>
	</html>]]
	ads:navigateAd(html, yPos, height)
	return true
end

function ads:newLeadboltAd(yPos, height, adType, adId)
	if (adType == "wall") then
		if (ads.currentWebView == nil) then
			ads.currentWebView = nui:createWebView( {
				x = 0, y = yPos, 
				w = director.displayWidth, h = height, 
				transparentBackground = true, 
				url = "http://ad.leadboltads.net/show_app_wall?section_id=" .. adId
				} )
		else
			ads.currentWebView.isVisible = true;
			ads.currentWebView.url = "http://ad.leadboltads.net/show_app_wall?section_id=" .. adId
			ads.currentWebView.y = yPos;
			ads.currentWebView.h = height;
		end
		return true
	elseif (adType ~= "banner") then
		return false
	end
	
	-- Create html to display ad
	local html = [[
	<html>
		<head>
			<meta name="viewport" content="width=device-width, initial-scale=1.0, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
		</head>
		<body style='margin:0;padding:0;text-align: center;'>
			<script type='text/javascript' src='http://ad.leadboltads.net/show_app_ad.js?section_id=]] .. adId .. [['></script>
		</body>
	</html>]]
	ads:navigateAd(html, yPos, height)
	return true
end

function ads:newAdmodaAd(yPos, height, adType, adId)
	if (adType ~= "banner") then
		return false
	end
	-- Create html to display ad
	local html = [[
	<html>
		<head>
			<meta name="viewport" content="width=device-width, initial-scale=1.0, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
		</head>
		<body style='margin:0;padding:0;text-align: center;'>
			<script src="http://www.admoda.com/ads/jsbannertext.php?v=4&l=javascript&z=]] .. adId .. [["></script>
		</body>
	</html>]]
	ads:navigateAd(html, yPos, height)
	return true
end


function ads:newAd(yPos, height, adProvider, adType, adId)
	if (nui:isWebViewAvailable()) then
		yPos = director.displayHeight - yPos
		-- Show Ad
		self.currentAdProvider = adProvider
		self.currentAdType = adType
		self.currentAdId = adId
		self.currentAdY = yPos
		self.currentAdHeight = height
		if (adProvider == "inneractive") then
			return ads:newInneractiveAd(yPos, height, adType, adId)
		elseif (adProvider == "leadbolt") then
			return ads:newLeadboltAd(yPos, height, adType, adId)
		elseif (adProvider == "admoda") then
			return ads:newAdmodaAd(yPos, height, adType, adId)
		else
			dbg.log("Ad provider " .. adProvider .. " not supported.")
		end
	else
		dbg.log("ads requires QWebView which is not supported on this platform.")
	end

	return false
end

function ads:show(visibility)
	if (ads.currentWebView ~= nil) then
		ads.currentWebView.isVisible = visibility;
	end
end

-- Web view events handler
function adsWebViewLoadedEvent(event)
	if (event.type == "error") then
		dbg.print("Error loading ad " .. event.url)
	elseif (event.type == "startedLoading") then
		if (ads.currentAdProvider == "leadbolt" and string.find(event.url, "show_app_ad?") ~= nil) then
			-- Special case for leadbolt that prevents redirects being recognmised as an ad click
		elseif (ads.currentAdType == "wall") then
			-- Special case for leadbolt app wall ads, these do not open in a new browser window
		else
			print("Loading URL: " .. event.url)
			if (string.find(event.url, "http:") ~= nil) then
				-- If the tapped link is a web site then open it using the system
				dbg.print("Launching ad with url " .. event.url)
				browser:launchURL(event.url, false)
				-- Show new ad
				ads:newAd(ads.currentAdY, ads.currentAdHeight, ads.currentAdProvider, ads.currentAdType, ads.currentAdId)
			end
		end
	elseif (event.type == "loaded") then
		dbg.print("Ad page loaded " .. event.url)
	end
end

function ads:init()
	-- Set up event listener
	if (nui:isWebViewAvailable()) then
		-- Add web view event handler
		system:addEventListener("webViewLoaded", adsWebViewLoadedEvent)
	end
end

