local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- local forward references should go here --

local physics = require( "physics" )
physics:start()
physics.setDrawMode( "normal" )
physics.setGravity( 0, 0 )

local score = 0
local scoreText

local countNum = 0
local count
local totalCount = 4

local timeLimit = 4
local timeLeft

local purpleBall1
local purpleBall2
local purpleBall3
local purpleBall4
local purpleBall5
local purpleTimer

local hideObject

local function timerDown()
	timeLimit = timeLimit - 1
	timeLeft.text = timeLimit
	if timeLimit == 0 then
		physics.stop( )
		hideObject()
		if (countNum == 0 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = 0, totalCount = 4, id = "level2"}} )
			print("Time Out") -- or do your code for time out
		elseif (countNum < 4 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 4, id = "level2"}} )
		elseif (countNum >= 4 and timeLimit >= 0) then
			storyboard.showOverlay( "nextmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 4, id = "level2"}} )
		end
		timeLimit = 4
	end
	return true
end

local function myJoint(obj1, obj2, x, y)
    physics.newJoint( "weld", obj1, obj2, x, y )
end

function hideObject()
	physics.removeBody( purpleBall1 )
	physics.removeBody( purpleBall2 )
	physics.removeBody( purpleBall3 )
	physics.removeBody( purpleBall4 )
	physics.removeBody( purpleBall5 )
	physics.removeBody( purpleTimer )
	display.remove( purpleBall1 )
	display.remove( purpleBall2 )
	display.remove( purpleBall3 )
	display.remove( purpleBall4 )
	display.remove( purpleBall5 )
	display.remove( purpleTimer )
	display.remove( scoreText )
	display.remove( count )
	display.remove( levelText )
	return true
end

local function onCollision( event )
    print("collision")
    physics.setAverageCollisionPositions( true )
    physics.setReportCollisionsInContentCoordinates( true )
    local obj1 = event.target
    local obj2 = event.other
	local midX = (( event.target.x + event.other.x ) * 0.5)
	local midY = (( event.target.y + event.other.y ) * 0.5)
    if event.target.type ~= "static" and event.other.type ~= "static" then
        if ( event.phase == "began" ) then
            --transition.to( event.target, {time = 10000, xScale=1.2, yScale=1.2, alpha=0} )
            --transition.to( event.other, {time = 10000, xScale=1.2, yScale=1.2, alpha=0} )
            timer.performWithDelay( 1, function() myJoint(obj1, obj2, midX, midY) end )
            score = score + 25
			scoreText.text = "Score: " .. score
        elseif ( event.phase == "ended" ) then
			countNum = countNum + 1
			count.text = "Collision: " .. countNum .. "/" .. totalCount
            print("phase ended")
        end
    end
    return true
end

function ballsTouched(event)
	-- touch event
	local obj = event.target
	if event.phase == "began" then
		display.getCurrentStage():setFocus(obj)
		obj.startMoveX = obj.x
		obj.startMoveY = obj.y
	elseif event.phase == "moved" then
		obj.x = (event.x - event.xStart) + obj.startMoveX
		obj.y = (event.y - event.yStart) + obj.startMoveY
		--obj.x=event.x; obj.y=event.y
	elseif event.phase == "ended" or event.phase == "cancelled" then
		display.getCurrentStage():setFocus(nil)
	end
	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	levelText = display.newText( "Level 2", 0, 0, "Segoe UI", 24 )
	levelText.x = centerX
	levelText.y = centerY + 260

	scoreText = display.newText( "Score: 0", 0, 0, "Segoe UI", 24 )
	scoreText.x = centerX - 100
	scoreText.y = -20
	score = 0

	count = display.newText( "Collisions: 0/4", 0, 0, "Segoe UI", 24 )
	count.x = centerX + 80
	count.y = -20
	countNum = 0

	local bg = display.newImageRect( "images/bg-purple.png", display.contentWidth, display.contentHeight )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x = 0
	bg.y = -40
	bg:toBack( )
	group:insert(bg)

	purpleTimer = display.newImageRect( "images/purpletimer.png", 50, 50 )
	purpleTimer.x = centerX
	purpleTimer.y = centerY
	physics.addBody( purpleTimer, "static", {density=1, friction=0.3, radius = 25 } )
	purpleTimer.type = "static"
	purpleTimer.id = "purpletimer"
	group:insert(purpleTimer)

	timeLeft = display.newText( timeLimit, 0, 0, "Segoe UI", 30 )
	timeLeft.x = centerX
	timeLeft.y = centerY - 3
	group:insert(timeLeft)

	purpleBall1 = display.newCircle( centerX, centerY, 14 )
	purpleBall1.strokeWidth = 3
	purpleBall1:setFillColor(128,1,96)
	purpleBall1:setStrokeColor(205,0,104)
	purpleBall1.x = centerX + 90
	purpleBall1.y = centerY
	purpleBall1.id = "purpleBall1"
	purpleBall1.alpha = 0
	transition.to( purpleBall1, {time = 1000, alpha = 1} )

	purpleBall2 = display.newCircle( centerX, centerY, 14 )
	purpleBall2.strokeWidth = 3
	purpleBall2:setFillColor(128,1,96)
	purpleBall2:setStrokeColor(205,0,104)
	purpleBall2.x = centerX - 70
	purpleBall2.y = centerY - 50
	purpleBall2.id = "purpleBall2"
	purpleBall2.alpha = 0
	transition.to( purpleBall2, {time = 1000, alpha = 1} )

	purpleBall3 = display.newCircle( centerX, centerY, 14 )
	purpleBall3.strokeWidth = 3
	purpleBall3:setFillColor(128,1,96)
	purpleBall3:setStrokeColor(205,0,104)
	purpleBall3.x = centerX
	purpleBall3.y = centerY + 80
	purpleBall3.id = "purpleBall3"
	purpleBall3.alpha = 0
	transition.to( purpleBall3, {time = 1000, alpha = 1} )

	purpleBall4 = display.newCircle( centerX, centerY, 14 )
	purpleBall4.strokeWidth = 3
	purpleBall4:setFillColor(128,1,96)
	purpleBall4:setStrokeColor(205,0,104)
	purpleBall4.x = centerX - 50
	purpleBall4.y = centerY + 150
	purpleBall4.id = "purpleBall4"
	purpleBall4.alpha = 0
	transition.to( purpleBall4, {time = 1000, alpha = 1} )

	purpleBall5 = display.newCircle( centerX, centerY, 14 )
	purpleBall5.strokeWidth = 3
	purpleBall5:setFillColor(128,1,96)
	purpleBall5:setStrokeColor(205,0,104)
	purpleBall5.x = centerX - 70
	purpleBall5.y = centerY - 150
	purpleBall5.id = "purpleBall5"
	purpleBall5.alpha = 0
	transition.to( purpleBall5, {time = 1000, alpha = 1} )

	purpleBall1:addEventListener( "touch", ballsTouched )
	purpleBall2:addEventListener( "touch", ballsTouched )
	purpleBall3:addEventListener( "touch", ballsTouched )
	purpleBall4:addEventListener( "touch", ballsTouched )
	purpleBall5:addEventListener( "touch", ballsTouched )

	purpleBall1:addEventListener( "collision", onCollision )
	purpleBall2:addEventListener( "collision", onCollision )
	purpleBall3:addEventListener( "collision", onCollision )
	purpleBall4:addEventListener( "collision", onCollision )
	purpleBall5:addEventListener( "collision", onCollision )

	return true
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	physics.addBody( purpleBall1, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( purpleBall2, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( purpleBall3, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( purpleBall4, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( purpleBall5, "dynamic", {density = 3, friction = 3, radius = 14 } )

	timer.performWithDelay(1000, timerDown, timeLimit)

	return true
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
