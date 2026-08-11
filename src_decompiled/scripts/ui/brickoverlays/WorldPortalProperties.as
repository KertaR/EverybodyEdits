package ui.brickoverlays
{
   import blitter.Bl;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import playerio.DatabaseObject;
   import ui2.ui2minusbtn;
   import ui2.ui2plusbtn;
   
   public class WorldPortalProperties extends PropertiesBackground
   {
      
      private var worldname_timer:Timer;
      
      private var tfwname:TextField;
      
      private var inptfwtarget:TextField;
      
      private var myWorldOffset:int = 0;
      
      public function WorldPortalProperties()
      {
         var tff:TextFormat;
         var inptffwid:TextFormat;
         var addwid:ui2plusbtn;
         var subwid:ui2minusbtn;
         var inptffwtarget:TextFormat;
         var addwtarget:ui2plusbtn;
         var subwtarget:ui2minusbtn;
         var container:Sprite = null;
         var tfwid:TextField = null;
         var inptfwid:TextField = null;
         var tfwn:TextField = null;
         var tfwtarget:TextField = null;
         super();
         this.worldname_timer = new Timer(1000,1);
         this.worldname_timer.addEventListener(TimerEvent.TIMER,this.loadWorldName,false,0,true);
         setSize(320,100);
         container = new Sprite();
         addChild(container);
         tff = new TextFormat("system",12,16777215);
         tfwid = new TextField();
         tfwid.embedFonts = true;
         tfwid.selectable = false;
         tfwid.sharpness = 100;
         tfwid.multiline = false;
         tfwid.wordWrap = false;
         tfwid.defaultTextFormat = tff;
         tfwid.width = 150;
         tfwid.x = -150;
         tfwid.y = -39 - 50;
         tfwid.text = "Target World ID:";
         tfwid.height = tfwid.textHeight;
         container.addChild(tfwid);
         inptfwid = new TextField();
         inptfwid.type = TextFieldType.INPUT;
         inptfwid.x = 13;
         inptfwid.y = -39 - 50;
         inptfwid.width = 120;
         inptfwid.height = tfwid.height + 3;
         inptfwid.selectable = true;
         inptfwid.sharpness = 100;
         inptfwid.multiline = false;
         inptfwid.borderColor = 16777215;
         inptfwid.backgroundColor = 11184810;
         inptfwid.background = true;
         inptfwid.border = true;
         inptffwid = new TextFormat("Arial",12,0);
         inptffwid.blockIndent = 5;
         inptfwid.defaultTextFormat = inptffwid;
         inptfwid.text = Bl.data.world_portal_id;
         container.addChild(inptfwid);
         inptfwid.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         inptfwid.addEventListener(KeyboardEvent.KEY_UP,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         addwid = new ui2plusbtn();
         addwid.y = inptfwid.y + 9;
         addwid.x = inptfwid.x + inptfwid.width + 12;
         container.addChild(addwid);
         addwid.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            ++myWorldOffset;
            myWorldOffset %= Global.playerObject.roomids.length;
            Bl.data.world_portal_id = inptfwid.text = Global.playerObject.roomids[myWorldOffset];
            var _loc1_:String = Global.playerObject.roomnames[Global.playerObject.roomkeys[myWorldOffset]];
            Bl.data.world_portal_name = tfwname.text = _loc1_ != "" ? _loc1_ : "Untitled World";
         });
         subwid = new ui2minusbtn();
         subwid.y = inptfwid.y + 9;
         subwid.x = 0;
         container.addChild(subwid);
         subwid.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            --myWorldOffset;
            if(myWorldOffset < 0)
            {
               myWorldOffset = Global.playerObject.roomids.length - 1;
            }
            Bl.data.world_portal_id = inptfwid.text = Global.playerObject.roomids[myWorldOffset];
            var _loc1_:String = Global.playerObject.roomnames[Global.playerObject.roomkeys[myWorldOffset]];
            Bl.data.world_portal_name = tfwname.text = _loc1_ != "" ? _loc1_ : "Untitled World";
         });
         inptfwid.addEventListener(Event.CHANGE,function():void
         {
            tfwn.text = "World Name: ";
            Bl.data.world_portal_id = inptfwid.text;
            loadWorldNameWithDelay();
         });
         tfwn = new TextField();
         tfwn.embedFonts = true;
         tfwn.selectable = false;
         tfwn.sharpness = 100;
         tfwn.multiline = false;
         tfwn.wordWrap = false;
         tff.align = TextFormatAlign.LEFT;
         tfwn.defaultTextFormat = tff;
         tfwn.text = "World Name:";
         tfwn.width = 150;
         tfwn.height = tfwn.textHeight;
         tfwn.x = -150;
         tfwn.y = -39 - 25;
         container.addChild(tfwn);
         this.tfwname = new TextField();
         this.tfwname.embedFonts = true;
         this.tfwname.selectable = false;
         this.tfwname.sharpness = 100;
         this.tfwname.multiline = false;
         this.tfwname.wordWrap = false;
         tff.align = TextFormatAlign.RIGHT;
         this.tfwname.defaultTextFormat = tff;
         this.tfwname.width = 200;
         this.tfwname.height = 30;
         this.tfwname.x = -50;
         this.tfwname.y = -39 - 25;
         container.addChild(this.tfwname);
         if(Bl.data.world_portal_name != "")
         {
            this.updateWorldNameTf();
         }
         else
         {
            this.loadWorldName();
         }
         tfwtarget = new TextField();
         tfwtarget.embedFonts = true;
         tfwtarget.selectable = false;
         tfwtarget.sharpness = 100;
         tfwtarget.multiline = false;
         tfwtarget.wordWrap = false;
         tff.align = TextFormatAlign.LEFT;
         tfwtarget.defaultTextFormat = tff;
         tfwtarget.width = 200;
         tfwtarget.x = -150;
         tfwtarget.y = -39;
         tfwtarget.text = "Target Spawn Point ID:";
         tfwtarget.height = tfwtarget.textHeight;
         container.addChild(tfwtarget);
         this.inptfwtarget = new TextField();
         this.inptfwtarget.type = TextFieldType.INPUT;
         this.inptfwtarget.x = 83;
         this.inptfwtarget.y = -39;
         this.inptfwtarget.width = 50;
         this.inptfwtarget.height = tfwtarget.height + 3;
         this.inptfwtarget.selectable = true;
         this.inptfwtarget.sharpness = 100;
         this.inptfwtarget.multiline = false;
         this.inptfwtarget.borderColor = 16777215;
         this.inptfwtarget.backgroundColor = 11184810;
         this.inptfwtarget.background = true;
         this.inptfwtarget.border = true;
         this.inptfwtarget.restrict = "0-9";
         this.inptfwtarget.maxChars = 5;
         inptffwtarget = new TextFormat("Arial",12,0,null,null,null,null,null,TextFormatAlign.CENTER);
         this.inptfwtarget.defaultTextFormat = inptffwtarget;
         this.updateSpawnTargetTf();
         container.addChild(this.inptfwtarget);
         this.inptfwtarget.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.inptfwtarget.addEventListener(KeyboardEvent.KEY_UP,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.inptfwtarget.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            var _loc2_:int = parseInt(inptfwtarget.text);
            if(!isNaN(_loc2_) && _loc2_ >= 0 && _loc2_ <= 99999)
            {
               Bl.data.world_portal_target = _loc2_;
            }
            updateSpawnTargetTf();
         });
         addwtarget = new ui2plusbtn();
         addwtarget.y = this.inptfwtarget.y + 9;
         addwtarget.x = this.inptfwtarget.x + this.inptfwtarget.width + 12;
         container.addChild(addwtarget);
         addwtarget.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            if(Bl.data.world_portal_target < 99999)
            {
               ++Bl.data.world_portal_target;
               updateSpawnTargetTf();
            }
         });
         subwtarget = new ui2minusbtn();
         subwtarget.y = this.inptfwtarget.y + 9;
         subwtarget.x = this.inptfwtarget.x - 12;
         container.addChild(subwtarget);
         subwtarget.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            if(Bl.data.world_portal_target > 0)
            {
               --Bl.data.world_portal_target;
               updateSpawnTargetTf();
            }
         });
      }
      
      private function loadWorldNameWithDelay() : void
      {
         if(this.worldname_timer.running)
         {
            this.worldname_timer.reset();
         }
         if(Bl.data.world_portal_id != "")
         {
            this.tfwname.text = "Loading...";
            this.worldname_timer.start();
         }
         else
         {
            Bl.data.world_portal_name = "";
            this.updateWorldNameTf();
         }
      }
      
      private function loadWorldName(param1:Event = null) : void
      {
         var id:String = null;
         var e:Event = param1;
         if(Bl.data.world_portal_id == "")
         {
            return;
         }
         this.tfwname.text = "Loading...";
         id = Bl.data.world_portal_id;
         Global.base.client.bigDB.load("Worlds",id,function(param1:DatabaseObject):void
         {
            var _loc2_:String = null;
            if(Bl.data.world_portal_id == id)
            {
               if(param1 == null)
               {
                  _loc2_ = "No such world";
               }
               else if(param1.name == null)
               {
                  _loc2_ = "Untitled world";
               }
               else
               {
                  _loc2_ = param1.name;
               }
               Bl.data.world_portal_name = _loc2_;
               updateWorldNameTf();
            }
         });
      }
      
      private function updateWorldNameTf() : void
      {
         if(Bl.data.world_portal_name != "")
         {
            this.tfwname.text = Bl.data.world_portal_name;
         }
         else
         {
            this.tfwname.text = "No such world";
         }
      }
      
      private function updateMyWorldOffset() : void
      {
         this.myWorldOffset = 0;
         var _loc1_:int = 0;
         while(_loc1_ < Global.playerObject.roomids.length)
         {
            if(Bl.data.world_portal_id == Global.playerObject.roomids[_loc1_])
            {
               this.myWorldOffset = _loc1_;
            }
            _loc1_++;
         }
      }
      
      private function updateSpawnTargetTf() : void
      {
         if(Bl.data.world_portal_target > 0)
         {
            this.inptfwtarget.text = Bl.data.world_portal_target;
         }
         else
         {
            this.inptfwtarget.text = "Default";
         }
      }
   }
}

