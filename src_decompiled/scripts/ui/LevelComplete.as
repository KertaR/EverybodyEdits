package ui
{
   import blitter.Bl;
   import com.greensock.*;
   import com.greensock.easing.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import io.player.tools.Badwords;
   import items.ItemManager;
   import ui.profile.FriendSmiley;
   
   public class LevelComplete extends assets_complete
   {
      
      protected var CrownSilver:Class;
      
      private var crown_silver:BitmapData;
      
      private var profile_smiley:Sprite;
      
      public function LevelComplete()
      {
         var enabled:Boolean;
         var smileygx:FriendSmiley;
         var smileybitmap:Bitmap;
         var crown:FriendSmiley;
         var crownbitmap:Bitmap;
         this.CrownSilver = LevelComplete_CrownSilver;
         this.crown_silver = new this.CrownSilver().bitmapData;
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         name = "LevelCompleteScreen";
         tf_completed.text = "You completed \"" + Badwords.Filter(Global.currentLevelname.length > 0 ? Global.currentLevelname : "Untitled World") + "\"";
         btn_close.mouseEnabled = true;
         btn_close.addEventListener(MouseEvent.CLICK,this.close);
         enabled = false;
         if(Boolean(Bl.data.owner) || Global.player_is_guest)
         {
            btn_like.visible = false;
         }
         else
         {
            btn_like.gotoAndStop(Bl.data.liked ? 2 : 1);
            enabled = Bl.data.liked ? false : true;
            btn_like.buttonMode = enabled;
            btn_like.mouseEnabled = enabled;
            btn_like.mouseChildren = enabled;
            btn_like.addEventListener(MouseEvent.CLICK,this.like);
         }
         if(Boolean(Bl.data.owner) || Global.player_is_guest)
         {
            btn_favorite.visible = false;
         }
         else
         {
            btn_favorite.gotoAndStop(Bl.data.inFavorites ? 2 : 1);
            enabled = Bl.data.inFavorites ? false : true;
            btn_favorite.buttonMode = enabled;
            btn_favorite.mouseEnabled = enabled;
            btn_favorite.mouseChildren = enabled;
            btn_favorite.addEventListener(MouseEvent.CLICK,this.favorite);
         }
         if(Global.hasSubscribedToCrew)
         {
            btnSubscribe.buttonMode = false;
            btnSubscribe.mouseEnabled = false;
            btnSubscribe.text.text = "Thanks for subscribing";
         }
         else if(Global.currentLevelCrew != "")
         {
            btnSubscribe.text.text = "Subscribe to " + Global.currentLevelCrewName;
            btnSubscribe.buttonMode = true;
            btnSubscribe.text.mouseEnabled = false;
            btnSubscribe.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               Global.base.requestCrewLobbyMethod("crew" + Global.currentLevelCrew,"subscribe",null,null);
               btnSubscribe.buttonMode = false;
               btnSubscribe.mouseEnabled = false;
               btnSubscribe.text.mouseEnabled = false;
               btnSubscribe.text.text = "Thanks for subscribing";
            });
         }
         else
         {
            btnSubscribe.visible = false;
         }
         smileygx = new FriendSmiley(ItemManager.smileysBMD);
         smileygx.frame = Global.playerObject.smiley;
         smileybitmap = smileygx.getAsBitmap(6);
         smileybitmap.y = 6;
         crown = new FriendSmiley(this.crown_silver);
         crownbitmap = crown.getAsBitmap(6);
         this.profile_smiley = new Sprite();
         this.profile_smiley.addChild(smileybitmap);
         this.profile_smiley.addChild(crownbitmap);
         this.profile_smiley.x = -smileybitmap.width / 2;
         this.profile_smiley.y = -smileybitmap.height / 2;
         headanimation.holder.addChild(this.profile_smiley);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage,false,0,true);
      }
      
      protected function handleRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
      }
      
      private function closeToLobby(param1:Event = null) : void
      {
         this.close();
         Global.base.ShowLobby();
      }
      
      private function favorite(param1:Event = null) : void
      {
         if(!Bl.data.inFavorites)
         {
            Global.base.addToFavorites();
            btn_favorite.gotoAndStop(2);
            btn_favorite.buttonMode = false;
            btn_favorite.useHandCursor = false;
            btn_favorite.mouseEnabled = false;
         }
      }
      
      private function like(param1:Event = null) : void
      {
         if(!Bl.data.liked)
         {
            btn_like.gotoAndStop(2);
            Global.base.giveLike();
            btn_like.buttonMode = false;
            btn_like.useHandCursor = false;
            btn_like.mouseEnabled = false;
         }
      }
      
      public function close(param1:Event = null) : void
      {
         if(stage)
         {
            stage.focus = Global.base;
         }
         this.parent.removeChild(this);
      }
   }
}

