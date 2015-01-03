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
local totalCount = 9

local timeLimit = 3
local timeLeft

local redBall1
local redBall2
local redBall3
local redBall4
local redBall5
local redBall6
local redBall7
local redBall8
local redBall9
local redBall10
local redTimer

local hideObject

local function timerDown()
	timeLimit = timeLimit - 1
	timeLeft.text = timeLimit
	if timeLimit == 0 then
		physics.stop( )
		hideObject()
		if (countNum == 0 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = 0, totalCount = 9, id = "level3"}} )
			print("Time Out") -- or do your code for time out
		elseif (countNum < 9 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 9, id = "level3"}} )
		elseif (countNum >= 9 and timeLimit >= 0) then
			storyboard.showOverlay( "nextmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 9, id = "level3"}} )
		end
		timeLimit = 3
	end
	return true
end

local function myJoint(obj1, obj2, x, y)
    physics.newJoint( "weld", obj1, obj2, x, y )
end

function hideObject()
	physics.removeBody( redBall1 )
	physics.removeBody( redBall2 )
	physics.removeBody( redBall3 )
	physics.removeBody( redBall4 )
	physics.removeBody( redBall5 )
	physics.removeBody( redBall6 )
	physics.removeBody( redBall7 )
	physics.removeBody( redBall8 )
	physics.removeBody( redBall9 )
	physics.removeBody( redBall10 )
	physics.removeBody( redTimer )
	display.remove( redBall1 )
	display.remove( redBall2 )
	display.remove( redBall3 )
	display.remove( redBall4 )
	display.remove( redBall5 )
	display.remove( redBall6 )
	display.remove( redBall7 )
	display.remove( redBall8 )
	display.remove( redBall9 )
	display.remove( redBall10 )
	display.remove( redTimer )
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

	levelText = display.newText( "Level 3", 0, 0, "Segoe UI", 24 )
	levelText.x = centerX
	levelText.y = centerY + 260

	scoreText = display.newText( "Score: 0", 0, 0, "Segoe UI", 24 )
	scoreText.x = centerX - 100
	scoreText.y = -20
	score = 0

	count = display.newText( "Collisions: 0/9", 0, 0, "Segoe UI", 24 )
	count.x = centerX + 80
	count.y = -20
	countNum = 0

	local bg = display.newImageRect( "images/bg-red.png", display.contentWidth, display.contentHeight )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x = 0
	bg.y = -40
	bg:toBack( )
	group:insert(bg)

	redTimer = display.newImageRect( "images/redtimer.png", 50, 50 )
	redTimer.x = centerX
	redTimer.y = centerY
	physics.addBody( redTimer, "static", {density=1, friction=0.3, radius = 25 } )
	redTimer.type = "static"
	redTimer.id = "redtimer"
	group:insert(redTimer)

	timeLeft = display.newText( timeLimit, 0, 0, "Segoe UI", 30 )
	timeLeft.x = centerX
	timeLeft.y = centerY - 3
	group:insert(timeLeft)

	redBall1 = display.newCircle( centerX, centerY, 14 )
	redBall1.strokeWidth = 3
	redBall1:setFillColor(160,1,1)
	redBall1:setStrokeColor(255,0,0)
	redBall1.x = centerX + 90
	redBall1.y = centerY
	redBall1.id = "redBall1"
	redBall1.alpha = 0
	transition.to( redBall1, {time = 1000, alpha = 1} )

	redBall2 = display.newCircle( centerX, centerY, 14 )
	redBall2.strokeWidth = 3
	redBall2:setFillColor(160,1,1)
	redBall2:setStrokeColor(255,0,0)
	redBall2.x = centerX - 70
	redBall2.y = centerY - 50
	redBall2.id = "redBall2"
	redBall2.alpha = 0
	transition.to( redBall2, {time = 1000, alpha = 1} )

	redBall3 = display.newCircle( centerX, centerY, 14 )
	redBall3.strokeWidth = 3
	redBall3:setFillColor(160,1,1)
	redBall3:setStrokeColor(255,0,0)
	redBall3.x = centerX
	redBall3.y = centerY + 80
	redBall3.id = "redBall3"
	redBall3.alpha = 0
	transition.to( redBall3, {time = 1000, alpha = 1} )

	redBall4 = display.newCircle( centerX, centerY, 14 )
	redBall4.strokeWidth = 3
	redBall4:setFillColor(160,1,1)
	redBall4:setStrokeColor(255,0,0)
	redBall4.x = centerX - 50
	redBall4.y = centerY + 150
	redBall4.id = "redBall4"
	redBall4.alpha = 0
	transition.to( redBall4, {time = 1000, alpha = 1} )

	redBall5 = display.newCircle( centerX, centerY, 14 )
	redBall5.strokeWidth = 3
	redBall5:setFillColor(160,1,1)
	redBall5:setStrokeColor(255,0,0)
	redBall5.x = centerX - 70
	redBall5.y = centerY - 150
	redBall5.id = "redBall5"
	redBall5.alpha = 0
	transition.to( redBall5, {time = 1000, alpha = 1} )

	redBall6 = display.newCircle( centerX, centerY, 14 )
	redBall6.strokeWidth = 3
	redBall6:setFillColor(160,1,1)
	redBall6:setStrokeColor(255,0,0)
	redBall6.x = centerX - 70
	redBall6.y = centerY - 100
	redBall6.id = "redBall6"
	redBall6.alpha = 0
	transition.to( redBall6, {time = 1000, alpha = 1} )

	redBall7 = display.newCircle( centerX, centerY, 14 )
	redBall7.strokeWidth = 3
	redBall7:setFillColor(160,1,1)
	redBall7:setStrokeColor(255,0,0)
	redBall7.x = centerX - 100
	redBall7.y = centerY - 120
	redBall7.id = "redBall7"
	redBall7.alpha = 0
	transition.to( redBall7, {time = 1000, alpha = 1} )

	redBall8 = display.newCircle( centerX, centerY, 14 )
	redBall8.strokeWidth = 3
	redBall8:setFillColor(160,1,1)
	redBall8:setStrokeColor(255,0,0)
	redBall8.x = centerX - 90
	redBall8.y = centerY + 120
	redBall8.id = "redBall8"
	redBall8.alpha = 0
	transition.to( redBall8, {time = 1000, alpha = 1} )

	redBall9 = display.newCircle( centerX, centerY, 14 )
	redBall9.strokeWidth = 3
	redBall9:setFillColor(160,1,1)
	redBall9:setStrokeColor(255,0,0)
	redBall9.x = centerX + 70
	redBall9.y = centerY - 180
	redBall9.id = "redBall9"
	redBall9.alpha = 0
	transition.to( redBall9, {time = 1000, alpha = 1} )

	redBall10 = display.newCircle( centerX, centerY, 14 )
	redBall10.strokeWidth = 3
	redBall10:setFillColor(160,1,1)
	redBall10:setStrokeColor(255,0,0)
	redBall10.x = centerX + 100
	redBall10.y = centerY - 150
	redBall10.id = "redBall10"
	redBall10.alpha = 0
	transition.to( redBall10, {time = 1000, alpha = 1} )

	redBall1:addEventListener( "touch", ballsTouched )
	redBall2:addEventListener( "touch", ballsTouched )
	redBall3:addEventListener( "touch", ballsTouched )
	redBall4:addEventListener( "touch", ballsTouched )
	redBall5:addEventListener( "touch", ballsTouched )
	redBall6:addEventListener( "touch", ballsTouched )
	redBall7:addEventListener( "touch", ballsTouched )
	redBall8:addEventListener( "touch", ballsTouched )
	redBall9:addEventListener( "touch", ballsTouched )
	redBall10:addEventListener( "touch", ballsTouched )

	redBall1:addEventListener( "collision", onCollision )
	redBall2:addEventListener( "collision", onCollision )
	redBall3:addEventListener( "collision", onCollision )
	redBall4:addEventListener( "collision", onCollision )
	redBall5:addEventListener( "collision", onCollision )
	redBall6:addEventListener( "collision", onCollision )
	redBall7:addEventListener( "collision", onCollision )
	redBall8:addEventListener( "collision", onCollision )
	redBall9:addEventListener( "collision", onCollision )
	redBall10:addEventListener( "collision", onCollision )

	return true
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	physics.addBody( redBall1, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall2, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall3, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall4, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall5, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall6, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall7, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall8, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall9, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall10, "dynamic", {density = 3, friction = 3, radius = 14 } )

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
