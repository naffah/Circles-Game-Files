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
local totalCount = 14

local timeLimit = 3
local timeLeft

local blueBall1
local blueBall2
local blueBall3
local blueBall4
local blueBall5
local blueBall6
local blueBall7
local blueBall8
local blueBall9
local blueBall10
local blueBall11
local blueBall12
local blueBall13
local blueBall14
local blueBall15
local blueTimer

local hideObject

local function timerDown()
	timeLimit = timeLimit - 1
	timeLeft.text = timeLimit
	if timeLimit == 0 then
		hideObject()
		if (countNum == 0 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = 0, totalCount = 14, id = "level4"}} )
			print("Time Out") -- or do your code for time out
		elseif (countNum < 14 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 14, id = "level4"}} )
		elseif (countNum >= 14 and timeLimit >= 0) then
			storyboard.showOverlay( "nextmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 14, id = "level4"}} )
		end
		timeLimit = 3
	end
	return true
end

local function myJoint(obj1, obj2, x, y)
    physics.newJoint( "weld", obj1, obj2, x, y )
end

function hideObject()
	physics.removeBody( blueBall1 )
	physics.removeBody( blueBall2 )
	physics.removeBody( blueBall3 )
	physics.removeBody( blueBall4 )
	physics.removeBody( blueBall5 )
	physics.removeBody( blueBall6 )
	physics.removeBody( blueBall7 )
	physics.removeBody( blueBall8 )
	physics.removeBody( blueBall9 )
	physics.removeBody( blueBall10 )
	physics.removeBody( blueBall11 )
	physics.removeBody( blueBall12 )
	physics.removeBody( blueBall13 )
	physics.removeBody( blueBall14 )
	physics.removeBody( blueBall15 )
	physics.removeBody( blueTimer )
	display.remove( blueBall1 )
	display.remove( blueBall2 )
	display.remove( blueBall3 )
	display.remove( blueBall4 )
	display.remove( blueBall5 )
	display.remove( blueBall6 )
	display.remove( blueBall7 )
	display.remove( blueBall8 )
	display.remove( blueBall9 )
	display.remove( blueBall10 )
	display.remove( blueBall11 )
	display.remove( blueBall12 )
	display.remove( blueBall13 )
	display.remove( blueBall14 )
	display.remove( blueBall15 )
	display.remove( blueTimer )
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

	levelText = display.newText( "Level 4", 0, 0, "Segoe UI", 24 )
	levelText.x = centerX
	levelText.y = centerY + 260

	scoreText = display.newText( "Score: 0", 0, 0, "Segoe UI", 24 )
	scoreText.x = centerX - 100
	scoreText.y = -20
	score = 0

	count = display.newText( "Collisions: 0/14", 0, 0, "Segoe UI", 24 )
	count.x = centerX + 80
	count.y = -20
	countNum = 0

	local bg = display.newImageRect( "images/bg-blue.png", display.contentWidth, display.contentHeight )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x = 0
	bg.y = -40
	bg:toBack( )
	group:insert(bg)

	blueTimer = display.newImageRect( "images/bluetimer.png", 50, 50 )
	blueTimer.x = centerX
	blueTimer.y = centerY
	physics.addBody( blueTimer, "static", {density=1, friction=0.3, radius = 25 } )
	blueTimer.type = "static"
	blueTimer.id = "bluetimer"
	group:insert(blueTimer)

	timeLeft = display.newText( timeLimit, 0, 0, "Segoe UI", 30 )
	timeLeft.x = centerX
	timeLeft.y = centerY - 3
	group:insert(timeLeft)

	blueBall1 = display.newCircle( centerX, centerY, 14 )
	blueBall1.strokeWidth = 3
	blueBall1:setFillColor(64,96,160)
	blueBall1:setStrokeColor(102,153,255)
	blueBall1.x = centerX + 90
	blueBall1.y = centerY
	blueBall1.id = "blueBall1"
	blueBall1.alpha = 0
	transition.to( blueBall1, {time = 1000, alpha = 1} )

	blueBall2 = display.newCircle( centerX, centerY, 14 )
	blueBall2.strokeWidth = 3
	blueBall2:setFillColor(64,96,160)
	blueBall2:setStrokeColor(102,153,255)
	blueBall2.x = centerX - 70
	blueBall2.y = centerY - 50
	blueBall2.id = "blueBall2"
	blueBall2.alpha = 0
	transition.to( blueBall2, {time = 1000, alpha = 1} )

	blueBall3 = display.newCircle( centerX, centerY, 14 )
	blueBall3.strokeWidth = 3
	blueBall3:setFillColor(64,96,160)
	blueBall3:setStrokeColor(102,153,255)
	blueBall3.x = centerX
	blueBall3.y = centerY + 80
	blueBall3.id = "blueBall3"
	blueBall3.alpha = 0
	transition.to( blueBall3, {time = 1000, alpha = 1} )

	blueBall4 = display.newCircle( centerX, centerY, 14 )
	blueBall4.strokeWidth = 3
	blueBall4:setFillColor(64,96,160)
	blueBall4:setStrokeColor(102,153,255)
	blueBall4.x = centerX - 50
	blueBall4.y = centerY + 150
	blueBall4.id = "blueBall4"
	blueBall4.alpha = 0
	transition.to( blueBall4, {time = 1000, alpha = 1} )

	blueBall5 = display.newCircle( centerX, centerY, 14 )
	blueBall5.strokeWidth = 3
	blueBall5:setFillColor(64,96,160)
	blueBall5:setStrokeColor(102,153,255)
	blueBall5.x = centerX - 70
	blueBall5.y = centerY - 150
	blueBall5.id = "blueBall5"
	blueBall5.alpha = 0
	transition.to( blueBall5, {time = 1000, alpha = 1} )

	blueBall6 = display.newCircle( centerX, centerY, 14 )
	blueBall6.strokeWidth = 3
	blueBall6:setFillColor(64,96,160)
	blueBall6:setStrokeColor(102,153,255)
	blueBall6.x = centerX - 70
	blueBall6.y = centerY - 100
	blueBall6.id = "blueBall6"
	blueBall6.alpha = 0
	transition.to( blueBall6, {time = 1000, alpha = 1} )

	blueBall7 = display.newCircle( centerX, centerY, 14 )
	blueBall7.strokeWidth = 3
	blueBall7:setFillColor(64,96,160)
	blueBall7:setStrokeColor(102,153,255)
	blueBall7.x = centerX - 100
	blueBall7.y = centerY - 120
	blueBall7.id = "blueBall7"
	blueBall7.alpha = 0
	transition.to( blueBall7, {time = 1000, alpha = 1} )

	blueBall8 = display.newCircle( centerX, centerY, 14 )
	blueBall8.strokeWidth = 3
	blueBall8:setFillColor(64,96,160)
	blueBall8:setStrokeColor(102,153,255)
	blueBall8.x = centerX - 90
	blueBall8.y = centerY + 120
	blueBall8.id = "blueBall8"
	blueBall8.alpha = 0
	transition.to( blueBall8, {time = 1000, alpha = 1} )

	blueBall9 = display.newCircle( centerX, centerY, 14 )
	blueBall9.strokeWidth = 3
	blueBall9:setFillColor(64,96,160)
	blueBall9:setStrokeColor(102,153,255)
	blueBall9.x = centerX + 70
	blueBall9.y = centerY - 180
	blueBall9.id = "blueBall9"
	blueBall9.alpha = 0
	transition.to( blueBall9, {time = 1000, alpha = 1} )

	blueBall10 = display.newCircle( centerX, centerY, 14 )
	blueBall10.strokeWidth = 3
	blueBall10:setFillColor(64,96,160)
	blueBall10:setStrokeColor(102,153,255)
	blueBall10.x = centerX + 100
	blueBall10.y = centerY - 150
	blueBall10.id = "blueBall10"
	blueBall10.alpha = 0
	transition.to( blueBall10, {time = 1000, alpha = 1} )

	blueBall11 = display.newCircle( centerX, centerY, 14 )
	blueBall11.strokeWidth = 3
	blueBall11:setFillColor(64,96,160)
	blueBall11:setStrokeColor(102,153,255)
	blueBall11.x = centerX
	blueBall11.y = centerY - 180
	blueBall11.id = "blueBall11"
	blueBall11.alpha = 0
	transition.to( blueBall11, {time = 1000, alpha = 1} )

	blueBall12 = display.newCircle( centerX, centerY, 14 )
	blueBall12.strokeWidth = 3
	blueBall12:setFillColor(64,96,160)
	blueBall12:setStrokeColor(102,153,255)
	blueBall12.x = centerX + 100
	blueBall12.y = centerY + 150
	blueBall12.id = "blueBall12"
	blueBall12.alpha = 0
	transition.to( blueBall12, {time = 1000, alpha = 1} )

	blueBall13 = display.newCircle( centerX, centerY, 14 )
	blueBall13.strokeWidth = 3
	blueBall13:setFillColor(64,96,160)
	blueBall13:setStrokeColor(102,153,255)
	blueBall13.x = centerX - 80
	blueBall13.y = centerY + 150
	blueBall13.id = "blueBall13"
	blueBall13.alpha = 0
	transition.to( blueBall13, {time = 1000, alpha = 1} )

	blueBall14 = display.newCircle( centerX, centerY, 14 )
	blueBall14.strokeWidth = 3
	blueBall14:setFillColor(64,96,160)
	blueBall14:setStrokeColor(102,153,255)
	blueBall14.x = centerX + 30
	blueBall14.y = centerY - 40
	blueBall14.id = "blueBall14"
	blueBall14.alpha = 0
	transition.to( blueBall14, {time = 1000, alpha = 1} )

	blueBall15 = display.newCircle( centerX, centerY, 14 )
	blueBall15.strokeWidth = 3
	blueBall15:setFillColor(64,96,160)
	blueBall15:setStrokeColor(102,153,255)
	blueBall15.x = centerX + 25
	blueBall15.y = centerY + 185
	blueBall15.id = "blueBall15"
	blueBall15.alpha = 0
	transition.to( blueBall15, {time = 1000, alpha = 1} )

	blueBall1:addEventListener( "touch", ballsTouched )
	blueBall2:addEventListener( "touch", ballsTouched )
	blueBall3:addEventListener( "touch", ballsTouched )
	blueBall4:addEventListener( "touch", ballsTouched )
	blueBall5:addEventListener( "touch", ballsTouched )
	blueBall6:addEventListener( "touch", ballsTouched )
	blueBall7:addEventListener( "touch", ballsTouched )
	blueBall8:addEventListener( "touch", ballsTouched )
	blueBall9:addEventListener( "touch", ballsTouched )
	blueBall10:addEventListener( "touch", ballsTouched )
	blueBall11:addEventListener( "touch", ballsTouched )
	blueBall12:addEventListener( "touch", ballsTouched )
	blueBall13:addEventListener( "touch", ballsTouched )
	blueBall14:addEventListener( "touch", ballsTouched )
	blueBall15:addEventListener( "touch", ballsTouched )

	blueBall1:addEventListener( "collision", onCollision )
	blueBall2:addEventListener( "collision", onCollision )
	blueBall3:addEventListener( "collision", onCollision )
	blueBall4:addEventListener( "collision", onCollision )
	blueBall5:addEventListener( "collision", onCollision )
	blueBall6:addEventListener( "collision", onCollision )
	blueBall7:addEventListener( "collision", onCollision )
	blueBall8:addEventListener( "collision", onCollision )
	blueBall9:addEventListener( "collision", onCollision )
	blueBall10:addEventListener( "collision", onCollision )
	blueBall11:addEventListener( "collision", onCollision )
	blueBall12:addEventListener( "collision", onCollision )
	blueBall13:addEventListener( "collision", onCollision )
	blueBall14:addEventListener( "collision", onCollision )
	blueBall15:addEventListener( "collision", onCollision )

	return true
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	physics.addBody( blueBall1, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall2, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall3, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall4, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall5, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall6, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall7, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall8, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall9, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall10, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall11, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall12, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall13, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall14, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( blueBall15, "dynamic", {density = 3, friction = 3, radius = 14 } )

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
