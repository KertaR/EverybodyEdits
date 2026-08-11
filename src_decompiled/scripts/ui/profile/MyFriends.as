package ui.profile
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sample.ui.components.Box;
   import sample.ui.components.Label;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   import ui.social.SocialFriend;
   import ui.social.SocialFriends;
   
   public class MyFriends extends Sprite
   {
      
      public static const BUTTON_SPACE:Number = 4;
      
      private var socialFriends:SocialFriends;
      
      private var readyCallback:Function;
      
      private var reloadCallback:Function;
      
      private var friends:Box;
      
      private var friendsList:Rows;
      
      private var friendsScrollBox:ScrollBox;
      
      private var topBar:Sprite = new Sprite();
      
      private var friendsRefreshDate:Date;
      
      private var isLoading:Boolean = false;
      
      private var invitationItems:Array;
      
      private var friendItems:Array;
      
      private var pendingItems:Array;
      
      private var blockedItems:Array;
      
      private var buttonAdd:asset_friendrequest = new asset_friendrequest();
      
      private var buttonFriends:asset_showfriends = new asset_showfriends();
      
      private var buttonPending:asset_showpending = new asset_showpending();
      
      private var buttonBlocked:asset_showblocked = new asset_showblocked();
      
      private var buttonReload:assets_reload = new assets_reload();
      
      public function MyFriends(param1:SocialFriends, param2:Function, param3:Function)
      {
         super();
         this.socialFriends = param1;
         this.readyCallback = param2;
         this.reloadCallback = param3;
         this.friends = new Box();
         addChild(this.friends);
         this.friends.margin(0,0,0,0);
         this.friendsList = new Rows();
         this.friendsList.spacing(5);
         this.friendsList.addEventListener(Event.REMOVED,this.handleFriendItemRemoved);
         this.friendsList.addEventListener(Event.CHANGE,this.handleFriendItemRemoved);
         this.friendsList.addEventListener(FriendItem.BLOCK,this.handleFriendItemBlocked);
         this.topBar.addChild(this.buttonAdd);
         this.buttonFriends.x = Math.round(this.topBar.width + BUTTON_SPACE * 3);
         this.topBar.addChild(this.buttonFriends);
         this.buttonPending.x = Math.round(this.topBar.width + BUTTON_SPACE);
         this.topBar.addChild(this.buttonPending);
         this.buttonBlocked.x = Math.round(this.topBar.width + BUTTON_SPACE);
         this.topBar.addChild(this.buttonBlocked);
         this.buttonReload.x = Math.round(this.topBar.width + BUTTON_SPACE * 3);
         this.buttonReload.width = this.buttonReload.height = 20;
         this.buttonReload.buttonMode = true;
         this.buttonReload.mouseChildren = false;
         this.buttonReload.rotator.gotoAndStop(1);
         this.topBar.addChild(this.buttonReload);
         this.topBar.addEventListener(MouseEvent.CLICK,this.handleTopBarButton);
         addChild(this.topBar);
         this.friendsScrollBox = new ScrollBox();
         this.friendsScrollBox.scrollMultiplier = 8;
         this.friendsScrollBox.add(this.friendsList);
         var _loc4_:Box = new Box();
         _loc4_.margin(25,0,0,0);
         _loc4_.add(this.friendsScrollBox);
         this.friends.add(_loc4_);
         if(param1.isLoading)
         {
            param1.loadedCallbacks.push(this.handleReload);
         }
         else
         {
            this.handleReload();
         }
         addEventListener(FriendItem.DELETE,this.handleFriendItemDeleted);
      }
      
      private function handleReload() : void
      {
         var _loc1_:SocialFriend = null;
         var _loc2_:SocialFriend = null;
         var _loc3_:SocialFriend = null;
         var _loc4_:SocialFriend = null;
         var _loc5_:uint = 0;
         this.invitationItems = [];
         for each(_loc1_ in this.socialFriends.invitationItems)
         {
            this.invitationItems.push(new FriendItem(_loc1_));
         }
         this.friendItems = [];
         for each(_loc2_ in this.socialFriends.friendItems)
         {
            this.friendItems.push(new FriendItem(_loc2_));
         }
         this.pendingItems = [];
         for each(_loc3_ in this.socialFriends.pendingItems)
         {
            this.pendingItems.push(new FriendItem(_loc3_));
         }
         this.blockedItems = [];
         for each(_loc4_ in this.socialFriends.blockedItems)
         {
            this.blockedItems.push(new FriendItem(_loc4_));
         }
         this.friendsList.removeAllChildren();
         _loc5_ = 0;
         while(_loc5_ < this.invitationItems.length)
         {
            this.friendsList.addChild(this.invitationItems[_loc5_]);
            _loc5_++;
         }
         var _loc6_:uint = 0;
         while(_loc6_ < this.friendItems.length)
         {
            this.friendsList.addChild(this.friendItems[_loc6_]);
            _loc6_++;
         }
         if(this.friendsList.numChildren == 0)
         {
            this.friendsList.addChild(this.createAddFriendInfoBox());
         }
         this.sortFriendItems();
         this.readyCallback();
         this.animateFriends();
      }
      
      private function sortFriendItems() : void
      {
         this.friendItems.sort(function(param1:FriendItem, param2:FriendItem):int
         {
            if(param1.type == SocialFriend.ACCEPTED && param2.type != SocialFriend.ACCEPTED)
            {
               return -1;
            }
            if(param1.type != SocialFriend.ACCEPTED && param2.type == SocialFriend.ACCEPTED)
            {
               return 1;
            }
            if(param1.type == SocialFriend.REJECTED && param2.type != SocialFriend.REJECTED)
            {
               return -1;
            }
            if(param1.type != SocialFriend.REJECTED && param2.type == SocialFriend.REJECTED)
            {
               return 1;
            }
            if(param1.friend.onlineInWorld && !param2.friend.onlineInWorld)
            {
               return -1;
            }
            if(!param1.friend.onlineInWorld && param2.friend.onlineInWorld)
            {
               return 1;
            }
            if(param1.friend.online && !param2.friend.online)
            {
               return -1;
            }
            if(!param1.friend.online && param2.friend.online)
            {
               return 1;
            }
            return param1.friend.lastSeen > param2.friend.lastSeen ? -1 : 1;
         });
      }
      
      private function animateFriends() : void
      {
         var _loc2_:FriendItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < Math.min(this.friendItems.length,10))
         {
            _loc2_ = this.friendItems[_loc1_];
            _loc2_.x = -_loc2_.width % 75;
            _loc2_.alpha = 0;
            TweenMax.to(_loc2_,0.45,{
               "delay":0.075 * _loc1_,
               "x":0,
               "alpha":1
            });
            _loc1_++;
         }
         this.topBar.alpha = 0;
         TweenMax.to(this.topBar,0.3,{"alpha":1});
      }
      
      private function createAddFriendInfoBox() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.fill(10066329,1);
         _loc1_.margin(15,NaN,NaN,5);
         _loc1_.add(new Label("Invite friends by clicking +Add",12,"left",16777215,false,"system"));
         return _loc1_;
      }
      
      private function handleTopBarButton(param1:MouseEvent) : void
      {
         var currentFriendContent:Array = null;
         var j:uint = 0;
         var itm:FriendItem = null;
         var i:int = 0;
         var e:MouseEvent = param1;
         if(!e || e.target == this.buttonFriends || e.target == this.buttonAdd || e.target == this.buttonPending || e.target == this.buttonBlocked)
         {
            this.friendsList.removeAllChildren();
            currentFriendContent = [];
            if(!e || e.target == this.buttonFriends)
            {
               currentFriendContent = this.invitationItems.concat(this.friendItems);
               if(currentFriendContent.length == 0)
               {
                  currentFriendContent.push(this.createAddFriendInfoBox());
               }
            }
            else if(e.target == this.buttonAdd)
            {
               itm = new FriendItem(null,SocialFriend.INVITE);
               this.pendingItems.unshift(itm);
               currentFriendContent.push(itm);
            }
            else if(e.target == this.buttonPending)
            {
               i = 0;
               while(i < this.pendingItems.length)
               {
                  if((this.pendingItems[i] as FriendItem).type == SocialFriend.INVITE)
                  {
                     this.pendingItems.splice(i,1);
                  }
                  i++;
               }
               currentFriendContent = this.pendingItems;
            }
            else if(e.target == this.buttonBlocked)
            {
               currentFriendContent = this.blockedItems;
            }
            j = 0;
            while(j < currentFriendContent.length)
            {
               if(currentFriendContent[j] != null)
               {
                  this.friendsList.addChild(currentFriendContent[j]);
               }
               j++;
            }
            this.friendsScrollBox.refresh();
         }
         else if(e.target == this.buttonReload)
         {
            if(this.socialFriends.refresh())
            {
               this.reloadCallback();
               this.buttonReload.mouseEnabled = false;
               this.buttonReload.alpha = 0.5;
               TweenMax.killChildTweensOf(this.topBar);
               TweenMax.delayedCall(SocialFriends.REFRESH_DELAY / 1000,function():void
               {
                  buttonReload.mouseEnabled = true;
                  TweenMax.to(buttonReload,0.25,{"alpha":1});
               });
            }
         }
      }
      
      private function handleFriendItemDeleted(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:FriendItem = param1.target as FriendItem;
         switch(_loc2_.type)
         {
            case SocialFriend.FRIEND:
            case SocialFriend.CONFIRM:
            case SocialFriend.ACCEPTED:
            case SocialFriend.REJECTED:
               _loc3_ = 0;
               while(_loc3_ < this.friendItems.length)
               {
                  if(this.friendItems[_loc3_] == _loc2_)
                  {
                     this.friendItems.splice(_loc3_,1);
                     break;
                  }
                  _loc3_++;
               }
               break;
            case SocialFriend.INVITE:
            case SocialFriend.PENDING:
               _loc4_ = 0;
               while(_loc4_ < this.pendingItems.length)
               {
                  if(this.pendingItems[_loc4_] == _loc2_)
                  {
                     this.pendingItems.splice(_loc4_,1);
                     break;
                  }
                  _loc4_++;
               }
               if(_loc2_.type == SocialFriend.INVITE)
               {
                  this.handleTopBarButton(null);
               }
               break;
            case SocialFriend.INVITATION:
               _loc5_ = 0;
               while(_loc5_ < this.invitationItems.length)
               {
                  if(this.invitationItems[_loc5_] == _loc2_)
                  {
                     this.invitationItems.splice(_loc5_,1);
                     break;
                  }
                  _loc5_++;
               }
               break;
            case SocialFriend.BLOCKED:
               _loc6_ = 0;
               while(_loc6_ < this.blockedItems.length)
               {
                  if(this.blockedItems[_loc6_] == _loc2_)
                  {
                     this.blockedItems.splice(_loc6_,1);
                     break;
                  }
                  _loc6_++;
               }
         }
      }
      
      private function handleFriendItemBlocked(param1:Event) : void
      {
         var _loc2_:FriendItem = param1.target as FriendItem;
         var _loc3_:int = this.invitationItems.indexOf(_loc2_);
         if(_loc3_ > -1)
         {
            this.invitationItems.splice(_loc3_,1);
            this.friendsList.removeChild(_loc2_);
            this.blockedItems.push(_loc2_);
            this.handleFriendItemRemoved(null);
         }
      }
      
      private function handleFriendItemRemoved(param1:Event) : void
      {
         addEventListener(Event.EXIT_FRAME,this.handleExitFrame,false,0,true);
      }
      
      private function handleExitFrame(param1:Event) : void
      {
         removeEventListener(Event.EXIT_FRAME,this.handleExitFrame);
         this.friendsList.spacing(5);
         this.friendsScrollBox.refresh();
      }
      
      protected function handleAddFriend(param1:MouseEvent) : void
      {
         var _loc2_:FriendItem = new FriendItem(null,SocialFriend.INVITE);
         this.friendsList.addChildAt(_loc2_,0);
         this.friendsScrollBox.refresh();
      }
      
      override public function set width(param1:Number) : void
      {
         this.friends.width = param1;
         this.topBar.x = Math.round((param1 - this.topBar.width) / 2);
      }
      
      override public function set height(param1:Number) : void
      {
         this.friends.height = param1;
      }
   }
}

