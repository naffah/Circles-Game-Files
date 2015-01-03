local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- local forward references should go here --

local function mainMenuTapped( event )
	storyboard.gotoScene( "menu", {effect = "crossFade"} )
	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local bg = display.newImageRect( "images/uc.png", display.contentWidth, display.contentHeight )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x = 0
	bg.y = -40
	bg.alpha = 0
	transition.to( bg, { time = 1000, alpha = 1 })
	bg:toBack( )
	group:insert(bg)

	local mainMenu = display.newImageRect( "images/mainmenu.png", 90, 25 )
	mainMenu.x = centerX
	mainMenu.y = centerY + 140
	group:insert(mainMenu)
	mainMenu:addEventListener( "tap", mainMenuTapped )

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
