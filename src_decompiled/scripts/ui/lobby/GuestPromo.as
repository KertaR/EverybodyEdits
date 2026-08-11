package ui.lobby
{
   import flash.events.MouseEvent;
   
   public class GuestPromo extends assets_lobby_guestpromo
   {
      
      public function GuestPromo()
      {
         super();
         btnRegister.gotoAndStop(1);
         btnRegister.buttonMode = true;
         if(Global.playing_on_kongregate)
         {
            btnRegister.visible = false;
            btnKongregate.addEventListener(MouseEvent.CLICK,this.handleRegister,false,0,true);
         }
         else
         {
            btnKongregate.visible = false;
            btnRegister.addEventListener(MouseEvent.CLICK,this.handleRegister,false,0,true);
         }
      }
      
      private function handleRegister(param1:MouseEvent) : void
      {
         Global.base.showRegister(90);
      }
   }
}

