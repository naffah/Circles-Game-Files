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

local timeLimit = 3
local timeLeft

local orangeBall1
local orangeBall2
local orangeBall3
local orangeBall4
local orangeBall5
local orangeTimer

local hideObject

local function timerDown()
	timeLimit = timeLimit - 1
	timeLeft.text = timeLimit
	if timeLimit == 0 then
		physics.stop( )
		hideObject()
		if (countNum == 0 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = 0, totalCount = 4, id = "level5"}} )
			print("Time Out") -- or do your code for time out
		elseif (countNum < 4 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 4, id = "level5"}} )
		elseif (countNum >= 4 and timeLimit >= 0) then
			storyboard.showOverlay( "nextmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 4, id = "level5"}} )
		end
		timeLimit = 3
	end
	return true
end

local function myJoint(obj1, obj2, x, y)
    physics.newJoint( "weld", obj1, obj2, x, y )
end

function hideObject()
	physics.removeBody( orangeBall1 )
	physics.removeBody( orangeBall2 )
	physics.removeBody( orangeBall3 )
	physics.removeBody( orangeBall4 )
	physics.removeBody( orangeBall5 )
	physics.removeBody( orangeTimer )
	display.remove( orangeBall1 )
	display.remove( orangeBall2 )
	display.remove( orangeBall3 )
	display.remove( orangeBall4 )
	display.remove( orangeBall5 )
	display.remove( orangeTimer )
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

	levelText = display.newText( "Level 5", 0, 0, "Segoe UI", 24 )
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

	local bg = display.newImageRect( "images/bg-orange.png", display.contentWidth, display.contentHeight )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x = 0
	bg.y = -40
	bg:toBack( )
	group:insert(bg)

	orangeTimer = display.newImageRect( "images/orangetimer.png", 50, 50 )
	orangeTimer.x = centerX
	orangeTimer.y = centerY
	physics.addBody( orangeTimer, "static", {density=1, friction=0.3, radius = 25 } )
	orangeTimer.type = "static"
	orangeTimer.id = "orangetimer"
	group:insert(orangeTimer)

	timeLeft = display.newText( timeLimit, 0, 0, "Segoe UI", 30 )
	timeLeft.x = centerX
	timeLeft.y = centerY - 3
	group:insert(timeLeft)

	orangeBall1 = display.newCircle( centerX, centerY, 14 )
	orangeBall1.strokeWidth = 3
	orangeBall1:setFillColor(168,67,0)
	orangeBall1:setStrokeColor(200,152,6)
	orangeBall1.x = centerX + 90
	orangeBall1.y = centerY
	orangeBall1.id = "orangeBall1"
	orangeBall1.alpha = 0
	transition.to( orangeBall1, {time = 1000, alpha = 1} )

	orangeBall2 = display.newCircle( centerX, centerY, 14 )
	orangeBall2.strokeWidth = 3
	orangeBall2:setFillColor(168,67,0)
	orangeBall2:setStrokeColor(200,152,6)
	orangeBall2.x = centerX - 70
	orangeBall2.y = centerY - 50
	orangeBall2.id = "orangeBall2"
	orangeBall2.alpha = 0
	transition.to( orangeBall2, {time = 1000, alpha = 1} )

	orangeBall3 = display.newCircle( centerX, centerY, 14 )
	orangeBall3.strokeWidth = 3
	orangeBall3:setFillColor(168,67,0)
	orangeBall3:setStrokeColor(200,152,6)
	orangeBall3.x = centerX
	orangeBall3.y = centerY + 80
	orangeBall3.id = "orangeBall3"
	orangeBall3.alpha = 0
	transition.to( orangeBall3, {time = 1000, alpha = 1} )

	orangeBall4 = display.newCircle( centerX, centerY, 14 )
	orangeBall4.strokeWidth = 3
	orangeBall4:setFillColor(168,67,0)
	orangeBall4:setStrokeColor(200,152,6)
	orangeBall4.x = centerX - 50
	orangeBall4.y = centerY + 150
	orangeBall4.id = "orangeBall4"
	orangeBall4.alpha = 0
	transition.to( orangeBall4, {time = 1000, alpha = 1} )

	orangeBall5 = display.newCircle( centerX, centerY, 14 )
	orangeBall5.strokeWidth = 3
	orangeBall5:setFillColor(168,67,0)
	orangeBall5:setStrokeColor(200,152,6)
	orangeBall5.x = centerX - 70
	orangeBall5.y = centerY - 150
	orangeBall5.id = "orangeBall5"
	orangeBall5.alpha = 0
	transition.to( orangeBall5, {time = 1000, alpha = 1} )

	orangeBall1:addEventListener( "touch", ballsTouched )
	orangeBall2:addEventListener( "touch", ballsTouched )
	orangeBall3:addEventListener( "touch", ballsTouched )
	orangeBall4:addEventListener( "touch", ballsTouched )
	orangeBall5:addEventListener( "touch", ballsTouched )

	orangeBall1:addEventListener( "collision", onCollision )
	orangeBall2:addEventListener( "collision", onCollision )
	orangeBall3:addEventListener( "collision", onCollision )
	orangeBall4:addEventListener( "collision", onCollision )
	orangeBall5:addEventListener( "collision", onCollision )

	return true
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	physics.addBody( orangeBall1, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( orangeBall2, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( orangeBall3, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( orangeBall4, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( orangeBall5, "dynamic", {density = 3, friction = 3, radius = 14 } )

	timer.performWithDelay(1200, timerDown, timeLimit)

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
