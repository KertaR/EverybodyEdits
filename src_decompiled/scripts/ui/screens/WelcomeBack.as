package ui.screens
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import items.ItemManager;
   import playerio.Message;
   import ui.profile.FriendSmiley;
   
   public class WelcomeBack extends assets_welcomeback
   {
      
      private var rewards:Array;
      
      public function WelcomeBack(param1:int, param2:Message)
      {
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:RewardItem = null;
         this.rewards = [];
         super();
         btn_thanks.buttonMode = true;
         btn_thanks.addEventListener(MouseEvent.CLICK,this.close,false,0,true);
         btn_close.buttonMode = true;
         btn_close.addEventListener(MouseEvent.CLICK,this.close,false,0,true);
         var _loc3_:FriendSmiley = new FriendSmiley(ItemManager.smileysBMD);
         _loc3_.frame = Global.playerObject.smiley;
         var _loc4_:Bitmap = _loc3_.getAsBitmap(6);
         _loc4_.x = 445 - _loc4_.width / 2;
         _loc4_.y = 220 - _loc4_.height / 2;
         addChild(_loc4_);
         var _loc5_:int = 2;
         while(_loc5_ < param2.length)
         {
            this.rewards.push(new RewardItem(param2.getString(_loc5_),param2.getInt(_loc5_ + 1)));
            _loc5_ += 2;
         }
         param1++;
         tf_days.text = "Congratulations you\'ve logged in for " + param1 + (param1 == 1 ? " day" : " days") + " in a row!";
         var _loc7_:int = 0;
         while(_loc7_ < this.rewards.length)
         {
            _loc6_ += this.rewards[_loc7_].width + 10;
            _loc7_++;
         }
         _loc8_ = 0;
         while(_loc8_ < this.rewards.length)
         {
            _loc9_ = this.rewards[_loc8_];
            if(_loc9_ != null)
            {
               _loc9_.y = 320;
               _loc9_.x = _loc8_ * 40 + (width - _loc6_) / 2 + 30;
               addChild(_loc9_);
            }
            _loc8_++;
         }
      }
      
      private function close(param1:Event) : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
   }
}

