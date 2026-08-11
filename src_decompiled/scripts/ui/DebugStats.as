package ui
{
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   import playerio.Connection;
   import playerio.Message;
   import states.PlayState;
   
   public class DebugStats extends TextField
   {
      
      private static const UPDATE_INTERVAL:Number = 1000;
      
      private var state:PlayState;
      
      private var con:Connection;
      
      private var lastUpdate:Number;
      
      private var frameCount:Number;
      
      private var lastFps:Number = 0;
      
      private var lastPing:Number = 0;
      
      private var lastPingSent:Number = -1;
      
      private var lastPingResponse:Number = -1;
      
      private var pinging:Boolean = false;
      
      public function DebugStats(param1:PlayState, param2:Number = 16777215, param3:Number = 11)
      {
         super();
         this.state = param1;
         this.con = param1.getConnection();
         x = 4;
         y = 2;
         var _loc4_:TextFormat = new TextFormat("Tahoma",param3,param2);
         defaultTextFormat = _loc4_;
         antiAliasType = AntiAliasType.ADVANCED;
         gridFitType = GridFitType.SUBPIXEL;
         multiline = true;
         autoSize = TextFieldAutoSize.LEFT;
         selectable = false;
         mouseEnabled = false;
         addEventListener(Event.ADDED_TO_STAGE,this.onShow);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onHide);
         this.con.addMessageHandler("pong",this.onPing);
      }
      
      private function onShow(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.update);
         this.frameCount = 0;
         this.lastUpdate = getTimer();
         this.lastPingSent = this.lastPingResponse = -1;
      }
      
      private function onHide(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.update);
         this.pinging = false;
      }
      
      private function update(param1:Event) : void
      {
         if(!visible)
         {
            return;
         }
         var _loc2_:Number = getTimer();
         ++this.frameCount;
         if(_loc2_ >= this.lastUpdate + UPDATE_INTERVAL)
         {
            this.lastUpdate = _loc2_;
            this.lastFps = this.frameCount;
            this.frameCount = 0;
         }
         if(!this.pinging && (this.lastPingResponse == -1 || _loc2_ >= this.lastPingResponse + UPDATE_INTERVAL))
         {
            this.con.send("ping");
            this.lastPingSent = _loc2_;
            this.pinging = true;
         }
         this.updateText();
      }
      
      private function onPing(param1:Message) : void
      {
         if(!this.pinging)
         {
            return;
         }
         this.lastPingResponse = getTimer();
         this.lastPing = this.lastPingResponse - this.lastPingSent;
         this.pinging = false;
      }
      
      private function updateText() : void
      {
         text = "";
         this.add("Everybody Edits v" + Config.client_type_version);
         this.add("Ping (RTT)",this.lastPing + "ms");
         this.add("FPS",this.lastFps.toString());
         this.add("Position","(" + (this.state.player.x / 16).toFixed(3) + ", " + (this.state.player.y / 16).toFixed(3) + ")");
         this.add("Time",(this.state.player.ticks / 100).toFixed(2) + "s");
         if(Global.reportTextTest != "")
         {
            this.add("Report",Global.reportTextTest);
         }
      }
      
      private function add(param1:String, param2:String = "") : void
      {
         text += param1 + (param2 == "" ? "" : ": " + param2) + "\n";
      }
   }
}

