SCALE = 1

TILESIZE = 16

SCREENWIDTH = 400
SCREENHEIGHT = 240

BOTTOMSCREENWIDTH = 320
BOTTOMSCREENHEIGHT = 240
BOTTOMSCREENOFFSET = 40

WIDTH = SCREENWIDTH/TILESIZE
HEIGHT = SCREENHEIGHT/TILESIZE

GRAVITY = 80
GRAVITYJUMPING = 30 --gravity while jumping (Only for mario)
MAXYSPEED = 100

JUMPFORCE = 16--16
JUMPFORCEADD = 1.9 --how much jumpforce is added at top speed (linear from 0 to topspeed)

WALKACCELERATION = 8 --acceleration of walking on ground
RUNACCELERATION = 16 --acceleration of running on ground
WALKACCELERATIONAIR = 8 --acceleration of walking in the air
RUNACCLERATIONAIR = 16 --acceleration of running in the air
MINSPEED = 0.7 --When FRICTION is in effect and speed falls below this, speed is set to 0
MAXWALKSPEED = 6.4 --fastest speedx when walking
MAXRUNSPEED = 9.0 --fastest speedx when running
FRICTION = 14 --amount of speed that is substracted when not pushing buttons, as well as speed added to acceleration when changing directions
SUPERFRICTION = 100 --see above, but when speed is greater than MAXRUNSPEED
FRICTIONAIR = 0 --see above, but in air
AIRSLIDEFACTOR = 0.8 --multiply of acceleration in air when changing direction

ENEMYBOUNCEHEIGHT = 14/16

SCROLLRATE = 5
SUPERSCROLLRATE = 40

SCROLLINGSTART = WIDTH-13 --when the scrolling begins to set in
SCROLLINGCOMPLETE = WIDTH-10 --when the scrolling will be as fast as mario can run
SCROLLINGLEFTSTART = 6 --See above, but for scrolling left
SCROLLINGLEFTCOMPLETE = 4

RUNANIMATIONTIME = 0.1

OFFSCREENDRAW = 1
LEVELCANVASWIDTH = 64-OFFSCREENDRAW*2 -- how many blocks to draw to a canvas

BLOCKBOUNCETIME = 0.2
BLOCKBOUNCEHEIGHT = 0.4


JUMPLEEWAY = 6/16
BLOCKHITFORCE = 2

COINANIMATIONTIME = 0.14

ENEMIESPSAWNAHEAD = 0

DEPTHMUL = 0.3

if love.system.getOS() == "Horizon" then -- 3DS controls
    CONTROLS = {
        quit = "start",
        frameTime = "select",
    
        left = "left",
        right = "right",
        jump = "b",
        run = "y"
    }
else -- Computer controls
    CONTROLS = {
        quit = "escape",
        frameTime = "f",
        
        left = "a",
        right = "d",
        jump = "space",
        run = "lshift"
    }
end