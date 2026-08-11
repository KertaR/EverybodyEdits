package ui
{
   import com.greensock.TweenMax;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class ConfirmPrompt extends asset_confirmprompt
   {
      
      private var focusBase:Boolean;
      
      public var btn_yes:SimpleButton;
      
      public var btn_no:SimpleButton;
      
      public var onAnyClose:Function;
      
      public function ConfirmPrompt(param1:String, param2:Boolean, param3:String = null, param4:Boolean = true, param5:Boolean = true)
      {
         var text:String = param1;
         var danger:Boolean = param2;
         var dangerName:String = param3;
         var focusBase:Boolean = param4;
         var closeButton:Boolean = param5;
         super();
         btn_yes1.visible = btn_no1.visible = !danger;
         btn_yes2.visible = btn_no2.visible = danger;
         btn_yes2.field.mouseEnabled = false;
         if(danger && Boolean(dangerName))
         {
            btn_yes2.field.text = dangerName;
         }
         this.btn_yes = danger ? btn_yes2.btn : btn_yes1;
         this.btn_no = danger ? btn_no2 : btn_no1;
         closebtn.visible = closeButton;
         this.focusBase = focusBase;
         this.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         textbox.text = text;
         this.btn_no.addEventListener(MouseEvent.CLICK,this.close);
         closebtn.addEventListener(MouseEvent.CLICK,this.close);
      }
      
      public function close(param1:Event = null) : void
      {
         var e:Event = param1;
         var pm:ConfirmPrompt = this;
         TweenMax.to(pm,0.4,{
            "alpha":0,
            "onComplete":function(param1:ConfirmPrompt):void
            {
               if(param1 != null && param1.parent != null)
               {
                  if(Boolean(stage) && focusBase)
                  {
                     stage.focus = stage;
                  }
                  param1.parent.removeChild(param1);
                  if(onAnyClose != null)
                  {
                     onAnyClose();
                  }
               }
            },
            "onCompleteParams":[pm]
         });
      }
   }
}

