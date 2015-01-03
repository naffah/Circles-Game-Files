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
local totalCount = 2

local timeLimit = 3
local timeLeft

-- local joint = -1

local orangeBall
local greenBall1
local greenBall2
local greenTimer

local hideObject
local changeColorOnCollision

local function timerDown()
	timeLimit = timeLimit - 1
	timeLeft.text = timeLimit
	if timeLimit == 0 then
		hideObject()
		if (countNum == 0 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = 0, totalCount = 2, id = "level6"}} )
			print("Time Out") -- or do your code for time out
		elseif (countNum < 2 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 2, id = "level6"}} )
		elseif (countNum >= 2 and timeLimit >= 0) then
			storyboard.showOverlay( "nextmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 2, id = "level6"}} )
		end
		timeLimit = 3
	end
	return true
end

local function myJoint(obj1, obj2, x, y)
    local newObj = physics.newJoint( "weld", obj1, obj2, x, y )
 --    newObj.type = "dynamic"
	-- joint = joint + 1
	-- if (joint == 0) then
	-- 	newObj:addEventListener( "collision", changeColorOnCollision )
	-- end
	-- joint = 0
end

-- local function myJoint2(obj1, obj2, x, y)
-- 	physics.newJoint( "weld", obj1, obj2, x, y )
--     obj2:setFillColor(0,160,0)
-- 	obj2:setStrokeColor(0,236,0)
-- end

function hideObject()
	physics.removeBody( orangeBall )
	physics.removeBody( greenBall1 )
	physics.removeBody( greenBall2 )
	physics.removeBody( greenTimer )
	display.remove( orangeBall )
	display.remove( greenBall1 )
	display.remove( greenBall2 )
	display.remove( greenTimer )
	display.remove( scoreText )
	display.remove( count )
	display.remove( levelText )
	return true
end

-- function changeColorOnCollision (event)
-- 	if (event.target.type ~= "static" and event.other.type ~= "static") then
-- 		local midX = (( event.target.x + event.target.x ) * 0.5)
-- 		local midY = (( event.other.y + event.other.y ) * 0.5)
-- 	    timer.performWithDelay( 1, function() myJoint2(event.target, event.other, midX, midY) end )
-- 	    score = score + 25
-- 		scoreText.text = "Score: " .. score
-- 		countNum = countNum + 1
-- 		count.text = "Collision: " .. countNum .. "/" .. totalCount
-- 	end
-- end

local function onTimerCollision (event)
	local orangeBall = event.target
	if event.phase == "began" then
		if (event.other.type == "static") then
				event.target:setFillColor(0,160,0)
				event.target:setStrokeColor(0,236,0)
				event.target.type = "greenball"
		end
		if (event.target.type ~= "static" and event.other.type ~= "static") and (event.target.type ~= "orangeball" and event.other.type ~= "orangeball") then
	        local midX = (( event.target.x + event.other.x ) * 0.5)
			local midY = (( event.target.y + event.other.y ) * 0.5)
	        timer.performWithDelay( 1, function() myJoint(event.target, event.other, midX, midY) end )
	        score = score + 25
			scoreText.text = "Score: " .. score
			countNum = countNum + 1
			count.text = "Collision: " .. countNum .. "/" .. totalCount
		end
	elseif event.phase == "ended" then
		print ("phase ended")
	end
	return true
end

local function onCollision( event )
    print("collision")
    physics.setAverageCollisionPositions( true )
    physics.setReportCollisionsInContentCoordinates( true )
	local midX = (( event.target.x + event.other.x ) * 0.5)
	local midY = (( event.target.y + event.other.y ) * 0.5)
	if ( event.phase == "began" ) then
    	if (event.target.type ~= "static" and event.other.type ~= "static") and (event.target.type ~= "orangeball" and event.other.type ~= "orangeball") then
            timer.performWithDelay( 1, function() myJoint(event.target, event.other, midX, midY) end )
            score = score + 25
			scoreText.text = "Score: " .. score
			countNum = countNum + 1
			count.text = "Collision: " .. countNum .. "/" .. totalCount
        elseif ( event.phase == "ended" ) then
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

	levelText = display.newText( "Level 7", 0, 0, "Segoe UI", 24 )
	levelText.x = centerX
	levelText.y = centerY + 260

	scoreText = display.newText( "Score: 0", 0, 0, "Segoe UI", 24 )
	scoreText.x = centerX - 100
	scoreText.y = -20
	score = 0

	count = display.newText( "Collisions: 0/2", 0, 0, "Segoe UI", 24 )
	count.x = centerX + 80
	count.y = -20
	countNum = 0

	local bg = display.newImageRect( "images/bg-green.png", display.contentWidth, display.contentHeight )
	bg:setReferencePoint( display.TopLeftReferencePoint )
	bg.x = 0
	bg.y = -40
	bg:toBack( )
	group:insert(bg)

	greenTimer = display.newImageRect( "images/greentimer.png", 50, 50 )
	greenTimer.x = centerX
	greenTimer.y = centerY
	physics.addBody( greenTimer, "static", {density=1, friction=0.3, radius = 25 } )
	greenTimer.type = "static"
	greenTimer.id = "greenTimer"
	group:insert(greenTimer)

	timeLeft = display.newText( timeLimit, 0, 0, "Segoe UI", 30 )
	timeLeft.x = centerX
	timeLeft.y = centerY - 3
	group:insert(timeLeft)

	orangeBall = display.newCircle( centerX, centerY, 14 )
	orangeBall.strokeWidth = 3
	orangeBall:setFillColor(168,67,0)
	orangeBall:setStrokeColor(200,152,6)
	orangeBall.x = centerX + 100
	orangeBall.y = centerY
	orangeBall.id = "orangeball"
	orangeBall.type = "orangeball"
	orangeBall.alpha = 0
	transition.to( orangeBall, {time = 1000, alpha = 1} )

	greenBall1 = display.newCircle( centerX, centerY, 14 )
	greenBall1.strokeWidth = 3
	greenBall1:setFillColor(0,160,0)
	greenBall1:setStrokeColor(0,236,0)
	greenBall1.x = centerX - 100
	greenBall1.y = centerY - 30
	greenBall1.id = "greenball1"
	greenBall1.type = "greenball"
	greenBall1.alpha = 0
	transition.to( greenBall1, {time = 1000, alpha = 1} )

	greenBall2 = display.newCircle( centerX, centerY, 14 )
	greenBall2.strokeWidth = 3
	greenBall2:setFillColor(0,160,0)
	greenBall2:setStrokeColor(0,236,0)
	greenBall2.x = centerX
	greenBall2.y = centerY + 100
	greenBall2.id = "greenball2"
	greenBall2.type = "greenball"
	greenBall2.alpha = 0
	transition.to( greenBall2, {time = 1000, alpha = 1} )

	orangeBall:addEventListener( "touch", ballsTouched )
	greenBall1:addEventListener( "touch", ballsTouched )
	greenBall2:addEventListener( "touch", ballsTouched )

	orangeBall:addEventListener( "collision", onTimerCollision )
	greenBall1:addEventListener( "collision", onCollision )
	greenBall2:addEventListener( "collision", onCollision )

	return true
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	physics.addBody( orangeBall, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( greenBall1, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( greenBall2, "dynamic", {density = 3, friction = 3, radius = 14 } )
	
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
