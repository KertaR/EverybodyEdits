package ui.ingame.pam
{
   import blitter.BlText;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import sample.ui.components.Box;
   import states.PlayState;
   
   public class PAMButton extends Box
   {
      
      private var background:Box;
      
      private var hoverBackground:Box;
      
      private var pam:PlayerActionsMenu;
      
      public function PAMButton(param1:int, param2:PlayerActionsMenu)
      {
         var actionText:BlText;
         var bitmap:Bitmap = null;
         var width:int = param1;
         var pam:PlayerActionsMenu = param2;
         super();
         this.pam = pam;
         buttonMode = true;
         useHandCursor = true;
         this.background = new Box();
         this.background.graphics.beginFill(3158064,0.75);
         this.background.graphics.drawRect(0,0,width,20);
         add(this.background);
         this.hoverBackground = new Box();
         this.hoverBackground.graphics.beginFill(13421772,0.75);
         this.hoverBackground.graphics.drawRect(0,0,width,20);
         this.hoverBackground.visible = false;
         add(this.hoverBackground);
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
         addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
         addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            action(param1);
            pam.close();
         });
         actionText = new BlText(14,width,16777215,"left","visitor");
         actionText.text = this.text;
         bitmap = new Bitmap(actionText.clone());
         bitmap.x = 20;
         bitmap.y = 2;
         addChild(bitmap);
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = param1.type != MouseEvent.MOUSE_OUT;
         this.background.visible = !_loc2_;
         this.hoverBackground.visible = _loc2_;
      }
      
      protected function get hasSpecialPowers() : Boolean
      {
         return Player.isAdmin(this.pam.me.name) || Player.isModerator(this.pam.me.name);
      }
      
      protected function get targetIsGuest() : Boolean
      {
         return this.pam.targetPlayer.name.indexOf("-") != -1;
      }
      
      protected function get targetPlayer() : Player
      {
         return this.pam.targetPlayer;
      }
      
      protected function get playState() : PlayState
      {
         return this.pam.playState;
      }
      
      protected function executeCommand(param1:String, ... rest) : void
      {
         this.pam.connection.send("say","/" + param1 + " " + rest.join(" "));
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      protected function get text() : String
      {
         return "Cancel";
      }
      
      protected function action(param1:MouseEvent) : void
      {
      }
   }
}

