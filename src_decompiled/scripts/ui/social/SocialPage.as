package ui.social
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sample.ui.components.Box;
   import ui.profile.Alerts.MyNews;
   import ui.profile.Crew.MyCrew;
   import ui.profile.MyFriends;
   import ui.profile.MyInbox;
   
   public class SocialPage extends assets_socialpage
   {
      
      private var socialTab:MovieClip;
      
      private var content:Box;
      
      public var currentTab:MovieClip;
      
      private var currentcontent:Sprite;
      
      private var loadinganim:assets_miniloading;
      
      private var myfriends:MyFriends;
      
      public var myCrew:MyCrew;
      
      private var myinbox:MyInbox;
      
      private var mynews:MyNews;
      
      public var friends:SocialFriends;
      
      private var newAlert:Boolean = false;
      
      private var newMail:Boolean = false;
      
      public function SocialPage(param1:MovieClip)
      {
         var socialTab:MovieClip = param1;
         this.content = new Box();
         this.loadinganim = new assets_miniloading();
         super();
         this.socialTab = socialTab;
         this.loadinganim.x = Math.round(bg.width / 2);
         this.loadinganim.y = bg.y + Math.round(bg.height / 2);
         this.content.y = bg.y;
         this.content.width = bg.width;
         this.content.height = bg.height;
         this.content.margin(10,10,10,10);
         addChild(this.content);
         tabbar.tab_friends.buttonMode = tabbar.tab_crew.buttonMode = tabbar.tab_inbox.buttonMode = tabbar.tab_news.buttonMode = true;
         tabbar.tab_friends.mouseChildren = tabbar.tab_crew.mouseChildren = tabbar.tab_inbox.mouseChildren = tabbar.tab_news.mouseChildren = false;
         this.resetTabs();
         tabbar.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            var _loc2_:MovieClip = param1.target as MovieClip;
            if(_loc2_.parent == tabbar)
            {
               _loc2_.gotoAndStop(2);
            }
         });
         tabbar.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
         {
            var _loc2_:MovieClip = param1.target as MovieClip;
            if(_loc2_.parent == tabbar && _loc2_ != currentTab)
            {
               _loc2_.gotoAndStop(1);
            }
         });
         tabbar.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:MovieClip = param1.target as MovieClip;
            if(_loc2_.parent == tabbar && !loadinganim.parent)
            {
               showContent(_loc2_);
            }
         });
         this.toggleNewAlert(false);
         this.toggleNewMail(false);
         this.friends = new SocialFriends();
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
      }
      
      private function resetTabs() : void
      {
         tabbar.tab_friends.gotoAndStop(1);
         tabbar.tab_crew.gotoAndStop(1);
         tabbar.tab_inbox.gotoAndStop(1);
         tabbar.tab_news.gotoAndStop(1);
      }
      
      private function toggleNewAlert(param1:Boolean) : void
      {
         this.newAlert = param1;
         tabbar.tab_news.alertIcon.visible = param1;
         this.updateTabAlert();
      }
      
      private function toggleNewMail(param1:Boolean) : void
      {
         this.newMail = param1;
         tabbar.tab_inbox.alertIcon.visible = param1;
         this.updateTabAlert();
      }
      
      private function updateTabAlert() : void
      {
         this.socialTab.gotoAndStop((this.newAlert || this.newMail ? 3 : 1) + (this.socialTab.currentFrame == 2 || this.socialTab.currentFrame == 4 ? 1 : 0));
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         var e:Event = param1;
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         this.showContent(tabbar.tab_friends);
         this.mynews = new MyNews();
         this.mynews.refresh(function(param1:Boolean = false):void
         {
            if(param1)
            {
               toggleNewAlert(!mynews.hasSeenNewest);
            }
         });
         this.myinbox = new MyInbox();
         this.myinbox.refresh(function(param1:Boolean = false):void
         {
            if(param1)
            {
               toggleNewMail(!myinbox.hasSeenNewest);
            }
         });
      }
      
      private function showContent(param1:MovieClip) : void
      {
         var tab:MovieClip = param1;
         if(Boolean(this.currentcontent) && this.currentcontent.parent == this.content)
         {
            this.content.removeChild(this.currentcontent);
         }
         this.resetTabs();
         this.currentTab = tab;
         this.currentTab.gotoAndStop(2);
         addChild(this.loadinganim);
         switch(tab)
         {
            case tabbar.tab_friends:
               if(!this.myfriends)
               {
                  this.myfriends = new MyFriends(this.friends,function():void
                  {
                     onContentReady(myfriends);
                     if(myinbox)
                     {
                        myinbox.friendNames = friends.friendNames;
                     }
                  },function():void
                  {
                     showContent(tabbar.tab_friends);
                  });
               }
               else
               {
                  this.onContentReady(this.myfriends);
               }
               break;
            case tabbar.tab_crew:
               if(!this.myCrew)
               {
                  this.myCrew = new MyCrew();
               }
               this.myCrew.refresh(function():void
               {
                  onContentReady(myCrew);
               });
               break;
            case tabbar.tab_inbox:
               if(this.newMail)
               {
                  this.toggleNewMail(false);
               }
               if(!this.myinbox)
               {
                  this.myinbox = new MyInbox();
               }
               this.myinbox.refresh(function():void
               {
                  onContentReady(myinbox);
                  if(myfriends)
                  {
                     myinbox.friendNames = friends.friendNames;
                  }
                  myinbox.setSeenNewest();
                  toggleNewMail(false);
               });
               break;
            case tabbar.tab_news:
               if(this.newAlert)
               {
                  this.toggleNewAlert(false);
               }
               if(!this.mynews)
               {
                  this.mynews = new MyNews();
               }
               this.mynews.refresh(function():void
               {
                  onContentReady(mynews);
                  mynews.setSeenNewest();
                  toggleNewAlert(false);
               });
         }
      }
      
      private function onContentReady(param1:Sprite) : void
      {
         if(!this.currentcontent || !this.currentcontent.parent)
         {
            if(this.loadinganim.parent)
            {
               removeChild(this.loadinganim);
            }
            this.currentcontent = param1;
            this.content.add(param1);
         }
      }
   }
}

