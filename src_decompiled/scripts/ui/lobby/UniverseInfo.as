package ui.lobby
{
   import flash.events.MouseEvent;
   import playerio.Message;
   import states.LobbyState;
   import states.LobbyStatePage;
   import ui.ConfirmPrompt;
   import ui.shop.MainShop;
   
   public class UniverseInfo extends assets_universe_info
   {
      
      public function UniverseInfo()
      {
         super();
         btn_optin.buttonMode = true;
         if(Global.player_is_guest)
         {
            btn_optin.visible = tf_optin.visible = false;
            btn_support.x = Math.round((width - btn_support.width) / 2);
         }
         btn_support.addEventListener(MouseEvent.CLICK,function():void
         {
            dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_PATREON,true,false));
         });
         this.update();
      }
      
      public function update() : void
      {
         btn_optin.removeEventListener(MouseEvent.CLICK,this.handleGetBeta);
         btn_optin.removeEventListener(MouseEvent.CLICK,this.handleOptIn);
         if(Global.player_is_guest)
         {
            return;
         }
         if(!Global.player_is_beta_member)
         {
            btn_optin.gotoAndStop(3);
            tf_optin.text = "Get Beta to opt-in to the EEU closed beta!";
            btn_optin.addEventListener(MouseEvent.CLICK,this.handleGetBeta);
         }
         else if(Global.playerObject.universe)
         {
            btn_optin.gotoAndStop(2);
            btn_optin.mouseEnabled = false;
            tf_optin.text = "You\'ve opted-in to play the EEU closed beta!";
         }
         else
         {
            btn_optin.gotoAndStop(1);
            tf_optin.text = "You can opt-in to play the EEU closed beta!";
            btn_optin.addEventListener(MouseEvent.CLICK,this.handleOptIn);
         }
      }
      
      private function handleGetBeta(param1:MouseEvent) : void
      {
         var _loc2_:LobbyState = Global.base.state as LobbyState;
         _loc2_.setPage(LobbyStatePage.ENERGY_SHOP);
         _loc2_.mainshop.showTab(MainShop.TAB_SERVICES);
      }
      
      private function handleOptIn(param1:MouseEvent) : void
      {
         var prompt:ConfirmPrompt = null;
         var e:MouseEvent = param1;
         prompt = new ConfirmPrompt("Are you sure you wish to be invited to the EE Universe Closed Beta when it\'s ready?",false);
         prompt.btn_yes.addEventListener(MouseEvent.CLICK,function():void
         {
            prompt.close();
            Global.base.showLoadingScreen("Opting in...");
            Global.base.requestRemoteMethod("universeOptIn",function(param1:Message):void
            {
               if(param1.getBoolean(0))
               {
                  Global.playerObject.universe = true;
                  update();
                  Global.base.showInfo("Success!","Thank you for signing up for the Everybody Edits Universe Closed Beta! You will receive an email inviting you to participate when the time comes, and your current username will be reserved for you.\n\nIf you wish to update the email currently associated with your account, please send a message to staff@everybodyedits.com from the email you wish to change your account to, including your username and your account\'s current email.",400);
               }
               Global.base.hideLoadingScreen();
            });
         });
         Global.base.showOnTop(prompt);
      }
   }
}

