package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
    public function new()
    {
        #if mobile
        Sys.setCwd(#if android android.content.Context.getExternalFilesDir() + '/' #elseif ios lime.system.System.documentsDirectory #end);
        #end
        super();
        addChild(new FlxGame(426, 240, MenuState));
        #if android FlxG.android.preventDefaultKeys = [BACK]; #end
    }
}
