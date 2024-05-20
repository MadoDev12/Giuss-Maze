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

		storyDialogue = new FlxText(0, 0, 500); // x, y, width
		storyDialogue.setFormat("assets/fonts/pixel.ttf", 10, FlxColor.WHITE, CENTER);
		storyDialogue.antialiasing = true;
		storyDialogue.scrollFactor.set(0,0);
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
		if(SwitchLevel._curStage == 3 && player.x < (npc.x + 10) && FlxG.keys.anyJustReleased([ENTER]) || !fnpcd)
			{
				switch (dialogueCnt)
				{
					case 0:
						storyDialogue.text = "UHH! You scared me!";
					case 1:
						storyDialogue.text = "How did you found me?";
					case 2:
						storyDialogue.text = "I've been lost here for months now.";
					case 3:
						storyDialogue.text = "What?";
					case 4:
						storyDialogue.text = "You want me to follow you?";
					case 5: 
						storyDialogue.text = "Are you crazy or something?";
					case 6:
						storyDialogue.text = "I won't. Of course.";
					case 7: 
						storyDialogue.text = "Imagine following a stranger, huh?";
					case 8:
						storyDialogue.text = "Leave me alone now, okay?";
				}
				inDialogue = true;
				isNPCDialogue = true;
				fnpcd = true;
			}
		
		super.update(elapsed);
		FlxG.collide(player, walls);
		FlxG.overlap(player, stageSwitchers, changeLevel);
		returnToMenu();
		//events
		if (SwitchLevel._curStage == 1 && player.y < 135 && player.x > 250)
		{
			storyDialogue.text = "Keep going...";
			inDialogue = true;
		}
		if (SwitchLevel._curStage == 2 && (player.y < 424 && player.y > 384) && player.x < 304)
		{
			storyDialogue.text = "Don't stop...";
			inDialogue = true;
		}
		if (SwitchLevel._curStage == 3 && player.y > 352 && player.x > 1813)
		{
			storyDialogue.text = "You... found me...";
			inDialogue = true; 
		}

		if (inDialogue)
		{
			add(textbox);
			add(storyDialogue);
			
			if (!isNPCDialogue || dialogueCnt == 8)
				canCloseDialogue = true;
		}
		if (FlxG.keys.anyPressed([ENTER]) && isNPCDialogue && !canCloseDialogue)
			dialogueCnt += 1; 
		if (FlxG.keys.anyPressed([ENTER]) && canCloseDialogue)
		{
			textbox.kill();
			storyDialogue.kill();
			canCloseDialogue = false;
		}
		if (canCloseDialogue = false)
			inDialogue = false; 
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

	function returnToMenu()
	{
		if (FlxG.keys.anyPressed([ESCAPE, BACKSPACE]))
			FlxG.switchState(new MenuState());
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
		// do NEVER look what is in SwitchLevel.hx. NEVER.
		switch (SwitchLevel._curStage)
		{
			case 1: 
				map = new FlxOgmo3Loader("assets/data/levelpreset.ogmo", "assets/data/levels/room_001.json");
			case 2:
				map = new FlxOgmo3Loader("assets/data/levelpreset.ogmo", "assets/data/levels/room_002.json");
			case 3:
				map = new FlxOgmo3Loader("assets/data/levelpreset.ogmo", "assets/data/levels/room_003.json");
		}
	}
}
