package ui.profile.Crew
{
   import flash.events.MouseEvent;
   import states.LobbyState;
   import states.LobbyStatePage;
   import ui.shop.MainShop;
   
   public class NoCrew extends assets_nocrew
   {
      
      public function NoCrew()
      {
         super();
         btn_openshop.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:ShopEvent = new ShopEvent(ShopEvent.OPEN_MAINSHOP,true,false);
            _loc2_.tab = MainShop.TAB_CREW;
            dispatchEvent(_loc2_);
            (Global.base.state as LobbyState).setPage(LobbyStatePage.ENERGY_SHOP);
         });
      }
   }
}

