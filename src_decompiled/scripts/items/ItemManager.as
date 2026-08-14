package items
{
   import blitter.BlSprite;
   import blitter.BlockSprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemManager
   {
      
      public static var badgeFullBMD:BitmapData;
      
      public static var sprCoinDoors:BlockSprite;
      
      public static var sprCoinGates:BlockSprite;
      
      public static var sprBlueCoinDoors:BlockSprite;
      
      public static var sprBlueCoinGates:BlockSprite;
      
      public static var sprPurpleDoors:BlockSprite;
      
      public static var sprPurpleGates:BlockSprite;
      
      public static var sprOrangeDoors:BlockSprite;
      
      public static var sprOrangeGates:BlockSprite;
      
      public static var sprSwitchUP:BlockSprite;
      
      public static var sprSwitchDOWN:BlockSprite;
      
      public static var sprSwitchRESET:BlockSprite;
      
      public static var sprOrangeSwitchUP:BlockSprite;
      
      public static var sprOrangeSwitchDOWN:BlockSprite;
      
      public static var sprOrangeSwitchRESET:BlockSprite;
      
      public static var sprDeathDoor:BlockSprite;
      
      public static var sprDeathGate:BlockSprite;
      
      public static var sprBadge:BlockSprite;
      
      public static var sprMultiJumps:BlockSprite;
      
      private static var smileysBM:Class = ItemManager_smileysBM;
      
      public static var smileysBMD:BitmapData = new smileysBM().bitmapData;
      
      private static var smileyPlatinumSpenderBM:Class = ItemManager_smileyPlatinumSpenderBM;
      
      public static var smileyPlatinumSpenderBMD:BitmapData = new smileyPlatinumSpenderBM().bitmapData;
      
      private static var aurasBM:Class = ItemManager_aurasBM;
      
      public static var aurasBMD:BitmapData = new aurasBM().bitmapData;
      
      protected static var aurasOrnateBM:Class = ItemManager_aurasOrnateBM;
      
      public static var aurasOrnateBMD:BitmapData = new aurasOrnateBM().bitmapData;
      
      protected static var aurasBubbleBM:Class = ItemManager_aurasBubbleBM;
      
      public static var aurasBubbleBMD:BitmapData = new aurasBubbleBM().bitmapData;
      
      protected static var aurasGalaxyBM:Class = ItemManager_aurasGalaxyBM;
      
      public static var aurasGalaxyBMD:BitmapData = new aurasGalaxyBM().bitmapData;
      
      private static var shopBM:Class = ItemManager_shopBM;
      
      public static var shopBMD:BitmapData = new shopBM().bitmapData;
      
      private static var shopWorldsBM:Class = ItemManager_shopWorldsBM;
      
      public static var shopWorldsBMD:BitmapData = new shopWorldsBM().bitmapData;
      
      private static var shopAurasBM:Class = ItemManager_shopAurasBM;
      
      public static var shopAurasBMD:BitmapData = new shopAurasBM().bitmapData;
      
      protected static var favoriteBM:Class = ItemManager_favoriteBM;
      
      private static var favoriteBMD:BitmapData = new favoriteBM().bitmapData;
      
      protected static var likeBM:Class = ItemManager_likeBM;
      
      private static var likeBMD:BitmapData = new likeBM().bitmapData;
      
      protected static var particlesBM:Class = ItemManager_particlesBM;
      
      public static var allParticles:BitmapData = new particlesBM().bitmapData;
      
      protected static var graphicsPreviewBM:Class = ItemManager_graphicsPreviewBM;
      
      public static var graphicsPreviewBG:BitmapData = new graphicsPreviewBM().bitmapData;
      
      private static var blocksBM:Class = ItemManager_blocksBM;
      
      private static var blocksBMD:BitmapData = new blocksBM().bitmapData;
      
      private static var decoBlocksBM:Class = ItemManager_decoBlocksBM;
      
      private static var decoBlocksBMD:BitmapData = new decoBlocksBM().bitmapData;
      
      private static var bgBlocksBM:Class = ItemManager_bgBlocksBM;
      
      private static var bgBlocksBMD:BitmapData = new bgBlocksBM().bitmapData;
      
      protected static var specialBlocksBM:Class = ItemManager_specialBlocksBM;
      
      private static var specialBlocksBMD:BitmapData = new specialBlocksBM().bitmapData;
      
      protected static var shadowBlocksBM:Class = ItemManager_shadowBlocksBM;
      
      private static var shadowBlocksBMD:BitmapData = new shadowBlocksBM().bitmapData;
      
      protected static var mudBlocksBM:Class = ItemManager_mudBlocksBM;
      
      private static var mudBlocksBMD:BitmapData = new mudBlocksBM().bitmapData;
      
      protected static var npcBlocksBM:Class = ItemManager_npcBlocksBM;
      
      public static var npcBlocksBMD:BitmapData = new npcBlocksBM().bitmapData;
      
      protected static var doorBlocksBM:Class = ItemManager_doorBlocksBM;
      
      private static var doorBlocksBMD:BitmapData = new doorBlocksBM().bitmapData;
      
      private static var effectBlocksBM:Class = ItemManager_effectBlocksBM;
      
      public static var effectBlocksBMD:BitmapData = new effectBlocksBM().bitmapData;
      
      private static var teamBlocksBM:Class = ItemManager_teamBlocksBM;
      
      private static var teamBlocksBMD:BitmapData = new teamBlocksBM().bitmapData;
      
      protected static var completeBlocksBM:Class = ItemManager_completeBlocksBM;
      
      private static var completeBlocksBMD:BitmapData = new completeBlocksBM().bitmapData;
      
      private static var blockNumbersBM:Class = ItemManager_blockNumbersBM;
      
      private static var blockNumbersBMD:BitmapData = new blockNumbersBM().bitmapData;
      
      private static var blocksFireworksBM:Class = ItemManager_blocksFireworksBM;
      
      public static var blocksFireworksBMD:BitmapData = new blocksFireworksBM().bitmapData;
      
      private static var blocksGoldenEasterEggBM:Class = ItemManager_blocksGoldenEasterEggBM;
      
      public static var blocksGoldenEasterEggBMD:BitmapData = new blocksGoldenEasterEggBM().bitmapData;
      
      private static var bounds:Array = [];
      
      private static var coinDoorsBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var coinGatesBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var effectMultiJumpsBMD:BitmapData = new BitmapData(16 * 1001,16,true,0);
      
      private static var blueCoinDoorsBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var blueCoinGatesBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchDoorsBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchGatesBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchSwitchUpBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchSwitchDownBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchSwitchResetBMD:BitmapData = new BitmapData(16 * 1001,16,true,0);
      
      private static var switchOrangeDoorsBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchOrangeGatesBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchOrangeSwitchUpBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchOrangeSwitchDownBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var switchOrangeSwitchResetBMD:BitmapData = new BitmapData(16 * 1001,16,true,0);
      
      private static var deathDoorBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      private static var deathGateBMD:BitmapData = new BitmapData(16 * 1000,16,true,0);
      
      public static var smilies:Vector.<ItemSmiley> = new Vector.<ItemSmiley>();
      
      public static var auraShapes:Vector.<ItemAuraShape> = new Vector.<ItemAuraShape>();
      
      public static var auraColors:Vector.<ItemAuraColor> = new Vector.<ItemAuraColor>();
      
      public static var npcs:Vector.<ItemNpc> = new Vector.<ItemNpc>();
      
      public static var brickPackages:Vector.<ItemBrickPackage> = new Vector.<ItemBrickPackage>();
      
      public static var bmdBricks:Vector.<BitmapData> = new Vector.<BitmapData>(4001);
      
      public static var bricks:Vector.<ItemBrick> = new Vector.<ItemBrick>(4001);
      
      public static var bmdBadge:Vector.<BitmapData> = new Vector.<BitmapData>(12);
      
      public static var sprCheckpoint:BlockSprite = new BlockSprite(specialBlocksBMD,154,0,16,16,2);
      
      public static var sprSpikes:BlockSprite = new BlockSprite(specialBlocksBMD,156,0,16,16,4);
      
      public static var sprSpikesSilver:BlockSprite = new BlockSprite(specialBlocksBMD,868,0,16,16,4);
      
      public static var sprSpikesBlack:BlockSprite = new BlockSprite(specialBlocksBMD,873,0,16,16,4);
      
      public static var sprSpikesRed:BlockSprite = new BlockSprite(specialBlocksBMD,878,0,16,16,4);
      
      public static var sprSpikesGold:BlockSprite = new BlockSprite(specialBlocksBMD,883,0,16,16,4);
      
      public static var sprSpikesGreen:BlockSprite = new BlockSprite(specialBlocksBMD,888,0,16,16,4);
      
      public static var sprSpikesBlue:BlockSprite = new BlockSprite(specialBlocksBMD,893,0,16,16,4);
      
      public static var sprDoors:BlockSprite = new BlockSprite(doorBlocksBMD,0,0,16,16,doorBlocksBMD.width / 16);
      
      public static var sprDoorsTime:BlockSprite = new BlockSprite(specialBlocksBMD,332,0,16,16,10,true);
      
      public static var sprSecret:BlockSprite = new BlockSprite(specialBlocksBMD,139,0,16,16,3);
      
      public static var sprPortal:BlockSprite = new BlockSprite(specialBlocksBMD,52,0,16,16,61);
      
      public static var sprPortalWorld:BlockSprite = new BlockSprite(specialBlocksBMD,113,0,16,16,21);
      
      public static var sprCoin:BlockSprite = new BlockSprite(specialBlocksBMD,0,0,16,16,12);
      
      public static var sprCoinShadow:BlockSprite = new BlockSprite(specialBlocksBMD,26,0,16,16,12);
      
      public static var sprBonusCoin:BlockSprite = new BlockSprite(specialBlocksBMD,13,0,16,16,12);
      
      public static var sprBonusCoinShadow:BlockSprite = new BlockSprite(specialBlocksBMD,39,0,16,16,12);
      
      public static var sprWater:BlockSprite = new BlockSprite(specialBlocksBMD,196,0,16,16,22);
      
      public static var sprToxic:BlockSprite = new BlockSprite(specialBlocksBMD,746,0,16,16,22);
      
      public static var sprToxicBubble:BlockSprite = new BlockSprite(specialBlocksBMD,768,0,16,16,22);
      
      public static var sprWave:BlockSprite = new BlockSprite(specialBlocksBMD,234,0,16,16,8);
      
      public static var sprMud:BlockSprite = new BlockSprite(mudBlocksBMD,0,0,16,16,mudBlocksBMD.width / 16);
      
      public static var sprMudBubble:BlockSprite = new BlockSprite(specialBlocksBMD,244,0,16,16,19);
      
      public static var sprFavoriteStar:BlockSprite = new BlockSprite(favoriteBMD,0,0,16,16,favoriteBMD.width / 16);
      
      public static var sprLikeHeart:BlockSprite = new BlockSprite(likeBMD,0,0,16,16,likeBMD.width / 16);
      
      public static var sprDiamond:BlockSprite = new BlockSprite(specialBlocksBMD,284,0,16,16,14,true);
      
      public static var sprCake:BlockSprite = new BlockSprite(specialBlocksBMD,298,0,16,16,12,true);
      
      public static var sprPianoBlink:BlockSprite = new BlockSprite(specialBlocksBMD,148,0,16,16,6);
      
      public static var sprDrumsBlink:BlockSprite = new BlockSprite(specialBlocksBMD,142,0,16,16,6);
      
      public static var sprInvGravityBlink:BlockSprite = new BlockSprite(specialBlocksBMD,312,0,16,16,20);
      
      public static var sprInvDotBlink:BlockSprite = new BlockSprite(specialBlocksBMD,466,0,16,16,5);
      
      public static var sprFireHazard:BlockSprite = new BlockSprite(specialBlocksBMD,184,0,16,16,12);
      
      public static var sprHologram:BlockSprite = new BlockSprite(specialBlocksBMD,279,0,16,16,5,true);
      
      public static var sprLava:BlockSprite = new BlockSprite(specialBlocksBMD,218,0,16,16,16);
      
      public static var sprGravityEffect:BlockSprite = new BlockSprite(effectBlocksBMD,17,0,16,16,5,true);
      
      public static var sprTeamEffect:BlockSprite = new BlockSprite(teamBlocksBMD,0,0,16,16,teamBlocksBMD.width / 16,true);
      
      public static var sprEffect:BlockSprite = new BlockSprite(effectBlocksBMD,0,0,16,16,effectBlocksBMD.width / 16,true);
      
      public static var sprSign:BlockSprite = new BlockSprite(specialBlocksBMD,513,0,16,16,8);
      
      public static var sprParticles:BlSprite = new BlSprite(allParticles,0,0,5,5,allParticles.width / 5);
      
      public static var sprOnewayCyan:BlockSprite = new BlockSprite(specialBlocksBMD,263,0,16,16,4,true);
      
      public static var sprOnewayOrange:BlockSprite = new BlockSprite(specialBlocksBMD,271,0,16,16,4,true);
      
      public static var sprOnewayYellow:BlockSprite = new BlockSprite(specialBlocksBMD,267,0,16,16,4,true);
      
      public static var sprOnewayPink:BlockSprite = new BlockSprite(specialBlocksBMD,275,0,16,16,4,true);
      
      public static var sprOnewayGray:BlockSprite = new BlockSprite(specialBlocksBMD,471,0,16,16,4,true);
      
      public static var sprOnewayBlue:BlockSprite = new BlockSprite(specialBlocksBMD,475,0,16,16,4,true);
      
      public static var sprOnewayRed:BlockSprite = new BlockSprite(specialBlocksBMD,479,0,16,16,4,true);
      
      public static var sprOnewayGreen:BlockSprite = new BlockSprite(specialBlocksBMD,483,0,16,16,4,true);
      
      public static var sprOnewayBlack:BlockSprite = new BlockSprite(specialBlocksBMD,487,0,16,16,4,true);
      
      public static var sprOnewayWhite:BlockSprite = new BlockSprite(specialBlocksBMD,565,0,16,16,4,true);
      
      public static var sprGlowylineBlueSlope:BlockSprite = new BlockSprite(specialBlocksBMD,176,0,16,16,4);
      
      public static var sprGlowylineBlueStraight:BlockSprite = new BlockSprite(specialBlocksBMD,180,0,16,16,4);
      
      public static var sprGlowylineGreenSlope:BlockSprite = new BlockSprite(specialBlocksBMD,168,0,16,16,4);
      
      public static var sprGlowylineGreenStraight:BlockSprite = new BlockSprite(specialBlocksBMD,172,0,16,16,4);
      
      public static var sprGlowylineYellowSlope:BlockSprite = new BlockSprite(specialBlocksBMD,160,0,16,16,4);
      
      public static var sprGlowylineYellowStraight:BlockSprite = new BlockSprite(specialBlocksBMD,164,0,16,16,4);
      
      public static var sprGlowylineRedSlope:BlockSprite = new BlockSprite(specialBlocksBMD,408,0,16,16,4);
      
      public static var sprGlowylineRedStraight:BlockSprite = new BlockSprite(specialBlocksBMD,412,0,16,16,4);
      
      public static var sprMedievalAxe:BlockSprite = new BlockSprite(specialBlocksBMD,364,0,16,16,4);
      
      public static var sprMedievalBanner:BlockSprite = new BlockSprite(specialBlocksBMD,368,0,16,16,4);
      
      public static var sprMedievalShield:BlockSprite = new BlockSprite(specialBlocksBMD,372,0,16,16,4);
      
      public static var sprMedievalSword:BlockSprite = new BlockSprite(specialBlocksBMD,376,0,16,16,4);
      
      public static var sprMedievalCoatOfArms:BlockSprite = new BlockSprite(specialBlocksBMD,404,0,16,16,4);
      
      public static var sprMedievalTimber:BlockSprite = new BlockSprite(specialBlocksBMD,416,0,16,16,6);
      
      public static var sprToothSmall:BlockSprite = new BlockSprite(specialBlocksBMD,380,0,16,16,4);
      
      public static var sprToothBig:BlockSprite = new BlockSprite(specialBlocksBMD,384,0,16,16,4);
      
      public static var sprToothTriple:BlockSprite = new BlockSprite(specialBlocksBMD,400,0,16,16,4);
      
      public static var sprDojoLightLeft:BlockSprite = new BlockSprite(specialBlocksBMD,388,0,16,16,3);
      
      public static var sprDojoLightRight:BlockSprite = new BlockSprite(specialBlocksBMD,391,0,16,16,3);
      
      public static var sprDojoDarkLeft:BlockSprite = new BlockSprite(specialBlocksBMD,394,0,16,16,3);
      
      public static var sprDojoDarkRight:BlockSprite = new BlockSprite(specialBlocksBMD,397,0,16,16,3);
      
      public static var sprDomesticLightBulb:BlockSprite = new BlockSprite(specialBlocksBMD,424,0,16,16,4);
      
      public static var sprDomesticTap:BlockSprite = new BlockSprite(specialBlocksBMD,428,0,16,16,4,true);
      
      public static var sprDomesticPainting:BlockSprite = new BlockSprite(specialBlocksBMD,432,0,16,16,4);
      
      public static var sprDomesticVase:BlockSprite = new BlockSprite(specialBlocksBMD,436,0,16,16,4);
      
      public static var sprDomesticTV:BlockSprite = new BlockSprite(specialBlocksBMD,440,0,16,16,4);
      
      public static var sprDomesticWindow:BlockSprite = new BlockSprite(specialBlocksBMD,444,0,16,16,4);
      
      public static var sprHalfBlockDomesticYellow:BlockSprite = new BlockSprite(specialBlocksBMD,448,0,16,16,4,true);
      
      public static var sprHalfBlockDomesticBrown:BlockSprite = new BlockSprite(specialBlocksBMD,452,0,16,16,4,true);
      
      public static var sprHalfBlockDomesticWhite:BlockSprite = new BlockSprite(specialBlocksBMD,456,0,16,16,4,true);
      
      public static var sprHalfBlockWhite:BlockSprite = new BlockSprite(specialBlocksBMD,667,0,16,16,4,true);
      
      public static var sprHalfBlockGray:BlockSprite = new BlockSprite(specialBlocksBMD,671,0,16,16,4,true);
      
      public static var sprHalfBlockBlack:BlockSprite = new BlockSprite(specialBlocksBMD,675,0,16,16,4,true);
      
      public static var sprHalfBlockRed:BlockSprite = new BlockSprite(specialBlocksBMD,679,0,16,16,4,true);
      
      public static var sprHalfBlockOrange:BlockSprite = new BlockSprite(specialBlocksBMD,683,0,16,16,4,true);
      
      public static var sprHalfBlockYellow:BlockSprite = new BlockSprite(specialBlocksBMD,687,0,16,16,4,true);
      
      public static var sprHalfBlockGreen:BlockSprite = new BlockSprite(specialBlocksBMD,691,0,16,16,4,true);
      
      public static var sprHalfBlockCyan:BlockSprite = new BlockSprite(specialBlocksBMD,695,0,16,16,4,true);
      
      public static var sprHalfBlockBlue:BlockSprite = new BlockSprite(specialBlocksBMD,699,0,16,16,4,true);
      
      public static var sprHalfBlockPurple:BlockSprite = new BlockSprite(specialBlocksBMD,703,0,16,16,4,true);
      
      public static var sprHalloween2015WindowRect:BlockSprite = new BlockSprite(specialBlocksBMD,460,0,16,16,2);
      
      public static var sprHalloween2015WindowCircle:BlockSprite = new BlockSprite(specialBlocksBMD,462,0,16,16,2);
      
      public static var sprHalloween2015Lamp:BlockSprite = new BlockSprite(specialBlocksBMD,464,0,16,16,2);
      
      public static var sprNewYear2015Balloon:BlockSprite = new BlockSprite(specialBlocksBMD,491,0,16,16,5);
      
      public static var sprNewYear2015Streamer:BlockSprite = new BlockSprite(specialBlocksBMD,496,0,16,16,5);
      
      public static var sprPortalInvisible:BlockSprite = new BlockSprite(specialBlocksBMD,134,0,16,16,5);
      
      public static var sprIce:BlockSprite = new BlockSprite(specialBlocksBMD,501,0,16,16,12,true);
      
      public static var sprHalfBlockFairytaleRed:BlockSprite = new BlockSprite(specialBlocksBMD,521,0,16,16,4,true);
      
      public static var sprHalfBlockFairytaleGreen:BlockSprite = new BlockSprite(specialBlocksBMD,525,0,16,16,4,true);
      
      public static var sprHalfBlockFairytaleBlue:BlockSprite = new BlockSprite(specialBlocksBMD,529,0,16,16,4,true);
      
      public static var sprHalfBlockFairytalePink:BlockSprite = new BlockSprite(specialBlocksBMD,533,0,16,16,4,true);
      
      public static var sprFairytaleFlowers:BlockSprite = new BlockSprite(specialBlocksBMD,537,0,16,16,3,true);
      
      public static var sprSpringDaisy:BlockSprite = new BlockSprite(specialBlocksBMD,540,0,16,16,3,true);
      
      public static var sprSpringTulip:BlockSprite = new BlockSprite(specialBlocksBMD,543,0,16,16,3,true);
      
      public static var sprSpringDaffodil:BlockSprite = new BlockSprite(specialBlocksBMD,546,0,16,16,3,true);
      
      public static var sprSummerFlag:BlockSprite = new BlockSprite(specialBlocksBMD,549,0,16,16,6,true);
      
      public static var sprSummerAwning:BlockSprite = new BlockSprite(specialBlocksBMD,555,0,16,16,6,true);
      
      public static var sprSummerIceCream:BlockSprite = new BlockSprite(specialBlocksBMD,561,0,16,16,4,true);
      
      public static var sprCaveCrystal:BlockSprite = new BlockSprite(specialBlocksBMD,569,0,16,16,6,true);
      
      public static var sprCaveTorch:BlockSprite = new BlockSprite(specialBlocksBMD,575,0,16,16,12,false);
      
      public static var sprRestaurantCup:BlockSprite = new BlockSprite(specialBlocksBMD,587,0,16,16,4,true);
      
      public static var sprRestaurantPlate:BlockSprite = new BlockSprite(specialBlocksBMD,591,0,16,16,5,true);
      
      public static var sprRestaurantBowl:BlockSprite = new BlockSprite(specialBlocksBMD,596,0,16,16,4,true);
      
      public static var sprHalloweenEyes:BlockSprite = new BlockSprite(specialBlocksBMD,606,0,16,16,24,false);
      
      public static var sprHalloweenPumpkin:BlockSprite = new BlockSprite(specialBlocksBMD,604,0,16,16,2,true);
      
      public static var sprHalloweenRot:BlockSprite = new BlockSprite(specialBlocksBMD,600,0,16,16,4,false);
      
      public static var sprChristmas2016LightsDown:BlockSprite = new BlockSprite(specialBlocksBMD,630,0,16,16,5,false);
      
      public static var sprChristmas2016LightsUp:BlockSprite = new BlockSprite(specialBlocksBMD,635,0,16,16,5,false);
      
      public static var sprChristmas2016Candle:BlockSprite = new BlockSprite(specialBlocksBMD,640,0,16,16,12,false);
      
      public static var sprGuitarBlink:BlockSprite = new BlockSprite(specialBlocksBMD,661,0,16,16,6);
      
      public static var sprInvGravityDownBlink:BlockSprite = new BlockSprite(specialBlocksBMD,652,0,16,16,5);
      
      public static var sprIndustrialPipeThin:BlockSprite = new BlockSprite(specialBlocksBMD,707,0,16,16,2,true);
      
      public static var sprIndustrialPipeThick:BlockSprite = new BlockSprite(specialBlocksBMD,709,0,16,16,2,true);
      
      public static var sprIndustrialTable:BlockSprite = new BlockSprite(specialBlocksBMD,711,0,16,16,3,true);
      
      public static var sprDomesticPipeStraight:BlockSprite = new BlockSprite(specialBlocksBMD,714,0,16,16,2,true);
      
      public static var sprDomesticPipeT:BlockSprite = new BlockSprite(specialBlocksBMD,716,0,16,16,4,true);
      
      public static var sprDomesticFrameBorder:BlockSprite = new BlockSprite(specialBlocksBMD,720,0,16,16,11,true);
      
      public static var sprHalfBlockWinter2018Snow:BlockSprite = new BlockSprite(specialBlocksBMD,731,0,16,16,4,true);
      
      public static var sprHalfBlockWinter2018Glacier:BlockSprite = new BlockSprite(specialBlocksBMD,735,0,16,16,4,true);
      
      public static var sprToxicWasteBarrel:BlockSprite = new BlockSprite(specialBlocksBMD,787,0,16,16,2,true);
      
      public static var sprSewerPipe:BlockSprite = new BlockSprite(specialBlocksBMD,789,0,16,16,5,false);
      
      public static var sprMetalPlatform:BlockSprite = new BlockSprite(specialBlocksBMD,794,0,16,16,4,true);
      
      public static var sprFireworks:BlockSprite = new BlockSprite(specialBlocksBMD,740,0,16,16,3,false);
      
      public static var sprDungeonPillarBottom:BlockSprite = new BlockSprite(specialBlocksBMD,798,0,16,16,4,true);
      
      public static var sprDungeonPillarMiddle:BlockSprite = new BlockSprite(specialBlocksBMD,802,0,16,16,4,true);
      
      public static var sprDungeonPillarTop:BlockSprite = new BlockSprite(specialBlocksBMD,806,0,16,16,4,true);
      
      public static var sprDungeonArchLeft:BlockSprite = new BlockSprite(specialBlocksBMD,810,0,16,16,4,true);
      
      public static var sprDungeonArchRight:BlockSprite = new BlockSprite(specialBlocksBMD,814,0,16,16,4,true);
      
      public static var sprDungeonTorch:BlockSprite = new BlockSprite(specialBlocksBMD,818,0,16,16,48,false);
      
      public static var sprShadowA:BlockSprite = new BlockSprite(shadowBlocksBMD,0,0,16,16,4,false);
      
      public static var sprShadowB:BlockSprite = new BlockSprite(shadowBlocksBMD,4,0,16,16,4,false);
      
      public static var sprShadowC:BlockSprite = new BlockSprite(shadowBlocksBMD,8,0,16,16,2,false);
      
      public static var sprShadowD:BlockSprite = new BlockSprite(shadowBlocksBMD,10,0,16,16,4,false);
      
      public static var sprShadowF:BlockSprite = new BlockSprite(shadowBlocksBMD,15,0,16,16,4,false);
      
      public static var sprShadowG:BlockSprite = new BlockSprite(shadowBlocksBMD,19,0,16,16,4,false);
      
      public static var sprShadowH:BlockSprite = new BlockSprite(shadowBlocksBMD,23,0,16,16,2,false);
      
      public static var sprShadowI:BlockSprite = new BlockSprite(shadowBlocksBMD,25,0,16,16,4,false);
      
      public static var sprShadowK:BlockSprite = new BlockSprite(shadowBlocksBMD,30,0,16,16,4,false);
      
      public static var sprShadowL:BlockSprite = new BlockSprite(shadowBlocksBMD,34,0,16,16,4,false);
      
      public static var sprShadowM:BlockSprite = new BlockSprite(shadowBlocksBMD,38,0,16,16,4,false);
      
      public static var sprShadowN:BlockSprite = new BlockSprite(shadowBlocksBMD,42,0,16,16,4,false);
      
      private static var totalBricks:int = 0;
      
      private static var totalSmilies:int = 0;
      
      private static var totalAuraColors:int = 0;
      
      private static var auraImagesindex:int = 0;
      
      private static var totalAuraShapes:int = 0;
      
      private static var totalNpcs:int = 0;
      
      private static var npcImagesIndex:int = 0;
      
      public function ItemManager()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc120_:Matrix = null;
         var _loc121_:Bitmap = null;
         var _loc122_:ColorTransform = null;
         addSmiley(0,"Smiley","",smileysBMD,"");
         addSmiley(1,"Grin","",smileysBMD,"smileygrin");
         addSmiley(2,"Tongue","",smileysBMD,"smileytongue");
         addSmiley(3,"Happy","",smileysBMD,"smileyhappy");
         addSmiley(4,"Annoyed","",smileysBMD,"smileyannoyed");
         addSmiley(5,"Sad","",smileysBMD,"smileysad");
         addSmiley(6,"Crying","",smileysBMD,"pro");
         addSmiley(7,"Wink","",smileysBMD,"pro");
         addSmiley(8,"Frustrated","",smileysBMD,"pro");
         addSmiley(9,"Shades","",smileysBMD,"pro");
         addSmiley(10,"Devil","",smileysBMD,"pro");
         addSmiley(11,"Inquisitive","",smileysBMD,"pro");
         addSmiley(12,"Ninja","",smileysBMD,"smileyninja",0);
         addSmiley(13,"Santa","",smileysBMD,"smileysanta");
         addSmiley(14,"Worker","",smileysBMD,"smileyworker");
         addSmiley(15,"Big Spender","",smileysBMD,"smileybigspender");
         addSmiley(16,"Superman","",smileysBMD,"smileysuper");
         addSmiley(17,"Surprise","",smileysBMD,"smileysupprice");
         addSmiley(18,"Indifferent","",smileysBMD,"smileyindifferent");
         addSmiley(19,"Girl","",smileysBMD,"smileygirl");
         addSmiley(20,"New Year 2010","",smileysBMD,"mixednewyear2010");
         addSmiley(21,"Coy","",smileysBMD,"smileycoy");
         addSmiley(22,"Wizard","",smileysBMD,"smileywizard");
         addSmiley(23,"Fan Boy","",smileysBMD,"smileyfanboy");
         addSmiley(24,"Terminator","",smileysBMD,"smileyterminator");
         addSmiley(25,"Extra Grin","",smileysBMD,"smileyxd");
         addSmiley(26,"Bully","",smileysBMD,"smileybully");
         addSmiley(27,"Commando","",smileysBMD,"smileycommando");
         addSmiley(28,"Kissing","",smileysBMD,"smileyvalentines2011");
         addSmiley(29,"Bird","",smileysBMD,"smileybird");
         addSmiley(30,"Bunny","",smileysBMD,"smileybunni");
         addSmiley(31,"Diamond Touch","",smileysBMD,"unobtainable");
         addSmiley(32,"Fire Wizard","",smileysBMD,"smileywizard2");
         addSmiley(33,"Extra Tongue","",smileysBMD,"smileyxdp");
         addSmiley(34,"Postman","",smileysBMD,"smileypostman");
         addSmiley(35,"Templar","",smileysBMD,"smileytemplar");
         addSmiley(36,"Angel","",smileysBMD,"smileyangel");
         addSmiley(37,"Nurse","",smileysBMD,"smileynurse");
         addSmiley(38,"Vampire","",smileysBMD,"smileyhw2011vampire");
         addSmiley(39,"Ghost","",smileysBMD,"smileyhw2011ghost");
         addSmiley(40,"Frankenstein","",smileysBMD,"smileyhw2011frankenstein");
         addSmiley(41,"Witch","",smileysBMD,"smileywitch");
         addSmiley(42,"Indian","",smileysBMD,"smileytg2011indian");
         addSmiley(43,"Pilgrim","",smileysBMD,"smileytg2011pilgrim");
         addSmiley(44,"Pumpkin","",smileysBMD,"smileypumpkin1");
         addSmiley(45,"Lit Pumpkin","",smileysBMD,"smileypumpkin2");
         addSmiley(46,"Snowman","",smileysBMD,"smileyxmassnowman");
         addSmiley(47,"Reindeer","",smileysBMD,"smileyxmasreindeer");
         addSmiley(48,"Grinch","",smileysBMD,"smileyxmasgrinch");
         addSmiley(49,"Maestro","",smileysBMD,"bricknode");
         addSmiley(50,"DJ","",smileysBMD,"brickdrums");
         addSmiley(51,"Sigh","",smileysBMD,"smileysigh");
         addSmiley(52,"Robber","",smileysBMD,"smileyrobber",0);
         addSmiley(53,"Police","",smileysBMD,"smileypolice",4279002358);
         addSmiley(54,"Purple Ghost","",smileysBMD,"smileypurpleghost");
         addSmiley(55,"Pirate","",smileysBMD,"smileypirate");
         addSmiley(56,"Viking","",smileysBMD,"smileyviking");
         addSmiley(57,"Karate","",smileysBMD,"smileykarate");
         addSmiley(58,"Cowboy","",smileysBMD,"smileycowboy");
         addSmiley(59,"Diver","",smileysBMD,"smileydiver");
         addSmiley(60,"Tanned","",smileysBMD,"smileytanned");
         addSmiley(61,"Propeller Hat","",smileysBMD,"smileypropeller");
         addSmiley(62,"Hard Hat","",smileysBMD,"smileyhardhat");
         addSmiley(63,"Gas Mask","",smileysBMD,"smileygasmask");
         addSmiley(64,"Robot","",smileysBMD,"smileyrobot");
         addSmiley(65,"Peasant","",smileysBMD,"smileypeasant");
         addSmiley(66,"Guard","",smileysBMD,"smileyguard");
         addSmiley(67,"Blacksmith","",smileysBMD,"smileyblacksmith");
         addSmiley(68,"LOL","",smileysBMD,"smileylol");
         addSmiley(69,"Dog","",smileysBMD,"smileydog");
         addSmiley(70,"Alien","",smileysBMD,"smileyalien");
         addSmiley(71,"Astronaut","",smileysBMD,"smileyastronaut");
         addSmiley(72,"PartyOrange","",smileysBMD,"unobtainable");
         addSmiley(73,"PartyGreen","",smileysBMD,"unobtainable");
         addSmiley(74,"PartyBlue","",smileysBMD,"unobtainable");
         addSmiley(75,"PartyRed","",smileysBMD,"unobtainable");
         addSmiley(76,"Daredevil","",smileysBMD,"smileydaredevil");
         addSmiley(77,"Monster","",smileysBMD,"smileymonster");
         addSmiley(78,"Skeleton","",smileysBMD,"smileyskeleton");
         addSmiley(79,"Mad Scientist","",smileysBMD,"smileymadscientist");
         addSmiley(80,"Headhunter","",smileysBMD,"smileyheadhunter");
         addSmiley(81,"Safari","",smileysBMD,"smileysafari");
         addSmiley(82,"Archaeologist","",smileysBMD,"smileyarchaeologist");
         addSmiley(83,"New Year 2013","",smileysBMD,"smileynewyear2012");
         addSmiley(84,"Winter Hat","",smileysBMD,"smileywinter");
         addSmiley(85,"Fire demon","",smileysBMD,"smileyfiredeamon");
         addSmiley(86,"Bishop","",smileysBMD,"smileybishop");
         addSmiley(87,"Zombie","",smileysBMD,"unobtainable");
         addSmiley(88,"Bruce","",smileysBMD,"smileyzombieslayer");
         addSmiley(89,"Unit","",smileysBMD,"smileyunit");
         addSmiley(90,"Spartan","",smileysBMD,"smileyspartan");
         addSmiley(91,"Lady","",smileysBMD,"smileyhelen");
         addSmiley(92,"Cow","",smileysBMD,"smileycow");
         addSmiley(93,"Scarecrow","",smileysBMD,"smileyscarecrow");
         addSmiley(94,"Dark Wizard","",smileysBMD,"smileydarkwizard");
         addSmiley(95,"Kung Fu Master","",smileysBMD,"smileykungfumaster");
         addSmiley(96,"Fox","",smileysBMD,"smileyfox");
         addSmiley(97,"Night Vision","",smileysBMD,"smileynightvision");
         addSmiley(98,"Summer Girl","",smileysBMD,"smileysummergirl");
         addSmiley(99,"Fan Boy II","",smileysBMD,"smileyfanboy2");
         addSmiley(100,"Sci-Fi Hologram","",smileysBMD,"unobtainable");
         addSmiley(101,"Gingerbread","",smileysBMD,"smileygingerbread");
         addSmiley(102,"Caroler","",smileysBMD,"smileycaroler");
         addSmiley(103,"Elf","",smileysBMD,"smileyelf");
         addSmiley(104,"Nutcracker","",smileysBMD,"smileynutcracker");
         addSmiley(105,"Blushing","",smileysBMD,"brickvalentines2015");
         addSmiley(106,"Artist","",smileysBMD,"smileyartist");
         addSmiley(107,"Princess","",smileysBMD,"smileyprincess");
         addSmiley(108,"Chef","",smileysBMD,"smileychef");
         addSmiley(109,"Clown","",smileysBMD,"smileyclown");
         addSmiley(110,"Red Ninja","",smileysBMD,"smileyninjared");
         addSmiley(111,"3D Glasses","",smileysBMD,"smiley3dglasses");
         addSmiley(112,"Sunburned","",smileysBMD,"smileysunburned");
         addSmiley(113,"Tourist","",smileysBMD,"smileytourist");
         addSmiley(114,"Graduate","",smileysBMD,"smileygraduate");
         addSmiley(115,"Sombrero","",smileysBMD,"smileysombrero");
         addSmiley(116,"Cat","",smileysBMD,"smileycat");
         addSmiley(117,"Scared","",smileysBMD,"smileyscared");
         addSmiley(118,"Ghoul","",smileysBMD,"smileyghoul");
         addSmiley(119,"Mummy","",smileysBMD,"smileymummy");
         addSmiley(120,"Bat","",smileysBMD,"smileybat");
         addSmiley(121,"Eyeball","",smileysBMD,"smileyeyeball");
         addSmiley(122,"Light Wizard","",smileysBMD,"smileylightwizard");
         addSmiley(123,"Hooded","",smileysBMD,"smileyhooded");
         addSmiley(124,"Earmuffs","",smileysBMD,"smileyearmuffs");
         addSmiley(125,"Penguin","",smileysBMD,"smileypenguin");
         addSmiley(126,"Gold Smiley","",smileysBMD,"goldmember");
         addSmiley(127,"Gold Ninja","",smileysBMD,"goldmember");
         addSmiley(128,"Gold Robot","",smileysBMD,"goldmember");
         addSmiley(129,"Gold Top Hat","",smileysBMD,"goldmember");
         addSmiley(130,"Sick","",smileysBMD,"smileysick");
         addSmiley(131,"Unsure","",smileysBMD,"smileyunsure");
         addSmiley(132,"Goofy","",smileysBMD,"smileygoofy");
         addSmiley(133,"Raindrop","",smileysBMD,"smileyraindrop");
         addSmiley(134,"Bee","",smileysBMD,"smileybee");
         addSmiley(135,"Butterfly","",smileysBMD,"smileybutterfly");
         addSmiley(136,"Sea Captain","",smileysBMD,"smileyseacaptain");
         addSmiley(137,"Soda Clerk","",smileysBMD,"smileysodaclerk");
         addSmiley(138,"Lifeguard","",smileysBMD,"smileylifeguard");
         addSmiley(139,"Aviator","",smileysBMD,"smileyaviator");
         addSmiley(140,"Sleepy","",smileysBMD,"smileysleepy");
         addSmiley(141,"Seagull","",smileysBMD,"smileyseagull");
         addSmiley(142,"Werewolf","",smileysBMD,"smileywerewolf");
         addSmiley(143,"Swamp Creature","",smileysBMD,"smileyswampcreature");
         addSmiley(144,"Fairy","",smileysBMD,"smileyfairy");
         addSmiley(145,"Firefighter","",smileysBMD,"smileyfirefighter");
         addSmiley(146,"Spy","",smileysBMD,"smileyspy",0);
         addSmiley(147,"Devil Skull","",smileysBMD,"smileydevilskull");
         addSmiley(148,"Clockwork Robot","",smileysBMD,"smileyclockwork");
         addSmiley(149,"Teddy Bear","",smileysBMD,"smileyteddybear");
         addSmiley(150,"Christmas Soldier","",smileysBMD,"smileychristmassoldier");
         addSmiley(151,"Scrooge","",smileysBMD,"smileyscrooge");
         addSmiley(152,"Boy","",smileysBMD,"smileyboy");
         addSmiley(153,"Pigtails","",smileysBMD,"smileypigtails");
         addSmiley(154,"Doctor","",smileysBMD,"smileydoctor");
         addSmiley(155,"Turban","",smileysBMD,"smileyturban");
         addSmiley(156,"Hazmat Suit","",smileysBMD,"smileyhazmatsuit");
         addSmiley(157,"Leprechaun","",smileysBMD,"smileyleprechaun");
         addSmiley(158,"Angry","",smileysBMD,"smileyangry");
         addSmiley(159,"Smirk","",smileysBMD,"smileysmirk");
         addSmiley(160,"Sweat","",smileysBMD,"smileysweat");
         addSmiley(161,"Country Singer","",smileysBMD,"brickguitar");
         addSmiley(162,"Thor","",smileysBMD,"smileythor");
         addSmiley(163,"Cowgirl","",smileysBMD,"smileycowgirl");
         addSmiley(164,"Raccoon","",smileysBMD,"smileyraccoon");
         addSmiley(165,"Lion","",smileysBMD,"smileylion");
         addSmiley(166,"Laika","",smileysBMD,"smileylaiika");
         addSmiley(167,"Fishbowl","",smileysBMD,"smileyfishbowl");
         addSmiley(168,"Slime","",smileysBMD,"smileyslime");
         addSmiley(169,"Designer","",smileysBMD,"smileydesigner");
         addSmiley(170,"Frozen","",smileysBMD,"smileyfrozen");
         addSmiley(171,"Masquerade","",smileysBMD,"smileymasquerade");
         addSmiley(172,"Polar Bear","",smileysBMD,"smileypolarbear");
         addSmiley(173,"Baseball Cap","",smileysBMD,"smileybaseball");
         addSmiley(174,"Golfer","",smileysBMD,"smileygolfer");
         addSmiley(ItemId.SMILEY_PLATINUM_SPENDER,"Platinum Big Spender","",smileysBMD,"smileyplatinumspender");
         addSmiley(176,"Green Dragon","",smileysBMD,"smileydragongreen");
         addSmiley(177,"Red Dragon","",smileysBMD,"smileydragonred");
         addSmiley(178,"Executioner","",smileysBMD,"smileyexecutioner");
         addSmiley(179,"Gargoyle","",smileysBMD,"smileygargoyle");
         addSmiley(180,"Banshee","",smileysBMD,"smileybanshee");
         addSmiley(181,"Golem","",smileysBMD,"smileygolem");
         addSmiley(182,"Frost Dragon","",smileysBMD,"smileyfrostdragon");
         addSmiley(183,"Squirrel","",smileysBMD,"smileysquirrel");
         addSmiley(184,"Golden Dragon","",smileysBMD,"smileygoldendragon");
         addSmiley(185,"Robot Mk II","",smileysBMD,"smileyrobot2");
         addSmiley(186,"Black Dragon","",smileysBMD,"smileydragonblack");
         addSmiley(187,"Silver Dragon","",smileysBMD,"smileydragonsilver");
         addAuraColor(0,"White","");
         addAuraColor(1,"Red","aurared");
         addAuraColor(2,"Blue","aurablue");
         addAuraColor(3,"Yellow","aurayellow");
         addAuraColor(4,"Green","auragreen");
         addAuraColor(5,"Purple","aurapurple");
         addAuraColor(6,"Orange","auraorange");
         addAuraColor(7,"Cyan","auracyan");
         addAuraColor(8,"Gold","goldmember");
         addAuraColor(9,"Pink","aurapink");
         addAuraColor(10,"Indigo","auraindigo");
         addAuraColor(11,"Lime","auralime");
         addAuraColor(12,"Black","aurablack");
         addAuraColor(13,"Teal","aurateal");
         addAuraColor(14,"Grey","auragrey");
         addAuraColor(15,"Amaranth","auraamaranth");
         addAuraShape(0,"Default",aurasBMD,"");
         addAuraShape(1,"Pinwheel",aurasBMD,"aurashapepinwheel",6);
         addAuraShape(2,"Torus",aurasBMD,"aurashapetorus");
         addAuraShape(3,"Ornate",aurasBMD,"goldmember",6);
         addAuraShape(4,"Spiral",aurasBMD,"aurashapespiral",6,0.15);
         addAuraShape(5,"Star",aurasBMD,"aurashapestar");
         addAuraShape(6,"Snowflake",aurasBMD,"aurashapesnowflake");
         addAuraShape(7,"Atom",aurasBMD,"aurashapeatom",8,0.175);
         addAuraShape(8,"Sawblade",aurasBMD,"aurashapesawblade",6,0.2);
         addAuraShape(9,"Target",aurasBMD,"aurashapetarget",6,0.15);
         addAuraShape(10,"Bubble",aurasBubbleBMD,"aurabubble",8,0.1,false,false);
         addAuraShape(11,"Galaxy",aurasGalaxyBMD,"auragalaxy",12,0.15,false,false);
         addAuraShape(12,"Heart",aurasBMD,"aurashapeheart",10,0.125);
         addAuraShape(13,"Flower",aurasBMD,"aurashapesunflower");
         var _loc1_:ItemBrickPackage = new ItemBrickPackage("NPCs","idk, npcs are npcs.",["npc"]);
         addNpc(ItemId.NPC_SMILE,"npcsmile",_loc1_,2,["Smile","Happy","Yellow"]);
         addNpc(ItemId.NPC_SAD,"npcsad",_loc1_,2,["Sad","Yellow"]);
         addNpc(ItemId.NPC_OLD,"npcold",_loc1_,2,["Old","Yellow"]);
         addNpc(ItemId.NPC_ANGRY,"npcangry",_loc1_,2,["Angry","Mad","Red"]);
         addNpc(ItemId.NPC_SLIME,"npcslime",_loc1_,2,["Slime","Lime","Green"]);
         addNpc(ItemId.NPC_ROBOT,"npcrobot",_loc1_,2,["Robot","Grey"]);
         addNpc(ItemId.NPC_KNIGHT,"npcknight",_loc1_,2,["Knight","War","Grey"]);
         addNpc(ItemId.NPC_MEH,"npcmeh",_loc1_,2,["Meh","Yellow"]);
         addNpc(ItemId.NPC_COW,"npccow",_loc1_,2,["Cow","Brown"]);
         addNpc(ItemId.NPC_FROG,"npcfrog",_loc1_,9,["Frog","Green"],6.5 / 3,-7);
         addNpc(ItemId.NPC_BRUCE,"npcbruce",_loc1_,2,["Bruce","Yellow"]);
         addNpc(ItemId.NPC_STARFISH,"npcstarfish",_loc1_,2,["Starfish","Pink","Ocean"]);
         addNpc(ItemId.NPC_DT,"npcdt",_loc1_,2,["Computer","???"]);
         addNpc(ItemId.NPC_SKELETON,"npcskeleton",_loc1_,2,["Skeleton"]);
         addNpc(ItemId.NPC_ZOMBIE,"npczombie",_loc1_,2,["Zombie"]);
         addNpc(ItemId.NPC_GHOST,"npcghost",_loc1_,6,["Ghost"],6.5 / 1.25);
         addNpc(ItemId.NPC_ASTRONAUT,"npcastronaut",_loc1_,9,["Astronaut","Space","Sci-fi"],4.5);
         addNpc(ItemId.NPC_SANTA,"npcsanta",_loc1_,2,["Santa","Christmas","Holiday","Yellow"],7);
         addNpc(ItemId.NPC_SNOWMAN,"npcsnowman",_loc1_,4,["Snowman","Christmas","Holiday"],7);
         addNpc(ItemId.NPC_WALRUS,"npcwalrus",_loc1_,3,["Walrus"]);
         addNpc(ItemId.NPC_CRAB,"npccrab",_loc1_,10,["Hermit","Crab","Shell"]);
         var _loc2_:ItemBrickPackage = new ItemBrickPackage("basic","Basic Blocks",["Primary","Simple","Standard","Default"]);
         _loc2_.addBrick(createBrick(1088,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,260,-1,["White","Light"]));
         _loc2_.addBrick(createBrick(9,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,9,4285427310,["Grey","Gray","Taupe"]));
         _loc2_.addBrick(createBrick(182,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,156,4280821800,["Black","Dark","Coal","Road"]));
         _loc2_.addBrick(createBrick(12,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,12,4289213780,["Red","Magenta","Vermillion","Ruby"]));
         _loc2_.addBrick(createBrick(1018,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,205,-1,["Orange","Persimmon","Copper"]));
         _loc2_.addBrick(createBrick(13,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,13,4287866933,["Yellow","Lime","Chartreuse","Light green","Citrine","Citrus"]));
         _loc2_.addBrick(createBrick(14,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,14,4282558518,["Green","Kelly","Emerald","Grass"]));
         _loc2_.addBrick(createBrick(15,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,15,4281704102,["Blue","Cyan","Light Blue","Aquamarine","Sky Blue"]));
         _loc2_.addBrick(createBrick(10,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,10,4281684648,["Blue","Dark Blue","Cobalt"]));
         _loc2_.addBrick(createBrick(11,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,11,4288099751,["Purple","Pink","Plum","Violet"]));
         brickPackages.push(_loc2_);
         var _loc3_:ItemBrickPackage = new ItemBrickPackage("beta","Beta Access",["Exclusive"]);
         _loc3_.addBrick(createBrick(1089,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,261,4293256677,["White","Light"]));
         _loc3_.addBrick(createBrick(42,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,42,4288256409,["Grey","Gray","Taupe"]));
         _loc3_.addBrick(createBrick(1021,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,208,4282861383,["Black","Dark","Onyx"]));
         _loc3_.addBrick(createBrick(40,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,40,4291782224,["Red","Ruby","Garnet"]));
         _loc3_.addBrick(createBrick(1020,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,207,4291722832,["Orange","Copper"]));
         _loc3_.addBrick(createBrick(41,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,41,4291995973,["Yellow","Gold","Jasmine"]));
         _loc3_.addBrick(createBrick(38,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,38,4283091074,["Green","Emerald","Malachite"]));
         _loc3_.addBrick(createBrick(1019,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,206,4283024070,["Blue","Cyan","Light blue","Aquamarine","Turquoise"]));
         _loc3_.addBrick(createBrick(39,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,39,4283270342,["Blue","Sapphire"]));
         _loc3_.addBrick(createBrick(37,ItemLayer.FORGROUND,blocksBMD,"pro","",ItemTab.BLOCK,false,true,37,4291715791,["Purple","Pink","Magenta","Violet","Amethyst"]));
         brickPackages.push(_loc3_);
         var _loc4_:ItemBrickPackage = new ItemBrickPackage("brick","Brick Blocks",["Standard","Wall"]);
         _loc4_.addBrick(createBrick(1090,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,262,4287137928,["White","Light"]));
         _loc4_.addBrick(createBrick(1022,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,209,4283190348,["Gray","Grey","Concrete","Stone"]));
         _loc4_.addBrick(createBrick(1024,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,211,-1,["Black","Dark","Coal"]));
         _loc4_.addBrick(createBrick(20,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,20,4285473833,["Red","Maroon","Hell"]));
         _loc4_.addBrick(createBrick(16,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,16,4287315465,["Brown","Orange","Soil","Dirt","Mahogany"]));
         _loc4_.addBrick(createBrick(21,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,21,4285488420,["Beige","Tan","Olive","Brown","Ecru","Yellow"]));
         _loc4_.addBrick(createBrick(19,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,19,4282614544,["Green","Grass"]));
         _loc4_.addBrick(createBrick(17,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,17,4280577869,["Blue","Cyan","Turquoise","Teal","Skobeloff","Dark Green"]));
         _loc4_.addBrick(createBrick(1023,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,210,-1,["Blue","Dark","Zaffre"]));
         _loc4_.addBrick(createBrick(18,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,18,4283311215,["Purple","Dark","Violet"]));
         brickPackages.push(_loc4_);
         var _loc5_:ItemBrickPackage = new ItemBrickPackage("metal","Metal Blocks",["Ore","Standard"]);
         _loc5_.addBrick(createBrick(29,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,29,4288783269,["Silver","White","Iron","Platinum"]));
         _loc5_.addBrick(createBrick(30,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,30,4292835905,["Orange","Bronze","Amber"]));
         _loc5_.addBrick(createBrick(31,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,31,4293962023,["Yellow","Gold","Jasmine"]));
         brickPackages.push(_loc5_);
         var _loc6_:ItemBrickPackage = new ItemBrickPackage("grass","Grass Blocks",["Environment","Nature","Standard","Soil","Ground","Dirt","Flora"]);
         _loc6_.addBrick(createBrick(34,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.BLOCK,false,true,34,4282737427,["Left","Soil"]));
         _loc6_.addBrick(createBrick(35,ItemLayer.FORGROUND,blocksBMD,"","",ItemTab.BLOCK,false,true,35,4282737427,["Middle","Soil"]));
         _loc6_.addBrick(createBrick(36,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.BLOCK,false,true,36,4282737427,["Right","Soil"]));
         brickPackages.push(_loc6_);
         var _loc7_:ItemBrickPackage = new ItemBrickPackage("generic","Generic Blocks",["Special"]);
         _loc7_.addBrick(createBrick(22,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.BLOCK,false,true,22,4287191826,["Caution","Warning","Hazard","Stripes","Yellow","Black","Standard"]));
         _loc7_.addBrick(createBrick(1057,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.BLOCK,false,true,235,-1,["Neutral","Yellow","Body","No face"]));
         _loc7_.addBrick(createBrick(32,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.BLOCK,false,true,32,4291792930,["Face","Smiley","Yellow","Standard"]));
         _loc7_.addBrick(createBrick(1058,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.BLOCK,false,true,236,-1,["Caution","Warning","Hazard","Stripes","Black","Yellow"]));
         _loc7_.addBrick(createBrick(33,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.BLOCK,false,true,33,4278190080,["Black","Dark","Standard"]));
         brickPackages.push(_loc7_);
         var _loc8_:ItemBrickPackage = new ItemBrickPackage("factory","Factory Package");
         _loc8_.addBrick(createBrick(45,ItemLayer.FORGROUND,blocksBMD,"brickfactory","",ItemTab.BLOCK,false,true,45,4285686091,["X","Crate","Metal","Box","Wood"]));
         _loc8_.addBrick(createBrick(46,ItemLayer.FORGROUND,blocksBMD,"brickfactory","",ItemTab.BLOCK,false,true,46,4285426528,["Concrete","Grey","Gray","Stone","Slate","X"]));
         _loc8_.addBrick(createBrick(47,ItemLayer.FORGROUND,blocksBMD,"brickfactory","",ItemTab.BLOCK,false,true,47,4287525711,["Wood","Tree","Wooden","House","Planks","Flooring","Parquet"]));
         _loc8_.addBrick(createBrick(48,ItemLayer.FORGROUND,blocksBMD,"brickfactory","",ItemTab.BLOCK,false,true,48,4286533419,["X","Crate","Wooden","Box","Wood","Storage"]));
         _loc8_.addBrick(createBrick(49,ItemLayer.FORGROUND,blocksBMD,"brickfactory","",ItemTab.BLOCK,false,true,49,4285887861,["Silver","Metal","Scales"]));
         brickPackages.push(_loc8_);
         var _loc9_:ItemBrickPackage = new ItemBrickPackage("secrets","Secret Bricks",["Hidden","Invisible"]);
         _loc9_.addBrick(createBrick(44,ItemLayer.FORGROUND,blocksBMD,"bricksecrets","completely black, makes minimap invisible",ItemTab.BLOCK,false,true,44,16777216,["Black","Pure","Old","Solid"]));
         _loc9_.addBrick(createBrick(50,ItemLayer.DECORATION,specialBlocksBMD,"bricksecrets","",ItemTab.BLOCK,false,true,139,0,["Appear"]));
         _loc9_.addBrick(createBrick(243,ItemLayer.DECORATION,specialBlocksBMD,"bricksecrets","",ItemTab.BLOCK,false,true,140,16777216,["Blank","Hidden"]));
         _loc9_.addBrick(createBrick(136,ItemLayer.DECORATION,specialBlocksBMD,"bricksecrets","",ItemTab.BLOCK,false,false,141,0,["Disappear"]));
         brickPackages.push(_loc9_);
         var _loc10_:ItemBrickPackage = new ItemBrickPackage("glass","Glass bricks",["Bright","Light","Shine","Polish","Neon"]);
         _loc10_.addBrick(createBrick(51,ItemLayer.FORGROUND,blocksBMD,"brickglass","",ItemTab.BLOCK,false,true,51,4294480537,["Red","Light red","Pink","Ruby"]));
         _loc10_.addBrick(createBrick(58,ItemLayer.FORGROUND,blocksBMD,"brickglass","",ItemTab.BLOCK,false,true,58,4294359700,["Orange","Light orange","Topaz"]));
         _loc10_.addBrick(createBrick(57,ItemLayer.FORGROUND,blocksBMD,"brickglass","",ItemTab.BLOCK,false,true,57,4294498956,["Yellow","Light yellow","Jasmine"]));
         _loc10_.addBrick(createBrick(56,ItemLayer.FORGROUND,blocksBMD,"brickglass","",ItemTab.BLOCK,false,true,56,4287822762,["Green","Light green","Emerald"]));
         _loc10_.addBrick(createBrick(55,ItemLayer.FORGROUND,blocksBMD,"brickglass","",ItemTab.BLOCK,false,true,55,4288011510,["Cyan","Light blue","Diamond"]));
         _loc10_.addBrick(createBrick(54,ItemLayer.FORGROUND,blocksBMD,"brickglass","",ItemTab.BLOCK,false,true,54,4286487030,["Blue","Sapphire"]));
         _loc10_.addBrick(createBrick(53,ItemLayer.FORGROUND,blocksBMD,"brickglass","",ItemTab.BLOCK,false,true,53,4289169910,["Purple","Violet","Amethyst"]));
         _loc10_.addBrick(createBrick(52,ItemLayer.FORGROUND,blocksBMD,"brickglass","",ItemTab.BLOCK,false,true,52,4293495798,["Pink","Magenta","Purple","Quartz"]));
         brickPackages.push(_loc10_);
         var _loc11_:ItemBrickPackage = new ItemBrickPackage("minerals","Minerals",["Neon","Pure","Bright"]);
         _loc11_.addBrick(createBrick(70,ItemLayer.FORGROUND,blocksBMD,"brickminerals","",ItemTab.BLOCK,false,true,70,4293787648,["Red","Ruby"]));
         _loc11_.addBrick(createBrick(76,ItemLayer.FORGROUND,blocksBMD,"brickminerals","",ItemTab.BLOCK,false,true,76,4293818112,["Orange","Topaz"]));
         _loc11_.addBrick(createBrick(75,ItemLayer.FORGROUND,blocksBMD,"brickminerals","",ItemTab.BLOCK,false,true,75,4293848576,["Yellow","Jasmine"]));
         _loc11_.addBrick(createBrick(74,ItemLayer.FORGROUND,blocksBMD,"brickminerals","",ItemTab.BLOCK,false,true,74,4278251008,["Green","Lime","Emerald","Peridot"]));
         _loc11_.addBrick(createBrick(73,ItemLayer.FORGROUND,blocksBMD,"brickminerals","",ItemTab.BLOCK,false,true,73,4278251246,["Cyan","Light blue","Aquamarine","Turquoise"]));
         _loc11_.addBrick(createBrick(72,ItemLayer.FORGROUND,blocksBMD,"brickminerals","",ItemTab.BLOCK,false,true,72,4278190318,["Blue","Indigo","Sapphire","Lapis"]));
         _loc11_.addBrick(createBrick(71,ItemLayer.FORGROUND,blocksBMD,"brickminerals","",ItemTab.BLOCK,false,true,71,4293787886,["Pink","Magenta","Purple","Amethyst"]));
         brickPackages.push(_loc11_);
         var _loc12_:ItemBrickPackage = new ItemBrickPackage("christmas 2011","Christmas 2011 bricks",["Holiday","Wrapping Paper","Gift","Present"]);
         _loc12_.addBrick(createBrick(78,ItemLayer.FORGROUND,blocksBMD,"brickxmas2011","",ItemTab.BLOCK,false,true,78,-1,["Yellow"]));
         _loc12_.addBrick(createBrick(79,ItemLayer.FORGROUND,blocksBMD,"brickxmas2011","",ItemTab.BLOCK,false,true,79,-1,["White"]));
         _loc12_.addBrick(createBrick(80,ItemLayer.FORGROUND,blocksBMD,"brickxmas2011","",ItemTab.BLOCK,false,true,80,-1,["Red"]));
         _loc12_.addBrick(createBrick(81,ItemLayer.FORGROUND,blocksBMD,"brickxmas2011","",ItemTab.BLOCK,false,true,81,-1,["Blue"]));
         _loc12_.addBrick(createBrick(82,ItemLayer.FORGROUND,blocksBMD,"brickxmas2011","",ItemTab.BLOCK,false,true,82,-1,["Green"]));
         brickPackages.push(_loc12_);
         var _loc13_:ItemBrickPackage = new ItemBrickPackage("gravity","Gravity Modifying Arrows",["Physics","Motion","Action","Standard"]);
         _loc13_.addBrick(createBrick(0,ItemLayer.BACKGROUND,blocksBMD,"","",ItemTab.ACTION,false,false,0,4278190080,["Clear","Empty","Delete","Nothing","Erase"]));
         _loc13_.addBrick(createBrick(1,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,1,0,["Left","Arrow"]));
         _loc13_.addBrick(createBrick(2,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,2,0,["Up","Arrow"]));
         _loc13_.addBrick(createBrick(3,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,3,0,["Right","Arrow"]));
         _loc13_.addBrick(createBrick(1518,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,285,0,["Down","Arrow"]));
         _loc13_.addBrick(createBrick(4,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,4,0,["Dot"]));
         _loc13_.addBrick(createBrick(ItemId.SLOW_DOT,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,233,0,["Slow","Dot","Climbable","Physics"]));
         _loc13_.addBrick(createBrick(411,ItemLayer.DECORATION,specialBlocksBMD,"","",ItemTab.ACTION,false,false,312,0,["Invisible","Left","Arrow"]));
         _loc13_.addBrick(createBrick(412,ItemLayer.DECORATION,specialBlocksBMD,"","",ItemTab.ACTION,false,false,317,0,["Invisible","Up","Arrow"]));
         _loc13_.addBrick(createBrick(413,ItemLayer.DECORATION,specialBlocksBMD,"","",ItemTab.ACTION,false,false,322,0,["Invisible","Right","Arrow"]));
         _loc13_.addBrick(createBrick(1519,ItemLayer.DECORATION,specialBlocksBMD,"","",ItemTab.ACTION,false,false,652,0,["Invisible","Down","Arrow"]));
         _loc13_.addBrick(createBrick(414,ItemLayer.DECORATION,specialBlocksBMD,"","",ItemTab.ACTION,false,false,327,0,["Invisible","Dot"]));
         _loc13_.addBrick(createBrick(ItemId.SLOW_DOT_INVISIBLE,ItemLayer.DECORATION,specialBlocksBMD,"","",ItemTab.ACTION,false,false,466,0,["Slow","Dot","Climbable","Physics","Invisible"]));
         brickPackages.push(_loc13_);
         var _loc14_:ItemBrickPackage = new ItemBrickPackage("keys","Key Blocks",["Key","Lock","Button","Action","Standard"]);
         _loc14_.addBrick(createBrick(6,ItemLayer.DECORATION,blocksBMD,"","hit to activate key doors and gates for everyone for 6 seconds",ItemTab.ACTION,false,false,6,4281080346,["Red","Key","Magenta"]));
         _loc14_.addBrick(createBrick(7,ItemLayer.DECORATION,blocksBMD,"","hit to activate key doors and gates for everyone for 6 seconds",ItemTab.ACTION,false,false,7,4279905306,["Green","Key"]));
         _loc14_.addBrick(createBrick(8,ItemLayer.DECORATION,blocksBMD,"","hit to activate key doors and gates for everyone for 6 seconds",ItemTab.ACTION,false,false,8,4279900716,["Blue","Key"]));
         _loc14_.addBrick(createBrick(408,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","hit to activate key doors and gates for everyone for 6 seconds",ItemTab.ACTION,false,false,189,4278988093,["Cyan","Teal"]));
         _loc14_.addBrick(createBrick(409,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","hit to activate key doors and gates for everyone for 6 seconds",ItemTab.ACTION,false,false,190,4282387520,["Pink","Violet","Purple"]));
         _loc14_.addBrick(createBrick(410,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","hit to activate key doors and gates for everyone for 6 seconds",ItemTab.ACTION,false,false,191,4281086730,["Yellow","Key"]));
         brickPackages.push(_loc14_);
         var _loc15_:ItemBrickPackage = new ItemBrickPackage("gates","Gate Blocks",["Key","Lock","Action","Standard"]);
         _loc15_.addBrick(createBrick(26,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,26,4288425286,["Red","Magenta"]));
         _loc15_.addBrick(createBrick(27,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,27,4281834544,["Green"]));
         _loc15_.addBrick(createBrick(28,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,28,4281156764,["Blue"]));
         _loc15_.addBrick(createBrick(1008,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","",ItemTab.ACTION,false,false,195,4281175449,["Cyan","Teal"]));
         _loc15_.addBrick(createBrick(1009,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","",ItemTab.ACTION,false,false,196,4287704473,["Pink","Purple","Violet"]));
         _loc15_.addBrick(createBrick(1010,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","",ItemTab.ACTION,false,false,197,4288123437,["Yellow"]));
         brickPackages.push(_loc15_);
         var _loc16_:ItemBrickPackage = new ItemBrickPackage("doors","Door Blocks",["Key","Lock","Action","Standard"]);
         _loc16_.addBrick(createBrick(23,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,true,23,4288425286,["Red","Magenta"]));
         _loc16_.addBrick(createBrick(24,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,true,24,4281834544,["Green"]));
         _loc16_.addBrick(createBrick(25,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,true,25,4281156764,["Blue"]));
         _loc16_.addBrick(createBrick(1005,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","",ItemTab.ACTION,false,true,192,4281175449,["Cyan","Teal"]));
         _loc16_.addBrick(createBrick(1006,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","",ItemTab.ACTION,false,true,193,4287704473,["Pink","Purple","Violet"]));
         _loc16_.addBrick(createBrick(1007,ItemLayer.DECORATION,blocksBMD,"brickextrakeys","",ItemTab.ACTION,false,true,194,4288123437,["Yellow"]));
         brickPackages.push(_loc16_);
         var _loc17_:ItemBrickPackage = new ItemBrickPackage("coins","Coin Blocks");
         _loc17_.addBrick(createBrick(100,ItemLayer.ABOVE,specialBlocksBMD,"","",ItemTab.ACTION,false,false,0,0,["Gold","G-Coins","Yellow","Money","Primary","Collect","Magic","Value","Standard"]));
         _loc17_.addBrick(createBrick(101,ItemLayer.ABOVE,specialBlocksBMD,"","",ItemTab.ACTION,false,false,13,0,["Blue","B-Coin","Secondary","Money","Optional","Collect","Magic","Value","Standard"]));
         _loc17_.addBrick(createBrick(110,ItemLayer.DECORATION,specialBlocksBMD,"","",ItemTab.ACTION,false,false,26,0,[],true,true));
         _loc17_.addBrick(createBrick(111,ItemLayer.DECORATION,specialBlocksBMD,"","",ItemTab.ACTION,false,false,39,0,[],true,true));
         _loc17_.addBrick(createBrick(ItemId.COINGATE,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,false,139,4290285077,["Gate","Yellow","Gold","Primary","Lock"]));
         _loc17_.addBrick(createBrick(ItemId.COINDOOR,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,true,43,4290285077,["Door","Yellow","Gold","Primary","Lock"]));
         _loc17_.addBrick(createBrick(ItemId.BLUECOINGATE,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,true,186,4280049908,["Gate","Blue","Optional","Lock"]));
         _loc17_.addBrick(createBrick(ItemId.BLUECOINDOOR,ItemLayer.DECORATION,blocksBMD,"","",ItemTab.ACTION,false,true,185,4280049908,["Door","Blue","Optional","Lock"]));
         brickPackages.push(_loc17_);
         var _loc18_:ItemBrickPackage = new ItemBrickPackage("tools","Tool Blocks");
         _loc18_.addBrick(createBrick(255,ItemLayer.DECORATION,decoBlocksBMD,"","players spawn here",ItemTab.ACTION,false,false,255 - 128,0,["Spawn","Start","Beginning","Enter"]));
         _loc18_.addBrick(createBrick(ItemId.WORLD_PORTAL_SPAWN,ItemLayer.DECORATION,decoBlocksBMD,"bricktools","a spawn point targetable by world portals",ItemTab.ACTION,true,false,354,0,["Spawn","Start","Beginning","Enter","World","Red"]));
         _loc18_.addBrick(createBrick(ItemId.CHECKPOINT,ItemLayer.DECORATION,specialBlocksBMD,"","players respawn here when they die",ItemTab.ACTION,false,false,154,0,["Checkpoint","Respawn","Safe","Enter","Save"]));
         _loc18_.addBrick(createBrick(ItemId.RESET_POINT,ItemLayer.ABOVE,decoBlocksBMD,"","resets the player\'s progress",ItemTab.ACTION,false,false,288,0,["Reset","Restart","Retry"]));
         _loc18_.addBrick(createBrick(ItemId.GOD_BLOCK,ItemLayer.ABOVE,decoBlocksBMD,"bricktools","gives the player god mode privileges",ItemTab.ACTION,true,false,320,0,["God"]));
         _loc18_.addBrick(createBrick(ItemId.MAP_BLOCK,ItemLayer.ABOVE,decoBlocksBMD,"bricktools","allows the player to use the minimap when disabled",ItemTab.ACTION,true,false,355,0,["Map","Minimap"]));
         brickPackages.push(_loc18_);
         var _loc19_:ItemBrickPackage = new ItemBrickPackage("crown","Crown");
         _loc19_.addBrick(createBrick(5,ItemLayer.DECORATION,blocksBMD,"","awards the player a golden crown",ItemTab.ACTION,false,true,5,4282595615,["Crown","King","Gold","Action","Prize","Reward"]));
         _loc19_.addBrick(createBrick(ItemId.CROWNGATE,ItemLayer.DECORATION,doorBlocksBMD,"brickcrown","",ItemTab.ACTION,false,true,40,0,["Crown","Gate","Gold","Yellow","Lock"]));
         _loc19_.addBrick(createBrick(ItemId.CROWNDOOR,ItemLayer.DECORATION,doorBlocksBMD,"brickcrown","",ItemTab.ACTION,false,true,41,0,["Crown","Door","Gold","Yellow","Lock"]));
         _loc19_.addBrick(createBrick(ItemId.BRICK_COMPLETE,ItemLayer.ABOVE,completeBlocksBMD,"","gives the player a silver crown, displays a win message",ItemTab.ACTION,false,false,0,0,["Crown","Trophy","Win","Complete","Finish","End","Reward"]));
         _loc19_.addBrick(createBrick(ItemId.SILVERCROWNGATE,ItemLayer.DECORATION,doorBlocksBMD,"brickcrown","",ItemTab.ACTION,false,true,42,0,["Crown","Gate","Silver","Lock"]));
         _loc19_.addBrick(createBrick(ItemId.SILVERCROWNDOOR,ItemLayer.DECORATION,doorBlocksBMD,"brickcrown","",ItemTab.ACTION,false,true,43,0,["Crown","Door","Silver","Lock"]));
         brickPackages.push(_loc19_);
         var _loc20_:ItemBrickPackage = new ItemBrickPackage("boost","Boost Arrows",["Speed","Fast","Friction","Arrow","Motion","Action","Physics"]);
         _loc20_.addBrick(createBrick(ItemId.SPEED_LEFT,ItemLayer.DECORATION,blocksBMD,"brickboost","",ItemTab.ACTION,false,false,157,0,["Left"]));
         _loc20_.addBrick(createBrick(ItemId.SPEED_UP,ItemLayer.DECORATION,blocksBMD,"brickboost","",ItemTab.ACTION,false,false,159,0,["Up","Above"]));
         _loc20_.addBrick(createBrick(ItemId.SPEED_RIGHT,ItemLayer.DECORATION,blocksBMD,"brickboost","",ItemTab.ACTION,false,false,158,0,["Right"]));
         _loc20_.addBrick(createBrick(ItemId.SPEED_DOWN,ItemLayer.DECORATION,blocksBMD,"brickboost","",ItemTab.ACTION,false,false,160,0,["Down","Below"]));
         brickPackages.push(_loc20_);
         var _loc21_:ItemBrickPackage = new ItemBrickPackage("climbable","Climbable Blocks",["Transportation","No","Gravity","Slow"]);
         _loc21_.addBrick(createBrick(ItemId.CHAIN,ItemLayer.DECORATION,blocksBMD,"brickclimbable","",ItemTab.ACTION,false,true,135,0,["Chain","Vertical","Ninja"]));
         _loc21_.addBrick(createBrick(ItemId.METAL_LADDER,ItemLayer.DECORATION,decoBlocksBMD,"brickindustrial","",ItemTab.ACTION,false,true,331,0,["Ladder","Vertical","Metal","Industrial"]));
         _loc21_.addBrick(createBrick(ItemId.NINJA_LADDER,ItemLayer.DECORATION,blocksBMD,"brickninja","",ItemTab.ACTION,false,true,98,0,["Ladder","Vertical","Ninja"]));
         _loc21_.addBrick(createBrick(ItemId.VINE_V,ItemLayer.DECORATION,blocksBMD,"brickjungle","",ItemTab.ACTION,false,true,174,0,["Vine","Vertical","Jungle","Environment"]));
         _loc21_.addBrick(createBrick(ItemId.VINE_H,ItemLayer.DECORATION,blocksBMD,"brickjungle","",ItemTab.ACTION,false,true,175,0,["Vine","Horizontal","Jungle","Environment"]));
         _loc21_.addBrick(createBrick(ItemId.ROPE,ItemLayer.DECORATION,decoBlocksBMD,"brickmedieval","",ItemTab.ACTION,false,true,266,0,["Rope","Vertical","Medieval","Ninja"]));
         _loc21_.addBrick(createBrick(ItemId.FAIRYTALE_LADDER,ItemLayer.DECORATION,blocksBMD,"brickclimbable","",ItemTab.ACTION,false,false,252,0,["Ladder","Vine","Fairytale"]));
         _loc21_.addBrick(createBrick(ItemId.GARDEN_LATTICE_VINES,ItemLayer.DECORATION,blocksBMD,"brickclimbable","",ItemTab.ACTION,false,true,303,0,["Ladder","Vine","Lattice","Fence","Brown","Leaf","Leaves","Lattice","Wood","Garden"]));
         _loc21_.addBrick(createBrick(ItemId.GARDEN_STALK,ItemLayer.DECORATION,blocksBMD,"brickclimbable","",ItemTab.ACTION,false,true,307,0,["Ladder","Stalk","Vine","Vertical","Green","Bean","Garden"]));
         _loc21_.addBrick(createBrick(ItemId.DUNGEON_CHAIN,ItemLayer.DECORATION,blocksBMD,"brickclimbable","",ItemTab.ACTION,false,true,315,0,["Halloween","Dungeon","Chain"]));
         brickPackages.push(_loc21_);
         var _loc22_:ItemBrickPackage = new ItemBrickPackage("switches","Switches",["Lock","Action"]);
         _loc22_.addBrick(createBrick(ItemId.SWITCH_PURPLE,ItemLayer.DECORATION,specialBlocksBMD,"brickswitches","",ItemTab.ACTION,false,true,310,0,["Switch","Lever","Button","Purple","Violet"]));
         _loc22_.addBrick(createBrick(ItemId.RESET_PURPLE,ItemLayer.DECORATION,specialBlocksBMD,"brickswitches","",ItemTab.ACTION,false,true,866,0,["Reset","Off","Switch","Lever","Button","Purple","Violet"]));
         _loc22_.addBrick(createBrick(ItemId.GATE_PURPLE,ItemLayer.DECORATION,doorBlocksBMD,"brickswitches","",ItemTab.ACTION,false,false,8,4284760474,["Switch","Gate","Purple","Violet"]));
         _loc22_.addBrick(createBrick(ItemId.DOOR_PURPLE,ItemLayer.DECORATION,doorBlocksBMD,"brickswitches","",ItemTab.ACTION,false,false,9,4284760474,["Switch","Door","Purple","Violet"]));
         _loc22_.addBrick(createBrick(ItemId.SWITCH_ORANGE,ItemLayer.DECORATION,specialBlocksBMD,"brickswitches","",ItemTab.ACTION,false,true,422,0,["Switch","Lever","Button","Orange"]));
         _loc22_.addBrick(createBrick(ItemId.RESET_ORANGE,ItemLayer.DECORATION,specialBlocksBMD,"brickswitches","",ItemTab.ACTION,false,true,867,0,["Reset","Off","Switch","Lever","Button","Orange"]));
         _loc22_.addBrick(createBrick(ItemId.GATE_ORANGE,ItemLayer.DECORATION,doorBlocksBMD,"brickswitches","",ItemTab.ACTION,false,false,38,4292305967,["Switch","Gate","Orange"]));
         _loc22_.addBrick(createBrick(ItemId.DOOR_ORANGE,ItemLayer.DECORATION,doorBlocksBMD,"brickswitches","",ItemTab.ACTION,false,false,39,4292305967,["Switch","Door","Orange"]));
         brickPackages.push(_loc22_);
         var _loc23_:ItemBrickPackage = new ItemBrickPackage("death","Death Doors/Gates (+10)",["Lock","Die","Skull","Curse"]);
         _loc23_.addBrick(createBrick(ItemId.DEATH_GATE,ItemLayer.DECORATION,blocksBMD,"brickdeath","",ItemTab.ACTION,false,false,198,4289309097,["Gate","Off"]));
         _loc23_.addBrick(createBrick(ItemId.DEATH_DOOR,ItemLayer.DECORATION,blocksBMD,"brickdeath","",ItemTab.ACTION,false,false,199,4289309097,["Door","On"]));
         brickPackages.push(_loc23_);
         var _loc24_:ItemBrickPackage = new ItemBrickPackage("zombie","Zombie Blocks",["Blue","Grey","Gray"]);
         _loc24_.addBrick(createBrick(ItemId.EFFECT_ZOMBIE,ItemLayer.DECORATION,effectBlocksBMD,"brickzombie","infects the player with a horrible disease",ItemTab.ACTION,false,false,5,0,["Effect","Death","Slow"]));
         _loc24_.addBrick(createBrick(ItemId.ZOMBIE_GATE,ItemLayer.DECORATION,doorBlocksBMD,"brickzombie","",ItemTab.ACTION,false,false,12,4284642431,["Gate"]));
         _loc24_.addBrick(createBrick(ItemId.ZOMBIE_DOOR,ItemLayer.DECORATION,doorBlocksBMD,"brickzombie","",ItemTab.ACTION,false,false,13,4284642431,["Door"]));
         brickPackages.push(_loc24_);
         var _loc25_:ItemBrickPackage = new ItemBrickPackage("teams","Team effect (+10)",["Team","Grey","Gray"]);
         _loc25_.addBrick(createBrick(ItemId.EFFECT_TEAM,ItemLayer.DECORATION,effectBlocksBMD,"brickteams","sets the player\'s team to the specified color",ItemTab.ACTION,false,false,6,0,["Effect","Separation"]));
         _loc25_.addBrick(createBrick(ItemId.TEAM_GATE,ItemLayer.DECORATION,doorBlocksBMD,"brickteams","",ItemTab.ACTION,false,false,29,0,["Gate","Lock","Off"]));
         _loc25_.addBrick(createBrick(ItemId.TEAM_DOOR,ItemLayer.DECORATION,doorBlocksBMD,"brickteams","",ItemTab.ACTION,false,false,22,0,["Door","Lock","On"]));
         brickPackages.push(_loc25_);
         var _loc26_:ItemBrickPackage = new ItemBrickPackage("timed","Timed Doors (+10)",["Lock","Wait","Door","Gate","Grey","Gray"]);
         _loc26_.addBrick(createBrick(ItemId.TIMEGATE,ItemLayer.DECORATION,specialBlocksBMD,"bricktimed","",ItemTab.ACTION,false,false,337,-1,["Off"]));
         _loc26_.addBrick(createBrick(ItemId.TIMEDOOR,ItemLayer.DECORATION,specialBlocksBMD,"bricktimed","",ItemTab.ACTION,false,true,332,-1,["On"]));
         brickPackages.push(_loc26_);
         var _loc27_:ItemBrickPackage = new ItemBrickPackage("music","Music Blocks",["Sound","Entertainment","Note","Melody","Instrument"]);
         _loc27_.addBrick(createBrick(77,ItemLayer.DECORATION,blocksBMD,"brickmusic","plays a sound when touched",ItemTab.ACTION,false,false,77,0,["Piano","Maestro"]));
         _loc27_.addBrick(createBrick(83,ItemLayer.DECORATION,blocksBMD,"brickmusic","plays a sound when touched",ItemTab.ACTION,false,false,83,0,["Drums"]));
         _loc27_.addBrick(createBrick(1520,ItemLayer.DECORATION,blocksBMD,"brickmusic","plays a sound when touched",ItemTab.ACTION,false,false,286,0,["Guitar"]));
         brickPackages.push(_loc27_);
         var _loc28_:ItemBrickPackage = new ItemBrickPackage("hazards","Hazard Blocks",["Kill","Die","Respawn","Death","Trap","Fatal","Deadly"]);
         _loc28_.addBrick(createBrick(ItemId.SPIKE,ItemLayer.DECORATION,specialBlocksBMD,"","kills the player",ItemTab.ACTION,false,false,157,0,["Spikes","Morphable"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_CENTER,ItemLayer.DECORATION,specialBlocksBMD,"","kills the player",ItemTab.ACTION,false,false,739,0,["Spikes","Floating","Centre","Center","Central","Mine","Hover"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_SILVER,ItemLayer.DECORATION,specialBlocksBMD,"brickspikesilver","kills the player",ItemTab.ACTION,false,false,869,0,["Spikes","Morphable"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_SILVER_CENTER,ItemLayer.DECORATION,specialBlocksBMD,"brickspikesilver","kills the player",ItemTab.ACTION,false,false,872,0,["Spikes","Floating","Centre","Center","Central","Mine","Hover"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_BLACK,ItemLayer.DECORATION,specialBlocksBMD,"brickspikeblack","kills the player",ItemTab.ACTION,false,false,874,0,["Spikes","Morphable","Silver","Light","White","Gray","Grey"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_BLACK_CENTER,ItemLayer.DECORATION,specialBlocksBMD,"brickspikeblack","kills the player",ItemTab.ACTION,false,false,877,0,["Spikes","Floating","Centre","Center","Central","Mine","Hover","Silver","Light","White","Gray","Grey"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_RED,ItemLayer.DECORATION,specialBlocksBMD,"brickspikered","kills the player",ItemTab.ACTION,false,false,879,0,["Spikes","Morphable","Black","Dark","Gray","Grey"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_RED_CENTER,ItemLayer.DECORATION,specialBlocksBMD,"brickspikered","kills the player",ItemTab.ACTION,false,false,882,0,["Spikes","Floating","Centre","Center","Central","Mine","Hover","Black","Dark","Gray","Grey"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_GOLD,ItemLayer.DECORATION,specialBlocksBMD,"brickspikegold","kills the player",ItemTab.ACTION,false,false,884,0,["Spikes","Morphable","Yellow","Gold"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_GOLD_CENTER,ItemLayer.DECORATION,specialBlocksBMD,"brickspikegold","kills the player",ItemTab.ACTION,false,false,887,0,["Spikes","Floating","Centre","Center","Central","Mine","Hover","Yellow","Gold"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_GREEN,ItemLayer.DECORATION,specialBlocksBMD,"brickspikegreen","kills the player",ItemTab.ACTION,false,false,889,0,["Spikes","Morphable","Green"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_GREEN_CENTER,ItemLayer.DECORATION,specialBlocksBMD,"brickspikegreen","kills the player",ItemTab.ACTION,false,false,892,0,["Spikes","Floating","Centre","Center","Central","Mine","Hover","Green"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_BLUE,ItemLayer.DECORATION,specialBlocksBMD,"brickspikeblue","kills the player",ItemTab.ACTION,false,false,894,0,["Spikes","Morphable","Blue"]));
         _loc28_.addBrick(createBrick(ItemId.SPIKE_BLUE_CENTER,ItemLayer.DECORATION,specialBlocksBMD,"brickspikeblue","kills the player",ItemTab.ACTION,false,false,897,0,["Spikes","Floating","Centre","Center","Central","Mine","Hover","Blue"]));
         _loc28_.addBrick(createBrick(ItemId.FIRE,ItemLayer.ABOVE,specialBlocksBMD,"","kills the player",ItemTab.ACTION,false,false,188,0,["Fire","Burn","Flames","Animated","Hell"]));
         brickPackages.push(_loc28_);
         var _loc29_:ItemBrickPackage = new ItemBrickPackage("liquids","Liquid Blocks",["Transportation","Swim","Fluid","Action","Environment"]);
         _loc29_.addBrick(createBrick(ItemId.WATER,ItemLayer.ABOVE,specialBlocksBMD,"brickliquids","",ItemTab.ACTION,false,false,196,0,["Water","Blue","Up","Float"]));
         _loc29_.addBrick(createBrick(ItemId.LAVA,ItemLayer.ABOVE,specialBlocksBMD,"brickliquids","sets the player on fire and kills",ItemTab.ACTION,false,false,218,0,["Lava","Hazard","Die","Orange","Death","Burn","Sink","Hell"]));
         _loc29_.addBrick(createBrick(ItemId.MUD,ItemLayer.ABOVE,mudBlocksBMD,"brickliquids","slows the player down",ItemTab.ACTION,false,false,0,0,["Mud","Swamp","Bog","Slow","Brown","Sink"]));
         _loc29_.addBrick(createBrick(ItemId.TOXIC_WASTE,ItemLayer.ABOVE,specialBlocksBMD,"brickliquids","kills the player instantly on touch",ItemTab.ACTION,false,false,746,0,["Toxic","Waste","Slow","Green"]));
         brickPackages.push(_loc29_);
         var _loc30_:ItemBrickPackage = new ItemBrickPackage("portals","Portal Blocks",["Teleport"]);
         _loc30_.addBrick(createBrick(ItemId.PORTAL_INVISIBLE,ItemLayer.DECORATION,specialBlocksBMD,"brickportals","teleports the player to another portal",ItemTab.ACTION,false,true,138,0,["Invisible","Secrets","Hidden"]));
         _loc30_.addBrick(createBrick(242,ItemLayer.DECORATION,specialBlocksBMD,"brickportals","teleports the player to another portal",ItemTab.ACTION,false,true,52,-1,["Visible","Blue"]));
         _loc30_.addBrick(createBrick(ItemId.WORLD_PORTAL,ItemLayer.DECORATION,specialBlocksBMD,"brickportals","teleports the player to another world",ItemTab.ACTION,true,true,113,-1,["World","Red"]));
         brickPackages.push(_loc30_);
         var _loc31_:ItemBrickPackage = new ItemBrickPackage("diamond","Diamond (+1)",["Exclusive"]);
         _loc31_.addBrick(createBrick(ItemId.DIAMOND,ItemLayer.DECORATION,decoBlocksBMD,"brickdiamond","changes the player\'s smiley to diamond",ItemTab.ACTION,true,true,241 - 128,-1,["Luxury","Smiley","Expensive","Gray","Animated","Shiny","Grey"],false,true));
         brickPackages.push(_loc31_);
         var _loc32_:ItemBrickPackage = new ItemBrickPackage("cake","Cake");
         _loc32_.addBrick(createBrick(ItemId.CAKE,ItemLayer.DECORATION,specialBlocksBMD,"brickcake","changes the player\'s smiley to party hat",ItemTab.ACTION,true,true,298,0,["Party","Birthday","Smiley","Hat","Animated","Food"]));
         brickPackages.push(_loc32_);
         var _loc33_:ItemBrickPackage = new ItemBrickPackage("hologram","Hologram");
         _loc33_.addBrick(createBrick(ItemId.HOLOGRAM,ItemLayer.DECORATION,specialBlocksBMD,"brickhologram","changes the player\'s smiley to hologram",ItemTab.ACTION,true,true,279,1718026239,["Sci-fi","Blue","Transparent","Smiley","Future","Animated"]));
         brickPackages.push(_loc33_);
         var _loc34_:ItemBrickPackage = new ItemBrickPackage("christmas 2010","Christmas 2010 Blocks",["Holiday","Xmas","Winter"]);
         _loc34_.addBrick(createBrick(249,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2010","",ItemTab.DECORATIVE,false,false,249 - 128,0,["Snow","Left","Corner","Snowdrift","Environment"]));
         _loc34_.addBrick(createBrick(250,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2010","",ItemTab.DECORATIVE,false,false,250 - 128,0,["Snow","Right","Corner","Snowdrift","Environment"]));
         _loc34_.addBrick(createBrick(251,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2010","",ItemTab.DECORATIVE,false,false,251 - 128,0,["Tree","Plant","Nature","Spruce","Environment"]));
         _loc34_.addBrick(createBrick(252,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2010","",ItemTab.DECORATIVE,false,false,252 - 128,0,["Tree","Snow","Plant","Lights","Spruce","Nature","Environment"]));
         _loc34_.addBrick(createBrick(253,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2010","",ItemTab.DECORATIVE,false,false,253 - 128,0,["Fence","Snow","Wood"]));
         _loc34_.addBrick(createBrick(254,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2010","",ItemTab.DECORATIVE,false,false,254 - 128,0,["Fence","Wood"]));
         brickPackages.push(_loc34_);
         var _loc35_:ItemBrickPackage = new ItemBrickPackage("new year 2010","New Year 2010",["Holiday","Baubles","Ornament","Light","Bulb"]);
         _loc35_.addBrick(createBrick(244,ItemLayer.DECORATION,decoBlocksBMD,"brickny2010","",ItemTab.DECORATIVE,false,true,244 - 128,0,["Pink","Violet","Purple"]));
         _loc35_.addBrick(createBrick(245,ItemLayer.DECORATION,decoBlocksBMD,"brickny2010","",ItemTab.DECORATIVE,false,true,245 - 128,0,["Yellow"]));
         _loc35_.addBrick(createBrick(246,ItemLayer.DECORATION,decoBlocksBMD,"brickny2010","",ItemTab.DECORATIVE,false,true,246 - 128,0,["Blue"]));
         _loc35_.addBrick(createBrick(247,ItemLayer.DECORATION,decoBlocksBMD,"brickny2010","",ItemTab.DECORATIVE,false,true,247 - 128,0,["Red"]));
         _loc35_.addBrick(createBrick(248,ItemLayer.DECORATION,decoBlocksBMD,"brickny2010","",ItemTab.DECORATIVE,false,true,248 - 128,0,["Green"]));
         brickPackages.push(_loc35_);
         var _loc36_:ItemBrickPackage = new ItemBrickPackage("spring 2011","Spring package 2011",["Season","Nature","Plant","Environment"]);
         _loc36_.addBrick(createBrick(233,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2011","",ItemTab.DECORATIVE,false,false,233 - 128,0,["Grass","Left","Grass","Short"]));
         _loc36_.addBrick(createBrick(234,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2011","",ItemTab.DECORATIVE,false,false,234 - 128,0,["Grass","Middle","Short"]));
         _loc36_.addBrick(createBrick(235,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2011","",ItemTab.DECORATIVE,false,false,235 - 128,0,["Grass","Right","Short"]));
         _loc36_.addBrick(createBrick(236,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2011","",ItemTab.DECORATIVE,false,false,236 - 128,0,["Grass","Hedge","Left","Big","Tall Grass","Bush"]));
         _loc36_.addBrick(createBrick(237,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2011","",ItemTab.DECORATIVE,false,false,237 - 128,0,["Grass","Hedge","Middle","Big","Tall Grass","Bush"]));
         _loc36_.addBrick(createBrick(238,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2011","",ItemTab.DECORATIVE,false,false,238 - 128,0,["Grass","Hedge","Right","Big","Tall Grass","Bush"]));
         _loc36_.addBrick(createBrick(239,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2011","",ItemTab.DECORATIVE,false,false,239 - 128,0,["Flower","Sun","Yellow","Flora"]));
         _loc36_.addBrick(createBrick(240,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2011","",ItemTab.DECORATIVE,false,false,240 - 128,0,["Bush","Plant","Shrub","Flora"]));
         brickPackages.push(_loc36_);
         var _loc37_:ItemBrickPackage = new ItemBrickPackage("Prizes","Your Prizes",["Prize"]);
         _loc37_.addBrick(createBrick(223,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","trophy for the Halloween 2011 contest winners",ItemTab.DECORATIVE,false,false,95,0,["Cup","Trophy","Halloween","Gold","Thanel"],false,true));
         _loc37_.addBrick(createBrick(478,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning third place in the Spring 2016 contest",ItemTab.DECORATIVE,false,false,298,0,["Trophy","Bronze","Spring","Flower"],false,true));
         _loc37_.addBrick(createBrick(479,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning second place in the Spring 2016 contest ",ItemTab.DECORATIVE,false,false,297,0,["Trophy","Silver","Spring","Flower"],false,true));
         _loc37_.addBrick(createBrick(480,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning first place in the Spring 2016 contest",ItemTab.DECORATIVE,false,false,296,0,["Trophy","Gold","Spring","Flower"],false,true));
         _loc37_.addBrick(createBrick(484,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning third place in the Summer 2016 contest",ItemTab.DECORATIVE,false,false,301,0,["Trophy","Bronze","Summer","Sun"],false,true));
         _loc37_.addBrick(createBrick(485,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning second place in the Summer 2016 contest ",ItemTab.DECORATIVE,false,false,300,0,["Trophy","Silver","Summer","Sun"],false,true));
         _loc37_.addBrick(createBrick(486,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning first place in the Summer 2016 contest",ItemTab.DECORATIVE,false,false,299,0,["Trophy","Gold","Summer","Sun"],false,true));
         _loc37_.addBrick(createBrick(1540,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning third place in the Design contest",ItemTab.DECORATIVE,false,false,338,0,["Trophy","Bronze","Design"],false,true));
         _loc37_.addBrick(createBrick(1541,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning second place in the Design contest",ItemTab.DECORATIVE,false,false,337,0,["Trophy","Silver","Design"],false,true));
         _loc37_.addBrick(createBrick(1542,ItemLayer.ABOVE,decoBlocksBMD,"bricktrophy","prize for winning first place in the Design contest",ItemTab.DECORATIVE,false,false,336,0,["Trophy","Gold","Design"],false,true));
         brickPackages.push(_loc37_);
         var _loc38_:ItemBrickPackage = new ItemBrickPackage("easter 2012","Easter  decorations 2012",["Holiday","Decor","Egg"]);
         _loc38_.addBrick(createBrick(256,ItemLayer.ABOVE,decoBlocksBMD,"brickeaster2012","",ItemTab.DECORATIVE,false,false,256 - 128,0,["Cyan","Teal","Wavy"]));
         _loc38_.addBrick(createBrick(257,ItemLayer.ABOVE,decoBlocksBMD,"brickeaster2012","",ItemTab.DECORATIVE,false,false,257 - 128,0,["Pink","Wavy"]));
         _loc38_.addBrick(createBrick(258,ItemLayer.ABOVE,decoBlocksBMD,"brickeaster2012","",ItemTab.DECORATIVE,false,false,258 - 128,0,["Green","Line","Yellow"]));
         _loc38_.addBrick(createBrick(259,ItemLayer.ABOVE,decoBlocksBMD,"brickeaster2012","",ItemTab.DECORATIVE,false,false,259 - 128,0,["Pink","Stripes"]));
         _loc38_.addBrick(createBrick(260,ItemLayer.ABOVE,decoBlocksBMD,"brickeaster2012","",ItemTab.DECORATIVE,false,false,260 - 128,0,["Green","Dots"]));
         brickPackages.push(_loc38_);
         var _loc39_:ItemBrickPackage = new ItemBrickPackage("basic","Basic Background Blocks");
         _loc39_.addBrick(createBrick(715,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,209,-1,["White","Light"]));
         _loc39_.addBrick(createBrick(500,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,500 - 500,-1,["Gray","Grey"]));
         _loc39_.addBrick(createBrick(645,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,139,-1,["Black","Dark","Shadow"]));
         _loc39_.addBrick(createBrick(503,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,503 - 500,-1,["Red"]));
         _loc39_.addBrick(createBrick(644,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,138,-1,["Orange"]));
         _loc39_.addBrick(createBrick(504,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,504 - 500,-1,["Yellow","Lime","Green"]));
         _loc39_.addBrick(createBrick(505,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,505 - 500,-1,["Green","Backdrop"]));
         _loc39_.addBrick(createBrick(506,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,506 - 500,-1,["Cyan","Teal","Turquoise","Blue"]));
         _loc39_.addBrick(createBrick(501,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,501 - 500,-1,["Blue"]));
         _loc39_.addBrick(createBrick(502,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,502 - 500,-1,["Purple","Magenta","Pink","Violet"]));
         brickPackages.push(_loc39_);
         var _loc40_:ItemBrickPackage = new ItemBrickPackage("beta","Beta Access",["Exclusive"]);
         _loc40_.addBrick(createBrick(743,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,237,-1,["White","Light"]));
         _loc40_.addBrick(createBrick(744,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,238,-1,["Grey","Gray","Taupe"]));
         _loc40_.addBrick(createBrick(745,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,239,-1,["Black","Dark","Onyx"]));
         _loc40_.addBrick(createBrick(746,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,240,-1,["Red","Ruby","Garnet"]));
         _loc40_.addBrick(createBrick(747,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,241,-1,["Orange","Copper"]));
         _loc40_.addBrick(createBrick(748,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,242,-1,["Yellow","Gold","Jasmine"]));
         _loc40_.addBrick(createBrick(749,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,243,-1,["Green","Emerald","Malachite"]));
         _loc40_.addBrick(createBrick(750,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,244,-1,["Blue","Cyan","Light blue","Aquamarine","Turquoise"]));
         _loc40_.addBrick(createBrick(751,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,245,-1,["Blue","Sapphire"]));
         _loc40_.addBrick(createBrick(752,ItemLayer.BACKGROUND,bgBlocksBMD,"pro","",ItemTab.BACKGROUND,false,true,246,-1,["Purple","Pink","Magenta","Violet","Amethyst"]));
         brickPackages.push(_loc40_);
         var _loc41_:ItemBrickPackage = new ItemBrickPackage("brick","Brick Background Blocks");
         _loc41_.addBrick(createBrick(716,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,210,4284177243,["White","Light"]));
         _loc41_.addBrick(createBrick(646,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,true,140,4280821800,["Gray","Grey"]));
         _loc41_.addBrick(createBrick(648,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,true,142,4279176975,["Black","Dark","Shadow"]));
         _loc41_.addBrick(createBrick(511,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,11,-1,["Red"]));
         _loc41_.addBrick(createBrick(507,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,7,-1,["Orange","Brown","Dirt","Soil"]));
         _loc41_.addBrick(createBrick(512,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,12,-1,["Yellow","Soil","Brown"]));
         _loc41_.addBrick(createBrick(510,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,10,-1,["Green","Lime"]));
         _loc41_.addBrick(createBrick(508,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,8,-1,["Cyan","Teal","Turquoise","Blue"]));
         _loc41_.addBrick(createBrick(647,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,true,141,-1,["Blue"]));
         _loc41_.addBrick(createBrick(509,ItemLayer.BACKGROUND,bgBlocksBMD,"","",ItemTab.BACKGROUND,false,false,9,-1,["Magenta","Purple","Violet"]));
         brickPackages.push(_loc41_);
         var _loc42_:ItemBrickPackage = new ItemBrickPackage("checker","Checker Backgrounds",["Checkered"]);
         _loc42_.addBrick(createBrick(718,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,false,212,-1,["White","Light"]));
         _loc42_.addBrick(createBrick(513,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,false,513 - 500,-1,["Gray","Grey","Shadow"]));
         _loc42_.addBrick(createBrick(650,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,true,144,-1,["Black","Dark","Shadow"]));
         _loc42_.addBrick(createBrick(516,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,false,516 - 500,-1,["Red","Pink"]));
         _loc42_.addBrick(createBrick(649,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,true,143,-1,["Orange"]));
         _loc42_.addBrick(createBrick(517,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,false,517 - 500,-1,["Yellow","Lime"]));
         _loc42_.addBrick(createBrick(518,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,false,518 - 500,-1,["Green"]));
         _loc42_.addBrick(createBrick(519,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,false,519 - 500,-1,["Cyan","Teal","Turquoise","Blue"]));
         _loc42_.addBrick(createBrick(514,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,false,514 - 500,-1,["Blue"]));
         _loc42_.addBrick(createBrick(515,ItemLayer.BACKGROUND,bgBlocksBMD,"brickchecker","",ItemTab.BACKGROUND,false,false,515 - 500,-1,["Purple","Magenta","Pink","Violet"]));
         brickPackages.push(_loc42_);
         var _loc43_:ItemBrickPackage = new ItemBrickPackage("dark","Solid Dark Backgrounds",["Solid"]);
         _loc43_.addBrick(createBrick(719,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,false,213,-1,["White","Light"]));
         _loc43_.addBrick(createBrick(520,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,false,520 - 500,-1,["Gray","Grey","Shadow"]));
         _loc43_.addBrick(createBrick(652,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,true,146,-1,["Black","Dark","Shadow"]));
         _loc43_.addBrick(createBrick(523,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,false,523 - 500,-1,["Red"]));
         _loc43_.addBrick(createBrick(651,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,true,145,-1,["Orange"]));
         _loc43_.addBrick(createBrick(524,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,false,524 - 500,-1,["Yellow","Lime"]));
         _loc43_.addBrick(createBrick(525,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,false,525 - 500,-1,["Green"]));
         _loc43_.addBrick(createBrick(526,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,false,526 - 500,-1,["Cyan","Teal","Turquoise","Blue"]));
         _loc43_.addBrick(createBrick(521,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,false,521 - 500,-1,["Blue"]));
         _loc43_.addBrick(createBrick(522,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdark","",ItemTab.BACKGROUND,false,false,522 - 500,-1,["Purple","Magenta","Pink","Violet"]));
         brickPackages.push(_loc43_);
         var _loc44_:ItemBrickPackage = new ItemBrickPackage("normal","Solid backrounds",["Solid"]);
         _loc44_.addBrick(createBrick(717,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,false,211,-1,["White","Light"]));
         _loc44_.addBrick(createBrick(610,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,110,-1,["Gray","Grey","Shadow"]));
         _loc44_.addBrick(createBrick(654,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,148,-1,["Black","Dark","Shadow"]));
         _loc44_.addBrick(createBrick(613,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,113,-1,["Red"]));
         _loc44_.addBrick(createBrick(653,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,147,-1,["Orange"]));
         _loc44_.addBrick(createBrick(614,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,114,-1,["Yellow","Lime"]));
         _loc44_.addBrick(createBrick(615,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,115,-1,["Green"]));
         _loc44_.addBrick(createBrick(616,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,116,-1,["Cyan","Teal","Turquoise","Blue"]));
         _loc44_.addBrick(createBrick(611,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,111,-1,["Blue"]));
         _loc44_.addBrick(createBrick(612,ItemLayer.BACKGROUND,bgBlocksBMD,"bricknormal","",ItemTab.BACKGROUND,false,true,112,-1,["Purple","Magenta","Pink","Violet"]));
         brickPackages.push(_loc44_);
         var _loc45_:ItemBrickPackage = new ItemBrickPackage("pastel","Pretty Pastel Backgrounds",["Solid","Bright"]);
         _loc45_.addBrick(createBrick(532,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpastel","",ItemTab.BACKGROUND,false,false,32,-1,["Pink","Red","Magenta"]));
         _loc45_.addBrick(createBrick(676,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpastel","",ItemTab.BACKGROUND,false,false,170,-1,["Orange"]));
         _loc45_.addBrick(createBrick(527,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpastel","",ItemTab.BACKGROUND,false,false,27,-1,["Yellow"]));
         _loc45_.addBrick(createBrick(529,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpastel","",ItemTab.BACKGROUND,false,false,29,-1,["Yellow","Green","Lime"]));
         _loc45_.addBrick(createBrick(528,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpastel","",ItemTab.BACKGROUND,false,false,28,-1,["Green"]));
         _loc45_.addBrick(createBrick(530,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpastel","",ItemTab.BACKGROUND,false,false,30,-1,["Cyan","Light Blue","Sky"]));
         _loc45_.addBrick(createBrick(531,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpastel","",ItemTab.BACKGROUND,false,false,31,-1,["Blue","Sky"]));
         _loc45_.addBrick(createBrick(677,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpastel","",ItemTab.BACKGROUND,false,false,171,-1,["Purple"]));
         brickPackages.push(_loc45_);
         var _loc46_:ItemBrickPackage = new ItemBrickPackage("canvas","Canvas Backgrounds",["Rough","Textured"]);
         _loc46_.addBrick(createBrick(538,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,38,-1,["Gray","Grey"]));
         _loc46_.addBrick(createBrick(671,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,165,-1,["Red"]));
         _loc46_.addBrick(createBrick(533,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,33,-1,["Orange"]));
         _loc46_.addBrick(createBrick(534,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,34,-1,["Beige","Brown","Tan"]));
         _loc46_.addBrick(createBrick(535,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,35,-1,["Yellow"]));
         _loc46_.addBrick(createBrick(536,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,36,-1,["Green"]));
         _loc46_.addBrick(createBrick(537,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,37,-1,["Cyan","Light Blue","Water"]));
         _loc46_.addBrick(createBrick(606,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,106,-1,["Blue"]));
         _loc46_.addBrick(createBrick(672,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcanvas","",ItemTab.BACKGROUND,false,false,166,-1,["Purple","Violet"]));
         brickPackages.push(_loc46_);
         var _loc47_:ItemBrickPackage = new ItemBrickPackage("carnival","Carnival backgrounds");
         _loc47_.addBrick(createBrick(545,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcarnival","",ItemTab.BACKGROUND,false,false,45,-1,["Stripes","Red","Yellow","McDonald\'s"]));
         _loc47_.addBrick(createBrick(546,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcarnival","",ItemTab.BACKGROUND,false,false,46,-1,["Stripes","Purple","Violet","Dark"]));
         _loc47_.addBrick(createBrick(547,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcarnival","",ItemTab.BACKGROUND,false,false,47,-1,["Magenta","Pink"]));
         _loc47_.addBrick(createBrick(548,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcarnival","",ItemTab.BACKGROUND,false,false,48,-1,["Checker","Black","White","Double"]));
         _loc47_.addBrick(createBrick(549,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcarnival","",ItemTab.BACKGROUND,false,false,49,-1,["Green"]));
         _loc47_.addBrick(createBrick(558,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcarnival","",ItemTab.BACKGROUND,false,false,58,-1,["Yellow"]));
         _loc47_.addBrick(createBrick(563,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcarnival","",ItemTab.BACKGROUND,false,false,63,-1,["Poland","Stripes","Red","White"]));
         _loc47_.addBrick(createBrick(607,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcarnival","",ItemTab.BACKGROUND,false,false,107,-1,["Blue","Solid"]));
         brickPackages.push(_loc47_);
         var _loc48_:ItemBrickPackage = new ItemBrickPackage("candy","CandyLand",["Sweet","Sugar","Food"]);
         _loc48_.addBrick(createBrick(60,ItemLayer.FORGROUND,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,60,-1,["Pink","Cotton Candy","Fairy Floss","Stripes","Pastel"]));
         _loc48_.addBrick(createBrick(1154,ItemLayer.FORGROUND,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,310,-1,["Blue","Cotton Candy","Fairy Floss","Stripes","Pastel"]));
         _loc48_.addBrick(createBrick(61,ItemLayer.DECORATION,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,61,-1,["Platform","Magenta","Pink","One-Way"]));
         _loc48_.addBrick(createBrick(62,ItemLayer.DECORATION,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,62,-1,["Platform","Red","One-Way","One way"]));
         _loc48_.addBrick(createBrick(63,ItemLayer.DECORATION,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,63,-1,["Platform","Cyan","One-Way","One way"]));
         _loc48_.addBrick(createBrick(64,ItemLayer.DECORATION,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,64,-1,["Platform","Green","One-Way","One way"]));
         _loc48_.addBrick(createBrick(65,ItemLayer.DECORATION,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,65,-1,["Candy","Cane","Red","White","Stripes"]));
         _loc48_.addBrick(createBrick(66,ItemLayer.DECORATION,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,66,-1,["Cake","Licorice","Hamburger","Sandwich","Stripes"]));
         _loc48_.addBrick(createBrick(67,ItemLayer.DECORATION,blocksBMD,"brickcandy","",ItemTab.BLOCK,false,true,67,-1,["Gingerbread","Chocolate","Brown","Cake","Dirt"]));
         _loc48_.addBrick(createBrick(227,ItemLayer.ABOVE,decoBlocksBMD,"brickcandy","",ItemTab.DECORATIVE,false,false,99,0,["Cream","Small","Creme","Whipped Topping","White"]));
         _loc48_.addBrick(createBrick(431,ItemLayer.ABOVE,decoBlocksBMD,"brickcandy","",ItemTab.DECORATIVE,false,false,273,0,["Cream","Big","Creme","Whipped Topping","White"]));
         _loc48_.addBrick(createBrick(432,ItemLayer.ABOVE,decoBlocksBMD,"brickcandy","",ItemTab.DECORATIVE,false,false,274,0,["Gumdrop","Red"]));
         _loc48_.addBrick(createBrick(433,ItemLayer.ABOVE,decoBlocksBMD,"brickcandy","",ItemTab.DECORATIVE,false,false,275,0,["Gumdrop","Green"]));
         _loc48_.addBrick(createBrick(434,ItemLayer.ABOVE,decoBlocksBMD,"brickcandy","",ItemTab.DECORATIVE,false,false,276,0,["Gumdrop","Pink"]));
         _loc48_.addBrick(createBrick(539,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcandy","",ItemTab.BACKGROUND,false,false,39,-1,["Stripes","Pink","Pastel"]));
         _loc48_.addBrick(createBrick(540,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcandy","",ItemTab.BACKGROUND,false,false,40,-1,["Stripes","Blue","Pastel"]));
         brickPackages.push(_loc48_);
         var _loc49_:ItemBrickPackage = new ItemBrickPackage("summer 2011","Summer package 2011",["Season","Hot","Beach"]);
         _loc49_.addBrick(createBrick(59,ItemLayer.FORGROUND,blocksBMD,"bricksummer2011","",ItemTab.BLOCK,false,true,59,-1,["Sand","Environment"]));
         _loc49_.addBrick(createBrick(228,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2011","",ItemTab.DECORATIVE,false,false,228 - 128,0,["Umbrella","Parasol","Beach","Sun"]));
         _loc49_.addBrick(createBrick(229,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2011","",ItemTab.DECORATIVE,false,false,229 - 128,0,["Left","Sand","Corner","Dune","Environment"]));
         _loc49_.addBrick(createBrick(230,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2011","",ItemTab.DECORATIVE,false,false,230 - 128,0,["Right","Sand","Corner","Dune","Environment"]));
         _loc49_.addBrick(createBrick(231,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2011","",ItemTab.DECORATIVE,false,false,231 - 128,0,["Rock","Stone","Environment"]));
         _loc49_.addBrick(createBrick(232,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2011","",ItemTab.DECORATIVE,false,false,232 - 128,0,["Bush","Nature","Plant","Yellow","Dead","Tumbleweed","Environment"]));
         brickPackages.push(_loc49_);
         var _loc50_:ItemBrickPackage = new ItemBrickPackage("halloween 2011","Halloween pack",["Scary","Holiday","Creepy"]);
         _loc50_.addBrick(createBrick(68,ItemLayer.FORGROUND,blocksBMD,"brickhw2011","",ItemTab.BLOCK,false,true,68,-1,["Brick","Gray","Grey","Bloody","Wall","House"]));
         _loc50_.addBrick(createBrick(69,ItemLayer.FORGROUND,blocksBMD,"brickhw2011","",ItemTab.BLOCK,false,true,69,-1,["Basic","Gray","Grey"]));
         _loc50_.addBrick(createBrick(224,ItemLayer.ABOVE,decoBlocksBMD,"brickhw2011","",ItemTab.DECORATIVE,false,false,224 - 128,0,["Grave","Tombstone","Headstone","Marker","Dead"]));
         _loc50_.addBrick(createBrick(225,ItemLayer.ABOVE,decoBlocksBMD,"brickhw2011","",ItemTab.DECORATIVE,false,true,225 - 128,0,["Cobweb","Spider Web","Right","Corner"]));
         _loc50_.addBrick(createBrick(226,ItemLayer.ABOVE,decoBlocksBMD,"brickhw2011","",ItemTab.DECORATIVE,false,true,226 - 128,0,["Cobweb","Spider Web","Left","Corner"]));
         _loc50_.addBrick(createBrick(541,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2011","",ItemTab.BACKGROUND,false,false,541 - 500,-1,["Stone","Gray","Grey"]));
         _loc50_.addBrick(createBrick(542,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2011","",ItemTab.BACKGROUND,false,false,542 - 500,-1,["Brick","Gray","Grey","House"]));
         _loc50_.addBrick(createBrick(543,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2011","",ItemTab.BACKGROUND,false,false,543 - 500,-1,["Brick","Damaged","Right","Ruins","Corner","House"]));
         _loc50_.addBrick(createBrick(544,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2011","",ItemTab.BACKGROUND,false,false,544 - 500,-1,["Brick","Damaged","Left","Ruins","Corner","House"]));
         brickPackages.push(_loc50_);
         var _loc51_:ItemBrickPackage = new ItemBrickPackage("christmas 2011","XMAS  decorations",["2011","Xmas","Bauble","Ornament","Holiday"]);
         _loc51_.addBrick(createBrick(218,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2011","",ItemTab.DECORATIVE,false,true,218 - 128,0,["Red","Bulb","Round","Holiday","Circle"]));
         _loc51_.addBrick(createBrick(219,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2011","",ItemTab.DECORATIVE,false,true,219 - 128,0,["Green","Bulb","Round","Holiday","Circle"]));
         _loc51_.addBrick(createBrick(220,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2011","",ItemTab.DECORATIVE,false,true,220 - 128,0,["Blue","Bulb","Round","Holiday","Circle"]));
         _loc51_.addBrick(createBrick(221,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2011","",ItemTab.DECORATIVE,false,true,221 - 128,0,["Circle","Wreath","Garland","Holiday","Green"]));
         _loc51_.addBrick(createBrick(222,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2011","",ItemTab.DECORATIVE,false,true,222 - 128,0,["Star","Yellow","Night","Sky"]));
         brickPackages.push(_loc51_);
         var _loc52_:ItemBrickPackage = new ItemBrickPackage("sci-fi","Sci-Fi Package",["Future","Science Fiction","Alien","UFO"]);
         _loc52_.addBrick(createBrick(84,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,84,-1,["Red","Screen","Panel"]));
         _loc52_.addBrick(createBrick(85,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,85,-1,["Blue","Screen","Panel"]));
         _loc52_.addBrick(createBrick(1150,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,308,-1,["Green","Screen","Panel"]));
         _loc52_.addBrick(createBrick(1151,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,309,-1,["Yellow","Screen","Panel"]));
         _loc52_.addBrick(createBrick(1162,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,317,-1,["Magenta","Pink","Purple","Screen","Panel"]));
         _loc52_.addBrick(createBrick(1163,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,318,-1,["Cyan","Screen","Panel"]));
         _loc52_.addBrick(createBrick(86,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,86,-1,["Metal","Gray","Bumpy","Grey"]));
         _loc52_.addBrick(createBrick(87,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,87,4294967295,["Metal","White","Grey","Gray"]));
         _loc52_.addBrick(createBrick(88,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,88,-1,["Brown","Camouflauge","Leopard","Carpet"]));
         _loc52_.addBrick(createBrick(89,ItemLayer.DECORATION,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,89,-1,["Platform","Red","One-way","One way"]));
         _loc52_.addBrick(createBrick(90,ItemLayer.DECORATION,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,90,-1,["Platform","Blue","One-way","One way"]));
         _loc52_.addBrick(createBrick(91,ItemLayer.DECORATION,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,91,-1,["Platform","Green","One-way","One way"]));
         _loc52_.addBrick(createBrick(ItemId.ONEWAY_SCIFI_YELLOW,ItemLayer.DECORATION,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,234,-1,["Platform","Yellow","One-way","One way"]));
         _loc52_.addBrick(createBrick(ItemId.ONEWAY_SCIFI_MAGENTA,ItemLayer.DECORATION,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,319,-1,["Platform","Magenta","Pink","Purple","One-way","One way"]));
         _loc52_.addBrick(createBrick(ItemId.ONEWAY_SCIFI_CYAN,ItemLayer.DECORATION,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,320,-1,["Platform","Cyan","One-way","One way"]));
         _loc52_.addBrick(createBrick(ItemId.GLOWYLINE_BLUE_SLOPE,ItemLayer.DECORATION,specialBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,true,177,0,["Morphable","Laser","Neon","Blue","Flourescent","Corner"]));
         _loc52_.addBrick(createBrick(ItemId.GLOWY_LINE_BLUE_STRAIGHT,ItemLayer.DECORATION,specialBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,true,181,0,["Morphable","Laser","Neon","Blue","Flourescent","Middle"]));
         _loc52_.addBrick(createBrick(ItemId.GLOWY_LINE_GREEN_SLOPE,ItemLayer.DECORATION,specialBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,true,169,0,["Morphable","Laser","Neon","Green","Flourescent","Corner"]));
         _loc52_.addBrick(createBrick(ItemId.GLOWY_LINE_GREEN_STRAIGHT,ItemLayer.DECORATION,specialBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,true,173,0,["Morphable","Laser","Neon","Green","Flourescent","Middle"]));
         _loc52_.addBrick(createBrick(ItemId.GLOWY_LINE_YELLOW_SLOPE,ItemLayer.DECORATION,specialBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,true,161,0,["Morphable","Laser","Neon","Yellow","Orange","Flourescent","Corner"]));
         _loc52_.addBrick(createBrick(ItemId.GLOWY_LINE_YELLOW_STRAIGHT,ItemLayer.DECORATION,specialBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,true,165,0,["Morphable","Laser","Neon","Yellow","Orange","Flourescent","Middle"]));
         _loc52_.addBrick(createBrick(ItemId.GLOWY_LINE_RED_SLOPE,ItemLayer.DECORATION,specialBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,true,409,0,["Morphable","Laser","Neon","Red","Pink","Flourescent","Corner"]));
         _loc52_.addBrick(createBrick(ItemId.GLOWY_LINE_RED_STRAIGHT,ItemLayer.DECORATION,specialBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,true,413,0,["Morphable","Laser","Neon","Red","Pink","Flourescent","Middle"]));
         _loc52_.addBrick(createBrick(637,ItemLayer.BACKGROUND,bgBlocksBMD,"brickscifi","",ItemTab.BACKGROUND,false,true,131,4285758849,["Gray","Outline","Grey"]));
         brickPackages.push(_loc52_);
         var _loc53_:ItemBrickPackage = new ItemBrickPackage("prison","Prison",["Cell","Jail"]);
         _loc53_.addBrick(createBrick(261,ItemLayer.ABOVE,decoBlocksBMD,"brickprison","",ItemTab.DECORATIVE,false,false,261 - 128,0,["Bars","Metal"]));
         _loc53_.addBrick(createBrick(92,ItemLayer.FORGROUND,blocksBMD,"brickprison","",ItemTab.BLOCK,false,true,92,-1,["Wall","Brick","Grey","Gray","House"]));
         _loc53_.addBrick(createBrick(550,ItemLayer.BACKGROUND,bgBlocksBMD,"brickprison","",ItemTab.BACKGROUND,false,true,50,-1,["Wall","Brick","Background","Grey","Gray","House"]));
         _loc53_.addBrick(createBrick(551,ItemLayer.BACKGROUND,bgBlocksBMD,"brickprison","",ItemTab.BACKGROUND,false,true,51,-1,["Window","Light","Orange","Brick"]));
         _loc53_.addBrick(createBrick(552,ItemLayer.BACKGROUND,bgBlocksBMD,"brickprison","",ItemTab.BACKGROUND,false,true,52,-1,["Window","Light","Blue","Brick"]));
         _loc53_.addBrick(createBrick(553,ItemLayer.BACKGROUND,bgBlocksBMD,"brickprison","",ItemTab.BACKGROUND,false,true,53,-1,["Window","Dark","Vent","Brick","Grey","Gray","Drain"]));
         brickPackages.push(_loc53_);
         var _loc54_:ItemBrickPackage = new ItemBrickPackage("windows","Colored Windows",["Glass"]);
         _loc54_.addBrick(createBrick(262,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,262 - 128,0,["Transparent","Clear","Black","Dark"]));
         _loc54_.addBrick(createBrick(268,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,268 - 128,0,["Transparent","Red","Pink"]));
         _loc54_.addBrick(createBrick(269,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,269 - 128,0,["Transparent","Orange"]));
         _loc54_.addBrick(createBrick(270,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,270 - 128,0,["Transparent","Yellow"]));
         _loc54_.addBrick(createBrick(263,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,263 - 128,0,["Transparent","Green"]));
         _loc54_.addBrick(createBrick(264,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,264 - 128,0,["Transparent","Turquoise","Cyan","Teal","Blue","Green"]));
         _loc54_.addBrick(createBrick(265,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,265 - 128,0,["Transparent","Blue"]));
         _loc54_.addBrick(createBrick(266,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,266 - 128,0,["Transparent","Purple","Violet","Indigo"]));
         _loc54_.addBrick(createBrick(267,ItemLayer.ABOVE,decoBlocksBMD,"brickwindows","",ItemTab.DECORATIVE,false,false,267 - 128,0,["Transparent","Pink","Magenta"]));
         brickPackages.push(_loc54_);
         var _loc55_:ItemBrickPackage = new ItemBrickPackage("pirate","Pirate Pack");
         _loc55_.addBrick(createBrick(93,ItemLayer.FORGROUND,blocksBMD,"brickpirate","",ItemTab.BLOCK,false,true,93,-1,["Wood","Planks","Board","Siding","Navy","House"]));
         _loc55_.addBrick(createBrick(94,ItemLayer.FORGROUND,blocksBMD,"brickpirate","",ItemTab.BLOCK,false,true,94,-1,["Chest","Treasure","Loot","Booty","Navy"]));
         _loc55_.addBrick(createBrick(154,ItemLayer.DECORATION,blocksBMD,"brickpirate","",ItemTab.BLOCK,false,true,131,0,["Platform","Wood","Ship","Navy","One Way","One-Way"]));
         _loc55_.addBrick(createBrick(271,ItemLayer.DECORATION,decoBlocksBMD,"brickpirate","",ItemTab.DECORATIVE,false,true,143,0,["Wood","Decoration","Navy"]));
         _loc55_.addBrick(createBrick(272,ItemLayer.ABOVE,decoBlocksBMD,"brickpirate","",ItemTab.DECORATIVE,false,true,144,0,["Skull","Head","Skeleton","Creepy","Death"]));
         _loc55_.addBrick(createBrick(435,ItemLayer.DECORATION,decoBlocksBMD,"brickpirate","",ItemTab.DECORATIVE,false,false,277,0,["Cannon","Sea war","Gun","Ship","Navy"]));
         _loc55_.addBrick(createBrick(436,ItemLayer.DECORATION,decoBlocksBMD,"brickpirate","",ItemTab.DECORATIVE,false,false,278,0,["Port Window","Porthole","Ship","Navy"]));
         _loc55_.addBrick(createBrick(554,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpirate","",ItemTab.BACKGROUND,false,false,54,-1,["Wood","Dark","Planks","Board","Ship","House","Siding","Navy"]));
         _loc55_.addBrick(createBrick(555,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpirate","",ItemTab.BACKGROUND,false,false,55,-1,["Wood","Light","Planks","Board","Ship","House","Siding","Navy"]));
         _loc55_.addBrick(createBrick(559,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpirate","",ItemTab.BACKGROUND,false,false,59,-1,["Wood","Dark","Planks","Board","Ship","House","Siding","Navy"]));
         _loc55_.addBrick(createBrick(560,ItemLayer.BACKGROUND,bgBlocksBMD,"brickpirate","",ItemTab.BACKGROUND,false,false,60,-1,["Flag","Jolly Roger","Skull","Ship","Navy"]));
         brickPackages.push(_loc55_);
         var _loc56_:ItemBrickPackage = new ItemBrickPackage("stone","Stone Pack",["Cave","Rocks","Environment","House"]);
         _loc56_.addBrick(createBrick(95,ItemLayer.FORGROUND,blocksBMD,"brickstone","",ItemTab.BLOCK,false,true,95,-1,["Gray","Grey"]));
         _loc56_.addBrick(createBrick(1044,ItemLayer.FORGROUND,blocksBMD,"brickstone","",ItemTab.BLOCK,false,true,226,-1,["Green","Limestone"]));
         _loc56_.addBrick(createBrick(1045,ItemLayer.FORGROUND,blocksBMD,"brickstone","",ItemTab.BLOCK,false,true,227,-1,["Brown","Dirt"]));
         _loc56_.addBrick(createBrick(1046,ItemLayer.FORGROUND,blocksBMD,"brickstone","",ItemTab.BLOCK,false,true,228,-1,["Blue"]));
         _loc56_.addBrick(createBrick(561,ItemLayer.BACKGROUND,bgBlocksBMD,"brickstone","",ItemTab.BACKGROUND,false,false,61,-1,["Dark","Gray","Grey"]));
         _loc56_.addBrick(createBrick(562,ItemLayer.BACKGROUND,bgBlocksBMD,"brickstone","",ItemTab.BACKGROUND,false,false,62,-1,["Half","Dark","Gray","Grey"]));
         _loc56_.addBrick(createBrick(688,ItemLayer.BACKGROUND,bgBlocksBMD,"brickstone","",ItemTab.BACKGROUND,false,false,182,-1,["Green","Limestone"]));
         _loc56_.addBrick(createBrick(689,ItemLayer.BACKGROUND,bgBlocksBMD,"brickstone","",ItemTab.BACKGROUND,false,false,183,-1,["Half","Limestone"]));
         _loc56_.addBrick(createBrick(690,ItemLayer.BACKGROUND,bgBlocksBMD,"brickstone","",ItemTab.BACKGROUND,false,false,184,-1,["Brown"]));
         _loc56_.addBrick(createBrick(691,ItemLayer.BACKGROUND,bgBlocksBMD,"brickstone","",ItemTab.BACKGROUND,false,false,185,-1,["Half","Brown"]));
         _loc56_.addBrick(createBrick(692,ItemLayer.BACKGROUND,bgBlocksBMD,"brickstone","",ItemTab.BACKGROUND,false,false,186,-1,["Blue"]));
         _loc56_.addBrick(createBrick(693,ItemLayer.BACKGROUND,bgBlocksBMD,"brickstone","",ItemTab.BACKGROUND,false,false,187,-1,["Half"]));
         brickPackages.push(_loc56_);
         var _loc57_:ItemBrickPackage = new ItemBrickPackage("dojo","Dojo Pack",["Ninja","Asian","Japanese","Kung Fu"]);
         _loc57_.addBrick(createBrick(96,ItemLayer.DECORATION,blocksBMD,"brickninja","",ItemTab.BLOCK,false,true,96,0,["Platform","White","One-way","One way"]));
         _loc57_.addBrick(createBrick(97,ItemLayer.DECORATION,blocksBMD,"brickninja","",ItemTab.BLOCK,false,true,97,0,["Platform","Gray","Grey","One-way","One way"]));
         _loc57_.addBrick(createBrick(564,ItemLayer.BACKGROUND,bgBlocksBMD,"brickninja","",ItemTab.BACKGROUND,false,true,64,-1,["White"]));
         _loc57_.addBrick(createBrick(565,ItemLayer.BACKGROUND,bgBlocksBMD,"brickninja","",ItemTab.BACKGROUND,false,true,65,-1,["Grey","Gray"]));
         _loc57_.addBrick(createBrick(566,ItemLayer.BACKGROUND,bgBlocksBMD,"brickninja","",ItemTab.BACKGROUND,false,true,66,-1,["Roof","Blue","Tile","Shingles","House"]));
         _loc57_.addBrick(createBrick(567,ItemLayer.BACKGROUND,bgBlocksBMD,"brickninja","",ItemTab.BACKGROUND,false,true,67,-1,["Roof","Blue","Dark","Tile","Shingles","House"]));
         _loc57_.addBrick(createBrick(667,ItemLayer.BACKGROUND,bgBlocksBMD,"brickninja","",ItemTab.BACKGROUND,false,false,161,-1,["Roof","Red","Tile","Shingles","House"]));
         _loc57_.addBrick(createBrick(668,ItemLayer.BACKGROUND,bgBlocksBMD,"brickninja","",ItemTab.BACKGROUND,false,false,162,-1,["Roof","Red","Dark","Tile","Shingles","House"]));
         _loc57_.addBrick(createBrick(669,ItemLayer.BACKGROUND,bgBlocksBMD,"brickninja","",ItemTab.BACKGROUND,false,false,163,-1,["Roof","Green","Tile","Shingles","House"]));
         _loc57_.addBrick(createBrick(670,ItemLayer.BACKGROUND,bgBlocksBMD,"brickninja","",ItemTab.BACKGROUND,false,false,164,-1,["Roof","Green","Dark","Tile","Shingles","House"]));
         _loc57_.addBrick(createBrick(ItemId.DOJO_LIGHT_LEFT,ItemLayer.DECORATION,specialBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,389,0,["Morphable","Fin","Left","Blue","Green","Red","Corner"]));
         _loc57_.addBrick(createBrick(ItemId.DOJO_LIGHT_RIGHT,ItemLayer.DECORATION,specialBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,392,0,["Morphable","Fin","Right","Blue","Green","Red","Corner"]));
         _loc57_.addBrick(createBrick(278,ItemLayer.DECORATION,decoBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,278 - 128,0,["Window","Open","House"]));
         _loc57_.addBrick(createBrick(ItemId.DOJO_DARK_LEFT,ItemLayer.DECORATION,specialBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,395,0,["Morphable","Fin","Left","Dark","Blue","Green","Red","Corner"]));
         _loc57_.addBrick(createBrick(ItemId.DOJO_DARK_RIGHT,ItemLayer.DECORATION,specialBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,398,0,["Morphable","Fin","Right","Dark","Blue","Green","Red","Corner"]));
         _loc57_.addBrick(createBrick(281,ItemLayer.DECORATION,decoBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,281 - 128,0,["Window","Dark","Open","House"]));
         _loc57_.addBrick(createBrick(282,ItemLayer.DECORATION,decoBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,282 - 128,0,["Character","Chinese"]));
         _loc57_.addBrick(createBrick(283,ItemLayer.DECORATION,decoBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,283 - 128,0,["Character","Chinese"]));
         _loc57_.addBrick(createBrick(284,ItemLayer.DECORATION,decoBlocksBMD,"brickninja","",ItemTab.DECORATIVE,false,false,284 - 128,0,["Yin Yang","Chinese","White","Black white"]));
         brickPackages.push(_loc57_);
         var _loc58_:ItemBrickPackage = new ItemBrickPackage("wild west","Wild West Pack",["Cowboy","Western","House"]);
         _loc58_.addBrick(createBrick(122,ItemLayer.DECORATION,blocksBMD,"brickwildwest","",ItemTab.BLOCK,false,true,99,0,["Brown","Wood","Platform","One way","One-Way"]));
         _loc58_.addBrick(createBrick(123,ItemLayer.DECORATION,blocksBMD,"brickwildwest","",ItemTab.BLOCK,false,true,100,0,["Red","Wood","Platform","One way","One-Way"]));
         _loc58_.addBrick(createBrick(124,ItemLayer.DECORATION,blocksBMD,"brickwildwest","",ItemTab.BLOCK,false,true,101,0,["Blue","Wood","Platform","One way","One-Way"]));
         _loc58_.addBrick(createBrick(125,ItemLayer.DECORATION,blocksBMD,"brickwildwest","",ItemTab.BLOCK,false,true,102,0,["Dark","Brown","Wood","Platform","One way","One-Way"]));
         _loc58_.addBrick(createBrick(126,ItemLayer.DECORATION,blocksBMD,"brickwildwest","",ItemTab.BLOCK,false,true,103,0,["Dark","Red","Wood","Platform","One way","One-Way"]));
         _loc58_.addBrick(createBrick(127,ItemLayer.DECORATION,blocksBMD,"brickwildwest","",ItemTab.BLOCK,false,true,104,0,["Dark","Blue","Wood","Platform","One way","One-Way"]));
         _loc58_.addBrick(createBrick(568,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwildwest","",ItemTab.BACKGROUND,false,true,68,-1,["Siding","Wood","Brown","Planks","Ship","Board"]));
         _loc58_.addBrick(createBrick(569,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwildwest","",ItemTab.BACKGROUND,false,true,69,-1,["Siding","Wood","Dark Brown","Planks","Ship","Board"]));
         _loc58_.addBrick(createBrick(570,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwildwest","",ItemTab.BACKGROUND,false,true,70,-1,["Siding","Wood","Red","Planks","Board","Board"]));
         _loc58_.addBrick(createBrick(571,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwildwest","",ItemTab.BACKGROUND,false,true,71,-1,["Siding","Wood","Dark Red","Planks","Board"]));
         _loc58_.addBrick(createBrick(572,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwildwest","",ItemTab.BACKGROUND,false,true,72,-1,["Siding","Wood","Blue","Planks","Board"]));
         _loc58_.addBrick(createBrick(573,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwildwest","",ItemTab.BACKGROUND,false,true,73,-1,["Siding","Wood","Dark Blue","Planks","Board"]));
         _loc58_.addBrick(createBrick(285,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,true,285 - 128,0,["Pole","White"]));
         _loc58_.addBrick(createBrick(286,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,true,286 - 128,0,["Pole","Gray","Dark","Grey"]));
         _loc58_.addBrick(createBrick(1521,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,true,321,0,["Pole","White"]));
         _loc58_.addBrick(createBrick(1522,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,true,322,0,["Pole","Gray","Dark","Grey"]));
         _loc58_.addBrick(createBrick(287,ItemLayer.DECORATION,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,287 - 128,0,["Door","Wood","Brown","Left"]));
         _loc58_.addBrick(createBrick(288,ItemLayer.DECORATION,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,288 - 128,0,["Door","Wood","Brown","Right"]));
         _loc58_.addBrick(createBrick(289,ItemLayer.DECORATION,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,289 - 128,0,["Door","Wood","Red","Left"]));
         _loc58_.addBrick(createBrick(290,ItemLayer.DECORATION,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,290 - 128,0,["Door","Wood","Red","Right"]));
         _loc58_.addBrick(createBrick(291,ItemLayer.DECORATION,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,291 - 128,0,["Door","Wood","Blue","Left"]));
         _loc58_.addBrick(createBrick(292,ItemLayer.DECORATION,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,292 - 128,0,["Door","Wood","Blue","Right"]));
         _loc58_.addBrick(createBrick(293,ItemLayer.DECORATION,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,293 - 128,0,["Window","Curtains"]));
         _loc58_.addBrick(createBrick(294,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,294 - 128,0,["Fence","Wood","Brown"]));
         _loc58_.addBrick(createBrick(295,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,295 - 128,0,["Fence","Wood","Brown"]));
         _loc58_.addBrick(createBrick(296,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,296 - 128,0,["Fence","Wood","Red"]));
         _loc58_.addBrick(createBrick(297,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,297 - 128,0,["Fence","Wood","Red"]));
         _loc58_.addBrick(createBrick(298,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,298 - 128,0,["Fence","Wood","Blue"]));
         _loc58_.addBrick(createBrick(299,ItemLayer.ABOVE,decoBlocksBMD,"brickwildwest","",ItemTab.DECORATIVE,false,false,299 - 128,0,["Fence","Wood","Blue"]));
         brickPackages.push(_loc58_);
         var _loc59_:ItemBrickPackage = new ItemBrickPackage("plastic","Plastic Pack",["Neon","Bright"]);
         _loc59_.addBrick(createBrick(129,ItemLayer.DECORATION,blocksBMD,"brickplastic","",ItemTab.BLOCK,false,true,106,-1,["Red"]));
         _loc59_.addBrick(createBrick(135,ItemLayer.DECORATION,blocksBMD,"brickplastic","",ItemTab.BLOCK,false,true,112,-1,["Orange"]));
         _loc59_.addBrick(createBrick(130,ItemLayer.DECORATION,blocksBMD,"brickplastic","",ItemTab.BLOCK,false,true,107,-1,["Yellow"]));
         _loc59_.addBrick(createBrick(128,ItemLayer.DECORATION,blocksBMD,"brickplastic","",ItemTab.BLOCK,false,true,105,-1,["Green","Light Green","Lime"]));
         _loc59_.addBrick(createBrick(134,ItemLayer.DECORATION,blocksBMD,"brickplastic","",ItemTab.BLOCK,false,true,111,-1,["Green"]));
         _loc59_.addBrick(createBrick(131,ItemLayer.DECORATION,blocksBMD,"brickplastic","",ItemTab.BLOCK,false,true,108,-1,["Light Blue","Cyan"]));
         _loc59_.addBrick(createBrick(132,ItemLayer.DECORATION,blocksBMD,"brickplastic","",ItemTab.BLOCK,false,true,109,-1,["Blue","Indigo"]));
         _loc59_.addBrick(createBrick(133,ItemLayer.DECORATION,blocksBMD,"brickplastic","",ItemTab.BLOCK,false,true,110,-1,["Purple","Magenta","Pink"]));
         brickPackages.push(_loc59_);
         var _loc60_:ItemBrickPackage = new ItemBrickPackage("water","Water pack",["Sea","Ocean","Nature","Environment"]);
         _loc60_.addBrick(createBrick(ItemId.WAVE,ItemLayer.ABOVE,specialBlocksBMD,"brickwater","",ItemTab.DECORATIVE,false,false,234,0,["Waves","Animated"]));
         _loc60_.addBrick(createBrick(574,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwater","",ItemTab.BACKGROUND,false,true,74,4285913831));
         _loc60_.addBrick(createBrick(575,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwater","",ItemTab.BACKGROUND,false,true,75,4285913831,["Octopus","Squid"]));
         _loc60_.addBrick(createBrick(576,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwater","",ItemTab.BACKGROUND,false,true,76,4285913831,["Fish"]));
         _loc60_.addBrick(createBrick(577,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwater","",ItemTab.BACKGROUND,false,true,77,4285913831,["Seahorse"]));
         _loc60_.addBrick(createBrick(578,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwater","",ItemTab.BACKGROUND,false,true,78,4285913831,["Seaweed","Plant","Algae"]));
         brickPackages.push(_loc60_);
         var _loc61_:ItemBrickPackage = new ItemBrickPackage("sand","Sand Pack",["Desert","Beach","Environment","Soil"]);
         _loc61_.addBrick(createBrick(137,ItemLayer.FORGROUND,blocksBMD,"bricksand","",ItemTab.BLOCK,false,true,114,-1,["White","Beige"]));
         _loc61_.addBrick(createBrick(138,ItemLayer.FORGROUND,blocksBMD,"bricksand","",ItemTab.BLOCK,false,true,115,-1,["Grey","Gray"]));
         _loc61_.addBrick(createBrick(139,ItemLayer.FORGROUND,blocksBMD,"bricksand","",ItemTab.BLOCK,false,true,116,-1,["Yellow"]));
         _loc61_.addBrick(createBrick(140,ItemLayer.FORGROUND,blocksBMD,"bricksand","",ItemTab.BLOCK,false,true,117,-1,["Yellow","Orange"]));
         _loc61_.addBrick(createBrick(141,ItemLayer.FORGROUND,blocksBMD,"bricksand","",ItemTab.BLOCK,false,true,118,-1,["Brown","Light"]));
         _loc61_.addBrick(createBrick(142,ItemLayer.FORGROUND,blocksBMD,"bricksand","",ItemTab.BLOCK,false,true,119,-1,["Brown","Dark","Dirt"]));
         _loc61_.addBrick(createBrick(579,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksand","",ItemTab.BACKGROUND,false,false,79,-1,["Off-white"]));
         _loc61_.addBrick(createBrick(580,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksand","",ItemTab.BACKGROUND,false,false,80,-1,["Gray","Grey"]));
         _loc61_.addBrick(createBrick(581,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksand","",ItemTab.BACKGROUND,false,false,81,-1,["Yellow"]));
         _loc61_.addBrick(createBrick(582,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksand","",ItemTab.BACKGROUND,false,false,82,-1,["Orange","Yellow"]));
         _loc61_.addBrick(createBrick(583,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksand","",ItemTab.BACKGROUND,false,false,83,-1,["Brown","Light"]));
         _loc61_.addBrick(createBrick(584,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksand","",ItemTab.BACKGROUND,false,false,84,-1,["Brown","Dark"]));
         _loc61_.addBrick(createBrick(301,ItemLayer.ABOVE,decoBlocksBMD,"bricksand","",ItemTab.DECORATIVE,false,false,300 - 128,0,["White"]));
         _loc61_.addBrick(createBrick(302,ItemLayer.ABOVE,decoBlocksBMD,"bricksand","",ItemTab.DECORATIVE,false,false,301 - 128,0,["Gray","Grey"]));
         _loc61_.addBrick(createBrick(303,ItemLayer.ABOVE,decoBlocksBMD,"bricksand","",ItemTab.DECORATIVE,false,false,302 - 128,0,["Yellow"]));
         _loc61_.addBrick(createBrick(304,ItemLayer.ABOVE,decoBlocksBMD,"bricksand","",ItemTab.DECORATIVE,false,false,303 - 128,0,["Yellow","Orange"]));
         _loc61_.addBrick(createBrick(305,ItemLayer.ABOVE,decoBlocksBMD,"bricksand","",ItemTab.DECORATIVE,false,false,304 - 128,0,["Brown","Light"]));
         _loc61_.addBrick(createBrick(306,ItemLayer.ABOVE,decoBlocksBMD,"bricksand","",ItemTab.DECORATIVE,false,false,305 - 128,0,["Brown","Dark"]));
         brickPackages.push(_loc61_);
         var _loc62_:ItemBrickPackage = new ItemBrickPackage("summer 2012","Summer pack 2012",["Season","Beach"]);
         _loc62_.addBrick(createBrick(307,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2012","",ItemTab.DECORATIVE,false,false,306 - 128,0,["Beach","Ball","Toy","Ball"]));
         _loc62_.addBrick(createBrick(308,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2012","",ItemTab.DECORATIVE,false,false,307 - 128,0,["Pail","Bucket","Toy","Sand"]));
         _loc62_.addBrick(createBrick(309,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2012","",ItemTab.DECORATIVE,false,false,308 - 128,0,["Shovel","Dig","Toy","Sand"]));
         _loc62_.addBrick(createBrick(310,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2012","",ItemTab.DECORATIVE,false,false,309 - 128,0,["Drink","Margarita","Umbrella","Cocktail","Glass","Cup"]));
         brickPackages.push(_loc62_);
         var _loc63_:ItemBrickPackage = new ItemBrickPackage("cloud","Cloud Pack",["Sky","Environment"]);
         _loc63_.addBrick(createBrick(143,ItemLayer.FORGROUND,blocksBMD,"brickcloud","",ItemTab.BLOCK,false,false,120,-1,["Center","Middle","White"]));
         _loc63_.addBrick(createBrick(311,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,310 - 128,0,["Top","Side","White"]));
         _loc63_.addBrick(createBrick(312,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,311 - 128,0,["Bottom","Side","White"]));
         _loc63_.addBrick(createBrick(313,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,312 - 128,0,["Left","Side","White"]));
         _loc63_.addBrick(createBrick(314,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,313 - 128,0,["Right","Side","White"]));
         _loc63_.addBrick(createBrick(315,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,314 - 128,0,["Top right","Corner","White"]));
         _loc63_.addBrick(createBrick(316,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,315 - 128,0,["Top left","Corner","White"]));
         _loc63_.addBrick(createBrick(317,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,316 - 128,0,["Bottom left","Corner","White"]));
         _loc63_.addBrick(createBrick(318,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,317 - 128,0,["Bottom right","Corner","White"]));
         _loc63_.addBrick(createBrick(1126,ItemLayer.FORGROUND,blocksBMD,"brickcloud","",ItemTab.BLOCK,false,false,287,-1,["Center","Middle","Dark","Grey","Gray","Storm"]));
         _loc63_.addBrick(createBrick(1523,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,323,0,["Top","Side","Dark","Grey","Gray","Storm"]));
         _loc63_.addBrick(createBrick(1524,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,324,0,["Bottom","Side","Dark","Grey","Gray","Storm"]));
         _loc63_.addBrick(createBrick(1525,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,325,0,["Left","Side","Dark","Grey","Gray","Storm"]));
         _loc63_.addBrick(createBrick(1526,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,326,0,["Right","Side","Dark","Grey","Gray","Storm"]));
         _loc63_.addBrick(createBrick(1527,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,327,0,["Top right","Corner","Dark","Grey","Gray","Storm"]));
         _loc63_.addBrick(createBrick(1528,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,328,0,["Top left","Corner","Dark","Grey","Gray","Storm"]));
         _loc63_.addBrick(createBrick(1529,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,329,0,["Bottom left","Corner","Dark","Grey","Gray","Storm"]));
         _loc63_.addBrick(createBrick(1530,ItemLayer.DECORATION,decoBlocksBMD,"brickcloud","",ItemTab.DECORATIVE,false,false,330,0,["Bottom right","Corner","Dark","Grey","Gray","Storm"]));
         brickPackages.push(_loc63_);
         var _loc64_:ItemBrickPackage = new ItemBrickPackage("industrial","Industrial Package",["Factory"]);
         _loc64_.addBrick(createBrick(144,ItemLayer.FORGROUND,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,121,-1,["Diamond plating","Plate","Metal"]));
         _loc64_.addBrick(createBrick(145,ItemLayer.FORGROUND,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,122,-1,["Wiring","Wires","Metal"]));
         _loc64_.addBrick(createBrick(585,ItemLayer.BACKGROUND,bgBlocksBMD,"brickindustrial","",ItemTab.BACKGROUND,false,false,85,-1,["Plate","Metal"]));
         _loc64_.addBrick(createBrick(586,ItemLayer.BACKGROUND,bgBlocksBMD,"brickindustrial","",ItemTab.BACKGROUND,false,false,86,-1,["Gray","Steel","Plate","Metal"]));
         _loc64_.addBrick(createBrick(587,ItemLayer.BACKGROUND,bgBlocksBMD,"brickindustrial","",ItemTab.BACKGROUND,false,false,87,-1,["Blue","Cyan","Plate","Metal"]));
         _loc64_.addBrick(createBrick(588,ItemLayer.BACKGROUND,bgBlocksBMD,"brickindustrial","",ItemTab.BACKGROUND,false,false,88,-1,["Green","Plate","Metal"]));
         _loc64_.addBrick(createBrick(589,ItemLayer.BACKGROUND,bgBlocksBMD,"brickindustrial","",ItemTab.BACKGROUND,false,false,89,-1,["Yellow","Orange","Plate","Metal"]));
         _loc64_.addBrick(createBrick(146,ItemLayer.DECORATION,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,123,0,["Platform","One-Way","One Way","Metal"]));
         _loc64_.addBrick(createBrick(147,ItemLayer.DECORATION,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,124,0,["Scissor","Scaffolding","X","Metal"]));
         _loc64_.addBrick(createBrick(1133,ItemLayer.DECORATION,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,294,0,["Scissor","Scaffolding","X","Metal"]));
         _loc64_.addBrick(createBrick(148,ItemLayer.DECORATION,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,125,0,["Lift","Table","Piston","Metal"]));
         _loc64_.addBrick(createBrick(ItemId.INDUSTRIAL_TABLE,ItemLayer.DECORATION,specialBlocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,712,0,["Lift","Table","Piston","Metal","Morphable"]));
         _loc64_.addBrick(createBrick(149,ItemLayer.FORGROUND,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,126,-1,["Tube","Plate","Piston","Metal"]));
         _loc64_.addBrick(createBrick(1127,ItemLayer.FORGROUND,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,288,-1,["Tube","Plate","Piston","Metal"]));
         _loc64_.addBrick(createBrick(ItemId.INDUSTRIAL_PIPE_THICK,ItemLayer.DECORATION,specialBlocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,710,0,["Thick","Pipe","Metal","Morphable"]));
         _loc64_.addBrick(createBrick(150,ItemLayer.DECORATION,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,127,-1,["Conveyor belt","Left","Metal"]));
         _loc64_.addBrick(createBrick(151,ItemLayer.DECORATION,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,128,-1,["Conveyor belt","Middle","Metal"]));
         _loc64_.addBrick(createBrick(152,ItemLayer.DECORATION,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,129,-1,["Conveyor belt","Middle","Metal"]));
         _loc64_.addBrick(createBrick(153,ItemLayer.DECORATION,blocksBMD,"brickindustrial","",ItemTab.BLOCK,false,true,130,-1,["Conveyor belt","Right","Metal"]));
         _loc64_.addBrick(createBrick(319,ItemLayer.ABOVE,decoBlocksBMD,"brickindustrial","",ItemTab.DECORATIVE,false,true,190,0,["Caution","Warning","Fire","Flame","Sign","Alert"]));
         _loc64_.addBrick(createBrick(320,ItemLayer.ABOVE,decoBlocksBMD,"brickindustrial","",ItemTab.DECORATIVE,false,true,191,0,["Caution","Warning","Death","Toxin","Poison","Sign","Alert"]));
         _loc64_.addBrick(createBrick(321,ItemLayer.ABOVE,decoBlocksBMD,"brickindustrial","",ItemTab.DECORATIVE,false,true,192,0,["Caution","Warning","Electricity","Lightning","Sign","Alert"]));
         _loc64_.addBrick(createBrick(322,ItemLayer.ABOVE,decoBlocksBMD,"brickindustrial","",ItemTab.DECORATIVE,false,true,193,0,["Caution","Warning","No","Do not enter","X","Sign","Alert"]));
         _loc64_.addBrick(createBrick(323,ItemLayer.DECORATION,decoBlocksBMD,"brickindustrial","",ItemTab.DECORATIVE,false,true,194,0,["Caution","Warning","Horizontal","Stripes","Hazard","Pole","Alert"]));
         _loc64_.addBrick(createBrick(324,ItemLayer.DECORATION,decoBlocksBMD,"brickindustrial","",ItemTab.DECORATIVE,false,true,195,0,["Caution","Warning","Vertical","Stripes","Hazard","Pole","Alert"]));
         _loc64_.addBrick(createBrick(ItemId.INDUSTRIAL_PIPE_THIN,ItemLayer.DECORATION,specialBlocksBMD,"brickindustrial","",ItemTab.DECORATIVE,false,true,708,0,["Thin","Pipe","Metal","Morphable"]));
         brickPackages.push(_loc64_);
         var _loc65_:ItemBrickPackage = new ItemBrickPackage("clay","Clay Backgrounds",["House"]);
         _loc65_.addBrick(createBrick(594,ItemLayer.BACKGROUND,bgBlocksBMD,"brickclay","",ItemTab.BACKGROUND,false,false,94,-1,["White","Tile","Bathroom"]));
         _loc65_.addBrick(createBrick(595,ItemLayer.BACKGROUND,bgBlocksBMD,"brickclay","",ItemTab.BACKGROUND,false,false,95,-1,["Brick","Tile","Bathroom"]));
         _loc65_.addBrick(createBrick(596,ItemLayer.BACKGROUND,bgBlocksBMD,"brickclay","",ItemTab.BACKGROUND,false,false,96,-1,["Diamond","Chisel","Tile","Bathroom"]));
         _loc65_.addBrick(createBrick(597,ItemLayer.BACKGROUND,bgBlocksBMD,"brickclay","",ItemTab.BACKGROUND,false,false,97,-1,["X","Cross","Chisel","Bathroom","Tile"]));
         _loc65_.addBrick(createBrick(598,ItemLayer.BACKGROUND,bgBlocksBMD,"brickclay","",ItemTab.BACKGROUND,false,false,98,-1,["Rough","Natural"]));
         brickPackages.push(_loc65_);
         var _loc66_:ItemBrickPackage = new ItemBrickPackage("medieval","Medieval",["Castle"]);
         _loc66_.addBrick(createBrick(158,ItemLayer.DECORATION,blocksBMD,"brickmedieval","",ItemTab.BLOCK,false,true,132,0,["Platform","Stone"]));
         _loc66_.addBrick(createBrick(159,ItemLayer.FORGROUND,blocksBMD,"brickmedieval","",ItemTab.BLOCK,false,true,133,-1,["Brick","Stone"]));
         _loc66_.addBrick(createBrick(160,ItemLayer.FORGROUND,blocksBMD,"brickmedieval","",ItemTab.BLOCK,false,true,134,-1,["Brick","Arrow slit","Stone","Window"]));
         _loc66_.addBrick(createBrick(599,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmedieval","",ItemTab.BACKGROUND,false,false,99,-1,["Anvil","Blacksmith"]));
         _loc66_.addBrick(createBrick(325,ItemLayer.ABOVE,decoBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,true,196,0,["Brick","Stone","House"]));
         _loc66_.addBrick(createBrick(326,ItemLayer.ABOVE,decoBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,false,197,-1,["Top","Display","Stone"]));
         _loc66_.addBrick(createBrick(162,ItemLayer.DECORATION,blocksBMD,"brickmedieval","",ItemTab.BLOCK,false,true,136,0,["Parapet","Stone"]));
         _loc66_.addBrick(createBrick(163,ItemLayer.DECORATION,blocksBMD,"brickmedieval","",ItemTab.BLOCK,false,true,137,0,["Barrel","Keg"]));
         _loc66_.addBrick(createBrick(437,ItemLayer.DECORATION,decoBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,false,279,0,["Window","Wood","House"]));
         _loc66_.addBrick(createBrick(600,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmedieval","",ItemTab.BACKGROUND,false,false,100,-1,["Wood","Planks","Vertical","Brown","House"]));
         _loc66_.addBrick(createBrick(590,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmedieval","",ItemTab.BACKGROUND,false,false,90,-1,["Straw","Hay","Roof","House"]));
         _loc66_.addBrick(createBrick(591,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmedieval","",ItemTab.BACKGROUND,false,false,91,-1,["Roof","Shingles","Scales","Red","House"]));
         _loc66_.addBrick(createBrick(592,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmedieval","",ItemTab.BACKGROUND,false,false,92,-1,["Roof","Shingles","Scales","Green","House"]));
         _loc66_.addBrick(createBrick(556,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmedieval","",ItemTab.BACKGROUND,false,false,56,-1,["Roof","Shingles","Scales","Brown","House"]));
         _loc66_.addBrick(createBrick(593,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmedieval","",ItemTab.BACKGROUND,false,false,93,-1,["Gray","Dry wall","Stucco","Grey","House","Beige"]));
         _loc66_.addBrick(createBrick(ItemId.MEDIEVAL_TIMBER,ItemLayer.DECORATION,specialBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,false,417,0,["Scaffolding","Wood","Morphable","Fence","House","Design"]));
         _loc66_.addBrick(createBrick(330,ItemLayer.DECORATION,decoBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,true,201,0,["Shield","Warrior","Weapon"]));
         _loc66_.addBrick(createBrick(ItemId.MEDIEVAL_AXE,ItemLayer.DECORATION,specialBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,true,365,0,["Axe","Morphable","Warrior","Weapon"]));
         _loc66_.addBrick(createBrick(ItemId.MEDIEVAL_SWORD,ItemLayer.DECORATION,specialBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,true,377,0,["Sword","Morphable","Warrior","Weapon"]));
         _loc66_.addBrick(createBrick(ItemId.MEDIEVAL_SHIELD,ItemLayer.DECORATION,specialBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,true,373,0,["Shield","Morphable","Blue","Green","Yellow","Red","Circle"]));
         _loc66_.addBrick(createBrick(ItemId.MEDIEVAL_COATOFARMS,ItemLayer.DECORATION,specialBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,true,405,0,["Shield","Morphable","Blue","Green","Yellow","Red"]));
         _loc66_.addBrick(createBrick(ItemId.MEDIEVAL_BANNER,ItemLayer.DECORATION,specialBlocksBMD,"brickmedieval","",ItemTab.DECORATIVE,false,true,369,0,["Banner","Morphable","Blue","Green","Yellow","Red","Flag"]));
         brickPackages.push(_loc66_);
         var _loc67_:ItemBrickPackage = new ItemBrickPackage("pipes","Pipes",["Orange"]);
         _loc67_.addBrick(createBrick(166,ItemLayer.FORGROUND,blocksBMD,"brickpipe","",ItemTab.BLOCK,false,true,140,-1,["Left"]));
         _loc67_.addBrick(createBrick(167,ItemLayer.FORGROUND,blocksBMD,"brickpipe","",ItemTab.BLOCK,false,true,141,-1,["Horizontal"]));
         _loc67_.addBrick(createBrick(168,ItemLayer.FORGROUND,blocksBMD,"brickpipe","",ItemTab.BLOCK,false,true,142,-1,["Right"]));
         _loc67_.addBrick(createBrick(169,ItemLayer.FORGROUND,blocksBMD,"brickpipe","",ItemTab.BLOCK,false,true,143,-1,["Up"]));
         _loc67_.addBrick(createBrick(170,ItemLayer.FORGROUND,blocksBMD,"brickpipe","",ItemTab.BLOCK,false,true,144,-1,["Vertical"]));
         _loc67_.addBrick(createBrick(171,ItemLayer.FORGROUND,blocksBMD,"brickpipe","",ItemTab.BLOCK,false,true,145,-1,["Down"]));
         brickPackages.push(_loc67_);
         var _loc68_:ItemBrickPackage = new ItemBrickPackage("outer space","Outer Space",["Ship","Aliens","UFO","Sci-Fi","Science Fiction","Void"]);
         _loc68_.addBrick(createBrick(172,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,146,-1,["White","Metal","Plate"]));
         _loc68_.addBrick(createBrick(173,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,147,-1,["Blue","Metal","Plate"]));
         _loc68_.addBrick(createBrick(174,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,148,-1,["Green","Metal","Plate"]));
         _loc68_.addBrick(createBrick(175,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,149,-1,["Red","Magenta","Metal","Plate","Pink"]));
         _loc68_.addBrick(createBrick(176,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,150,4294945604,["Sand","Mars","Orange"]));
         _loc68_.addBrick(createBrick(1029,ItemLayer.FORGROUND,blocksBMD,"brickscifi","",ItemTab.BLOCK,false,true,214,-1,["Moon","Rock","Stone","Metal","Grey","Gray"]));
         _loc68_.addBrick(createBrick(601,ItemLayer.BACKGROUND,bgBlocksBMD,"brickscifi","",ItemTab.BACKGROUND,false,true,101,-1,["White","Grey","Gray","Metal"]));
         _loc68_.addBrick(createBrick(602,ItemLayer.BACKGROUND,bgBlocksBMD,"brickscifi","",ItemTab.BACKGROUND,false,true,102,-1,["Blue","Metal"]));
         _loc68_.addBrick(createBrick(603,ItemLayer.BACKGROUND,bgBlocksBMD,"brickscifi","",ItemTab.BACKGROUND,false,true,103,-1,["Green","Metal"]));
         _loc68_.addBrick(createBrick(604,ItemLayer.BACKGROUND,bgBlocksBMD,"brickscifi","",ItemTab.BACKGROUND,false,true,104,-1,["Red","Metal"]));
         _loc68_.addBrick(createBrick(332,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,203,0,["Sign","Panel","Computer","Green"]));
         _loc68_.addBrick(createBrick(333,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,204,0,["Red","Dot","Light","Lamp","Circle","Orb","Button"]));
         _loc68_.addBrick(createBrick(334,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,205,0,["Blue","Dot","Light","Lamp","Circle","Orb","Button"]));
         _loc68_.addBrick(createBrick(1567,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,352,0,["Green","Dot","Light","Lamp","Circle","Orb","Button"]));
         _loc68_.addBrick(createBrick(1568,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,353,0,["Yellow","Dot","Light","Lamp","Circle","Orb","Button"]));
         _loc68_.addBrick(createBrick(1623,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,366,0,["Magenta","Pink","Purple","Dot","Light","Lamp","Circle","Orb","Button"]));
         _loc68_.addBrick(createBrick(1624,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,367,0,["Cyan","Dot","Light","Lamp","Circle","Orb","Button"]));
         _loc68_.addBrick(createBrick(335,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,206,0,["Computer","Control panel","System"]));
         _loc68_.addBrick(createBrick(428,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,270,0,["Star","Shiny","Red","Light","Night","Sky","Big"]));
         _loc68_.addBrick(createBrick(429,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,271,0,["Star","Shiny","Blue","Light","Night","Sky","Medium"]));
         _loc68_.addBrick(createBrick(430,ItemLayer.DECORATION,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,272,0,["Star","Shiny","Yellow","Light","Night","Sky","Small"]));
         _loc68_.addBrick(createBrick(331,ItemLayer.ABOVE,decoBlocksBMD,"brickscifi","",ItemTab.DECORATIVE,false,false,202,0,["Rock","Hard","Gray","Grey","Boulder","Stone","Environment"]));
         brickPackages.push(_loc68_);
         var _loc69_:ItemBrickPackage = new ItemBrickPackage("desert","Desert Pack",["Environment"]);
         _loc69_.addBrick(createBrick(177,ItemLayer.FORGROUND,blocksBMD,"brickdesert","",ItemTab.BLOCK,false,true,151,4292711483,["Mars","Orange","Sandstone","Ground","Soil","Dirt","Rocky","Space"]));
         _loc69_.addBrick(createBrick(178,ItemLayer.FORGROUND,blocksBMD,"brickdesert","",ItemTab.BLOCK,false,true,152,4291200308,["Mars","Orange","Sandstone","Ground","Soil","Dirt","Rocky","Space"]));
         _loc69_.addBrick(createBrick(179,ItemLayer.FORGROUND,blocksBMD,"brickdesert","",ItemTab.BLOCK,false,true,153,4287717671,["Mars","Orange","Sandstone","Ground","Soil","Dirt","Rocky","Space"]));
         _loc69_.addBrick(createBrick(180,ItemLayer.FORGROUND,blocksBMD,"brickdesert","",ItemTab.BLOCK,false,true,154,-1,["Mars","Orange","Sandstone","Ground","Soil","Dirt","Rocky","Space"]));
         _loc69_.addBrick(createBrick(181,ItemLayer.FORGROUND,blocksBMD,"brickdesert","",ItemTab.BLOCK,false,true,155,-1,["Mars","Orange","Sandstone","Ground","Soil","Dirt","Rocky","Space"]));
         _loc69_.addBrick(createBrick(336,ItemLayer.ABOVE,decoBlocksBMD,"brickdesert","",ItemTab.DECORATIVE,false,false,207,0,["Rock","Orange","Sandstone","Boulder","Space"]));
         _loc69_.addBrick(createBrick(425,ItemLayer.ABOVE,decoBlocksBMD,"brickdesert","",ItemTab.DECORATIVE,false,false,267,0,["Cactus","Nature","Plant","Western"]));
         _loc69_.addBrick(createBrick(426,ItemLayer.ABOVE,decoBlocksBMD,"brickdesert","",ItemTab.DECORATIVE,false,false,268,0,["Bush","Cactus","Nature","Plant","Western"]));
         _loc69_.addBrick(createBrick(427,ItemLayer.ABOVE,decoBlocksBMD,"brickdesert","",ItemTab.DECORATIVE,false,false,269,0,["Tree","Nature","Plant","Bush","Western","Bonsai"]));
         _loc69_.addBrick(createBrick(699,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdesert","",ItemTab.BACKGROUND,false,false,193,-1,["Brown","Dirt","Soil","Sandstone"]));
         _loc69_.addBrick(createBrick(700,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdesert","",ItemTab.BACKGROUND,false,false,194,-1,["Brown","Dirt","Soil","Sandstone"]));
         _loc69_.addBrick(createBrick(701,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdesert","",ItemTab.BACKGROUND,false,false,195,-1,["Brown","Dirt","Soil","Sandstone"]));
         brickPackages.push(_loc69_);
         var _loc70_:ItemBrickPackage = new ItemBrickPackage("neon","Neon Backgrounds",["Solid"]);
         _loc70_.addBrick(createBrick(675,ItemLayer.BACKGROUND,bgBlocksBMD,"brickneon","",ItemTab.BACKGROUND,false,true,169,-1,["Magenta","Pink","Red"]));
         _loc70_.addBrick(createBrick(673,ItemLayer.BACKGROUND,bgBlocksBMD,"brickneon","",ItemTab.BACKGROUND,false,true,167,-1,["Orange","Fire"]));
         _loc70_.addBrick(createBrick(697,ItemLayer.BACKGROUND,bgBlocksBMD,"brickneon","",ItemTab.BACKGROUND,false,true,191,-1,["Yellow"]));
         _loc70_.addBrick(createBrick(674,ItemLayer.BACKGROUND,bgBlocksBMD,"brickneon","",ItemTab.BACKGROUND,false,true,168,-1,["Green","Jungle"]));
         _loc70_.addBrick(createBrick(698,ItemLayer.BACKGROUND,bgBlocksBMD,"brickneon","",ItemTab.BACKGROUND,false,true,192,-1,["Cyan"]));
         _loc70_.addBrick(createBrick(605,ItemLayer.BACKGROUND,bgBlocksBMD,"brickneon","",ItemTab.BACKGROUND,false,true,105,-1,["Blue","Night","Sky","Dark"]));
         brickPackages.push(_loc70_);
         var _loc71_:ItemBrickPackage = new ItemBrickPackage("monster","Monster",["Creature"]);
         _loc71_.addBrick(createBrick(608,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmonster","",ItemTab.BACKGROUND,false,true,108,4288716897,["Green","Grass"]));
         _loc71_.addBrick(createBrick(609,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmonster","",ItemTab.BACKGROUND,false,true,109,4285558852,["Green","Dark","Grass"]));
         _loc71_.addBrick(createBrick(663,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmonster","",ItemTab.BACKGROUND,false,true,157,-1,["Red","Pink","Scales"]));
         _loc71_.addBrick(createBrick(664,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmonster","",ItemTab.BACKGROUND,false,false,158,-1,["Red","Pink","Dark","Scales"]));
         _loc71_.addBrick(createBrick(665,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmonster","",ItemTab.BACKGROUND,false,false,159,-1,["Purple","Scales","Violet"]));
         _loc71_.addBrick(createBrick(666,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmonster","",ItemTab.BACKGROUND,false,false,160,-1,["Purple","Scales","Dark","Violet"]));
         _loc71_.addBrick(createBrick(ItemId.TOOTH_BIG,ItemLayer.DECORATION,specialBlocksBMD,"brickmonster","",ItemTab.DECORATIVE,false,false,385,0,["Teeth","Tooth","Creepy","Morphable","Scary"]));
         _loc71_.addBrick(createBrick(ItemId.TOOTH_SMALL,ItemLayer.DECORATION,specialBlocksBMD,"brickmonster","",ItemTab.DECORATIVE,false,false,381,0,["Teeth","Tooth","Creepy","Morphable","Scary"]));
         _loc71_.addBrick(createBrick(ItemId.TOOTH_TRIPLE,ItemLayer.DECORATION,specialBlocksBMD,"brickmonster","",ItemTab.DECORATIVE,false,false,401,0,["Teeth","Tooth","Creepy","Morphable","Scary"]));
         _loc71_.addBrick(createBrick(274,ItemLayer.DECORATION,decoBlocksBMD,"brickmonster","",ItemTab.DECORATIVE,false,false,146,0,["Eye","Purple","Circle","Creepy","Ball","Scary"]));
         _loc71_.addBrick(createBrick(341,ItemLayer.DECORATION,decoBlocksBMD,"brickmonster","",ItemTab.DECORATIVE,false,false,211,0,["Eye","Yellow","Circle","Creepy","Ball","Scary"]));
         _loc71_.addBrick(createBrick(342,ItemLayer.DECORATION,decoBlocksBMD,"brickmonster","",ItemTab.DECORATIVE,false,false,212,0,["Eye","Blue","Circle","Creepy","Ball","Scary"]));
         brickPackages.push(_loc71_);
         var _loc72_:ItemBrickPackage = new ItemBrickPackage("fog","Fog",["Mist","Transparent","Damp","Environment"]);
         _loc72_.addBrick(createBrick(343,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,213,0,["Center","Middle"]));
         _loc72_.addBrick(createBrick(344,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,214,0,["Bottom","Side"]));
         _loc72_.addBrick(createBrick(345,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,215,0,["Top","Side"]));
         _loc72_.addBrick(createBrick(346,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,216,0,["Left","Side"]));
         _loc72_.addBrick(createBrick(347,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,217,0,["Right","Side"]));
         _loc72_.addBrick(createBrick(348,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,218,0,["Top Right","Corner"]));
         _loc72_.addBrick(createBrick(349,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,219,0,["Top Left","Corner"]));
         _loc72_.addBrick(createBrick(350,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,220,0,["Bottom Left","Corner"]));
         _loc72_.addBrick(createBrick(351,ItemLayer.ABOVE,decoBlocksBMD,"brickfog","",ItemTab.DECORATIVE,false,false,221,0,["Bottom Right","Corner"]));
         brickPackages.push(_loc72_);
         var _loc73_:ItemBrickPackage = new ItemBrickPackage("halloween 2012","Halloween 2012",["Holiday","Spooky"]);
         _loc73_.addBrick(createBrick(352,ItemLayer.ABOVE,decoBlocksBMD,"brickhw2012","",ItemTab.DECORATIVE,false,true,222,0,["Head","Transfer","Lamp","Top"]));
         _loc73_.addBrick(createBrick(353,ItemLayer.DECORATION,decoBlocksBMD,"brickhw2012","",ItemTab.DECORATIVE,false,false,223,0,["Antenna","Tesla coil","Middle"]));
         _loc73_.addBrick(createBrick(354,ItemLayer.DECORATION,decoBlocksBMD,"brickhw2012","",ItemTab.DECORATIVE,false,true,224,0,["Wire","Blue","Red","Electricity","Wiring","Power","Vertical"]));
         _loc73_.addBrick(createBrick(355,ItemLayer.DECORATION,decoBlocksBMD,"brickhw2012","",ItemTab.DECORATIVE,false,true,225,0,["Wire","Blue","Red","Electricity","Wiring","Power","Horizontal"]));
         _loc73_.addBrick(createBrick(356,ItemLayer.ABOVE,decoBlocksBMD,"brickhw2012","",ItemTab.DECORATIVE,false,false,226,0,["Lightning","Storm","Electricity","Environment"]));
         brickPackages.push(_loc73_);
         var _loc74_:ItemBrickPackage = new ItemBrickPackage("checker","Checker Blocks",["Checkered"]);
         _loc74_.addBrick(createBrick(1091,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,263,4290756543,["White","Light"]));
         _loc74_.addBrick(createBrick(186,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,161,4285229931,["Gray","Grey"]));
         _loc74_.addBrick(createBrick(1026,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,213,-1,["Black","Dark","Gray","Grey"]));
         _loc74_.addBrick(createBrick(189,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,164,4289206591,["Red","Magenta"]));
         _loc74_.addBrick(createBrick(1025,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,212,-1,["Orange"]));
         _loc74_.addBrick(createBrick(190,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,165,4289442611,["Yellow","Lime"]));
         _loc74_.addBrick(createBrick(191,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,166,4282753847,["Green"]));
         _loc74_.addBrick(createBrick(192,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,167,4282167980,["Cyan","Blue"]));
         _loc74_.addBrick(createBrick(187,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,162,4281291665,["Blue"]));
         _loc74_.addBrick(createBrick(188,ItemLayer.DECORATION,blocksBMD,"brickchecker","",ItemTab.BLOCK,false,true,163,4286594449,["Purple","Magenta","Pink","Violet"]));
         brickPackages.push(_loc74_);
         var _loc75_:ItemBrickPackage = new ItemBrickPackage("jungle","Jungle");
         _loc75_.addBrick(createBrick(193,ItemLayer.DECORATION,blocksBMD,"brickjungle","",ItemTab.BLOCK,false,true,168,0,["Idol","Face","Brick","No show","Statue","Totem","Ruins"]));
         _loc75_.addBrick(createBrick(194,ItemLayer.DECORATION,blocksBMD,"brickjungle","",ItemTab.BLOCK,false,true,169,0,["Platform","Old","Mossy","Ruins","Stone"]));
         _loc75_.addBrick(createBrick(195,ItemLayer.FORGROUND,blocksBMD,"brickjungle","",ItemTab.BLOCK,false,true,170,4288256378,["Brick","Grey","Gray","Ruins","Stone"]));
         _loc75_.addBrick(createBrick(196,ItemLayer.FORGROUND,blocksBMD,"brickjungle","",ItemTab.BLOCK,false,true,171,4289491041,["Brick","Red","Pink","Ruins","Stone"]));
         _loc75_.addBrick(createBrick(197,ItemLayer.FORGROUND,blocksBMD,"brickjungle","",ItemTab.BLOCK,false,true,172,4284647578,["Brick","Blue","Ruins","Stone"]));
         _loc75_.addBrick(createBrick(198,ItemLayer.FORGROUND,blocksBMD,"brickjungle","",ItemTab.BLOCK,false,true,173,4287071297,["Brick","Yellow","Olive","Ruins","Stone","Green"]));
         _loc75_.addBrick(createBrick(617,ItemLayer.BACKGROUND,bgBlocksBMD,"brickjungle","",ItemTab.BACKGROUND,false,true,117,4284900945,["Brick","Grey","Gray","Ruins","Stone"]));
         _loc75_.addBrick(createBrick(618,ItemLayer.BACKGROUND,bgBlocksBMD,"brickjungle","",ItemTab.BACKGROUND,false,true,118,4286008900,["Brick","Red","Pink","Ruins","Stone"]));
         _loc75_.addBrick(createBrick(619,ItemLayer.BACKGROUND,bgBlocksBMD,"brickjungle","",ItemTab.BACKGROUND,false,true,119,4282473062,["Brick","Blue","Ruins","Stone"]));
         _loc75_.addBrick(createBrick(620,ItemLayer.BACKGROUND,bgBlocksBMD,"brickjungle","",ItemTab.BACKGROUND,false,true,120,4285229108,["Brick","Yellow","Olive","Ruins","Stone","Green"]));
         _loc75_.addBrick(createBrick(199,ItemLayer.DECORATION,blocksBMD,"brickjungle","",ItemTab.BLOCK,false,true,176,0,["Pot","Jar","Clay","Ruins","Urn"]));
         _loc75_.addBrick(createBrick(621,ItemLayer.BACKGROUND,bgBlocksBMD,"brickjungle","",ItemTab.BACKGROUND,false,true,121,4285039619,["Leaves","Green","Grass","Environment","Nature"]));
         _loc75_.addBrick(createBrick(622,ItemLayer.BACKGROUND,bgBlocksBMD,"brickjungle","",ItemTab.BACKGROUND,false,true,122,4283985923,["Leaves","Green","Grass","Environment","Nature"]));
         _loc75_.addBrick(createBrick(623,ItemLayer.BACKGROUND,bgBlocksBMD,"brickjungle","",ItemTab.BACKGROUND,false,true,123,4282536962,["Leaves","Green","Grass","Environment","Nature"]));
         _loc75_.addBrick(createBrick(357,ItemLayer.ABOVE,decoBlocksBMD,"brickjungle","",ItemTab.DECORATIVE,false,false,227,0,["Bush","Plant","Nature","Environment"]));
         _loc75_.addBrick(createBrick(358,ItemLayer.ABOVE,decoBlocksBMD,"brickjungle","",ItemTab.DECORATIVE,false,false,228,0,["Rock","Pot","Jar","Basket","Ruins","Clay"]));
         _loc75_.addBrick(createBrick(359,ItemLayer.ABOVE,decoBlocksBMD,"brickjungle","",ItemTab.DECORATIVE,false,false,229,0,["Idol","Statue","Gold","Trophy","Artifact","Artefact","Yellow","Ruins"]));
         brickPackages.push(_loc75_);
         var _loc76_:ItemBrickPackage = new ItemBrickPackage("christmas 2012","Christmas 2012",["Xmas","Holiday"]);
         _loc76_.addBrick(createBrick(624,ItemLayer.BACKGROUND,bgBlocksBMD,"brickxmas2012","",ItemTab.BACKGROUND,false,true,124,4292381209,["Wrapping paper","Yellow","Stripes"]));
         _loc76_.addBrick(createBrick(625,ItemLayer.BACKGROUND,bgBlocksBMD,"brickxmas2012","",ItemTab.BACKGROUND,false,true,125,4283728909,["Wrapping paper","Green","Stripes"]));
         _loc76_.addBrick(createBrick(626,ItemLayer.BACKGROUND,bgBlocksBMD,"brickxmas2012","",ItemTab.BACKGROUND,false,true,126,4280236504,["Wrapping paper","Blue","Purple","Dots","Spots"]));
         _loc76_.addBrick(createBrick(362,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2012","",ItemTab.DECORATIVE,false,true,230,0,["Ribbon","Blue","Vertical"]));
         _loc76_.addBrick(createBrick(363,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2012","",ItemTab.DECORATIVE,false,true,231,0,["Ribbon","Blue","Horizontal"]));
         _loc76_.addBrick(createBrick(364,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2012","",ItemTab.DECORATIVE,false,true,232,0,["Ribbon","Blue","Cross","Middle"]));
         _loc76_.addBrick(createBrick(365,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2012","",ItemTab.DECORATIVE,false,true,233,0,["Ribbon","Purple","Vertical","Magenta","Red"]));
         _loc76_.addBrick(createBrick(366,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2012","",ItemTab.DECORATIVE,false,true,234,0,["Ribbon","Purple","Horizontal","Magenta","Red"]));
         _loc76_.addBrick(createBrick(367,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2012","",ItemTab.DECORATIVE,false,true,235,0,["Ribbon","Purple","Cross","Middle","Magenta","Red"]));
         brickPackages.push(_loc76_);
         var _loc77_:ItemBrickPackage = new ItemBrickPackage("lava","Lava",["Hell","Hot","Environment","Heat"]);
         _loc77_.addBrick(createBrick(202,ItemLayer.FORGROUND,blocksBMD,"bricklava","",ItemTab.BLOCK,false,true,177,4294954558,["Yellow"]));
         _loc77_.addBrick(createBrick(203,ItemLayer.FORGROUND,blocksBMD,"bricklava","",ItemTab.BLOCK,false,true,178,4294612750,["Orange"]));
         _loc77_.addBrick(createBrick(204,ItemLayer.FORGROUND,blocksBMD,"bricklava","",ItemTab.BLOCK,false,true,179,4294926080,["Orange","Red"]));
         _loc77_.addBrick(createBrick(627,ItemLayer.BACKGROUND,bgBlocksBMD,"bricklava","",ItemTab.BACKGROUND,false,true,127,4291601203,["Yellow"]));
         _loc77_.addBrick(createBrick(628,ItemLayer.BACKGROUND,bgBlocksBMD,"bricklava","",ItemTab.BACKGROUND,false,true,128,4291196171,["Orange"]));
         _loc77_.addBrick(createBrick(629,ItemLayer.BACKGROUND,bgBlocksBMD,"bricklava","",ItemTab.BACKGROUND,false,true,129,4290198016,["Red","Orange"]));
         _loc77_.addBrick(createBrick(415,ItemLayer.ABOVE,decoBlocksBMD,"bricklava","",ItemTab.DECORATIVE,false,false,264,0,["Fire","Glow","Orange"]));
         brickPackages.push(_loc77_);
         var _loc78_:ItemBrickPackage = new ItemBrickPackage("swamp","Swamp");
         _loc78_.addBrick(createBrick(370,ItemLayer.ABOVE,specialBlocksBMD,"brickswamp","",ItemTab.DECORATIVE,false,false,249,0,["Mud","Bubbles","Gas","Nature","Environment","Animated"]));
         _loc78_.addBrick(createBrick(371,ItemLayer.ABOVE,decoBlocksBMD,"brickswamp","",ItemTab.DECORATIVE,false,false,236,0,["Grass","Thick","Nature","Plant","Environment"]));
         _loc78_.addBrick(createBrick(372,ItemLayer.ABOVE,decoBlocksBMD,"brickswamp","",ItemTab.DECORATIVE,false,false,237,0,["Wood","Nature","Log","Environment"]));
         _loc78_.addBrick(createBrick(373,ItemLayer.ABOVE,decoBlocksBMD,"brickswamp","",ItemTab.DECORATIVE,false,false,238,0,["Danger","Sign","Caution","Radioactive","Nuclear"]));
         _loc78_.addBrick(createBrick(557,ItemLayer.BACKGROUND,bgBlocksBMD,"brickswamp","",ItemTab.BACKGROUND,false,false,57,-1,["Mud","Quicksand","Environment","Soil"]));
         _loc78_.addBrick(createBrick(630,ItemLayer.BACKGROUND,bgBlocksBMD,"brickswamp","",ItemTab.BACKGROUND,false,false,130,4284504612,["Green","Grass","Environment","Soil"]));
         brickPackages.push(_loc78_);
         var _loc79_:ItemBrickPackage = new ItemBrickPackage("marble","Sparta",["Rome","Sparta","House","Greece","Roman"]);
         _loc79_.addBrick(createBrick(382,ItemLayer.DECORATION,decoBlocksBMD,"brickmarble","",ItemTab.DECORATIVE,false,true,239,0,["Column","Top","Ancient"]));
         _loc79_.addBrick(createBrick(383,ItemLayer.DECORATION,decoBlocksBMD,"brickmarble","",ItemTab.DECORATIVE,false,true,240,0,["Column","Middle","Ancient"]));
         _loc79_.addBrick(createBrick(384,ItemLayer.DECORATION,decoBlocksBMD,"brickmarble","",ItemTab.DECORATIVE,false,true,241,0,["Column","Bottom","Ancient"]));
         _loc79_.addBrick(createBrick(208,ItemLayer.FORGROUND,blocksBMD,"brickmarble","",ItemTab.BLOCK,false,true,180,4291678675,["Brick","White","Ancient","Grey","Gray"]));
         _loc79_.addBrick(createBrick(209,ItemLayer.FORGROUND,blocksBMD,"brickmarble","",ItemTab.BLOCK,false,true,181,4290895033,["Brick","Green","Ancient"]));
         _loc79_.addBrick(createBrick(210,ItemLayer.FORGROUND,blocksBMD,"brickmarble","",ItemTab.BLOCK,false,true,182,4293248719,["Brick","Red","Pink","Ancient"]));
         _loc79_.addBrick(createBrick(211,ItemLayer.DECORATION,blocksBMD,"brickmarble","",ItemTab.BLOCK,false,true,183,0,["Column","Platform","Top","Ancient","One-Way","One Way"]));
         _loc79_.addBrick(createBrick(638,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmarble","",ItemTab.BACKGROUND,false,false,132,4286020477,["Brick","White","Ancient","Grey","Gray"]));
         _loc79_.addBrick(createBrick(639,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmarble","",ItemTab.BACKGROUND,false,false,133,4285563247,["Brick","Green","Ancient"]));
         _loc79_.addBrick(createBrick(640,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmarble","",ItemTab.BACKGROUND,false,false,134,4286805627,["Brick","Red","Pink","Ancient"]));
         brickPackages.push(_loc79_);
         var _loc80_:ItemBrickPackage = new ItemBrickPackage("Label","Admin Blocks");
         _loc80_.addBrick(createBrick(ItemId.LABEL,ItemLayer.DECORATION,decoBlocksBMD,"","",ItemTab.ACTION,false,true,265,0,["Text","Words","ModText"],true));
         brickPackages.push(_loc80_);
         var _loc81_:ItemBrickPackage = new ItemBrickPackage("sign","Signs (+1)");
         _loc81_.addBrick(createBrick(ItemId.TEXT_SIGN,ItemLayer.ABOVE,specialBlocksBMD,"","players will see a custom message when they touch this block",ItemTab.ACTION,false,true,513,0,["Morphable","Write","Text","Wood","Info"]));
         brickPackages.push(_loc81_);
         var _loc82_:ItemBrickPackage = new ItemBrickPackage("farm","Farm");
         _loc82_.addBrick(createBrick(386,ItemLayer.ABOVE,decoBlocksBMD,"brickfarm","",ItemTab.DECORATIVE,false,false,243,-1,["Wheat","Nature","Plant","Environment"]));
         _loc82_.addBrick(createBrick(387,ItemLayer.ABOVE,decoBlocksBMD,"brickfarm","",ItemTab.DECORATIVE,false,false,244,-1,["Corn","Nature","Plant","Environment"]));
         _loc82_.addBrick(createBrick(388,ItemLayer.ABOVE,decoBlocksBMD,"brickfarm","",ItemTab.DECORATIVE,false,true,245,-1,["Fence","Wood","Left"]));
         _loc82_.addBrick(createBrick(1531,ItemLayer.ABOVE,decoBlocksBMD,"brickfarm","",ItemTab.DECORATIVE,false,true,332,-1,["Fence","Wood","Center","Middle"]));
         _loc82_.addBrick(createBrick(389,ItemLayer.ABOVE,decoBlocksBMD,"brickfarm","",ItemTab.DECORATIVE,false,true,246,-1,["Fence","Wood","Right"]));
         _loc82_.addBrick(createBrick(212,ItemLayer.DECORATION,blocksBMD,"brickfarm","",ItemTab.BLOCK,false,true,184,4291608181,["Hay","Yellow","Haybale","Straw"]));
         brickPackages.push(_loc82_);
         var _loc83_:ItemBrickPackage = new ItemBrickPackage("autumn 2014","Autumn 2014",["Nature","Environment","Season","Fall"]);
         _loc83_.addBrick(createBrick(390,ItemLayer.ABOVE,decoBlocksBMD,"brickautumn2014","",ItemTab.DECORATIVE,false,false,247,-1,["Leaves","Left","Orange"]));
         _loc83_.addBrick(createBrick(391,ItemLayer.ABOVE,decoBlocksBMD,"brickautumn2014","",ItemTab.DECORATIVE,false,false,248,-1,["Leaves","Right","Orange"]));
         _loc83_.addBrick(createBrick(392,ItemLayer.ABOVE,decoBlocksBMD,"brickautumn2014","",ItemTab.DECORATIVE,false,false,249,-1,["Grass","Left"]));
         _loc83_.addBrick(createBrick(393,ItemLayer.ABOVE,decoBlocksBMD,"brickautumn2014","",ItemTab.DECORATIVE,false,false,250,-1,["Grass","Middle"]));
         _loc83_.addBrick(createBrick(394,ItemLayer.ABOVE,decoBlocksBMD,"brickautumn2014","",ItemTab.DECORATIVE,false,false,251,-1,["Grass","Right"]));
         _loc83_.addBrick(createBrick(395,ItemLayer.ABOVE,decoBlocksBMD,"brickautumn2014","",ItemTab.DECORATIVE,false,false,252,-1,["Acorn","Nut","Brown"]));
         _loc83_.addBrick(createBrick(396,ItemLayer.ABOVE,decoBlocksBMD,"brickautumn2014","",ItemTab.DECORATIVE,false,false,253,-1,["Pumpkin","Halloween","Food","Orange"]));
         _loc83_.addBrick(createBrick(641,ItemLayer.BACKGROUND,bgBlocksBMD,"brickautumn2014","",ItemTab.BACKGROUND,false,true,135,-1,["Leaves","Yellow"]));
         _loc83_.addBrick(createBrick(642,ItemLayer.BACKGROUND,bgBlocksBMD,"brickautumn2014","",ItemTab.BACKGROUND,false,true,136,-1,["Leaves","Orange"]));
         _loc83_.addBrick(createBrick(643,ItemLayer.BACKGROUND,bgBlocksBMD,"brickautumn2014","",ItemTab.BACKGROUND,false,true,137,-1,["Leaves","Red"]));
         brickPackages.push(_loc83_);
         var _loc84_:ItemBrickPackage = new ItemBrickPackage("christmas 2014","Christmas 2014",["Xmas","Holiday"]);
         _loc84_.addBrick(createBrick(215,ItemLayer.FORGROUND,blocksBMD,"brickxmas2014","",ItemTab.BLOCK,false,true,187,-1,["Snow","Environment"]));
         _loc84_.addBrick(createBrick(216,ItemLayer.DECORATION,blocksBMD,"brickxmas2014","",ItemTab.BLOCK,false,true,188,-1,["Ice","Snow","Platform","Icicle","Top","Environment","One-Way","One Way"]));
         _loc84_.addBrick(createBrick(398,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2014","",ItemTab.DECORATIVE,false,false,254,-1,["Snow","Fluff","Left","Snowdrift","Environment"]));
         _loc84_.addBrick(createBrick(399,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2014","",ItemTab.DECORATIVE,false,false,255,-1,["Snow","Fluff","Middle","Snowdrift","Environment"]));
         _loc84_.addBrick(createBrick(400,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2014","",ItemTab.DECORATIVE,false,false,256,-1,["Snow","Fluff","Right","Snowdrift","Environment"]));
         _loc84_.addBrick(createBrick(401,ItemLayer.ABOVE,decoBlocksBMD,"brickxmas2014","",ItemTab.DECORATIVE,false,false,257,0,["Candy cane","Stripes"]));
         _loc84_.addBrick(createBrick(402,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2014","",ItemTab.DECORATIVE,false,true,258,0,["Tinsel","Nature","Garland","Top"]));
         _loc84_.addBrick(createBrick(403,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2014","",ItemTab.DECORATIVE,false,true,259,0,["Stocking","Sock","Red","Holiday"]));
         _loc84_.addBrick(createBrick(404,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2014","",ItemTab.DECORATIVE,false,true,260,0,["Bow","Ribbon","Red"]));
         brickPackages.push(_loc84_);
         var _loc85_:ItemBrickPackage = new ItemBrickPackage("one-way","One-way Blocks",["Platform"]);
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_WHITE,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,566,-1,["One way","White","Light","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_GRAY,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,472,-1,["One way","Gray","Grey","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_BLACK,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,488,-1,["One way","Black","Dark","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_RED,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,480,-1,["One way","Red","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_ORANGE,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,272,-1,["One way","Orange","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_YELLOW,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,268,-1,["One way","Yellow","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_GREEN,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,484,-1,["One way","Green","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_CYAN,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,264,-1,["One way","Cyan","Blue","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_BLUE,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,476,-1,["One way","Blue","Dark","Morphable","One-way"]));
         _loc85_.addBrick(createBrick(ItemId.ONEWAY_PINK,ItemLayer.DECORATION,specialBlocksBMD,"brickoneway","",ItemTab.BLOCK,false,false,276,-1,["One way","Purple","Pink","Morphable","One-way"]));
         brickPackages.push(_loc85_);
         var _loc86_:ItemBrickPackage = new ItemBrickPackage("valentines 2015","Valentines 2015",["Kiss","Holiday","Love","Heart","<3"]);
         _loc86_.addBrick(createBrick(405,ItemLayer.DECORATION,decoBlocksBMD,"brickval2015","",ItemTab.DECORATIVE,false,true,261,0,["Red"]));
         _loc86_.addBrick(createBrick(406,ItemLayer.DECORATION,decoBlocksBMD,"brickval2015","",ItemTab.DECORATIVE,false,true,262,0,["Purple","Pink"]));
         _loc86_.addBrick(createBrick(407,ItemLayer.DECORATION,decoBlocksBMD,"brickval2015","",ItemTab.DECORATIVE,false,true,263,0,["Pink"]));
         brickPackages.push(_loc86_);
         var _loc87_:ItemBrickPackage = new ItemBrickPackage("magic","Magic Blocks",["Rare"]);
         _loc87_.addBrick(createBrick(1013,ItemLayer.FORGROUND,blocksBMD,"brickmagic","the first magic block",ItemTab.BLOCK,false,true,200,-1,["Green","Emerald","Peridot"]));
         _loc87_.addBrick(createBrick(1014,ItemLayer.FORGROUND,blocksBMD,"brickmagic","the second magic block",ItemTab.BLOCK,false,true,201,-1,["Purple","Violet","Amethyst"]));
         _loc87_.addBrick(createBrick(1015,ItemLayer.FORGROUND,blocksBMD,"brickmagic","the third magic block",ItemTab.BLOCK,false,true,202,-1,["Yellow","Orange","Amber","Topaz"]));
         _loc87_.addBrick(createBrick(1016,ItemLayer.FORGROUND,blocksBMD,"brickmagic","the fourth magic block",ItemTab.BLOCK,false,true,203,-1,["Blue","Sapphire"]));
         _loc87_.addBrick(createBrick(1017,ItemLayer.FORGROUND,blocksBMD,"brickmagic","the fifth magic block",ItemTab.BLOCK,false,true,204,-1,["Red","Ruby","Garnet"]));
         _loc87_.addBrick(createBrick(1132,ItemLayer.FORGROUND,blocksBMD,"brickmagic","the sixth magic block",ItemTab.BLOCK,false,true,293,-1,["Cyan","Aquamarine","Turquoise"]));
         _loc87_.addBrick(createBrick(1142,ItemLayer.FORGROUND,blocksBMD,"brickmagic","the seventh magic block",ItemTab.BLOCK,false,true,299,-1,["White","Opal","Pearl"]));
         _loc87_.addBrick(createBrick(1161,ItemLayer.FORGROUND,blocksBMD,"brickmagic","the eighth magic block",ItemTab.BLOCK,false,true,316,-1,["Black","Onyx"]));
         brickPackages.push(_loc87_);
         var _loc88_:ItemBrickPackage = new ItemBrickPackage("effect","Effect Blocks",["Powers","Action","Physics"]);
         _loc88_.addBrick(createBrick(ItemId.EFFECT_JUMP,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","jump effect: players jump twice or half as high",ItemTab.ACTION,false,false,0,0,["Jump","Boost","High","Low"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_FLY,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","fly effect: players can levitate by holding space",ItemTab.ACTION,false,false,1,0,["Fly","Hover","Levitate"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_RUN,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","speed effect: players move 50% faster or slower",ItemTab.ACTION,false,false,2,0,["Speed","Fast","Run","Slow"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_LOW_GRAVITY,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","low gravity effect: player gravity is reduced",ItemTab.ACTION,false,false,13,0,["Gravity","Moon","Low gravity","Space","Slow fall","Float"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_PROTECTION,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","protection effect: players are safe from hazards and cured from curses/zombies",ItemTab.ACTION,false,false,3,0,["Invincible","Health","Plus","Immortal","Protection"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_CURSE,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","players die after X seconds, spreads on contact, maximum of 3 curses at a time",ItemTab.ACTION,false,false,4,0,["Curse","Skull","Skeleton","Timed","Death","Die","Kill"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_MULTIJUMP,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","multijump effect: players can jump X times",ItemTab.ACTION,false,false,15,0,["Double","Jump","Twice","Powers","Action","Physics"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_GRAVITY,ItemLayer.DECORATION,specialBlocksBMD,"brickeffect","gravity effect: player gravity is rotated",ItemTab.ACTION,false,false,657,0,["Gravity","Reverse","Action","Physics"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_POISON,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","poison effect: players die after X seconds, does not spread",ItemTab.ACTION,false,false,23,0,["Poison","Toxic","Action","Timed","Death","Die","Kill"]));
         _loc88_.addBrick(createBrick(ItemId.EFFECT_RESET,ItemLayer.DECORATION,effectBlocksBMD,"brickeffect","reset effect: resets all non-timed effects",ItemTab.ACTION,false,false,26,0,["Reset","Action","Physics"]));
         brickPackages.push(_loc88_);
         var _loc89_:ItemBrickPackage = new ItemBrickPackage("gold","Gold Membership Blocks",["Shiny","Yellow"]);
         _loc89_.addBrick(createBrick(1065,ItemLayer.FORGROUND,blocksBMD,"goldmember","",ItemTab.BLOCK,true,true,242,-1,[]));
         _loc89_.addBrick(createBrick(1066,ItemLayer.FORGROUND,blocksBMD,"goldmember","",ItemTab.BLOCK,true,true,243,-1,[]));
         _loc89_.addBrick(createBrick(1067,ItemLayer.FORGROUND,blocksBMD,"goldmember","",ItemTab.BLOCK,true,true,244,-1,[]));
         _loc89_.addBrick(createBrick(1068,ItemLayer.FORGROUND,blocksBMD,"goldmember","",ItemTab.BLOCK,true,true,245,-1,[]));
         _loc89_.addBrick(createBrick(1069,ItemLayer.DECORATION,blocksBMD,"goldmember","",ItemTab.BLOCK,true,true,246,0,[]));
         _loc89_.addBrick(createBrick(709,ItemLayer.BACKGROUND,bgBlocksBMD,"goldmember","",ItemTab.BACKGROUND,true,false,198,-1,[]));
         _loc89_.addBrick(createBrick(710,ItemLayer.BACKGROUND,bgBlocksBMD,"goldmember","",ItemTab.BACKGROUND,true,false,199,-1,[]));
         _loc89_.addBrick(createBrick(711,ItemLayer.BACKGROUND,bgBlocksBMD,"goldmember","",ItemTab.BACKGROUND,true,false,200,-1,[]));
         _loc89_.addBrick(createBrick(ItemId.GATE_GOLD,ItemLayer.DECORATION,doorBlocksBMD,"goldmember","",ItemTab.ACTION,true,false,10,-1,[]));
         _loc89_.addBrick(createBrick(ItemId.DOOR_GOLD,ItemLayer.DECORATION,doorBlocksBMD,"goldmember","",ItemTab.ACTION,true,false,11,-1,[]));
         brickPackages.push(_loc89_);
         var _loc90_:ItemBrickPackage = new ItemBrickPackage("cave","Cave Backgrounds",["Environment"]);
         _loc90_.addBrick(createBrick(766,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,259,-1,["Dark","Grey","Gray"]));
         _loc90_.addBrick(createBrick(767,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,260,-1,["Dark","Grey","Gray"]));
         _loc90_.addBrick(createBrick(768,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,261,-1,["Dark","Grey","Gray","Black"]));
         _loc90_.addBrick(createBrick(662,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,156,-1,["Dark","Red"]));
         _loc90_.addBrick(createBrick(660,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,154,-1,["Dark","Orange","Brown"]));
         _loc90_.addBrick(createBrick(661,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,155,-1,["Dark","Yellow","Olive"]));
         _loc90_.addBrick(createBrick(659,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,153,-1,["Dark","Green"]));
         _loc90_.addBrick(createBrick(656,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,150,-1,["Dark","Cyan"]));
         _loc90_.addBrick(createBrick(657,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,151,-1,["Dark","Blue","Night","Sky"]));
         _loc90_.addBrick(createBrick(655,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,149,-1,["Dark","Purple"]));
         _loc90_.addBrick(createBrick(658,ItemLayer.BACKGROUND,bgBlocksBMD,"brickcave","",ItemTab.BACKGROUND,false,false,152,-1,["Dark","Pink","Magenta","Violet"]));
         brickPackages.push(_loc90_);
         var _loc91_:ItemBrickPackage = new ItemBrickPackage("summer 2015","Summer 2015",["Season"]);
         _loc91_.addBrick(createBrick(441,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2015","",ItemTab.DECORATIVE,false,true,280,0,["Life preserver","Life saver","Circle","Life buoy","Ring"]));
         _loc91_.addBrick(createBrick(442,ItemLayer.DECORATION,decoBlocksBMD,"bricksummer2015","",ItemTab.DECORATIVE,false,true,281,0,["Anchor","Metal","Ship","Water"]));
         _loc91_.addBrick(createBrick(443,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2015","",ItemTab.DECORATIVE,false,false,282,0,["Rope","Left","Dock"]));
         _loc91_.addBrick(createBrick(444,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2015","",ItemTab.DECORATIVE,false,false,283,0,["Rope","Right","Dock"]));
         _loc91_.addBrick(createBrick(445,ItemLayer.ABOVE,decoBlocksBMD,"bricksummer2015","",ItemTab.DECORATIVE,false,false,284,0,["Tree","Nature","Palm","Plant","Environment"]));
         brickPackages.push(_loc91_);
         var _loc92_:ItemBrickPackage = new ItemBrickPackage("environment","Environment",["Nature"]);
         _loc92_.addBrick(createBrick(1030,ItemLayer.FORGROUND,blocksBMD,"brickenvironment","",ItemTab.BLOCK,false,true,215,-1,["Wood","Tree","Brown"]));
         _loc92_.addBrick(createBrick(1031,ItemLayer.FORGROUND,blocksBMD,"brickenvironment","",ItemTab.BLOCK,false,true,216,-1,["Leaves","Grass","Green","Plant"]));
         _loc92_.addBrick(createBrick(1032,ItemLayer.FORGROUND,blocksBMD,"brickenvironment","",ItemTab.BLOCK,false,true,217,-1,["Bamboo","Wood","Yellow"]));
         _loc92_.addBrick(createBrick(1033,ItemLayer.FORGROUND,blocksBMD,"brickenvironment","",ItemTab.BLOCK,false,true,218,-1,["Obsidian","Rock","Ice","Grey","Gray"]));
         _loc92_.addBrick(createBrick(1034,ItemLayer.FORGROUND,blocksBMD,"brickenvironment","",ItemTab.BLOCK,false,true,219,-1,["Fire","Lava","Hot"]));
         _loc92_.addBrick(createBrick(678,ItemLayer.BACKGROUND,bgBlocksBMD,"brickenvironment","",ItemTab.BACKGROUND,false,false,172,-1,["Wood","Tree","Brown"]));
         _loc92_.addBrick(createBrick(679,ItemLayer.BACKGROUND,bgBlocksBMD,"brickenvironment","",ItemTab.BACKGROUND,false,false,173,-1,["Leaves","Grass","Green"]));
         _loc92_.addBrick(createBrick(680,ItemLayer.BACKGROUND,bgBlocksBMD,"brickenvironment","",ItemTab.BACKGROUND,false,false,174,-1,["Bamboo","Wood"]));
         _loc92_.addBrick(createBrick(681,ItemLayer.BACKGROUND,bgBlocksBMD,"brickenvironment","",ItemTab.BACKGROUND,false,false,175,-1,["Obsidian","Rock","Ice","Grey","Gray"]));
         _loc92_.addBrick(createBrick(682,ItemLayer.BACKGROUND,bgBlocksBMD,"brickenvironment","",ItemTab.BACKGROUND,false,false,176,-1,["Fire","Lava","Hot","Molten"]));
         brickPackages.push(_loc92_);
         var _loc93_:ItemBrickPackage = new ItemBrickPackage("domestic","Domestic",["House"]);
         _loc93_.addBrick(createBrick(1035,ItemLayer.FORGROUND,blocksBMD,"brickdomestic","",ItemTab.BLOCK,false,true,220,-1,["Tile","Double","Floor","Parquet","Checkered"]));
         _loc93_.addBrick(createBrick(1036,ItemLayer.FORGROUND,blocksBMD,"brickdomestic","",ItemTab.BLOCK,false,true,221,-1,["Wood","Brown","Floor"]));
         _loc93_.addBrick(createBrick(1037,ItemLayer.FORGROUND,blocksBMD,"brickdomestic","",ItemTab.BLOCK,false,true,222,-1,["Red","Carpet"]));
         _loc93_.addBrick(createBrick(1038,ItemLayer.FORGROUND,blocksBMD,"brickdomestic","",ItemTab.BLOCK,false,true,223,-1,["Blue","Carpet"]));
         _loc93_.addBrick(createBrick(1039,ItemLayer.FORGROUND,blocksBMD,"brickdomestic","",ItemTab.BLOCK,false,true,224,-1,["Green","Carpet","Grass"]));
         _loc93_.addBrick(createBrick(1040,ItemLayer.FORGROUND,blocksBMD,"brickdomestic","",ItemTab.BLOCK,false,true,225,-1,["White","Marble","Box","Square"]));
         _loc93_.addBrick(createBrick(683,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdomestic","",ItemTab.BACKGROUND,false,false,177,-1,["Wallpaper","Yellow","Dark yellow","Brown"]));
         _loc93_.addBrick(createBrick(684,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdomestic","",ItemTab.BACKGROUND,false,false,178,-1,["Wallpaper","Brown","Dark brown"]));
         _loc93_.addBrick(createBrick(685,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdomestic","",ItemTab.BACKGROUND,false,false,179,-1,["Wallpaper","Red","Dark red"]));
         _loc93_.addBrick(createBrick(686,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdomestic","",ItemTab.BACKGROUND,false,false,180,-1,["Wallpaper","Blue","Dark blue"]));
         _loc93_.addBrick(createBrick(687,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdomestic","",ItemTab.BACKGROUND,false,false,181,-1,["Wallpaper","Green","Dark green","Stripes"]));
         _loc93_.addBrick(createBrick(446,ItemLayer.DECORATION,decoBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,285,0,["Light","Lampshade"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_LIGHT_BULB,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,425,0,["Light","Bulb","Morphable"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_TAP,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,true,429,0,["Pipe","Tube","Mario","Corner","Morphable"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_PIPE_STRAIGHT,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,715,0,["Pipe","Tube","Mario","Morphable"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_PIPE_T,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,717,0,["Pipe","Tube","Mario","Corner","Morphable"]));
         _loc93_.addBrick(createBrick(1539,ItemLayer.DECORATION,decoBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,true,335,0,["Pipe","Tube","Mario","Corner"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_PAINTING,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,433,0,["Picture","Painting","Frame","Morphable"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_VASE,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,437,0,["Flower","Nature","Plant","Vase"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_TV,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,441,0,["Television","TV","Morphable","Screen","CRT","Box","LCD","Electronic"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_WINDOW,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,445,0,["Window","Morphable"]));
         _loc93_.addBrick(createBrick(ItemId.HALFBLOCK_DOMESTIC_YELLOW,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.BLOCK,false,false,449,-1,["Half block","Yellow","Morphable","Gold"]));
         _loc93_.addBrick(createBrick(ItemId.HALFBLOCK_DOMESTIC_BROWN,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.BLOCK,false,false,453,-1,["Half block","Brown","Morphable","Wood"]));
         _loc93_.addBrick(createBrick(ItemId.HALFBLOCK_DOMESTIC_WHITE,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.BLOCK,false,false,457,-1,["Half block","White","Morphable","Marble"]));
         _loc93_.addBrick(createBrick(ItemId.DOMESTIC_FRAME_BORDER,ItemLayer.DECORATION,specialBlocksBMD,"brickdomestic","",ItemTab.DECORATIVE,false,false,720,0,["Picture","Painting","Frame","Morphable"]));
         brickPackages.push(_loc93_);
         var _loc94_:ItemBrickPackage = new ItemBrickPackage("halloween 2015","Halloween 2015",["Holiday","House","Scary","Creepy"]);
         _loc94_.addBrick(createBrick(1047,ItemLayer.FORGROUND,blocksBMD,"brickhw2015","",ItemTab.BLOCK,false,true,229,-1,["Mossy","Green","Brick","Old","Sewer","Ghost"]));
         _loc94_.addBrick(createBrick(1048,ItemLayer.FORGROUND,blocksBMD,"brickhw2015","",ItemTab.BLOCK,false,true,230,-1,["Siding","Light gray"]));
         _loc94_.addBrick(createBrick(1049,ItemLayer.FORGROUND,blocksBMD,"brickhw2015","",ItemTab.BLOCK,false,true,231,-1,["Mossy","Gray","Green","Grey","Roof","Catacomb","Brick","Tomb"]));
         _loc94_.addBrick(createBrick(ItemId.HALLOWEEN_2015_ONEWAY,ItemLayer.DECORATION,blocksBMD,"brickhw2015","",ItemTab.BLOCK,false,true,232,0,["Platform","Gray","Grey","Stone","Corner","One Way","One-Way"]));
         _loc94_.addBrick(createBrick(454,ItemLayer.ABOVE,decoBlocksBMD,"brickhw2015","",ItemTab.DECORATIVE,false,false,286,0,["Bush","Nature","Plant","Dead","Shrub","Environment"]));
         _loc94_.addBrick(createBrick(455,ItemLayer.ABOVE,decoBlocksBMD,"brickhw2015","",ItemTab.DECORATIVE,false,false,287,0,["Fence","Spikes"]));
         _loc94_.addBrick(createBrick(ItemId.HALLOWEEN_2015_WINDOW_RECT,ItemLayer.DECORATION,specialBlocksBMD,"brickhw2015","",ItemTab.DECORATIVE,false,false,461,0,["Window","Morphable","Wood","Arched"]));
         _loc94_.addBrick(createBrick(ItemId.HALLOWEEN_2015_WINDOW_CIRCLE,ItemLayer.DECORATION,specialBlocksBMD,"brickhw2015","",ItemTab.DECORATIVE,false,false,463,0,["Window","Morphable","Round","Circle","Wood"]));
         _loc94_.addBrick(createBrick(ItemId.HALLOWEEN_2015_LAMP,ItemLayer.DECORATION,specialBlocksBMD,"brickhw2015","",ItemTab.DECORATIVE,false,false,465,0,["Light","Morphable","Lamp","Lantern"]));
         _loc94_.addBrick(createBrick(694,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2015","",ItemTab.BACKGROUND,false,false,188,-1,["Mossy","Green","Brick","Stone","Sewer"]));
         _loc94_.addBrick(createBrick(695,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2015","",ItemTab.BACKGROUND,false,false,189,-1,["Sliding","Gray","Grey","Slabs","Sewer"]));
         _loc94_.addBrick(createBrick(696,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2015","",ItemTab.BACKGROUND,false,false,190,-1,["Mossy","Gray","Grey","Roof","Catacomb","Tomb"]));
         brickPackages.push(_loc94_);
         var _loc95_:ItemBrickPackage = new ItemBrickPackage("arctic","Arctic",["Snow","Cold","Blue","Frozen","Freeze"]);
         _loc95_.addBrick(createBrick(1059,ItemLayer.FORGROUND,blocksBMD,"brickarctic","",ItemTab.BLOCK,false,true,237,-1,["Ice"]));
         _loc95_.addBrick(createBrick(1060,ItemLayer.FORGROUND,blocksBMD,"brickarctic","",ItemTab.BLOCK,false,true,238,-1));
         _loc95_.addBrick(createBrick(1061,ItemLayer.DECORATION,blocksBMD,"brickarctic","",ItemTab.BLOCK,false,true,239,-1,["Left"]));
         _loc95_.addBrick(createBrick(1062,ItemLayer.FORGROUND,blocksBMD,"brickarctic","",ItemTab.BLOCK,false,true,240,-1,["Middle"]));
         _loc95_.addBrick(createBrick(1063,ItemLayer.DECORATION,blocksBMD,"brickarctic","",ItemTab.BLOCK,false,true,241,-1,["Right"]));
         _loc95_.addBrick(createBrick(702,ItemLayer.BACKGROUND,bgBlocksBMD,"brickarctic","",ItemTab.BACKGROUND,false,false,196,-1));
         _loc95_.addBrick(createBrick(703,ItemLayer.BACKGROUND,bgBlocksBMD,"brickarctic","",ItemTab.BACKGROUND,false,false,197,-1));
         brickPackages.push(_loc95_);
         var _loc96_:ItemBrickPackage = new ItemBrickPackage("new year 2015","New Year 2015",["Holiday"]);
         _loc96_.addBrick(createBrick(462,ItemLayer.DECORATION,decoBlocksBMD,"brickny2015","",ItemTab.DECORATIVE,false,true,289,0,["Glass","Wine","Drink"]));
         _loc96_.addBrick(createBrick(463,ItemLayer.DECORATION,decoBlocksBMD,"brickny2015","",ItemTab.DECORATIVE,false,true,290,0,["Bottle","Champagne","Drink"]));
         _loc96_.addBrick(createBrick(ItemId.NEW_YEAR_2015_BALLOON,ItemLayer.DECORATION,specialBlocksBMD,"brickny2015","",ItemTab.DECORATIVE,false,true,492,0,["Balloon","Morphable"]));
         _loc96_.addBrick(createBrick(ItemId.NEW_YEAR_2015_STREAMER,ItemLayer.DECORATION,specialBlocksBMD,"brickny2015","",ItemTab.DECORATIVE,false,true,497,0,["String","Morphable","Streamer"]));
         brickPackages.push(_loc96_);
         var _loc97_:ItemBrickPackage = new ItemBrickPackage("ice","Ice");
         _loc97_.addBrick(createBrick(ItemId.ICE,ItemLayer.DECORATION,specialBlocksBMD,"brickice","",ItemTab.ACTION,false,true,501,-1,["Slippery","Physics","Slide"]));
         brickPackages.push(_loc97_);
         var _loc98_:ItemBrickPackage = new ItemBrickPackage("fairytale","Fairytale",["Mythical","Fiction"]);
         _loc98_.addBrick(createBrick(1070,ItemLayer.FORGROUND,blocksBMD,"brickfairytale","",ItemTab.BLOCK,false,true,247,-1,["Cobblestone","Pebbles"]));
         _loc98_.addBrick(createBrick(1071,ItemLayer.FORGROUND,blocksBMD,"brickfairytale","",ItemTab.BLOCK,false,true,248,-1,["Orange","Tree"]));
         _loc98_.addBrick(createBrick(1072,ItemLayer.FORGROUND,blocksBMD,"brickfairytale","",ItemTab.BLOCK,false,true,249,-1,["Green","Moss"]));
         _loc98_.addBrick(createBrick(1073,ItemLayer.DECORATION,blocksBMD,"brickfairytale","",ItemTab.BLOCK,false,true,250,-1,["Blue","Cloud"]));
         _loc98_.addBrick(createBrick(1074,ItemLayer.DECORATION,blocksBMD,"brickfairytale","",ItemTab.BLOCK,false,true,251,-1,["Red","Mushroom","Spotted"]));
         _loc98_.addBrick(createBrick(468,ItemLayer.DECORATION,decoBlocksBMD,"brickfairytale","",ItemTab.DECORATIVE,false,true,291,0,["Green","Plant","Vine"]));
         _loc98_.addBrick(createBrick(469,ItemLayer.DECORATION,decoBlocksBMD,"brickfairytale","",ItemTab.DECORATIVE,false,true,292,0,["Mushroom","Orange"]));
         _loc98_.addBrick(createBrick(1622,ItemLayer.DECORATION,decoBlocksBMD,"brickfairytale","",ItemTab.DECORATIVE,false,true,365,0,["Mushroom","Red","Spotted"]));
         _loc98_.addBrick(createBrick(470,ItemLayer.DECORATION,decoBlocksBMD,"brickfairytale","",ItemTab.DECORATIVE,false,true,293,0,["Dew Drop","Transparent","Water"]));
         _loc98_.addBrick(createBrick(704,ItemLayer.BACKGROUND,bgBlocksBMD,"brickfairytale","",ItemTab.BACKGROUND,false,false,201,-1,["Orange","Mist","Fog","Swirl"]));
         _loc98_.addBrick(createBrick(705,ItemLayer.BACKGROUND,bgBlocksBMD,"brickfairytale","",ItemTab.BACKGROUND,false,false,202,-1,["Green","Mist","Fog","Swirl"]));
         _loc98_.addBrick(createBrick(706,ItemLayer.BACKGROUND,bgBlocksBMD,"brickfairytale","",ItemTab.BACKGROUND,false,false,203,-1,["Blue","Mist","Fog","Swirl"]));
         _loc98_.addBrick(createBrick(707,ItemLayer.BACKGROUND,bgBlocksBMD,"brickfairytale","",ItemTab.BACKGROUND,false,false,204,-1,["Pink","Mist","Fog","Swirl"]));
         _loc98_.addBrick(createBrick(ItemId.HALFBLOCK_FAIRYTALE_ORANGE,ItemLayer.DECORATION,specialBlocksBMD,"brickfairytale","",ItemTab.BLOCK,false,false,522,-1,["Half block","Gemstone","Crystal","Orange"]));
         _loc98_.addBrick(createBrick(ItemId.HALFBLOCK_FAIRYTALE_GREEN,ItemLayer.DECORATION,specialBlocksBMD,"brickfairytale","",ItemTab.BLOCK,false,false,526,-1,["Half block","Gemstone","Crystal","Green"]));
         _loc98_.addBrick(createBrick(ItemId.HALFBLOCK_FAIRYTALE_BLUE,ItemLayer.DECORATION,specialBlocksBMD,"brickfairytale","",ItemTab.BLOCK,false,false,530,-1,["Half block","Gemstone","Crystal","Blue"]));
         _loc98_.addBrick(createBrick(ItemId.HALFBLOCK_FAIRYTALE_PINK,ItemLayer.DECORATION,specialBlocksBMD,"brickfairytale","",ItemTab.BLOCK,false,false,534,-1,["Half block","Gemstone","Crystal","Pink"]));
         _loc98_.addBrick(createBrick(ItemId.FAIRYTALE_FLOWERS,ItemLayer.DECORATION,specialBlocksBMD,"brickfairytale","",ItemTab.DECORATIVE,false,true,538,0,["Morphable","Green","Blue","Orange","Pink","Plant","Flower"]));
         brickPackages.push(_loc98_);
         var _loc99_:ItemBrickPackage = new ItemBrickPackage("spring 2016","Spring 2016");
         _loc99_.addBrick(createBrick(1081,ItemLayer.FORGROUND,blocksBMD,"brickspring2016","",ItemTab.BLOCK,false,true,253,-1,["Dirt","Brown","Soil","Nature"]));
         _loc99_.addBrick(createBrick(1082,ItemLayer.FORGROUND,blocksBMD,"brickspring2016","",ItemTab.BLOCK,false,true,254,-1,["Hedge","Green","Leaf","Nature","Plant"]));
         _loc99_.addBrick(createBrick(473,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2016","",ItemTab.DECORATIVE,false,false,294,0,["Dirt","Brown","Soil","Slope","Left"]));
         _loc99_.addBrick(createBrick(474,ItemLayer.ABOVE,decoBlocksBMD,"brickspring2016","",ItemTab.DECORATIVE,false,false,295,0,["Dirt","Brown","Soil","Slope","Right"]));
         _loc99_.addBrick(createBrick(ItemId.SPRING_DAISY,ItemLayer.DECORATION,specialBlocksBMD,"brickspring2016","",ItemTab.DECORATIVE,false,false,541,0,["Daisy","Flower","Plant","Nature","White","Blue","Pink"]));
         _loc99_.addBrick(createBrick(ItemId.SPRING_TULIP,ItemLayer.DECORATION,specialBlocksBMD,"brickspring2016","",ItemTab.DECORATIVE,false,false,544,0,["Tulip","Flower","Plant","Nature","Red","Yellow","Pink"]));
         _loc99_.addBrick(createBrick(ItemId.SPRING_DAFFODIL,ItemLayer.DECORATION,specialBlocksBMD,"brickspring2016","",ItemTab.DECORATIVE,false,false,547,0,["Daffodil","Flower","Plant","Nature","Yellow","White","Orange"]));
         brickPackages.push(_loc99_);
         var _loc100_:ItemBrickPackage = new ItemBrickPackage("summer 2016","Summer 2016");
         _loc100_.addBrick(createBrick(1083,ItemLayer.FORGROUND,blocksBMD,"bricksummer2016","",ItemTab.BLOCK,false,true,255,-1,["Thatched","Straw","Seasonal","Beige","Tan"]));
         _loc100_.addBrick(createBrick(1084,ItemLayer.FORGROUND,blocksBMD,"bricksummer2016","",ItemTab.BLOCK,false,true,256,-1,["Planks","Wood","Seasonal","Purple"]));
         _loc100_.addBrick(createBrick(1085,ItemLayer.FORGROUND,blocksBMD,"bricksummer2016","",ItemTab.BLOCK,false,true,257,-1,["Planks","Wood","Seasonal","Yellow"]));
         _loc100_.addBrick(createBrick(1086,ItemLayer.FORGROUND,blocksBMD,"bricksummer2016","",ItemTab.BLOCK,false,true,258,-1,["Planks","Wood","Seasonal","Teal"]));
         _loc100_.addBrick(createBrick(1087,ItemLayer.DECORATION,blocksBMD,"bricksummer2016","",ItemTab.BLOCK,false,true,259,0,["Platform","Dock","Wood","Seasonal","One Way","One-Way","Brown"]));
         _loc100_.addBrick(createBrick(708,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksummer2016","",ItemTab.BACKGROUND,false,false,205,-1,["Thatched","Straw","Seasonal","Beige","Tan"]));
         _loc100_.addBrick(createBrick(712,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksummer2016","",ItemTab.BACKGROUND,false,false,206,-1,["Planks","Wood","Seasonal","Purple"]));
         _loc100_.addBrick(createBrick(713,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksummer2016","",ItemTab.BACKGROUND,false,false,207,-1,["Planks","Wood","Seasonal","Yellow"]));
         _loc100_.addBrick(createBrick(714,ItemLayer.BACKGROUND,bgBlocksBMD,"bricksummer2016","",ItemTab.BACKGROUND,false,false,208,-1,["Planks","Wood","Seasonal","Teal"]));
         _loc100_.addBrick(createBrick(ItemId.SUMMER_FLAG,ItemLayer.DECORATION,specialBlocksBMD,"bricksummer2016","",ItemTab.DECORATIVE,false,false,550,0,["Flag","Seasonal","Red","Yellow","Green","Cyan","Blue","Purple"]));
         _loc100_.addBrick(createBrick(ItemId.SUMMER_AWNING,ItemLayer.DECORATION,specialBlocksBMD,"bricksummer2016","",ItemTab.DECORATIVE,false,false,556,0,["Awning","Striped","Seasonal","White","Red","Yellow","Green","Cyan","Blue","Purple"]));
         _loc100_.addBrick(createBrick(ItemId.SUMMER_ICECREAM,ItemLayer.DECORATION,specialBlocksBMD,"bricksummer2016","",ItemTab.DECORATIVE,false,false,562,0,["Ice Cream","Food","Vanilla","Chocolate","Strawberry","Mint","Beige","Brown","Pink","Green"]));
         brickPackages.push(_loc100_);
         var _loc101_:ItemBrickPackage = new ItemBrickPackage("mine","Mine");
         _loc101_.addBrick(createBrick(1093,ItemLayer.FORGROUND,blocksBMD,"brickmine","",ItemTab.BLOCK,false,true,264,-1,["Stone","Brown","Tan","Rock"]));
         _loc101_.addBrick(createBrick(720,ItemLayer.BACKGROUND,bgBlocksBMD,"brickmine","",ItemTab.BACKGROUND,false,true,219,-1,["Stone","Brown","Tan","Rock","Dark"]));
         _loc101_.addBrick(createBrick(495,ItemLayer.DECORATION,decoBlocksBMD,"brickmine","",ItemTab.DECORATIVE,false,true,307,0,["Stalagmite","Stone","Brown","Tan","Rock"]));
         _loc101_.addBrick(createBrick(496,ItemLayer.DECORATION,decoBlocksBMD,"brickmine","",ItemTab.DECORATIVE,false,true,308,0,["Stalagtite","Stone","Brown","Tan","Rock"]));
         _loc101_.addBrick(createBrick(ItemId.CAVE_CRYSTAL,ItemLayer.DECORATION,specialBlocksBMD,"brickmine","",ItemTab.DECORATIVE,false,true,570,0,["Crystal","Gemstone","Red","Yellow","Green","Cyan","Blue","Purple"]));
         _loc101_.addBrick(createBrick(ItemId.CAVE_TORCH,ItemLayer.DECORATION,specialBlocksBMD,"brickmine","",ItemTab.DECORATIVE,false,false,576,0,["Torch","Fire","Animated"]));
         brickPackages.push(_loc101_);
         var _loc102_:ItemBrickPackage = new ItemBrickPackage("restaurant","Restaurant");
         _loc102_.addBrick(createBrick(487,ItemLayer.DECORATION,decoBlocksBMD,"brickrestaurant","",ItemTab.DECORATIVE,false,true,302,0,["Hamburger","Sandwich","Food"]));
         _loc102_.addBrick(createBrick(488,ItemLayer.DECORATION,decoBlocksBMD,"brickrestaurant","",ItemTab.DECORATIVE,false,true,303,0,["Hot Dog","Sausage","Food"]));
         _loc102_.addBrick(createBrick(489,ItemLayer.DECORATION,decoBlocksBMD,"brickrestaurant","",ItemTab.DECORATIVE,false,true,304,0,["Sub","Sandwich","Ham","Food"]));
         _loc102_.addBrick(createBrick(490,ItemLayer.DECORATION,decoBlocksBMD,"brickrestaurant","",ItemTab.DECORATIVE,false,true,305,0,["Soda","Drink","Beverage","Red"]));
         _loc102_.addBrick(createBrick(491,ItemLayer.DECORATION,decoBlocksBMD,"brickrestaurant","",ItemTab.DECORATIVE,false,true,306,0,["French Fries","Chips","Food","Red","Yellow"]));
         _loc102_.addBrick(createBrick(ItemId.RESTAURANT_CUP,ItemLayer.DECORATION,specialBlocksBMD,"brickrestaurant","",ItemTab.DECORATIVE,false,true,588,0,["Glass","Cup","Drink","Water","Milk","Orange Juice","Beverage"]));
         _loc102_.addBrick(createBrick(ItemId.RESTAURANT_PLATE,ItemLayer.DECORATION,specialBlocksBMD,"brickrestaurant","",ItemTab.DECORATIVE,false,true,592,0,["Plate","Chicken","Ham","Fish","Food"]));
         _loc102_.addBrick(createBrick(ItemId.RESTAURANT_BOWL,ItemLayer.DECORATION,specialBlocksBMD,"brickrestaurant","",ItemTab.DECORATIVE,false,true,597,0,["Bowl","Salad","Spaghetti","Pasta","Ice Cream","Food"]));
         brickPackages.push(_loc102_);
         var _loc103_:ItemBrickPackage = new ItemBrickPackage("textile","Textile");
         _loc103_.addBrick(createBrick(721,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktextile","",ItemTab.BACKGROUND,false,true,214,-1,["Cloth","Fabric","Pattern","White","Green","Plaid","Checker"]));
         _loc103_.addBrick(createBrick(722,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktextile","",ItemTab.BACKGROUND,false,true,215,-1,["Cloth","Fabric","Pattern","White","Blue","Chevron","Zigzag"]));
         _loc103_.addBrick(createBrick(723,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktextile","",ItemTab.BACKGROUND,false,true,216,-1,["Cloth","Fabric","Pattern","White","Pink","Polka Dots","Spots"]));
         _loc103_.addBrick(createBrick(724,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktextile","",ItemTab.BACKGROUND,false,true,217,-1,["Cloth","Fabric","Pattern","White","Yellow","Stripes","Horizontal"]));
         _loc103_.addBrick(createBrick(725,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktextile","",ItemTab.BACKGROUND,false,true,218,-1,["Cloth","Fabric","Pattern","White","Red","Plaid","Diamond"]));
         brickPackages.push(_loc103_);
         var _loc104_:ItemBrickPackage = new ItemBrickPackage("halloween 2016","Halloween 2016");
         _loc104_.addBrick(createBrick(ItemId.HALLOWEEN_2016_ROTATABLE,ItemLayer.DECORATION,specialBlocksBMD,"brickhw2016","",ItemTab.DECORATIVE,false,false,601,0,["Branch","Root","Wood","Slope","Black","Rotatable","Morphable","Seasonal","Holiday"]));
         _loc104_.addBrick(createBrick(ItemId.HALLOWEEN_2016_PUMPKIN,ItemLayer.DECORATION,specialBlocksBMD,"brickhw2016","",ItemTab.DECORATIVE,false,false,605,0,["Pumpkin","Jack o Lantern","Orange","Morphable","Seasonal","Holiday"]));
         _loc104_.addBrick(createBrick(1501,ItemLayer.ABOVE,decoBlocksBMD,"brickhw2016","",ItemTab.DECORATIVE,false,false,309,0,["Grass","Plant","Purple","Seasonal","Holiday"]));
         _loc104_.addBrick(createBrick(ItemId.HALLOWEEN_2016_EYES,ItemLayer.DECORATION,specialBlocksBMD,"brickhw2016","",ItemTab.DECORATIVE,false,false,612,0,["Eyes","Orange","Purple","Green","Yellow","Morphable","Seasonal","Holiday"]));
         _loc104_.addBrick(createBrick(726,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2016","",ItemTab.BACKGROUND,false,false,220,-1,["Tree","Wood","Black","Seasonal","Holiday"]));
         _loc104_.addBrick(createBrick(727,ItemLayer.BACKGROUND,bgBlocksBMD,"brickhw2016","",ItemTab.BACKGROUND,false,false,221,-1,["Leaves","Plant","Purple","Seasonal","Holiday"]));
         brickPackages.push(_loc104_);
         var _loc105_:ItemBrickPackage = new ItemBrickPackage("construction","Construction");
         _loc105_.addBrick(createBrick(1096,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,265,-1,["Plywood","Wood","Brown","Tan"]));
         _loc105_.addBrick(createBrick(1097,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,266,-1,["Gravel","Stone","Gray","Grey"]));
         _loc105_.addBrick(createBrick(1098,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,267,-1,["Cement","Stone","Beige"]));
         _loc105_.addBrick(createBrick(1099,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,268,-1,["Beam","Metal","Red","Horizontal"]));
         _loc105_.addBrick(createBrick(1130,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,291,-1,["Beam","Metal","Red","Horizontal"]));
         _loc105_.addBrick(createBrick(1128,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,289,-1,["Beam","Metal","Red","Horizontal"]));
         _loc105_.addBrick(createBrick(1129,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,290,-1,["Beam","Metal","Red","Vertical"]));
         _loc105_.addBrick(createBrick(1131,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,292,-1,["Beam","Metal","Red","Vertical"]));
         _loc105_.addBrick(createBrick(1100,ItemLayer.FORGROUND,blocksBMD,"brickconstruction","",ItemTab.BLOCK,false,true,269,-1,["Beam","Metal","Red","Vertical"]));
         _loc105_.addBrick(createBrick(1503,ItemLayer.DECORATION,decoBlocksBMD,"brickconstruction","",ItemTab.DECORATIVE,false,true,310,0,["Sawhorse","Orange","White","Caution","Sign","Stripes","Horizontal"]));
         _loc105_.addBrick(createBrick(1504,ItemLayer.DECORATION,decoBlocksBMD,"brickconstruction","",ItemTab.DECORATIVE,false,true,311,0,["Cone","Orange","White"]));
         _loc105_.addBrick(createBrick(1505,ItemLayer.DECORATION,decoBlocksBMD,"brickconstruction","",ItemTab.DECORATIVE,false,true,312,0,["Sign","Orange","Caution","Warning"]));
         _loc105_.addBrick(createBrick(1532,ItemLayer.DECORATION,decoBlocksBMD,"brickconstruction","",ItemTab.DECORATIVE,false,true,333,0,["Sign","Red","Caution","Warning","Stop"]));
         _loc105_.addBrick(createBrick(1533,ItemLayer.DECORATION,decoBlocksBMD,"brickconstruction","",ItemTab.DECORATIVE,false,true,334,0,["Red","Fire","Hydrant"]));
         _loc105_.addBrick(createBrick(728,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,222,-1,["Plywood","Wood","Brown","Tan"]));
         _loc105_.addBrick(createBrick(729,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,223,-1,["Gravel","Stone","Gray","Grey"]));
         _loc105_.addBrick(createBrick(730,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,224,-1,["Cement","Stone","Beige"]));
         _loc105_.addBrick(createBrick(731,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,225,-1,["Beam","Metal","Red","Horizontal"]));
         _loc105_.addBrick(createBrick(755,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,249,-1,["Beam","Metal","Red","Horizontal"]));
         _loc105_.addBrick(createBrick(753,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,247,-1,["Beam","Metal","Red","Horizontal"]));
         _loc105_.addBrick(createBrick(754,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,248,-1,["Beam","Metal","Red","Vertical"]));
         _loc105_.addBrick(createBrick(756,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,250,-1,["Beam","Metal","Red","Vertical"]));
         _loc105_.addBrick(createBrick(732,ItemLayer.BACKGROUND,bgBlocksBMD,"brickconstruction","",ItemTab.BACKGROUND,false,true,226,-1,["Beam","Metal","Red","Vertical"]));
         brickPackages.push(_loc105_);
         var _loc106_:ItemBrickPackage = new ItemBrickPackage("christmas 2016","Christmas 2016");
         _loc106_.addBrick(createBrick(ItemId.HALFBLOCK_CHRISTMAS_2016_PRESENT_RED,ItemLayer.DECORATION,blocksBMD,"brickxmas2016","",ItemTab.BLOCK,false,true,270,-1,["Half block","Present","Gift","Holiday","Wrapping paper","Ribbon","Bow","Red"]));
         _loc106_.addBrick(createBrick(ItemId.HALFBLOCK_CHRISTMAS_2016_PRESENT_GREEN,ItemLayer.DECORATION,blocksBMD,"brickxmas2016","",ItemTab.BLOCK,false,true,271,-1,["Half block","Present","Gift","Holiday","Wrapping paper","Ribbon","Bow","Green"]));
         _loc106_.addBrick(createBrick(ItemId.HALFBLOCK_CHRISTMAS_2016_PRESENT_WHITE,ItemLayer.DECORATION,blocksBMD,"brickxmas2016","",ItemTab.BLOCK,false,true,272,-1,["Half block","Present","Gift","Holiday","Wrapping paper","Ribbon","Bow","White"]));
         _loc106_.addBrick(createBrick(ItemId.HALFBLOCK_CHRISTMAS_2016_PRESENT_BLUE,ItemLayer.DECORATION,blocksBMD,"brickxmas2016","",ItemTab.BLOCK,false,true,273,-1,["Half block","Present","Gift","Holiday","Wrapping paper","Ribbon","Bow","Blue"]));
         _loc106_.addBrick(createBrick(ItemId.HALFBLOCK_CHRISTMAS_2016_PRESENT_YELLOW,ItemLayer.DECORATION,blocksBMD,"brickxmas2016","",ItemTab.BLOCK,false,true,274,-1,["Half block","Present","Gift","Holiday","Wrapping paper","Ribbon","Bow","Yellow"]));
         _loc106_.addBrick(createBrick(ItemId.CHRISTMAS_2016_LIGHTS_DOWN,ItemLayer.DECORATION,specialBlocksBMD,"brickxmas2016","",ItemTab.DECORATIVE,false,true,631,0,["Light","String","Wire","Bulb","Holiday","Morphable","Red","Green","Yellow","Blue","Purple"]));
         _loc106_.addBrick(createBrick(ItemId.CHRISTMAS_2016_LIGHTS_UP,ItemLayer.DECORATION,specialBlocksBMD,"brickxmas2016","",ItemTab.DECORATIVE,false,true,636,0,["Light","String","Wire","Bulb","Holiday","Morphable","Red","Green","Yellow","Blue","Purple"]));
         _loc106_.addBrick(createBrick(1508,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2016","",ItemTab.DECORATIVE,false,true,313,0,["Bell","Bow","Holiday","Yellow","Gold"]));
         _loc106_.addBrick(createBrick(1509,ItemLayer.DECORATION,decoBlocksBMD,"brickxmas2016","",ItemTab.DECORATIVE,false,true,314,0,["Holly Berries","Holiday","Nature","Plant","Red","Green"]));
         _loc106_.addBrick(createBrick(ItemId.CHRISTMAS_2016_CANDLE,ItemLayer.DECORATION,specialBlocksBMD,"brickxmas2016","",ItemTab.DECORATIVE,false,true,640,0,["Candle","Fire","Flame","Holiday","Animated","Red"]));
         brickPackages.push(_loc106_);
         var _loc107_:ItemBrickPackage = new ItemBrickPackage("tiles","Tiles",["Tile"]);
         _loc107_.addBrick(createBrick(1106,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,275,-1,["White"]));
         _loc107_.addBrick(createBrick(1107,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,276,-1,["Gray","Grey"]));
         _loc107_.addBrick(createBrick(1108,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,277,-1,["Black","Gray","Grey"]));
         _loc107_.addBrick(createBrick(1109,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,278,-1,["Red"]));
         _loc107_.addBrick(createBrick(1110,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,279,-1,["Orange"]));
         _loc107_.addBrick(createBrick(1111,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,280,-1,["Yellow"]));
         _loc107_.addBrick(createBrick(1112,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,281,-1,["Green"]));
         _loc107_.addBrick(createBrick(1113,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,282,-1,["Cyan"]));
         _loc107_.addBrick(createBrick(1114,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,283,-1,["Blue"]));
         _loc107_.addBrick(createBrick(1115,ItemLayer.FORGROUND,blocksBMD,"bricktiles","",ItemTab.BLOCK,false,true,284,-1,["Purple"]));
         _loc107_.addBrick(createBrick(733,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,227,-1,["White"]));
         _loc107_.addBrick(createBrick(734,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,228,-1,["Gray","Grey"]));
         _loc107_.addBrick(createBrick(735,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,229,-1,["Black","Gray","Grey"]));
         _loc107_.addBrick(createBrick(736,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,230,-1,["Red"]));
         _loc107_.addBrick(createBrick(737,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,231,-1,["Orange"]));
         _loc107_.addBrick(createBrick(738,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,232,-1,["Yellow"]));
         _loc107_.addBrick(createBrick(739,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,233,-1,["Green"]));
         _loc107_.addBrick(createBrick(740,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,234,-1,["Cyan"]));
         _loc107_.addBrick(createBrick(741,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,235,-1,["Blue"]));
         _loc107_.addBrick(createBrick(742,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktiles","",ItemTab.BACKGROUND,false,true,236,-1,["Purple"]));
         brickPackages.push(_loc107_);
         var _loc108_:ItemBrickPackage = new ItemBrickPackage("St. Patricks 2017","St. Patricks 2017");
         _loc108_.addBrick(createBrick(1511,ItemLayer.ABOVE,decoBlocksBMD,"brickstpatricks2017","",ItemTab.DECORATIVE,false,true,315,0,["Shamrock","Clover","Green","Plant","Nature"]));
         _loc108_.addBrick(createBrick(1512,ItemLayer.ABOVE,decoBlocksBMD,"brickstpatricks2017","",ItemTab.DECORATIVE,false,true,316,0,["Pot of Gold"]));
         _loc108_.addBrick(createBrick(1513,ItemLayer.DECORATION,decoBlocksBMD,"brickstpatricks2017","",ItemTab.DECORATIVE,false,true,317,0,["Horseshoe","Gold"]));
         _loc108_.addBrick(createBrick(1514,ItemLayer.DECORATION,decoBlocksBMD,"brickstpatricks2017","",ItemTab.DECORATIVE,false,true,318,0,["Rainbow","Left"]));
         _loc108_.addBrick(createBrick(1515,ItemLayer.DECORATION,decoBlocksBMD,"brickstpatricks2017","",ItemTab.DECORATIVE,false,true,319,0,["Rainbow","Right"]));
         brickPackages.push(_loc108_);
         var _loc109_:ItemBrickPackage = new ItemBrickPackage("Half Blocks","Half Blocks");
         _loc109_.addBrick(createBrick(1116,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,668,-1,["White"]));
         _loc109_.addBrick(createBrick(1117,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,672,-1,["Gray","Grey"]));
         _loc109_.addBrick(createBrick(1118,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,676,-1,["Black","Gray","Grey"]));
         _loc109_.addBrick(createBrick(1119,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,680,-1,["Red"]));
         _loc109_.addBrick(createBrick(1120,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,684,-1,["Orange"]));
         _loc109_.addBrick(createBrick(1121,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,688,-1,["Yellow"]));
         _loc109_.addBrick(createBrick(1122,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,692,-1,["Green"]));
         _loc109_.addBrick(createBrick(1123,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,696,-1,["Cyan"]));
         _loc109_.addBrick(createBrick(1124,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,700,-1,["Blue"]));
         _loc109_.addBrick(createBrick(1125,ItemLayer.DECORATION,specialBlocksBMD,"brickhalf","",ItemTab.BLOCK,false,true,704,-1,["Purple"]));
         brickPackages.push(_loc109_);
         var _loc110_:ItemBrickPackage = new ItemBrickPackage("Winter 2018","Winter 2018",["Winter"]);
         _loc110_.addBrick(createBrick(1136,ItemLayer.FORGROUND,blocksBMD,"brickwinter2018","",ItemTab.BLOCK,false,true,295,-1,["Ice","Brick","Cyan","Snow"]));
         _loc110_.addBrick(createBrick(1137,ItemLayer.FORGROUND,blocksBMD,"brickwinter2018","",ItemTab.BLOCK,false,true,296,-1,["Snow","Pile","Grey","Gray","White"]));
         _loc110_.addBrick(createBrick(1138,ItemLayer.FORGROUND,blocksBMD,"brickwinter2018","",ItemTab.BLOCK,false,true,297,-1,["Glacier","Snow","Ice","Cyan","Blue"]));
         _loc110_.addBrick(createBrick(1139,ItemLayer.FORGROUND,blocksBMD,"brickwinter2018","",ItemTab.BLOCK,false,true,298,-1,["Slate","Grey","Gray"]));
         _loc110_.addBrick(createBrick(ItemId.HALFBLOCK_WINTER2018_SNOW,ItemLayer.DECORATION,specialBlocksBMD,"brickwinter2018","",ItemTab.BLOCK,false,true,732,-1,["Half Block","Morphable","Snow","Pile","Grey","Gray","White"]));
         _loc110_.addBrick(createBrick(ItemId.HALFBLOCK_WINTER2018_GLACIER,ItemLayer.DECORATION,specialBlocksBMD,"brickwinter2018","",ItemTab.BLOCK,false,true,736,-1,["Half Block","Morphable","Glacier","Snow","Ice","Cyan","Blue"]));
         _loc110_.addBrick(createBrick(1543,ItemLayer.ABOVE,decoBlocksBMD,"brickwinter2018","",ItemTab.DECORATIVE,false,false,339,0,["Snow","Pile","Small","White","Grey","Gray"]));
         _loc110_.addBrick(createBrick(1544,ItemLayer.ABOVE,decoBlocksBMD,"brickwinter2018","",ItemTab.DECORATIVE,false,false,340,0,["Snow","Pile","Left","White","Grey","Gray"]));
         _loc110_.addBrick(createBrick(1545,ItemLayer.ABOVE,decoBlocksBMD,"brickwinter2018","",ItemTab.DECORATIVE,false,false,341,0,["Snow","Pile","Right","White","Grey","Gray"]));
         _loc110_.addBrick(createBrick(1546,ItemLayer.ABOVE,decoBlocksBMD,"brickwinter2018","",ItemTab.DECORATIVE,false,true,342,0,["Snowman","Hat","Carrot","Scarf","White","Grey","Gray"]));
         _loc110_.addBrick(createBrick(1547,ItemLayer.DECORATION,decoBlocksBMD,"brickwinter2018","",ItemTab.DECORATIVE,false,true,343,0,["Tree","Wood","Snow","Brown","White"]));
         _loc110_.addBrick(createBrick(1548,ItemLayer.DECORATION,decoBlocksBMD,"brickwinter2018","",ItemTab.DECORATIVE,false,false,344,0,["Snowflake","Large","Sky"]));
         _loc110_.addBrick(createBrick(1549,ItemLayer.DECORATION,decoBlocksBMD,"brickwinter2018","",ItemTab.DECORATIVE,false,false,345,0,["Snowflake","Small","Sky"]));
         _loc110_.addBrick(createBrick(757,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwinter2018","",ItemTab.BACKGROUND,false,true,251,-1,["Ice","Brick","Cyan","Snow"]));
         _loc110_.addBrick(createBrick(758,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwinter2018","",ItemTab.BACKGROUND,false,true,252,-1,["Snow","Pile","Grey","Gray","White"]));
         _loc110_.addBrick(createBrick(759,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwinter2018","",ItemTab.BACKGROUND,false,true,253,-1,["Glacier","Snow","Ice","Cyan","Blue"]));
         _loc110_.addBrick(createBrick(760,ItemLayer.BACKGROUND,bgBlocksBMD,"brickwinter2018","",ItemTab.BACKGROUND,false,true,254,-1,["Slate","Grey","Gray","Winter"]));
         brickPackages.push(_loc110_);
         var _loc111_:ItemBrickPackage = new ItemBrickPackage("Garden","Garden",["Garden"]);
         _loc111_.addBrick(createBrick(1143,ItemLayer.FORGROUND,blocksBMD,"brickgarden","",ItemTab.BLOCK,false,true,300,-1,["Rock","Environment","Brown","Soil","Dark","Dirt"]));
         _loc111_.addBrick(createBrick(1144,ItemLayer.FORGROUND,blocksBMD,"brickgarden","",ItemTab.BLOCK,false,true,301,-1,["Grass","Moss","Environment","Brown","Soil","Dark","Dirt"]));
         _loc111_.addBrick(createBrick(1145,ItemLayer.FORGROUND,blocksBMD,"brickgarden","",ItemTab.BLOCK,false,true,302,-1,["Leaves","Green","Leaf","Nature","Plant"]));
         _loc111_.addBrick(createBrick(1560,ItemLayer.ABOVE,decoBlocksBMD,"brickgarden","",ItemTab.DECORATIVE,false,false,346,0,["Grass","Green","Nature","Plant","Short"]));
         _loc111_.addBrick(createBrick(1561,ItemLayer.ABOVE,decoBlocksBMD,"brickgarden","",ItemTab.DECORATIVE,false,false,347,0,["Fence","White","Short","Post"]));
         _loc111_.addBrick(createBrick(1562,ItemLayer.DECORATION,decoBlocksBMD,"brickgarden","",ItemTab.DECORATIVE,false,false,348,0,["Fence","Brown","Lattice","Wood"]));
         _loc111_.addBrick(createBrick(ItemId.GARDEN_ONEWAY_FLOWER,ItemLayer.DECORATION,blocksBMD,"brickgarden","",ItemTab.BLOCK,false,true,304,0,["Flower","Green","Pink","Vine","Bean","Stalk"]));
         _loc111_.addBrick(createBrick(ItemId.GARDEN_ONEWAY_LEAF_L,ItemLayer.DECORATION,blocksBMD,"brickgarden","",ItemTab.BLOCK,false,true,305,0,["Leaf","Green","Bean","Stalk","Left"]));
         _loc111_.addBrick(createBrick(ItemId.GARDEN_ONEWAY_LEAF_R,ItemLayer.DECORATION,blocksBMD,"brickgarden","",ItemTab.BLOCK,false,true,306,0,["Leaf","Green","Bean","Stalk","Right"]));
         _loc111_.addBrick(createBrick(1564,ItemLayer.DECORATION,decoBlocksBMD,"brickgarden","",ItemTab.DECORATIVE,false,false,349,0,["Snail","Shell"]));
         _loc111_.addBrick(createBrick(1565,ItemLayer.DECORATION,decoBlocksBMD,"brickgarden","",ItemTab.DECORATIVE,false,false,350,0,["Butterfly"]));
         _loc111_.addBrick(createBrick(761,ItemLayer.BACKGROUND,bgBlocksBMD,"brickgarden","",ItemTab.BACKGROUND,false,true,255,-1,["Rock","Environment","Brown","Soil","Dark","Dirt","Rock"]));
         _loc111_.addBrick(createBrick(762,ItemLayer.BACKGROUND,bgBlocksBMD,"brickgarden","",ItemTab.BACKGROUND,false,true,256,-1,["Grass","Moss","Environment","Brown","Soil","Dark","Dirt"]));
         _loc111_.addBrick(createBrick(763,ItemLayer.BACKGROUND,bgBlocksBMD,"brickgarden","",ItemTab.BACKGROUND,false,true,257,-1,["Leaves","Green","Leaf","Nature","Plant"]));
         _loc111_.addBrick(createBrick(1566,ItemLayer.ABOVE,decoBlocksBMD,"brickgarden","",ItemTab.DECORATIVE,false,false,351,0,["Wood","Frame","Window","Brown","Peep","Hole"]));
         brickPackages.push(_loc111_);
         var _loc112_:ItemBrickPackage = new ItemBrickPackage("Fireworks","Fireworks");
         _loc112_.addBrick(createBrick(ItemId.FIREWORKS,ItemLayer.DECORATION,specialBlocksBMD,"brickfireworks","",ItemTab.DECORATIVE,false,false,741,0,["Fireworks","Purple","White","Red","Blue","Green","Yellow","Magenta","Gold","Morphable","Seasonal","Holiday"]));
         brickPackages.push(_loc112_);
         var _loc113_:ItemBrickPackage = new ItemBrickPackage("Toxic","Toxic",["Toxic"]);
         _loc113_.addBrick(createBrick(ItemId.TOXIC_WASTE_SURFACE,ItemLayer.ABOVE,specialBlocksBMD,"bricktoxic","",ItemTab.DECORATIVE,false,false,774,0,["Toxic","Waste","Green","Glow"]));
         _loc113_.addBrick(createBrick(ItemId.TOXIC_WASTE_BARREL,ItemLayer.DECORATION,specialBlocksBMD,"bricktoxic","",ItemTab.DECORATIVE,false,true,788,0,["Toxic","Waste","Barrel","Leaking","Green","Glow","Morphable"]));
         _loc113_.addBrick(createBrick(ItemId.SEWER_PIPE,ItemLayer.DECORATION,specialBlocksBMD,"bricktoxic","",ItemTab.DECORATIVE,false,false,789,0,["Sewer","Pipe","Drain","Water","Blue","Lava","Orange","Mud","Swamp","Bog","Brown","Toxic","Waste","Green","Morphable"]));
         _loc113_.addBrick(createBrick(ItemId.TOXIC_WASTE_BG,ItemLayer.BACKGROUND,bgBlocksBMD,"bricktoxic","",ItemTab.BACKGROUND,false,false,258,-1,["Toxic","Waste","Green"]));
         _loc113_.addBrick(createBrick(ItemId.RUSTED_LADDER,ItemLayer.DECORATION,decoBlocksBMD,"bricktoxic","",ItemTab.DECORATIVE,false,true,356,0,["Rusty","Rusted","Broken","Metal","Ladder","Vertical","Industrial"]));
         _loc113_.addBrick(createBrick(ItemId.GUARD_RAIL,ItemLayer.ABOVE,decoBlocksBMD,"bricktoxic","",ItemTab.DECORATIVE,false,false,357,0,["Rusty","Rusted","Metal","Guard","Rail"]));
         _loc113_.addBrick(createBrick(ItemId.METAL_PLATFORM,ItemLayer.DECORATION,specialBlocksBMD,"bricktoxic","",ItemTab.BLOCK,false,true,795,-1,["Rusty","Rusted","One way","One-way","Metal","Platform","Morphable"]));
         brickPackages.push(_loc113_);
         var _loc114_:ItemBrickPackage = new ItemBrickPackage("Special","Special");
         _loc114_.addBrick(createBrick(ItemId.GOLDEN_EASTER_EGG,ItemLayer.ABOVE,decoBlocksBMD,"","",ItemTab.DECORATIVE,true,false,358,-1));
         _loc114_.addBrick(createBrick(ItemId.GREEN_SPACE,ItemLayer.DECORATION,decoBlocksBMD,"","",ItemTab.DECORATIVE,false,true,363,-1));
         _loc114_.addBrick(createBrick(ItemId.GOLD_SACK,ItemLayer.DECORATION,decoBlocksBMD,"","",ItemTab.DECORATIVE,false,true,364,-1));
         brickPackages.push(_loc114_);
         var _loc115_:ItemBrickPackage = new ItemBrickPackage("Dungeon","Dungeon",["Halloween","Dungeon"]);
         _loc115_.addBrick(createBrick(ItemId.GREY_DUNGEON_BRICK,ItemLayer.FORGROUND,blocksBMD,"brickdungeon","",ItemTab.BLOCK,false,true,311,-1,["Grey","Gray","Dungeon","Brick"]));
         _loc115_.addBrick(createBrick(ItemId.GREEN_DUNGEON_BRICK,ItemLayer.FORGROUND,blocksBMD,"brickdungeon","",ItemTab.BLOCK,false,true,312,-1,["Green","Dungeon","Brick"]));
         _loc115_.addBrick(createBrick(ItemId.BLUE_DUNGEON_BRICK,ItemLayer.FORGROUND,blocksBMD,"brickdungeon","",ItemTab.BLOCK,false,true,313,-1,["Blue","Dungeon","Brick"]));
         _loc115_.addBrick(createBrick(ItemId.PURPLE_DUNGEON_BRICK,ItemLayer.FORGROUND,blocksBMD,"brickdungeon","",ItemTab.BLOCK,false,true,314,-1,["Purple","Dungeon","Brick"]));
         _loc115_.addBrick(createBrick(ItemId.GREY_DUNGEON_BG,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdungeon","",ItemTab.BACKGROUND,false,false,262,-1,["Grey","Gray","Dungeon","Brick"]));
         _loc115_.addBrick(createBrick(ItemId.GREEN_DUNGEON_BG,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdungeon","",ItemTab.BACKGROUND,false,false,263,-1,["Green","Dungeon","Brick"]));
         _loc115_.addBrick(createBrick(ItemId.BLUE_DUNGEON_BG,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdungeon","",ItemTab.BACKGROUND,false,false,264,-1,["Blue","Dungeon","Brick"]));
         _loc115_.addBrick(createBrick(ItemId.PURPLE_DUNGEON_BG,ItemLayer.BACKGROUND,bgBlocksBMD,"brickdungeon","",ItemTab.BACKGROUND,false,false,265,-1,["Purple","Dungeon","Brick"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_PILLAR_BOTTOM,ItemLayer.DECORATION,specialBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,true,799,0,["Dungeon","Brick","Pillar","Bottom","Morphable"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_PILLAR_MIDDLE,ItemLayer.DECORATION,specialBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,true,803,0,["Dungeon","Brick","Pillar","Middle","Morphable"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_PILLAR_TOP,ItemLayer.DECORATION,specialBlocksBMD,"brickdungeon","",ItemTab.BLOCK,false,true,807,0,["Dungeon","Brick","Pillar","Top","Morphable"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_ARCH_LEFT,ItemLayer.DECORATION,specialBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,true,811,0,["Dungeon","Brick","Arch","Left","Morphable"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_ARCH_RIGHT,ItemLayer.DECORATION,specialBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,true,815,0,["Dungeon","Brick","Arch","Right","Morphable"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_TORCH,ItemLayer.DECORATION,specialBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,false,830,0,["Dungeon","Torch","Fire","Morphable"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_BARS,ItemLayer.DECORATION,decoBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,false,359,0,["Dungeon","Bars","Window"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_RING,ItemLayer.DECORATION,decoBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,true,360,0,["Dungeon","Chain","Ring"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_HOOK,ItemLayer.DECORATION,decoBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,true,361,0,["Dungeon","Chain","Hook"]));
         _loc115_.addBrick(createBrick(ItemId.DUNGEON_LOCK,ItemLayer.DECORATION,decoBlocksBMD,"brickdungeon","",ItemTab.DECORATIVE,false,true,362,0,["Dungeon","Lock","Padlock"]));
         brickPackages.push(_loc115_);
         var _loc116_:int = 610;
         var _loc117_:ItemBrickPackage = new ItemBrickPackage("Shadows","Shadows",["Shadows","Dark","Glow"]);
         _loc117_.addBrick(createBrick(ItemId.SHADOW_A,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,1,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_B,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,5,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_C,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,9,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_D,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,11,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_E,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,14,0,[],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_F,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,16,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_G,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,20,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_H,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,24,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_I,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,26,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_J,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,29,0,[],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_K,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,31,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_L,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,35,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_M,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,39,0,["Morphable"],false,false,_loc116_));
         _loc117_.addBrick(createBrick(ItemId.SHADOW_N,ItemLayer.DECORATION,shadowBlocksBMD,"brickshadows","",ItemTab.DECORATIVE,false,false,43,0,["Morphable"],false,false,_loc116_));
         brickPackages.push(_loc117_);
         brickPackages.push(_loc1_);
         var _loc118_:int = 0;
         while(_loc118_ <= 1000)
         {
            effectMultiJumpsBMD.copyPixels(bmdBricks[ItemId.EFFECT_MULTIJUMP],bmdBricks[ItemId.EFFECT_MULTIJUMP].rect,new Point(16 * _loc118_,0));
            switchSwitchResetBMD.copyPixels(bmdBricks[ItemId.RESET_PURPLE],bmdBricks[ItemId.RESET_PURPLE].rect,new Point(16 * _loc118_,0));
            switchOrangeSwitchResetBMD.copyPixels(bmdBricks[ItemId.RESET_ORANGE],bmdBricks[ItemId.RESET_ORANGE].rect,new Point(16 * _loc118_,0));
            if(_loc118_ < 1000)
            {
               coinDoorsBMD.copyPixels(bmdBricks[ItemId.COINDOOR],bmdBricks[ItemId.COINDOOR].rect,new Point(16 * _loc118_,0));
               coinGatesBMD.copyPixels(bmdBricks[ItemId.COINGATE],bmdBricks[ItemId.COINGATE].rect,new Point(16 * _loc118_,0));
               blueCoinDoorsBMD.copyPixels(bmdBricks[ItemId.BLUECOINDOOR],bmdBricks[ItemId.BLUECOINDOOR].rect,new Point(16 * _loc118_,0));
               blueCoinGatesBMD.copyPixels(bmdBricks[ItemId.BLUECOINGATE],bmdBricks[ItemId.BLUECOINGATE].rect,new Point(16 * _loc118_,0));
               switchDoorsBMD.copyPixels(bmdBricks[ItemId.DOOR_PURPLE],bmdBricks[ItemId.DOOR_PURPLE].rect,new Point(16 * _loc118_,0));
               switchGatesBMD.copyPixels(bmdBricks[ItemId.GATE_PURPLE],bmdBricks[ItemId.GATE_PURPLE].rect,new Point(16 * _loc118_,0));
               switchOrangeDoorsBMD.copyPixels(bmdBricks[ItemId.DOOR_ORANGE],bmdBricks[ItemId.DOOR_ORANGE].rect,new Point(16 * _loc118_,0));
               switchOrangeGatesBMD.copyPixels(bmdBricks[ItemId.GATE_ORANGE],bmdBricks[ItemId.GATE_ORANGE].rect,new Point(16 * _loc118_,0));
               switchSwitchUpBMD.copyPixels(bmdBricks[ItemId.SWITCH_PURPLE],bmdBricks[ItemId.SWITCH_PURPLE].rect,new Point(16 * _loc118_,0));
               switchSwitchDownBMD.copyPixels(specialBlocksBMD,new Rectangle(311 * 16,0,16,16),new Point(16 * _loc118_,0));
               switchOrangeSwitchUpBMD.copyPixels(bmdBricks[ItemId.SWITCH_ORANGE],bmdBricks[ItemId.SWITCH_ORANGE].rect,new Point(16 * _loc118_,0));
               switchOrangeSwitchDownBMD.copyPixels(specialBlocksBMD,new Rectangle(423 * 16,0,16,16),new Point(16 * _loc118_,0));
               deathDoorBMD.copyPixels(bmdBricks[ItemId.DEATH_DOOR],bmdBricks[ItemId.DEATH_DOOR].rect,new Point(16 * _loc118_,0));
               deathGateBMD.copyPixels(bmdBricks[ItemId.DEATH_GATE],bmdBricks[ItemId.DEATH_GATE].rect,new Point(16 * _loc118_,0));
            }
            _loc120_ = new Matrix();
            _loc120_.translate(_loc118_ * 16,0);
            _loc121_ = createBlockText(_loc118_);
            effectMultiJumpsBMD.draw(_loc121_,_loc120_);
            switchSwitchResetBMD.draw(_loc121_,_loc120_);
            switchOrangeSwitchResetBMD.draw(_loc121_,_loc120_);
            if(_loc118_ < 1000)
            {
               coinGatesBMD.draw(_loc121_,_loc120_);
               blueCoinDoorsBMD.draw(_loc121_,_loc120_);
               blueCoinGatesBMD.draw(_loc121_,_loc120_);
               switchDoorsBMD.draw(_loc121_,_loc120_);
               switchGatesBMD.draw(_loc121_,_loc120_);
               switchSwitchUpBMD.draw(_loc121_,_loc120_);
               switchSwitchDownBMD.draw(_loc121_,_loc120_);
               switchOrangeDoorsBMD.draw(_loc121_,_loc120_);
               switchOrangeGatesBMD.draw(_loc121_,_loc120_);
               switchOrangeSwitchUpBMD.draw(_loc121_,_loc120_);
               switchOrangeSwitchDownBMD.draw(_loc121_,_loc120_);
               switchOrangeSwitchResetBMD.draw(_loc121_,_loc120_);
               deathGateBMD.draw(_loc121_,_loc120_);
               _loc121_.filters = [];
               _loc122_ = new ColorTransform(0,0,0);
               _loc121_.bitmapData.draw(_loc121_,null,_loc122_);
               _loc121_.filters = [new GlowFilter(16777215,1,1,1,2,3)];
               coinDoorsBMD.draw(_loc121_,_loc120_);
               deathDoorBMD.draw(_loc121_,_loc120_);
            }
            _loc118_++;
         }
         sprCoinDoors = new BlockSprite(coinDoorsBMD,0,0,16,16,coinDoorsBMD.width / 16,true);
         sprCoinGates = new BlockSprite(coinGatesBMD,0,0,16,16,coinGatesBMD.width / 16);
         sprBlueCoinDoors = new BlockSprite(blueCoinDoorsBMD,0,0,16,16,blueCoinDoorsBMD.width / 16,true);
         sprBlueCoinGates = new BlockSprite(blueCoinGatesBMD,0,0,16,16,blueCoinGatesBMD.width / 16);
         sprPurpleDoors = new BlockSprite(switchDoorsBMD,0,0,16,16,switchDoorsBMD.width / 16,true);
         sprPurpleGates = new BlockSprite(switchGatesBMD,0,0,16,16,switchGatesBMD.width / 16);
         sprSwitchUP = new BlockSprite(switchSwitchUpBMD,0,0,16,16,switchSwitchUpBMD.width / 16,true);
         sprSwitchDOWN = new BlockSprite(switchSwitchDownBMD,0,0,16,16,switchSwitchDownBMD.width / 16,true);
         sprSwitchRESET = new BlockSprite(switchSwitchResetBMD,0,0,16,16,switchSwitchResetBMD.width / 16,true);
         sprDeathDoor = new BlockSprite(deathDoorBMD,0,0,16,16,deathDoorBMD.width / 16,true);
         sprDeathGate = new BlockSprite(deathGateBMD,0,0,16,16,deathGateBMD.width / 16);
         sprOrangeDoors = new BlockSprite(switchOrangeDoorsBMD,0,0,16,16,switchOrangeDoorsBMD.width / 16,true);
         sprOrangeGates = new BlockSprite(switchOrangeGatesBMD,0,0,16,16,switchOrangeGatesBMD.width / 16);
         sprOrangeSwitchUP = new BlockSprite(switchOrangeSwitchUpBMD,0,0,16,16,switchOrangeSwitchUpBMD.width / 16,true);
         sprOrangeSwitchDOWN = new BlockSprite(switchOrangeSwitchDownBMD,0,0,16,16,switchOrangeSwitchDownBMD.width / 16,true);
         sprOrangeSwitchRESET = new BlockSprite(switchOrangeSwitchResetBMD,0,0,16,16,switchOrangeSwitchResetBMD.width / 16,true);
         sprMultiJumps = new BlockSprite(effectMultiJumpsBMD,0,0,16,16,effectMultiJumpsBMD.width / 16,true);
         var _loc119_:int = 0;
         while(_loc119_ < bmdBricks.length)
         {
            if(bmdBricks[_loc119_] == null)
            {
               bmdBricks[_loc119_] = bmdBricks[0];
            }
            _loc119_++;
         }
      }
      
      private static function createBlockText(param1:int) : Bitmap
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:BitmapData = new BitmapData(16,16,true,0);
         var _loc3_:int = 1;
         if(param1 == 1000)
         {
            _loc2_.copyPixels(blockNumbersBMD,new Rectangle(10 * 4,0,4,5),new Point(11,10));
         }
         else
         {
            do
            {
               _loc5_ = param1 % 10;
               _loc6_ = _loc5_ == 1 ? 2 : 4;
               _loc3_ += _loc6_;
               _loc2_.copyPixels(blockNumbersBMD,new Rectangle(_loc5_ * 4,0,_loc6_,5),new Point(16 - _loc3_,10));
               _loc3_ += 1;
               param1 /= 10;
            }
            while(param1 > 0);
         }
         var _loc4_:Bitmap = new Bitmap(_loc2_);
         _loc4_.filters = [new GlowFilter(0,1,2,2,2,3)];
         return _loc4_;
      }
      
      public static function getNpcByPayvaultId(param1:String) : ItemNpc
      {
         var _loc2_:int = 0;
         while(_loc2_ < npcs.length)
         {
            if(npcs[_loc2_].payvaultid == param1)
            {
               return npcs[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getNpcById(param1:int) : ItemNpc
      {
         var _loc2_:int = 0;
         while(_loc2_ < npcs.length)
         {
            if(npcs[_loc2_].id == param1)
            {
               return npcs[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getSmileyByPayvaultId(param1:String) : ItemSmiley
      {
         var _loc2_:int = 0;
         while(_loc2_ < smilies.length)
         {
            if(smilies[_loc2_].payvaultid == param1)
            {
               return smilies[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getSmileyById(param1:int) : ItemSmiley
      {
         var _loc2_:int = 0;
         while(_loc2_ < smilies.length)
         {
            if(smilies[_loc2_].id == param1)
            {
               return smilies[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getAuraByIdAndColor(param1:int, param2:int) : ItemAura
      {
         var _loc4_:ItemAuraShape = null;
         var _loc3_:int = 0;
         while(_loc3_ < auraShapes.length)
         {
            if(auraShapes[_loc3_].id == param1)
            {
               _loc4_ = auraShapes[_loc3_];
               return _loc4_.auras[_loc4_.generated ? param2 : 0];
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function getAuraShapeByPayVaultId(param1:String) : ItemAuraShape
      {
         var _loc2_:int = 0;
         while(_loc2_ < auraShapes.length)
         {
            if(auraShapes[_loc2_].payvaultid == param1)
            {
               return auraShapes[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getBrickPackageByName(param1:String) : ItemBrickPackage
      {
         var _loc2_:int = 0;
         while(_loc2_ < brickPackages.length)
         {
            if(brickPackages[_loc2_].name == param1)
            {
               return brickPackages[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getBrickPackageByDescription(param1:String) : ItemBrickPackage
      {
         var _loc2_:int = 0;
         while(_loc2_ < brickPackages.length)
         {
            if(brickPackages[_loc2_].description.toLowerCase() == param1.toLowerCase())
            {
               return brickPackages[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getBricksByPayVaultId(param1:String) : Vector.<ItemBrick>
      {
         var _loc3_:ItemBrickPackage = null;
         var _loc4_:ItemBrick = null;
         var _loc2_:Vector.<ItemBrick> = new Vector.<ItemBrick>();
         for each(_loc3_ in brickPackages)
         {
            for each(_loc4_ in _loc3_.bricks)
            {
               if(_loc4_.payvaultid == param1)
               {
                  _loc2_.push(_loc4_);
               }
            }
         }
         if(_loc2_.length == 0)
         {
            var clean:String = param1.toLowerCase();
            if(clean.indexOf("brick") == 0)
            {
               clean = clean.substr(5);
            }
            // // if(clean == "construction") clean = "industrial";
            if(clean == "ninja") clean = "dojo";
            
            var cleanNorm:String = clean.replace("-", "").replace(" ", "");
            if(cleanNorm.length > 3 && cleanNorm.charAt(cleanNorm.length - 1) == "s")
            {
               cleanNorm = cleanNorm.substr(0, cleanNorm.length - 1);
            }
            
            for each(_loc3_ in brickPackages)
            {
               var pkgId:String = _loc3_.id.toLowerCase().replace("-", "").replace(" ", "");
               if(pkgId.length > 3 && pkgId.charAt(pkgId.length - 1) == "s")
               {
                  pkgId = pkgId.substr(0, pkgId.length - 1);
               }
               
               if(_loc3_.id == param1 || pkgId == cleanNorm)
               {
                  return _loc3_.bricks;
               }
            }
         }
         return _loc2_;
      }
      
      public static function getOpenWorldAntiSubset() : Vector.<ItemBrick>
      {
         var _loc1_:Vector.<ItemBrick> = new Vector.<ItemBrick>();
         _loc1_.push(getBrickById(ItemId.EFFECT_CURSE));
         _loc1_.push(getBrickById(ItemId.EFFECT_FLY));
         _loc1_.push(getBrickById(ItemId.EFFECT_JUMP));
         _loc1_.push(getBrickById(ItemId.EFFECT_LOW_GRAVITY));
         _loc1_.push(getBrickById(ItemId.EFFECT_MULTIJUMP));
         _loc1_.push(getBrickById(ItemId.EFFECT_GRAVITY));
         _loc1_.push(getBrickById(ItemId.EFFECT_PROTECTION));
         _loc1_.push(getBrickById(ItemId.EFFECT_RUN));
         _loc1_.push(getBrickById(ItemId.EFFECT_ZOMBIE));
         _loc1_.push(getBrickById(ItemId.EFFECT_POISON));
         _loc1_.push(getBrickById(ItemId.EFFECT_RESET));
         _loc1_.push(getBrickById(ItemId.ZOMBIE_DOOR));
         _loc1_.push(getBrickById(ItemId.ZOMBIE_GATE));
         _loc1_.push(getBrickById(ItemId.TEXT_SIGN));
         _loc1_.push(getBrickById(ItemId.PORTAL));
         _loc1_.push(getBrickById(ItemId.PORTAL_INVISIBLE));
         _loc1_.push(getBrickById(ItemId.WORLD_PORTAL));
         _loc1_.push(getBrickById(ItemId.WORLD_PORTAL_SPAWN));
         _loc1_.push(getBrickById(255));
         _loc1_.push(getBrickById(ItemId.CHECKPOINT));
         _loc1_.push(getBrickById(121));
         _loc1_.push(getBrickById(ItemId.RESET_POINT));
         _loc1_.push(getBrickById(ItemId.HOLOGRAM));
         _loc1_.push(getBrickById(ItemId.DIAMOND));
         _loc1_.push(getBrickById(ItemId.EFFECT_TEAM));
         _loc1_.push(getBrickById(ItemId.TEAM_DOOR));
         _loc1_.push(getBrickById(ItemId.TEAM_GATE));
         _loc1_.push(getBrickById(ItemId.TIMEDOOR));
         _loc1_.push(getBrickById(ItemId.TIMEGATE));
         _loc1_.push(getBrickById(ItemId.DOOR_GOLD));
         _loc1_.push(getBrickById(ItemId.GATE_GOLD));
         _loc1_.push(getBrickById(ItemId.SLOW_DOT_INVISIBLE));
         _loc1_.push(getBrickById(411),getBrickById(412),getBrickById(413),getBrickById(414));
         _loc1_.push(getBrickById(ItemId.COINDOOR),getBrickById(ItemId.COINGATE));
         _loc1_.push(getBrickById(ItemId.BLUECOINDOOR),getBrickById(ItemId.BLUECOINGATE));
         _loc1_.push(getBrickById(ItemId.SWITCH_ORANGE),getBrickById(ItemId.SWITCH_PURPLE));
         _loc1_.push(getBrickById(ItemId.RESET_ORANGE),getBrickById(ItemId.RESET_PURPLE));
         _loc1_.push(getBrickById(ItemId.GATE_ORANGE),getBrickById(ItemId.GATE_PURPLE));
         _loc1_.push(getBrickById(ItemId.DOOR_ORANGE),getBrickById(ItemId.DOOR_PURPLE));
         _loc1_.push(getBrickById(1000));
         _loc1_.push(getBrickById(ItemId.FIRE),getBrickById(ItemId.SPIKE),getBrickById(ItemId.LAVA),getBrickById(ItemId.TOXIC_WASTE),getBrickById(ItemId.SPIKE_CENTER));
         _loc1_.push(getBrickById(ItemId.SPIKE_SILVER),getBrickById(ItemId.SPIKE_SILVER_CENTER),getBrickById(ItemId.SPIKE_BLACK),getBrickById(ItemId.SPIKE_BLACK_CENTER),getBrickById(ItemId.SPIKE_RED),getBrickById(ItemId.SPIKE_RED_CENTER),getBrickById(ItemId.SPIKE_GOLD),getBrickById(ItemId.SPIKE_GOLD_CENTER),getBrickById(ItemId.SPIKE_GREEN),getBrickById(ItemId.SPIKE_GREEN_CENTER),getBrickById(ItemId.SPIKE_BLUE),getBrickById(ItemId.SPIKE_BLUE_CENTER));
         _loc1_.push(getBrickById(ItemId.DEATH_DOOR),getBrickById(ItemId.DEATH_GATE));
         _loc1_.push(getBrickById(136),getBrickById(50),getBrickById(243));
         _loc1_.push(getBrickById(ItemId.CAKE));
         _loc1_.push(getBrickById(ItemId.GOD_BLOCK));
         _loc1_.push(getBrickById(ItemId.MAP_BLOCK));
         _loc1_.push(getBrickById(ItemId.SILVERCROWNDOOR));
         _loc1_.push(getBrickById(ItemId.SILVERCROWNGATE));
         return _loc1_;
      }
      
      public static function getBrickById(param1:int) : ItemBrick
      {
         var _loc3_:ItemBrickPackage = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < brickPackages.length)
         {
            _loc3_ = brickPackages[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.bricks.length)
            {
               if(_loc3_.bricks[_loc4_].id == param1)
               {
                  return _loc3_.bricks[_loc4_];
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getBrickByPayvaultId(param1:String) : ItemBrick
      {
         var _loc3_:ItemBrickPackage = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < brickPackages.length)
         {
            _loc3_ = brickPackages[_loc2_];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.bricks.length)
            {
               if(_loc3_.bricks[_loc4_].payvaultid == param1)
               {
                  return _loc3_.bricks[_loc4_];
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getEffectBrickById(param1:int) : ItemBrick
      {
         switch(param1)
         {
            case Config.effectJump:
               return getBrickById(ItemId.EFFECT_JUMP);
            case Config.effectFly:
               return getBrickById(ItemId.EFFECT_FLY);
            case Config.effectRun:
               return getBrickById(ItemId.EFFECT_RUN);
            case Config.effectProtection:
               return getBrickById(ItemId.EFFECT_PROTECTION);
            case Config.effectCurse:
               return getBrickById(ItemId.EFFECT_CURSE);
            case Config.effectZombie:
               return getBrickById(ItemId.EFFECT_ZOMBIE);
            case Config.effectLowGravity:
               return getBrickById(ItemId.EFFECT_LOW_GRAVITY);
            case Config.effectFire:
               return getBrickById(ItemId.LAVA);
            case Config.effectMultijump:
               return getBrickById(ItemId.EFFECT_MULTIJUMP);
            case Config.effectGravity:
               return getBrickById(ItemId.EFFECT_GRAVITY);
            case Config.effectPoison:
               return getBrickById(ItemId.EFFECT_POISON);
            default:
               return null;
         }
      }
      
      public static function getMinimapColor(param1:int) : Number
      {
         var _loc2_:ItemBrick = bricks[param1];
         return _loc2_ == null ? bricks[0].minimapColor : _loc2_.minimapColor;
      }
      
      public static function getBlockDescription(param1:int) : String
      {
         return bricks[param1].description;
      }
      
      public static function getBlockTags(param1:int) : Array
      {
         return bricks[param1].tags;
      }
      
      private static function createBrick(param1:int, param2:int, param3:BitmapData, param4:String, param5:String, param6:int, param7:Boolean, param8:Boolean, param9:int, param10:Number, param11:Array = null, param12:Boolean = false, param13:Boolean = false, param14:int = 0) : ItemBrick
      {
         ++totalBricks;
         var _loc15_:BitmapData = new BitmapData(16,16,true,0);
         _loc15_.copyPixels(param3,new Rectangle(16 * param9,0,16,16),new Point(0,0));
         var _loc16_:ItemBrick = new ItemBrick(param1,param2,_loc15_,param4,param5,param6,param7,param12,param13,param8,param10,param11,param14);
         if(bricks[param1] != null)
         {
            throw new Error("Error creating new brick \'" + param4 + "\'. Brick id \'" + param1 + "\' is already in use");
         }
         bmdBricks[param1] = _loc16_.bmd;
         bricks[param1] = _loc16_;
         return _loc16_;
      }
      
      private static function addSmiley(param1:int, param2:String, param3:String, param4:BitmapData, param5:String, param6:uint = 4294967295) : void
      {
         ++totalSmilies;
         var _loc7_:BitmapData = new BitmapData(26,26,true,0);
         _loc7_.copyPixels(param4,new Rectangle(26 * param1,0,26,26),new Point(0,0));
         var _loc8_:BitmapData = new BitmapData(26,26,true,0);
         _loc8_.copyPixels(param4,new Rectangle(26 * param1,26,26,26),new Point(0,0));
         smilies.push(new ItemSmiley(param1,param2,param3,_loc7_,param5,param6,_loc8_));
      }
      
      private static function addAuraColor(param1:int, param2:String, param3:String) : void
      {
         ++totalAuraColors;
         auraColors.push(new ItemAuraColor(param1,param2,param3));
      }
      
      private static function addAuraShape(param1:int, param2:String, param3:BitmapData, param4:String, param5:int = 1, param6:Number = 0.2, param7:Boolean = false, param8:Boolean = true) : void
      {
         var _loc9_:BitmapData = null;
         ++totalAuraShapes;
         if(param8)
         {
            _loc9_ = new BitmapData(64 * param5,128,true,0);
            _loc9_.copyPixels(param3,new Rectangle(64 * auraImagesindex,0,64 * param5,128),new Point());
            auraImagesindex += param5;
         }
         else
         {
            _loc9_ = param3;
         }
         auraShapes.push(new ItemAuraShape(param1,param2,_loc9_,param4,param5,param6,param7,param8));
      }
      
      private static function addNpc(param1:int, param2:String, param3:ItemBrickPackage, param4:int = 2, param5:Array = null, param6:Number = 6.5, param7:Number = 0) : void
      {
         var _loc8_:BitmapData = new BitmapData(16,16,true,0);
         _loc8_.copyPixels(npcBlocksBMD,new Rectangle(16 * npcImagesIndex,16,16,16),new Point());
         param3.addBrick(createBrick(param1,ItemLayer.ABOVE,_loc8_,param2,"",ItemTab.ACTION,true,false,0,0,param5));
         var _loc9_:BitmapData = new BitmapData(16 * param4,32,true,0);
         _loc9_.copyPixels(npcBlocksBMD,new Rectangle(16 * npcImagesIndex,0,16 * param4,32),new Point());
         var _loc10_:ItemNpc = new ItemNpc(param1,param2,_loc9_,param4,param6,param7);
         npcs.push(_loc10_);
         ++totalNpcs;
         npcImagesIndex += param4;
      }
      
      public static function toSeconds(param1:int, param2:int, param3:int, param4:int = 0) : int
      {
         param2 += param1 * 24;
         param3 += param2 * 60;
         return int(param4 + param3 * 60);
      }
      
      public static function getBackgroundRotateableSprite(param1:int) : BlockSprite
      {
         var _loc2_:int = param1;
         switch(0)
         {
         }
         return null;
      }
      
      public static function GetBlockBounds(param1:int, param2:int = -1) : Rectangle
      {
         if(param2 != -1)
         {
            if(param2 == 0)
            {
               return new Rectangle(8,0,8,16);
            }
            if(param2 == 1)
            {
               return new Rectangle(0,8,16,8);
            }
            if(param2 == 2)
            {
               return new Rectangle(0,0,8,16);
            }
            if(param2 == 3)
            {
               return new Rectangle(0,0,16,8);
            }
            return new Rectangle(0,0,16,16);
         }
         if(bounds[param1] != null)
         {
            return bounds[param1] as Rectangle;
         }
         return new Rectangle(0,0,16,16);
      }
      
      private static function AddBlockBounds(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         if(bounds[param1] != null)
         {
            return;
         }
         bounds[param1] = new Rectangle(param2,param3,param4,param5);
      }
      
      public static function getRotateableSprite(param1:int) : BlockSprite
      {
         switch(param1)
         {
            case ItemId.GLOWYLINE_BLUE_SLOPE:
               return sprGlowylineBlueSlope;
            case ItemId.GLOWY_LINE_BLUE_STRAIGHT:
               return sprGlowylineBlueStraight;
            case ItemId.GLOWY_LINE_GREEN_SLOPE:
               return sprGlowylineGreenSlope;
            case ItemId.GLOWY_LINE_GREEN_STRAIGHT:
               return sprGlowylineGreenStraight;
            case ItemId.GLOWY_LINE_YELLOW_SLOPE:
               return sprGlowylineYellowSlope;
            case ItemId.GLOWY_LINE_YELLOW_STRAIGHT:
               return sprGlowylineYellowStraight;
            case ItemId.GLOWY_LINE_RED_SLOPE:
               return sprGlowylineRedSlope;
            case ItemId.GLOWY_LINE_RED_STRAIGHT:
               return sprGlowylineRedStraight;
            case ItemId.ONEWAY_CYAN:
               return sprOnewayCyan;
            case ItemId.ONEWAY_YELLOW:
               return sprOnewayYellow;
            case ItemId.ONEWAY_ORANGE:
               return sprOnewayOrange;
            case ItemId.ONEWAY_PINK:
               return sprOnewayPink;
            case ItemId.ONEWAY_GRAY:
               return sprOnewayGray;
            case ItemId.ONEWAY_BLUE:
               return sprOnewayBlue;
            case ItemId.ONEWAY_RED:
               return sprOnewayRed;
            case ItemId.ONEWAY_GREEN:
               return sprOnewayGreen;
            case ItemId.ONEWAY_BLACK:
               return sprOnewayBlack;
            case ItemId.ONEWAY_WHITE:
               return sprOnewayWhite;
            case ItemId.MEDIEVAL_AXE:
               return sprMedievalAxe;
            case ItemId.MEDIEVAL_BANNER:
               return sprMedievalBanner;
            case ItemId.MEDIEVAL_COATOFARMS:
               return sprMedievalCoatOfArms;
            case ItemId.MEDIEVAL_SHIELD:
               return sprMedievalShield;
            case ItemId.MEDIEVAL_SWORD:
               return sprMedievalSword;
            case ItemId.MEDIEVAL_TIMBER:
               return sprMedievalTimber;
            case ItemId.TOOTH_BIG:
               return sprToothBig;
            case ItemId.TOOTH_SMALL:
               return sprToothSmall;
            case ItemId.TOOTH_TRIPLE:
               return sprToothTriple;
            case ItemId.DOJO_LIGHT_LEFT:
               return sprDojoLightLeft;
            case ItemId.DOJO_LIGHT_RIGHT:
               return sprDojoLightRight;
            case ItemId.DOJO_DARK_LEFT:
               return sprDojoDarkLeft;
            case ItemId.DOJO_DARK_RIGHT:
               return sprDojoDarkRight;
            case ItemId.DOMESTIC_LIGHT_BULB:
               return sprDomesticLightBulb;
            case ItemId.DOMESTIC_TAP:
               return sprDomesticTap;
            case ItemId.DOMESTIC_PAINTING:
               return sprDomesticPainting;
            case ItemId.DOMESTIC_VASE:
               return sprDomesticVase;
            case ItemId.DOMESTIC_TV:
               return sprDomesticTV;
            case ItemId.DOMESTIC_WINDOW:
               return sprDomesticWindow;
            case ItemId.HALFBLOCK_DOMESTIC_BROWN:
               return sprHalfBlockDomesticBrown;
            case ItemId.HALFBLOCK_DOMESTIC_WHITE:
               return sprHalfBlockDomesticWhite;
            case ItemId.HALFBLOCK_DOMESTIC_YELLOW:
               return sprHalfBlockDomesticYellow;
            case ItemId.HALLOWEEN_2015_WINDOW_RECT:
               return sprHalloween2015WindowRect;
            case ItemId.HALLOWEEN_2015_WINDOW_CIRCLE:
               return sprHalloween2015WindowCircle;
            case ItemId.HALLOWEEN_2015_LAMP:
               return sprHalloween2015Lamp;
            case ItemId.NEW_YEAR_2015_BALLOON:
               return sprNewYear2015Balloon;
            case ItemId.NEW_YEAR_2015_STREAMER:
               return sprNewYear2015Streamer;
            case ItemId.HALFBLOCK_FAIRYTALE_ORANGE:
               return sprHalfBlockFairytaleRed;
            case ItemId.HALFBLOCK_FAIRYTALE_GREEN:
               return sprHalfBlockFairytaleGreen;
            case ItemId.HALFBLOCK_FAIRYTALE_BLUE:
               return sprHalfBlockFairytaleBlue;
            case ItemId.HALFBLOCK_FAIRYTALE_PINK:
               return sprHalfBlockFairytalePink;
            case ItemId.FAIRYTALE_FLOWERS:
               return sprFairytaleFlowers;
            case ItemId.SPRING_TULIP:
               return sprSpringTulip;
            case ItemId.SPRING_DAISY:
               return sprSpringDaisy;
            case ItemId.SPRING_DAFFODIL:
               return sprSpringDaffodil;
            case ItemId.SUMMER_FLAG:
               return sprSummerFlag;
            case ItemId.SUMMER_AWNING:
               return sprSummerAwning;
            case ItemId.SUMMER_ICECREAM:
               return sprSummerIceCream;
            case ItemId.CAVE_TORCH:
               return sprCaveTorch;
            case ItemId.CAVE_CRYSTAL:
               return sprCaveCrystal;
            case ItemId.RESTAURANT_CUP:
               return sprRestaurantCup;
            case ItemId.RESTAURANT_PLATE:
               return sprRestaurantPlate;
            case ItemId.RESTAURANT_BOWL:
               return sprRestaurantBowl;
            case ItemId.HALLOWEEN_2016_ROTATABLE:
               return sprHalloweenRot;
            case ItemId.HALLOWEEN_2016_EYES:
               return sprHalloweenEyes;
            case ItemId.HALLOWEEN_2016_PUMPKIN:
               return sprHalloweenPumpkin;
            case ItemId.CHRISTMAS_2016_LIGHTS_DOWN:
               return sprChristmas2016LightsDown;
            case ItemId.CHRISTMAS_2016_LIGHTS_UP:
               return sprChristmas2016LightsUp;
            case ItemId.HALFBLOCK_WHITE:
               return sprHalfBlockWhite;
            case ItemId.HALFBLOCK_GRAY:
               return sprHalfBlockGray;
            case ItemId.HALFBLOCK_BLACK:
               return sprHalfBlockBlack;
            case ItemId.HALFBLOCK_RED:
               return sprHalfBlockRed;
            case ItemId.HALFBLOCK_ORANGE:
               return sprHalfBlockOrange;
            case ItemId.HALFBLOCK_YELLOW:
               return sprHalfBlockYellow;
            case ItemId.HALFBLOCK_GREEN:
               return sprHalfBlockGreen;
            case ItemId.HALFBLOCK_CYAN:
               return sprHalfBlockCyan;
            case ItemId.HALFBLOCK_BLUE:
               return sprHalfBlockBlue;
            case ItemId.HALFBLOCK_PURPLE:
               return sprHalfBlockPurple;
            case ItemId.INDUSTRIAL_PIPE_THIN:
               return sprIndustrialPipeThin;
            case ItemId.INDUSTRIAL_PIPE_THICK:
               return sprIndustrialPipeThick;
            case ItemId.INDUSTRIAL_TABLE:
               return sprIndustrialTable;
            case ItemId.DOMESTIC_PIPE_STRAIGHT:
               return sprDomesticPipeStraight;
            case ItemId.DOMESTIC_PIPE_T:
               return sprDomesticPipeT;
            case ItemId.DOMESTIC_FRAME_BORDER:
               return sprDomesticFrameBorder;
            case ItemId.HALFBLOCK_WINTER2018_SNOW:
               return sprHalfBlockWinter2018Snow;
            case ItemId.HALFBLOCK_WINTER2018_GLACIER:
               return sprHalfBlockWinter2018Glacier;
            case ItemId.FIREWORKS:
               return sprFireworks;
            case ItemId.TOXIC_WASTE_BARREL:
               return sprToxicWasteBarrel;
            case ItemId.SEWER_PIPE:
               return sprSewerPipe;
            case ItemId.METAL_PLATFORM:
               return sprMetalPlatform;
            case ItemId.DUNGEON_PILLAR_BOTTOM:
               return sprDungeonPillarBottom;
            case ItemId.DUNGEON_PILLAR_MIDDLE:
               return sprDungeonPillarMiddle;
            case ItemId.DUNGEON_PILLAR_TOP:
               return sprDungeonPillarTop;
            case ItemId.DUNGEON_ARCH_LEFT:
               return sprDungeonArchLeft;
            case ItemId.DUNGEON_ARCH_RIGHT:
               return sprDungeonArchRight;
            case ItemId.SHADOW_A:
               return sprShadowA;
            case ItemId.SHADOW_B:
               return sprShadowB;
            case ItemId.SHADOW_C:
               return sprShadowC;
            case ItemId.SHADOW_D:
               return sprShadowD;
            case ItemId.SHADOW_F:
               return sprShadowF;
            case ItemId.SHADOW_G:
               return sprShadowG;
            case ItemId.SHADOW_H:
               return sprShadowH;
            case ItemId.SHADOW_I:
               return sprShadowI;
            case ItemId.SHADOW_K:
               return sprShadowK;
            case ItemId.SHADOW_L:
               return sprShadowL;
            case ItemId.SHADOW_M:
               return sprShadowM;
            case ItemId.SHADOW_N:
               return sprShadowN;
            case ItemId.SPIKE:
               return sprSpikes;
            case ItemId.SPIKE_SILVER:
               return sprSpikesSilver;
            case ItemId.SPIKE_BLACK:
               return sprSpikesBlack;
            case ItemId.SPIKE_RED:
               return sprSpikesRed;
            case ItemId.SPIKE_GOLD:
               return sprSpikesGold;
            case ItemId.SPIKE_GREEN:
               return sprSpikesGreen;
            case ItemId.SPIKE_BLUE:
               return sprSpikesBlue;
            default:
               return null;
         }
      }

      public static function getBricksByPayVaultId(param1:String) : Vector.<ItemBrick>
      {
         var _loc3_:ItemBrickPackage = null;
         var _loc4_:ItemBrick = null;
         var _loc2_:Vector.<ItemBrick> = new Vector.<ItemBrick>();
         for each(_loc3_ in brickPackages)
         {
            for each(_loc4_ in _loc3_.bricks)
            {
               if(_loc4_.payvaultid == param1 && param1 != "")
               {
                  _loc2_.push(_loc4_);
               }
            }
         }
         if(_loc2_.length == 0)
         {
            var clean:String = param1.toLowerCase();
            if(clean.indexOf("brick") == 0) clean = clean.substr(5);
            // // if(clean == "construction") clean = "industrial";
            if(clean == "ninja") clean = "dojo";
            if(clean == "pipe") clean = "pipes";
            if(clean == "scifi") clean = "sci-fi";
            if(clean == "xmas2011") clean = "christmas 2011";
            
            for each(_loc3_ in brickPackages)
            {
               var pId:String = _loc3_.id.toLowerCase();
               if(pId == clean || _loc3_.id == param1)
               {
                  return _loc3_.bricks;
               }
            }
         }
         return _loc2_;
      }
   }
}
