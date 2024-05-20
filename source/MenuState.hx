package;

import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxBitmapDataUtil;
import flixel.util.FlxColor;
import haxe.ds.Option;

class MenuState extends FlxState
{
    var playButton:FlxButton;
    var optButton:FlxButton;

    var creditText:FlxText;

    override public function create():Void
    {
    	playButton = new FlxButton(0,0, "", goPlay);
        playButton.loadGraphic("assets/images/playbutton.png", true, 48, 32);
        add(playButton);
        playButton.screenCenter();
        
        bgColor = FlxColor.TRANSPARENT;
        super.create();
    }

    override public function update(elapsed:Float):Void
    {
    	super.update(elapsed);
    }

    function goPlay()
    {
        FlxG.switchState(new PlayState());
    }
}