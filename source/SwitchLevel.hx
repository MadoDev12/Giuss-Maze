package;

import PlayState.PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.AssetManifest;

class SwitchLevel extends FlxSprite
{ 
    // yeah. i know. this is fucking useless. could have used FlxG.save.data but shut up and play the game >:(
        
    static public var _curStage:Int = 1;
    static public var isMoreThanLevelOne:Bool = false;
    
    public function new(x:Float, y:Float)
    {
        super(x,y);
    }
}