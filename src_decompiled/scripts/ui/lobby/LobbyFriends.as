package ui.lobby
{
   import com.greensock.TweenMax;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   import ui.social.SocialFriend;
   import ui.social.SocialFriends;
   
   public class LobbyFriends extends assets_lobbyfriends
   {
      
      private var friends:SocialFriends;
      
      private var handleJoin:Function;
      
      private var container:Rows;
      
      private var base:ScrollBox;
      
      private var clipLoading:assets_lobbyfriends_loading;
      
      private var clipNone:assets_lobbyfriends_none;
      
      private var lastLoading:Boolean = false;
      
      private var collapsed:Boolean = true;
      
      public function LobbyFriends(param1:SocialFriends)
      {
         var friends:SocialFriends = param1;
         this.container = new Rows();
         super();
         this.friends = friends;
         this.base = new ScrollBox().margin(0,1,1,1).add(this.container);
         this.container.spacing(0);
         this.container.forceScale = false;
         this.base.scrollMultiplier = 10;
         addChild(this.base);
         this.base.x = 8;
         this.base.y = 30;
         this.base.width = 376;
         this.base.height = 142;
         btn_reload.buttonMode = true;
         btn_reload.mouseChildren = false;
         btn_reload.rotator.gotoAndStop(1);
         btn_reload.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(friends.refresh())
            {
               render();
            }
         });
         this.collapsed = Global.cookie.data.collapseFriends != undefined ? Boolean(Global.cookie.data.collapseFriends) : true;
         check_collapsed.buttonMode = true;
         check_collapsed.mouseChildren = false;
         check_collapsed.gotoAndStop(this.collapsed ? 2 : 1);
         check_collapsed.addEventListener(MouseEvent.CLICK,function():void
         {
            collapsed = !collapsed;
            Global.cookie.data.collapseFriends = collapsed;
            check_collapsed.gotoAndStop(collapsed ? 2 : 1);
            render();
         });
         friends.loadedCallbacks.push(this.render);
         this.render();
      }
      
      public function render() : void
      {
         var none:Boolean = false;
         var worlds:Dictionary = null;
         var friend:SocialFriend = null;
         var sorted:Array = null;
         var i:int = 0;
         var id:String = null;
         var list:Array = null;
         this.container.removeAllChildren();
         if(this.friends.isLoading)
         {
            if(!this.clipLoading)
            {
               this.clipLoading = new assets_lobbyfriends_loading();
            }
            this.container.addChild(this.clipLoading);
         }
         else
         {
            none = true;
            for each(friend in this.friends.friendItems)
            {
               if(friend.onlineInWorld)
               {
                  if(this.collapsed)
                  {
                     if(!worlds)
                     {
                        worlds = new Dictionary();
                     }
                     if(!worlds[friend.worldId])
                     {
                        worlds[friend.worldId] = [friend];
                     }
                     else
                     {
                        worlds[friend.worldId].push(friend);
                     }
                  }
                  else
                  {
                     this.container.addChild(new LobbyFriendsItem([friend]));
                  }
                  none = false;
               }
            }
            if(this.collapsed && Boolean(worlds))
            {
               sorted = [];
               for(id in worlds)
               {
                  i = int(sorted.length);
                  while(i > 0 && worlds[id].length > sorted[i - 1].length)
                  {
                     i--;
                  }
                  sorted.insertAt(i,worlds[id]);
               }
               for each(list in sorted)
               {
                  this.container.addChild(new LobbyFriendsItem(list));
               }
            }
            if(none)
            {
               if(!this.clipNone)
               {
                  this.clipNone = new assets_lobbyfriends_none();
               }
               this.container.addChild(this.clipNone);
            }
         }
         this.base.refresh();
         this.base.scrollY = 1;
         if(this.friends.isLoading != this.lastLoading)
         {
            if(this.friends.isLoading)
            {
               btn_reload.rotator.gotoAndPlay(2);
            }
            else
            {
               btn_reload.rotator.gotoAndStop(1);
            }
            TweenMax.delayedCall(this.friends.isLoading ? 0 : SocialFriends.REFRESH_DELAY / 1000,function():void
            {
               btn_reload.mouseEnabled = !friends.isLoading;
               TweenMax.to(btn_reload,0.25,{"alpha":(friends.isLoading ? 0.5 : 1)});
            });
            this.lastLoading = this.friends.isLoading;
         }
      }
   }
}

