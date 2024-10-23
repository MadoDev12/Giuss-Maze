package;

import SwitchLevel;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.addons.effects.chainable.IFlxEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.id.SwitchProID;
import flixel.input.keyboard.FlxKeyboard;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton.FlxTypedButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import haxe.rtti.CType.Platforms;
import haxe.zip.InflateImpl;
import openfl.net.dns.AAAARecord;

class PlayState extends FlxState
{
	var player:Player; 
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var xydebug:FlxText;
	public static var stageSwitchers:FlxTypedGroup<SwitchLevel>;
	var level:Int = 1;
	var textbox:FlxSprite;
	var inDialogue:Bool = false;
	var storyDialogue:FlxText;
	var canCloseDialogue:Bool = false;
	var dialogueCnt:Int = 0;
	var isNPCDialogue:Bool = false;
	var npc:FlxSprite;
	var fnpcd:Bool = true;
	
	var eventsXY:Array<Int> = [253, 48, 253, 136, 368, 424];
	var curDialogue:Array<String>;

	override public function create()
	{	
		checkStage();
		trace(SwitchLevel._curStage);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, ANY);
		walls.setTileProperties(2, ANY);
		walls.setTileProperties(3, ANY);
		walls.setTileProperties(4, ANY);
		walls.setTileProperties(5, ANY);
		walls.setTileProperties(6, NONE);
		add(walls);

		stageSwitchers = new FlxTypedGroup<SwitchLevel>();
		add(stageSwitchers);

		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);

		textbox = new FlxSprite();
		textbox.makeGraphic(350, 70, FlxColor.BLACK);
		textbox.scrollFactor.set(0, 0);
		textbox.screenCenter();
		textbox.y += 75;

		storyDialogue = new FlxText(0, 0, 0, 'example text lmao', 6);
		storyDialogue.setFormat("assets/fonts/pixel.ttf", 6, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
		storyDialogue.scrollFactor.set();
		storyDialogue.screenCenter();
		storyDialogue.y += 75;

		npc = new FlxSprite(317, 395);
		npc.loadGraphic("assets/images/npc1.png", false, 16, 16);
		if (SwitchLevel._curStage == 3)
			add(npc);

		FlxG.camera.follow(player, TOPDOWN, 1);
		bgColor = FlxColor.TRANSPARENT;
		super.create();
	}

	override public function update(elapsed:Float)
	{
		if(SwitchLevel._curStage == 3 && player.x < 362 && player.y > eventsXY[4] && player.y < eventsXY[5])
			{
				curDialogue = ["UHH! You scared me!", "What are you doing here?", "You seem...", "Similar.",
				"I think I already saw you.", "You want me to follow you?", "What a question, uhh...", "I don't think I'm going to.",
				"There's some kind of force forcing me to stay here.", "...", "You can go now.", "..."];
				storyDialogue.text = curDialogue[dialogueCnt];
				inDialogue = true;
			}

		if(SwitchLevel._curStage == 1 && player.x >= 253 && player.y > eventsXY[1] && player.y < eventsXY[3])
		{
			curDialogue = ["Keep on going...", "You shall find me if you want to fix it all..."];
			storyDialogue.text = curDialogue[dialogueCnt];
			inDialogue = true;
		}
		
		super.update(elapsed);
		FlxG.collide(player, walls);
		FlxG.overlap(player, stageSwitchers, changeLevel);
		
		if (FlxG.keys.anyPressed([ESCAPE, BACKSPACE]))
			FlxG.switchState(new MenuState());

		if (inDialogue)
		{
			add(textbox);
			add(storyDialogue);
			
			if (dialogueCnt == curDialogue.length)
				canCloseDialogue = true;
		}
		if (FlxG.keys.justPressed.ENTER && !canCloseDialogue)
			dialogueCnt += 1; 
		if (FlxG.keys.anyPressed([ENTER]) && canCloseDialogue)
		{
			textbox.kill();
			storyDialogue.kill();
			canCloseDialogue = false;
		}
		if (canCloseDialogue = false)
			inDialogue = false; 
		if (FlxG.keys.anyPressed([U]))
			trace('x: ${player.x} y: ${player.y}');
	}

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "player")
		{
			player.setPosition(entity.x, entity.y);
		}
		else if (entity.name == "stageswitch")
			stageSwitchers.add(new SwitchLevel(entity.x, entity.y));
	}

	static public function changeLevel(player, stageSwitchers):Void
	{
		SwitchLevel._curStage += 1;
		trace("level : " + SwitchLevel._curStage + " .");
		SwitchLevel.isMoreThanLevelOne = true;
		FlxG.switchState(new PlayState());
	}

	function checkStage()
	{
		map = new FlxOgmo3Loader("assets/data/levelpreset.ogmo", 'assets/data/levels/room_00${SwitchLevel._curStage}.json');
	}
}
