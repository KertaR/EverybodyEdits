package ui.social
{
   import io.player.tools.Badwords;
   
   public class SocialFriend
   {
      
      public static const FRIEND:String = "friend";
      
      public static const INVITATION:String = "invitation";
      
      public static const PENDING:String = "pending";
      
      public static const ACCEPTED:String = "accepted";
      
      public static const REJECTED:String = "rejected";
      
      public static const CONFIRM:String = "confirm";
      
      public static const INVITE:String = "invite";
      
      public static const MESSAGE:String = "message";
      
      public static const BLOCKED:String = "blocked";
      
      public static const WAITING:String = "waiting";
      
      public var username:String;
      
      public var type:String;
      
      public var smileyId:int;
      
      public var usingGoldBorder:Boolean;
      
      public var lastSeen:Number;
      
      public var online:Boolean;
      
      public var onlineInWorld:Boolean;
      
      public var worldId:String;
      
      public var worldName:String;
      
      public function SocialFriend(param1:String, param2:String)
      {
         super();
         this.type = param1;
         this.username = param2;
      }
      
      public function setOnlineStatus(param1:Boolean, param2:int, param3:Boolean, param4:String, param5:String, param6:Number) : void
      {
         this.smileyId = param2;
         this.usingGoldBorder = param3;
         this.onlineInWorld = false;
         this.online = param1;
         if(param1)
         {
            if(Boolean(param4) && Boolean(param5))
            {
               this.worldId = param4;
               this.worldName = Badwords.Filter(param5);
               this.onlineInWorld = true;
            }
         }
         else
         {
            this.lastSeen = param6;
         }
      }
   }
}

