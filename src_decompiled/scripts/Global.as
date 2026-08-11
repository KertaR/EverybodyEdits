package
{
   import data.SimplePlayerObject;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import playerio.Client;
   import playerio.Message;
   import ui.DebugStats;
   
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Global
   {
      
      public static var logField:TextField;
      
      public static function log(param1:String) : void
      {
         trace("[LOG] " + param1);
         if(logField != null)
         {
            var _loc2_:int = logField.text.length;
            logField.appendText(param1 + "\n");
            var _loc3_:TextFormat = new TextFormat();
            _loc3_.color = 0x00FF00;
            _loc3_.size = 12;
            logField.setTextFormat(_loc3_,_loc2_,logField.text.length);
            logField.scrollV = logField.maxScrollV;
         }
      }
      
      public static var playerInstance:Player;
      
      public static var client:Client;
      
      public static var stage:Stage;
      
      public static var cookie:SharedObject;
      
      public static var sharedCookie:SharedObject;
      
      public static var playerObject:SimplePlayerObject;
      
      public static var base:EverybodyEdits;
      
      public static var worldData:Message;
      
      public static var loadingscreen_image:BitmapData;
      
      public static var currentCrew:String;
      
      public static var currentCrewName:String;
      
      public static var bgColor:uint;
      
      public static var backgroundEnabled:Boolean;
      
      public static var debug_stats:DebugStats;
      
      public static var player_is_guest:Boolean = false;
      
      public static var player_is_beta_member:Boolean = false;
      
      public static var playing_on_playedonline:Boolean = false;
      
      public static var playing_on_kongregate:Boolean = false;
      
      public static var playing_on_com:Boolean = false;
      
      public static var default_label_size:int = 12;
      
      public static var default_label_text:String = ":)";
      
      public static var default_label_hex:String = "#FFFFFF";
      
      public static var text_sign_text:String = "Enter text here.";
      
      public static var fullWidth:int = 640;
      
      public static var fullHeight:int = 500;
      
      public static var noSave:Boolean = false;
      
      public static var noSaveShown:Boolean = false;
      
      public static var normalStart:Boolean = true;
      
      public static var chatIsVisible:Boolean = false;
      
      public static var affiliate:String = "";
      
      public static var pianoOffset:int = 0;
      
      public static var drumOffset:int = 0;
      
      public static var guitarOffset:int = 0;
      
      public static var hasOwner:Boolean = false;
      
      public static var currentLevelname:String = "";
      
      public static var worldOwner:String = "";
      
      public static var ownerID:String = "";
      
      public static var currentLevelCrew:String = "";
      
      public static var currentLevelCrewName:String = "";
      
      public static var currentLevelStatus:int = 0;
      
      public static var currentLevelVisibility:int = 0;
      
      public static var hasSubscribedToCrew:Boolean = false;
      
      public static var canchat:Boolean = false;
      
      public static var showUI:Boolean = true;
      
      public static var showChatAndNames:Boolean = true;
      
      public static var getPlacer:Boolean = false;
      
      public static var myId:* = 0;
      
      public static var roomid:String = "";
      
      public static var is_fullscreen_allowed:Boolean = true;
      
      public static var EMBED_WIDTH:int = 0;
      
      public static var brickoverlayactive:Boolean = false;
      
      public static var isFirstLogin:Boolean = false;
      
      public static var mutedPlayersIds:Array = [];
      
      public static var cachedImages:Vector.<ImageBlock> = new Vector.<ImageBlock>();
      
      public static var drawableContentTest:Sprite = new Sprite();
      
      public static var reportTextTest:String = "";
      
      public static var inGameSettings:Boolean = false;
      
      public function Global()
      {
         super();
      }
      
      public static function get width() : int
      {
         if(!stage)
         {
            return EMBED_WIDTH;
         }
         if(stage.displayState == StageDisplayState.NORMAL)
         {
            return Math.min(Math.max(Config.minwidth,stage.stageWidth),Config.maxwidth);
         }
         return EMBED_WIDTH;
      }
      
      public static function get height() : int
      {
         if(!stage)
         {
            return fullHeight;
         }
         if(stage.displayState == StageDisplayState.NORMAL)
         {
            return stage.stageHeight;
         }
         return stage.stageHeight;
      }
      
      public static function setPath(param1:String, param2:String = "") : void
      {
         if(!ExternalInterface.available)
         {
            return;
         }
         try
         {
            ExternalInterface.call("setPath",param1,param2 || "/games/" + roomid.split(" ").join("-"));
         }
         catch(e:Error)
         {
         }
      }
      
      public static function toOrdinal(param1:int) : String
      {
         if(param1 % 100 < 10 || param1 % 100 >= 20)
         {
            switch(param1 % 10)
            {
               case 1:
                  return param1 + "st";
               case 2:
                  return param1 + "nd";
               case 3:
                  return param1 + "rd";
            }
         }
         return param1 + "th";
      }
      
      public static function monthName(param1:int) : String
      {
         return ["January","February","March","April","May","June","July","August","September","October","November","December"][param1];
      }
      
      public static function toPrettyDate(param1:Date) : String
      {
         return toOrdinal(param1.date) + " of " + monthName(param1.month) + " " + param1.fullYear;
      }
      
      public static function cleanCookie() : void
      {
         Global.cookie.data.access_token = "";
         Global.cookie.data.username = "";
         Global.cookie.data.password = "";
         Global.cookie.data.remember = false;
         Global.cookie.data.currentCrew = "";
         Global.cookie.data.currentCrewName = "";
         Global.cookie.data.hotbarSmileys = [];
         Global.cookie.data.history = [];
         Global.cookie.data.keyboardKeys = [];
         if(!Global.noSave)
         {
            Global.cookie.flush();
         }
      }
   }
}

