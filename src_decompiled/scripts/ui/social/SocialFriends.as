package ui.social
{
   import playerio.Message;
   import utilities.AsyncTasks;
   
   public class SocialFriends
   {
      
      public static const REFRESH_DELAY:int = 3000;
      
      private var friendsRefreshDate:Date;
      
      public var isLoading:Boolean = false;
      
      public var loadedCallbacks:Vector.<Function> = new Vector.<Function>();
      
      public var friendItems:Vector.<SocialFriend> = new Vector.<SocialFriend>();
      
      public var invitationItems:Vector.<SocialFriend> = new Vector.<SocialFriend>();
      
      public var pendingItems:Vector.<SocialFriend> = new Vector.<SocialFriend>();
      
      public var blockedItems:Vector.<SocialFriend> = new Vector.<SocialFriend>();
      
      public var friendNames:Array = [];
      
      public function SocialFriends()
      {
         super();
         this.refresh();
      }
      
      public function refresh() : Boolean
      {
         if(!this.isLoading && (this.friendsRefreshDate == null || new Date().time - this.friendsRefreshDate.time > REFRESH_DELAY))
         {
            this.refreshContentFriends();
            return true;
         }
         return false;
      }
      
      private function refreshContentFriends() : void
      {
         var tasks:AsyncTasks = null;
         this.friendsRefreshDate = new Date();
         this.isLoading = true;
         this.invitationItems = new Vector.<SocialFriend>();
         this.friendItems = new Vector.<SocialFriend>();
         this.pendingItems = new Vector.<SocialFriend>();
         this.blockedItems = new Vector.<SocialFriend>();
         this.friendNames = [];
         tasks = new AsyncTasks(4,function():void
         {
            var _loc1_:* = undefined;
            sortFriendItems();
            isLoading = false;
            for each(_loc1_ in loadedCallbacks)
            {
               _loc1_();
            }
         });
         Global.base.requestRemoteMethod("getInvitesToMe",function(param1:Message):void
         {
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               invitationItems.push(new SocialFriend(SocialFriend.INVITATION,param1.getString(_loc2_)));
               _loc2_++;
            }
            tasks.next();
         });
         Global.base.requestRemoteMethod("getFriends",function(param1:Message):void
         {
            var _loc3_:String = null;
            var _loc4_:SocialFriend = null;
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1.getString(_loc2_);
               _loc4_ = new SocialFriend(SocialFriend.FRIEND,_loc3_);
               _loc4_.setOnlineStatus(param1.getBoolean(_loc2_ + 1),param1.getInt(_loc2_ + 4),param1.getBoolean(_loc2_ + 6),param1.getString(_loc2_ + 2),param1.getString(_loc2_ + 3),param1.getNumber(_loc2_ + 5));
               friendItems.push(_loc4_);
               friendNames.push(_loc3_);
               _loc2_ += 7;
            }
            tasks.next();
         });
         Global.base.requestRemoteMethod("getPending",function(param1:Message):void
         {
            var _loc3_:int = 0;
            var _loc4_:String = null;
            var _loc5_:SocialFriend = null;
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1.getInt(_loc2_ + 1);
               _loc4_ = _loc3_ == 2 ? SocialFriend.REJECTED : (_loc3_ == 1 ? SocialFriend.ACCEPTED : SocialFriend.PENDING);
               _loc5_ = new SocialFriend(_loc4_,param1.getString(_loc2_));
               if(_loc3_ == 0)
               {
                  pendingItems.push(_loc5_);
               }
               else
               {
                  friendItems.push(_loc5_);
               }
               _loc2_ += 2;
            }
            tasks.next();
         });
         Global.base.requestRemoteMethod("getBlockedUsers",function(param1:Message):void
         {
            var _loc3_:SocialFriend = null;
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = new SocialFriend(SocialFriend.BLOCKED,param1.getString(_loc2_));
               blockedItems.push(_loc3_);
               _loc2_++;
            }
            tasks.next();
         });
      }
      
      private function sortFriendItems() : void
      {
         this.friendItems.sort(function(param1:SocialFriend, param2:SocialFriend):int
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
            if(param1.onlineInWorld && !param2.onlineInWorld)
            {
               return -1;
            }
            if(!param1.onlineInWorld && param2.onlineInWorld)
            {
               return 1;
            }
            if(param1.online && !param2.online)
            {
               return -1;
            }
            if(!param1.online && param2.online)
            {
               return 1;
            }
            return param1.lastSeen > param2.lastSeen ? -1 : 1;
         });
      }
   }
}

