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
local totalCount = 3

local timeLimit = 3
local timeLeft

-- local joint = -1

local redBall1
local redBall2
local purpleBall1
local purpleBall2
local purpleTimer

local hideObject
-- local changeColorOnCollision

local function timerDown()
	timeLimit = timeLimit - 1
	timeLeft.text = timeLimit
	if timeLimit == 0 then
		hideObject()
		if (countNum == 0 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = 0, totalCount = 3, id = "level7"}} )
			print("Time Out") -- or do your code for time out
		elseif (countNum < 3 and timeLimit == 0) then
			storyboard.showOverlay( "overmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 3, id = "level7"}} )
		elseif (countNum >= 3 and timeLimit >= 0) then
			storyboard.showOverlay( "nextmenu", {effect = "crossFade", params = {countNum = countNum, totalCount = 3, id = "level7"}} )
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
-- 	obj2:setStrokeColor(205,0,104)
-- end

function hideObject()
	physics.removeBody( redBall1 )
	physics.removeBody( redBall2 )
	physics.removeBody( purpleBall1 )
	physics.removeBody( purpleBall2 )
	physics.removeBody( purpleTimer )
	display.remove( redBall1 )
	display.remove( redBall2 )
	display.remove( purpleBall1 )
	display.remove( purpleBall2 )
	display.remove( purpleTimer )
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

local function onRed2TimerCollision (event)
	local redBall2 = event.target
	if event.phase == "began" then
		if (event.other.type == "static") then
				event.target:setFillColor(128,1,96)
				event.target:setStrokeColor(205,0,104)
				event.target.type = "purpleball"
		end
		if (event.target.type ~= "static" and event.other.type ~= "static") and (event.target.type ~= "redball2" and event.other.type ~= "redball2") then
	        local midX = (( event.target.x + event.target.x ) * 0.5)
			local midY = (( event.other.y + event.other.y ) * 0.5)
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

local function onRed1TimerCollision (event)
	local redBall1 = event.target
	if event.phase == "began" then
		if (event.other.type == "static") then
				event.target:setFillColor(128,1,96)
				event.target:setStrokeColor(205,0,104)
				event.target.type = "purpleball"
		end
		if (event.target.type ~= "static" and event.other.type ~= "static") and (event.target.type ~= "redball1" and event.other.type ~= "redball1") then
	        local midX = (( event.target.x + event.target.x ) * 0.5)
			local midY = (( event.other.y + event.other.y ) * 0.5)
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
	local midX = (( event.target.x + event.target.x ) * 0.5)
	local midY = (( event.other.y + event.other.y ) * 0.5)
	if ( event.phase == "began" ) then
    	if (event.target.type ~= "static" and event.other.type ~= "static") and (event.target.type ~= "redball1" and event.other.type ~= "redball1") and (event.target.type ~= "redball2" and event.other.type ~= "redball2") then
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
	purpleTimer.id = "purpleTimer"
	group:insert(purpleTimer)

	timeLeft = display.newText( timeLimit, 0, 0, "Segoe UI", 30 )
	timeLeft.x = centerX
	timeLeft.y = centerY - 3
	group:insert(timeLeft)

	redBall1 = display.newCircle( centerX, centerY, 14 )
	redBall1.strokeWidth = 3
	redBall1:setFillColor(160,1,1)
	redBall1:setStrokeColor(255,0,0)
	redBall1.x = centerX + 100
	redBall1.y = centerY
	redBall1.id = "redball1"
	redBall1.type = "redball1"
	redBall1.alpha = 0
	transition.to( redBall1, {time = 1000, alpha = 1} )

	redBall2 = display.newCircle( centerX, centerY, 14 )
	redBall2.strokeWidth = 3
	redBall2:setFillColor(160,1,1)
	redBall2:setStrokeColor(255,0,0)
	redBall2.x = centerX + 120
	redBall2.y = centerY + 150
	redBall2.id = "redball2"
	redBall2.type = "redball2"
	redBall2.alpha = 0
	transition.to( redBall2, {time = 1000, alpha = 1} )

	purpleBall1 = display.newCircle( centerX, centerY, 14 )
	purpleBall1.strokeWidth = 3
	purpleBall1:setFillColor(128,1,96)
	purpleBall1:setStrokeColor(205,0,104)
	purpleBall1.x = centerX - 100
	purpleBall1.y = centerY - 30
	purpleBall1.id = "purpleball1"
	purpleBall1.type = "purpleball"
	purpleBall1.alpha = 0
	transition.to( purpleBall1, {time = 1000, alpha = 1} )

	purpleBall2 = display.newCircle( centerX, centerY, 14 )
	purpleBall2.strokeWidth = 3
	purpleBall2:setFillColor(128,1,96)
	purpleBall2:setStrokeColor(205,0,104)
	purpleBall2.x = centerX
	purpleBall2.y = centerY + 100
	purpleBall2.id = "purpleball2"
	purpleBall2.type = "purpleball"
	purpleBall2.alpha = 0
	transition.to( purpleBall2, {time = 1000, alpha = 1} )

	redBall1:addEventListener( "touch", ballsTouched )
	redBall2:addEventListener( "touch", ballsTouched )
	purpleBall1:addEventListener( "touch", ballsTouched )
	purpleBall2:addEventListener( "touch", ballsTouched )

	redBall1:addEventListener( "collision", onRed1TimerCollision )
	redBall2:addEventListener( "collision", onRed2TimerCollision )
	purpleBall1:addEventListener( "collision", onCollision )
	purpleBall2:addEventListener( "collision", onCollision )

	return true
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	physics.addBody( redBall1, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( redBall2, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( purpleBall1, "dynamic", {density = 3, friction = 3, radius = 14 } )
	physics.addBody( purpleBall2, "dynamic", {density = 3, friction = 3, radius = 14 } )
	
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
