local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--==============================================================================================================
-- ************* ADMOB *********************
-- Hide the status bar
-- display.setStatusBar( display.HiddenStatusBar )

-- -- The name of the ad provider.
-- local adNetwork = "admob"

-- -- Your application ID
-- local appID = "*******************************"

-- -- Load Corona 'ads' library
-- local ads = require "ads"

-- -- Initialize the 'ads' library with the provider you wish to use.
-- if appID then
--  ads.init( adNetwork, appID )
-- end

--  -- initial variables
-- local sysModel = system.getInfo("model")
-- local sysEnv = system.getInfo("environment")
-- local bgW, bgH = 320, 480

-- if appID then
--     local adX, adY = display.contentCenterX, 0
--     local W = display.contentWidth
--     local font, size = "Helvetica-Bold", 16
--     if sysEnv == "simulator" then
--         local warningText2 = display.newText( "Please build for device ", adX, adY, font, size )
--         local warningText3 = display.newText( "to test this sample code.", adX, adY, font, size )
--         warningText2:setTextColor( 255, 255, 255)
--         warningText3:setTextColor( 255, 255, 255)
--         warningText2:setReferencePoint( display.CenterReferencePoint )
--         warningText3:setReferencePoint( display.CenterReferencePoint )
--         warningText2.x, warningText2.y = W, 0
--         warningText3.x, warningText3.y = W, 16
--     else
--         ads.show( "banner", { x=adX, y=adY} )
--     end
-- else
--     -- If no appId is set, show a message on the screen
--     local warningText1 = display.newText( "No appID has been set.", 0, 105, font, size )
--     warningText1:setTextColor( 255, 255, 255)
--     warningText1:setReferencePoint( display.CenterReferencePoint )
--     warningText1.x = halfW
-- end

--***************************************************************************************************Ad Code End

-- local forward references should go here --

local function howtoplay( )
	storyboard.gotoScene( "howtoplay", {effect = "crossFade"} )
end

local function playBtnTouched( event )
	local playBtn = event.target
	playBtn.xScale = 0.98
	playBtn.yScale = 0.98
	playBtn.alpha = 0.7
	timer.performWithDelay( 100, howtoplay )
end

local function aboutTouched( event )
	local goto = event.target.gotoScene
		storyboard.showOverlay ( "about", { effect = "crossFade", isModal = true } )
	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- CREATE display objects and add them to 'group' here.
	-- Example use-case: Restore 'group' from previously saved state.

	local bg = display.newImageRect( "images/bg.png", display.contentWidth, display.contentHeight )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x = 0
	bg.y = -40
	bg.alpha = 0
	transition.to( bg, { time = 1000, alpha = 1 })
	bg:toBack( )
	group:insert(bg)

	local title = display.newImageRect( "images/circles.png", 150, 60 )
	title.x = centerX
	title.y = centerY - 195
	title.alpha = 0
	transition.to( title, { time = 1000, alpha = 1 } )
	title:toFront( )
	group:insert(title)

	local playBtn = display.newImageRect( "images/playbutton.png", 146, 146 )
	playBtn.x = centerX
	playBtn.y = centerY
	playBtn.alpha = 0
	transition.to( playBtn, { time = 1000, alpha = 1 } )
	playBtn:toFront( )
	playBtn:addEventListener( "tap", playBtnTouched )
	group:insert(playBtn)

	local about = display.newImageRect( "images/about.png", 65, 20 )
	about.x = centerX
	about.y = centerY + 190
	about.alpha = 0
	about.gotoScene = "about"
	transition.to( about, { time = 1000, alpha = 1 } )
	about:toFront( )
	group:insert(about)
	about:addEventListener( "tap", aboutTouched )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

end


-- Called when scene ieasing.inExpo  alpha = 1,to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	-- Remove listeners attached to the Runtime, timers, transitions, audio tracks

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view

	-- INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	-- Remove listeners attached to the Runtime, timers, transitions, audio tracks

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )


---------------------------------------------------------------------------------

return scene
