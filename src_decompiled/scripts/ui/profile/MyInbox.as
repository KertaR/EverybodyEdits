package ui.profile
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sample.ui.components.Box;
   import sample.ui.components.Label;
   import sample.ui.components.scroll.ScrollBox;
   
   public class MyInbox extends Sprite
   {
      
      private static const UPDATE:int = 750;
      
      private var topBar:Sprite = new Sprite();
      
      private var buttonSend:assets_sendbtn = new assets_sendbtn();
      
      private var buttonMessages:assets_messagesbtn = new assets_messagesbtn();
      
      private var messages:Box;
      
      private var messagesBox:Box;
      
      private var messagesList:FillBox;
      
      private var messagesScrollBox:ScrollBox;
      
      private var refreshDate:Date;
      
      private var isLoading:Boolean = false;
      
      private var messageItems:Array = [];
      
      public var friendNames:Array = [];
      
      private var lastMail:String;
      
      public function MyInbox()
      {
         super();
      }
      
      public function refreshMessages(param1:Function = null) : void
      {
         param1(true);
      }
      
      public function refresh(param1:Function) : void
      {
         var _loc2_:Label = null;
         this.messagesList = new FillBox(5);
         _loc2_ = new Label("The messaging system has been disabled for the time being, during investigations of some security concerns.",14,"center",16777215,true,"system");
         this.messagesList.addChild(_loc2_);
         addChild(this.messagesList);
         _loc2_.width = 300;
         _loc2_.x = 255;
         _loc2_.y = 120;
         param1();
      }
      
      private function handleTopBarButton(param1:MouseEvent) : void
      {
      }
      
      private function adjustBoxMargin(param1:Boolean) : void
      {
         this.messagesBox.margin(25,0,0,param1 ? 227 : 186);
      }
      
      public function sendReply(param1:String, param2:String) : void
      {
      }
      
      private function renderMessages(param1:Array) : void
      {
      }
      
      public function get hasSeenNewest() : Boolean
      {
         return true;
      }
      
      public function setSeenNewest() : void
      {
      }
      
      private function handleMessageItemClick(param1:MouseEvent) : void
      {
      }
      
      private function handleMailRemoved(param1:MessageItem) : void
      {
      }
      
      private function addNoMail() : void
      {
      }
      
      private function handleUpdateInboxScrollBox(param1:Event) : void
      {
      }
      
      override public function set width(param1:Number) : void
      {
      }
      
      override public function set height(param1:Number) : void
      {
      }
   }
}

