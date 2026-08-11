package ui.profile.Alerts
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import playerio.Message;
   import sample.ui.components.Box;
   import sample.ui.components.Label;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   import utilities.AsyncTasks;
   
   public class MyNews extends Sprite
   {
      
      private static const UPDATE:int = 750;
      
      private var alerts:Box;
      
      private var alertsList:Rows;
      
      private var alertsScrollBox:ScrollBox;
      
      private var friendsRefreshDate:Date;
      
      private var isLoading:Boolean = false;
      
      private var alertCount:int = 0;
      
      private var alertItems:Array = [];
      
      private var lastNotification:String;
      
      public function MyNews()
      {
         super();
         addEventListener(Event.EXIT_FRAME,this.handleUpdateInboxScrollBox,false,0,true);
      }
      
      public function refreshMessages(param1:Function = null) : void
      {
         var messagesBox:Box;
         var crewLogo:Bitmap;
         var tasks:AsyncTasks = null;
         var callback:Function = param1;
         this.friendsRefreshDate = new Date();
         this.isLoading = true;
         if(this.alerts)
         {
            removeChild(this.alerts);
         }
         this.alerts = new Box();
         addChild(this.alerts);
         this.alerts.margin(0,0,0,0);
         this.alertsList = new Rows();
         this.alertsList.spacing(5);
         this.alertsList.forceScale = false;
         this.alertsScrollBox = new ScrollBox().margin(0,0,0,3);
         this.alertsScrollBox.scrollMultiplier = 8;
         this.alertsScrollBox.add(this.alertsList);
         messagesBox = new Box();
         messagesBox.margin(0,0,0,216);
         messagesBox.add(this.alertsScrollBox);
         this.alerts.add(messagesBox);
         this.alertItems = [];
         crewLogo = new Bitmap(new BitmapData(100,100,true,0));
         tasks = new AsyncTasks(2,function():void
         {
            renderMessages(alertItems);
            if(callback != null)
            {
               callback(true);
            }
         });
         Global.base.requestRemoteMethod("getNotifications",function(param1:Message):void
         {
            var _loc3_:String = null;
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1.getString(_loc2_);
               if(_loc2_ == 0)
               {
                  lastNotification = _loc3_;
               }
               alertItems.push(new AlertItem(_loc3_,param1.getString(_loc2_ + 1),param1.getString(_loc2_ + 2),param1.getString(_loc2_ + 3),AlertItem.NOTIFICATION,param1.getString(_loc2_ + 4),param1.getString(_loc2_ + 5),param1.getString(_loc2_ + 6),handleNotificationClosed));
               _loc2_ += 7;
            }
            tasks.next();
         });
         Global.base.requestRemoteMethod("getCrewInvites",function(param1:Message):void
         {
            var _loc3_:String = null;
            var _loc4_:AlertItem = null;
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1.getString(_loc2_ + 1);
               if(_loc2_ == 0 && !lastNotification)
               {
                  lastNotification = _loc3_;
               }
               _loc4_ = new AlertItem(param1.getString(_loc2_),"crew",_loc3_,_loc3_ + " has invited you to join their crew!",AlertItem.INVITE,"",param1.getString(_loc2_ + 2),"",handleNotificationClosed);
               alertItems.push(_loc4_);
               _loc2_ += 3;
            }
            tasks.next();
         });
      }
      
      public function get hasSeenNewest() : Boolean
      {
         return Global.sharedCookie.data.lastNotification == this.lastNotification || this.alertItems.length == 0;
      }
      
      public function setSeenNewest() : void
      {
         Global.sharedCookie.data.lastNotification = this.lastNotification;
      }
      
      private function renderMessages(param1:Array) : void
      {
         var _loc2_:int = 0;
         this.isLoading = false;
         if(param1.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.alertsList.addChild(param1[_loc2_]);
               _loc2_++;
            }
            this.alertCount = param1.length;
         }
         else
         {
            this.addNoNewsMessage();
         }
         this.alertsScrollBox.refresh();
      }
      
      private function handleNotificationClosed(param1:AlertItem) : void
      {
         var alert:AlertItem = param1;
         this.alertsScrollBox.refresh();
         if(this.alertsList.contains(alert))
         {
            TweenMax.to(alert,0.4,{
               "alpha":0,
               "onComplete":function(param1:AlertItem):void
               {
                  if(stage)
                  {
                     stage.stageFocusRect = false;
                     stage.focus = Global.base;
                  }
                  param1.parent.removeChild(param1);
                  if(alertsList.numChildren == 0)
                  {
                     addNoNewsMessage();
                  }
                  alertsScrollBox.refresh();
               },
               "onCompleteParams":[alert]
            });
         }
      }
      
      private function addNoNewsMessage() : void
      {
         this.alertsList.removeAllChildren();
         var _loc1_:Box = new Box();
         _loc1_.margin(2,2,0,92);
         this.alertsList.addChild(_loc1_);
         _loc1_.add(new Label("No new alerts to show!",16,"left",16777215,false,"system"));
      }
      
      public function refresh(param1:Function) : void
      {
         if(!this.isLoading && this.friendsRefreshDate == null || new Date().time - this.friendsRefreshDate.time > UPDATE)
         {
            this.refreshMessages(param1);
         }
         else if(param1 != null)
         {
            param1();
         }
      }
      
      private function handleUpdateInboxScrollBox(param1:Event) : void
      {
         removeEventListener(Event.EXIT_FRAME,this.handleUpdateInboxScrollBox);
         this.alertsScrollBox.refresh();
      }
      
      override public function set width(param1:Number) : void
      {
         this.alerts.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         this.alerts.height = param1;
      }
   }
}

