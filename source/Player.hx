package; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends FlxSprite
{  
    static inline var SPEED:Float = 100;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x,y);
        loadGraphic("assets/images/player.png", true, 16, 16);
        setFacingFlip(LEFT, false, false);
        setFacingFlip(RIGHT, true, false);
        setSize(8,8);
        offset.set(4,8);
        animation.add("d_walk", [0, 1, 2], 6);
        animation.add("lr_walk", [3, 4, 5], 6);
        animation.add("u_walk", [6, 7, 8], 6);
        animation.add("idle", [0, 2], 2);
        drag.x = drag.y = 800;
        setSize(8, 8);
        offset.set(4, 4);
    }

    function updateMovement()
    {
        var up:Bool = false;
        var down:Bool = false;
        var left:Bool = false;
        var right:Bool = false;

        up = FlxG.keys.anyPressed([UP, W]);
        down = FlxG.keys.anyPressed([DOWN, S]);
        left = FlxG.keys.anyPressed([LEFT, A]);
        right = FlxG.keys.anyPressed([RIGHT, D]);

        if (up && down)
            up = down = false;
        if (left && right)
            left = right = false;

        if (up || down || left || right)
        {
            var newAngle:Float = 0;
            if (up)
            {
                newAngle = -90;
                if (left)
                    newAngle -= 45;
                else if (right)
                    newAngle += 45;
                facing = UP;
            }
            else if (down)
            {
                newAngle = 90;
                if (left)
                    newAngle += 45;
                else if (right)
                    newAngle -= 45;
                facing = DOWN;
            }
            else if (left)
            {
                newAngle = 180;
                facing = LEFT;
            }   
            else if (right)
            {
                newAngle = 0;
                facing = RIGHT;
            }
            velocity.setPolarDegrees(SPEED, newAngle);
        }

        var action = "idle";
        if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
        {
            action = "walk";
        }
        else
            action = "idle";

        switch (facing)
        {
            case LEFT, RIGHT:
                if (action == "walk")
                    animation.play("lr_" + action);
                else 
                    animation.play("idle");
            case UP:
                if (action == "walk")
                    animation.play("u_" + action);
                else 
                    animation.play("idle");
            case DOWN:
                if (action == "walk")
                    animation.play("d_" + action);
                else 
                    animation.play("idle");
            case _:
        }
    }

    override function update(elapsed:Float)
    {
        updateMovement();
        super.update(elapsed);
    }
}