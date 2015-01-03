local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--==============================================================================================================
-- ************* ADMOB *********************
-- Hide the status bar
-- display.setStatusBar( display.HiddenStatusBar )

-- -- The name of the ad provider.
-- local adNetwork = "admob"

-- -- Your application ID
-- local appID = "***********************************"

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

local function level1( event )
	storyboard.gotoScene( "level1", {time = 50, effect = "fade"} )
end

local function menu( event )
	storyboard.gotoScene( "menu", {effect = "crossFade"} )
end

local fullHeight = display.contentHeight
local fullWidth = display.contentWidth

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local bg = display.newImageRect( "images/howtoplay.png", display.contentWidth, display.contentHeight )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x = 0
	bg.y = -40
	bg.alpha = 0
	transition.to( bg, { time = 50, alpha = 1 })
	bg:toBack( )
	group:insert(bg)

	local nextText = display.newText("next >>", 0, 0, "Segoe UI", 20 )
	nextText.x = fullWidth - 60
	nextText.y = fullHeight - 120
	nextText:addEventListener( "tap", level1 )
	group:insert(nextText)

	local backText = display.newText("<< back", 0, 0, "Segoe UI", 20 )
	backText.x = fullWidth - 260
	backText.y = fullHeight - 120
	backText:addEventListener( "tap", menu )
	group:insert(backText)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

end


-- Called when scene is about to move offscreen:
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
