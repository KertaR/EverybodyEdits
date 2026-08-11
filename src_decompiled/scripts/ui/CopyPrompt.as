package ui
{
   import com.greensock.TweenMax;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class CopyPrompt extends assets_copyprompt
   {
      
      public function CopyPrompt(param1:String, param2:String, param3:String, param4:Function = null)
      {
         var title:String = param1;
         var dtext:String = param2;
         var extraText:String = param3;
         var callback:Function = param4;
         super();
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
         headline.text = title;
         textfield.text = dtext;
         this.extraText.text = extraText;
         closebtn.addEventListener(MouseEvent.CLICK,this.close);
      }
      
      public function close(param1:Event = null) : void
      {
         var e:Event = param1;
         var pm:CopyPrompt = this;
         TweenMax.to(pm,0.4,{
            "alpha":0,
            "onComplete":function(param1:CopyPrompt):void
            {
               param1.parent.removeChild(param1);
            },
            "onCompleteParams":[pm]
         });
      }
   }
}

