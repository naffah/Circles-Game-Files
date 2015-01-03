local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- local forward references should go here --

local function backTapped( event )
	storyboard.hideOverlay( "fade" )
	return true
end

local function catchAllTaps( event )
	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local catchAll = display.newRect( screenLeft, screenTop, screenWidth, screenHeight )
	catchAll:setFillColor( 0,0,0 )
	catchAll.alpha = 0.5
	catchAll.isHitTestable = true
	catchAll:addEventListener( "tap", catchAllTaps )
	group:insert(catchAll)

	local bg = display.newRect( screenLeft + 90, screenTop + 400, screenWidth - 90, screenHeight - 400 )
	bg:setFillColor( 10,10,10 )
	bg.x = centerX
	bg.y = centerY
	bg.alpha = 1
	group:insert( bg )	

	local text = display.newText("Developers:", centerX - 60, centerY - 70, "Segoe UI", 24)
	local name1 = display.newText ("Naffah Amin", centerX - 60, centerY - 30, "Segoe UI", 16)
	local name2 = display.newText ("Uzair Zia", centerX - 60, centerY - 10, "Segoe UI", 16)
	local name3 = display.newText ("Hamza Ahmad", centerX - 60, centerY + 10, "Segoe UI", 16)
	group:insert( text )
	group:insert( name1 )
	group:insert( name2 )
	group:insert( name3 )

	local back = display.newImageRect( "images/back.png", 70, 25 )
	back.x = centerX
	back.y = centerY + 60
	group:insert(back)
	back:addEventListener( "tap", backTapped )

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
