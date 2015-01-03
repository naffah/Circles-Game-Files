local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- local forward references should go here --

local id

local function nextLevelTapped( event )
	if id == "level1" then
		storyboard.purgeScene( "level1" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "level2", {time = 10} )
	elseif id == "level2" then
		storyboard.purgeScene( "level2" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "level3", {time = 10} )
	elseif id == "level3" then
		storyboard.purgeScene( "level3" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "level4", {time = 10} )
	elseif id == "level4" then
		storyboard.purgeScene( "level4" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "level5", {time = 10} )
	elseif id == "level5" then
		storyboard.purgeScene( "level5" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "level6", {time = 10} )
	elseif id == "level6" then
		storyboard.purgeScene( "level6" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "level7", {time = 10} )
	elseif id == "level7" then
		storyboard.purgeScene( "level7" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "level8", {time = 10} )
		elseif id == "level8" then
		storyboard.purgeScene( "level8" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "underconstruction", {time = 10} )
	end
	return true
end

local function catchAllTaps( event )
	return true
end

local function mainMenuTapped( event )
	if id == "level1" then
		storyboard.purgeScene( "level1" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "menu" )
	elseif id == "level2" then
		storyboard.purgeScene( "level2" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "menu" )
	elseif id == "level3" then
		storyboard.purgeScene( "level3" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "menu" )
	elseif id == "level4" then
		storyboard.purgeScene( "level4" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "menu" )
	elseif id == "level5" then
		storyboard.purgeScene( "level5" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "menu" )
	elseif id == "level6" then
		storyboard.purgeScene( "level6" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "menu" )
	elseif id == "level7" then
		storyboard.purgeScene( "level7" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "menu" )
	elseif id == "level8" then
		storyboard.purgeScene( "level8" )
		storyboard.hideOverlay( "fade" )
		storyboard.gotoScene( "menu" )
	end
	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local countNum = event.params.countNum
	local totalCount = event.params.totalCount
	id = event.params.id

	local catchAll = display.newRect( screenLeft, screenTop, screenWidth, screenHeight )
	catchAll:setFillColor( 0,0,0 )
	catchAll.alpha = 0.5
	catchAll.isHitTestable = true
	catchAll:toFront( )
	catchAll:addEventListener( "tap", catchAllTaps )
	group:insert(catchAll)

	local bg = display.newRect( screenLeft + 90, screenTop + 200, screenWidth - 90, screenHeight - 200 )
	bg:setFillColor( 10,10,10 )
	bg.x = centerX
	bg.y = centerY
	bg.alpha = 1
	bg:toFront( )
	group:insert( bg )

	local gameOver = display.newText("Congratulations!", centerX - 85, centerY - 150, "Segoe UI", 24)
	group:insert(gameOver)

	local gameOver = display.newText("You got", centerX - 40, centerY - 30, "Segoe UI", 20)
	group:insert(gameOver)

	local count = display.newText(" ", centerX - 10, centerY - 8, "Segoe UI", 18)
	count.text = countNum .. "/" .. totalCount
	group:insert(count)

	local mainMenu = display.newImageRect( "images/mainmenu.png", 90, 25 )
	mainMenu.x = centerX - 60
	mainMenu.y = centerY + 140
	group:insert(mainMenu)
	mainMenu:addEventListener( "tap", mainMenuTapped )

	local nextLevel = display.newImageRect( "images/nextlevel.png", 90, 25 )
	nextLevel.x = centerX + 60
	nextLevel.y = centerY + 140
	group:insert(nextLevel)
	nextLevel:addEventListener( "tap", nextLevelTapped )

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
