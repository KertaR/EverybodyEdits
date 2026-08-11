package ui.ingame.pam
{
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class ShowProfilePAMButton extends PAMButton
   {
      
      public function ShowProfilePAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override public function get active() : Boolean
      {
         return !targetIsGuest;
      }
      
      override protected function get text() : String
      {
         return "Show profile";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         var _loc2_:NavigationEvent = null;
         if(param1.shiftKey)
         {
            navigateToURL(new URLRequest(Config.site + "/profiles/" + targetPlayer.name),"_blank");
         }
         else
         {
            _loc2_ = new NavigationEvent(NavigationEvent.SHOW_PROFILE,true);
            _loc2_.username = targetPlayer.name;
            dispatchEvent(_loc2_);
         }
      }
   }
}

