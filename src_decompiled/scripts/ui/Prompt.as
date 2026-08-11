package ui
{
   import com.greensock.TweenMax;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class Prompt extends asset_prompt
   {
      
      private var focusBase:Boolean;
      
      public function Prompt(param1:String, param2:String = "", param3:Function = null, param4:int = 140, param5:Boolean = false, param6:Boolean = true)
      {
         var title:String = param1;
         var dtext:String = param2;
         var callback:Function = param3;
         var max:int = param4;
         var overrideSave:Boolean = param5;
         var focusBase:Boolean = param6;
         super();
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
         tf_error.visible = false;
         savebtn.buttonMode = true;
         savebtn.gotoAndStop(1);
         headline.text = title;
         inputvar.text = dtext;
         inputvar.restrict = "^,";
         inputvar.maxChars = max;
         if(!overrideSave)
         {
            savebtn.addEventListener(MouseEvent.CLICK,function():void
            {
               callback(inputvar.text);
               close();
            });
         }
         closebtn.addEventListener(MouseEvent.CLICK,this.close);
      }
      
      public function setError(param1:String) : void
      {
         tf_error.visible = true;
         tf_error.text = param1;
      }
      
      public function close(param1:Event = null) : void
      {
         var e:Event = param1;
         var pm:Prompt = this;
         TweenMax.to(pm,0.4,{
            "alpha":0,
            "onComplete":function(param1:Prompt):void
            {
               if(Boolean(stage) && focusBase)
               {
                  stage.focus = Global.base;
               }
               param1.parent.removeChild(param1);
            },
            "onCompleteParams":[pm]
         });
      }
   }
}

