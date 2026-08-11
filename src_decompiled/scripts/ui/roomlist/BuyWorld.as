package ui.roomlist
{
   import flash.events.MouseEvent;
   import states.LobbyState;
   import states.LobbyStatePage;
   import ui.shop.MainShop;
   
   public class BuyWorld extends assets_buyworlds
   {
      
      public function BuyWorld()
      {
         super();
         btn.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:ShopEvent = new ShopEvent(ShopEvent.OPEN_MAINSHOP,true,false);
            _loc2_.tab = MainShop.TAB_WORLDS;
            dispatchEvent(_loc2_);
            (Global.base.state as LobbyState).setPage(LobbyStatePage.ENERGY_SHOP);
         });
      }
   }
}

