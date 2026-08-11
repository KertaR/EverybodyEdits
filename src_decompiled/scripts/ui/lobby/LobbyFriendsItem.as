package ui.lobby
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import items.ItemManager;
   import ui.profile.FriendSmiley;
   import ui.social.SocialFriend;
   
   public class LobbyFriendsItem extends assets_lobbyfriends_item
   {
      
      private static const MULTI_OFFSET_X:Number = 4;
      
      private static const MULTI_OFFSET_Y:Number = 3;
      
      public function LobbyFriendsItem(param1:Array)
      {
         var numSmileys:int;
         var shown:Array;
         var ox:Number;
         var oy:Number;
         var sx:Number;
         var sy:Number;
         var names:String;
         var j:int;
         var prefix:String;
         var i:int = 0;
         var id:int = 0;
         var friend:SocialFriend = null;
         var smiley:FriendSmiley = null;
         var smileyBitmap:Bitmap = null;
         var color:uint = 0;
         var sep:String = null;
         var friends:Array = param1;
         super();
         numSmileys = Math.min(3,friends.length);
         shown = [];
         ox = MULTI_OFFSET_X * (numSmileys - 1) / 2;
         oy = MULTI_OFFSET_Y * (numSmileys - 1) / 2;
         sx = Math.round(4 - ox);
         sy = Math.round(5 - oy);
         i = 0;
         while(i < numSmileys)
         {
            do
            {
               id = Math.floor(Math.random() * friends.length);
            }
            while(shown.indexOf(id) >= 0);
            friend = friends[id];
            shown.push(id);
            smiley = new FriendSmiley(ItemManager.smileysBMD);
            smiley.frame = friend.smileyId;
            smiley.setRectY(friend.usingGoldBorder ? 26 : 0);
            smileyBitmap = smiley.getAsBitmap(1);
            smileyBitmap.x = sx + MULTI_OFFSET_X * i;
            smileyBitmap.y = sy + MULTI_OFFSET_Y * i;
            smileyBitmap.alpha = numSmileys == 1 ? 1 : i / (numSmileys - 1) * 0.5 + 0.5;
            addChild(smileyBitmap);
            i++;
         }
         names = "";
         j = 0;
         while(j < friends.length)
         {
            color = Player.getNameColor(friends[j].username.toLowerCase());
            sep = j > 0 ? (j == friends.length - 1 ? " & " : ", ") : null;
            names += (sep ? "<font color=\'#999999\'>" + sep + "</font>" : "") + "<font color=\'#" + (color & 0xFFFFFF).toString(16) + "\'>" + friends[j].username.toUpperCase() + "</font>";
            j++;
         }
         tf_names.htmlText = names;
         tf_names.height = tf_names.textHeight + 4;
         tf_world.y = Math.round(tf_names.y + tf_names.height - 2);
         if(height > 36)
         {
            line.y = Math.round(height + 2);
         }
         prefix = "Playing in: ";
         tf_world.text = prefix + friends[0].worldName;
         tf_world.setTextFormat(new TextFormat(null,null,8607744),prefix.length,tf_world.text.length);
         btn_info.visible = false;
         btn_play.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD,true,false);
            _loc2_.world_id = friends[0].worldId;
            dispatchEvent(_loc2_);
         });
      }
   }
}

