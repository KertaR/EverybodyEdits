package ui.Prompts
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import sample.ui.components.Label;
   
   public class BasePrompt extends Sprite
   {
      
      private var closeButton:ProfileCloseButton;
      
      public var title:Label;
      
      private var error:Label;
      
      private var ow:Number;
      
      private var oh:Number;
      
      private var blackBG:BlackBG;
      
      private var prompt:Sprite;
      
      public function BasePrompt(param1:String, param2:Number, param3:Number)
      {
         var text:String = param1;
         var ow:Number = param2;
         var oh:Number = param3;
         super();
         this.ow = ow;
         this.oh = oh;
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
         this.prompt = new Sprite();
         this.prompt.graphics.clear();
         this.prompt.graphics.lineStyle(1,13421772);
         this.prompt.graphics.beginFill(2105376);
         this.prompt.graphics.drawRoundRect(0,0,ow,oh,15,15);
         this.prompt.graphics.endFill();
         addChild(this.prompt);
         this.closeButton = new ProfileCloseButton();
         this.closeButton.x = x + (ow - this.closeButton.width / 2);
         this.closeButton.y = y - this.closeButton.height / 2;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.close);
         addChild(this.closeButton);
         this.title = new Label(text,16,"left",16777215,false,"system");
         this.title.x = (ow - this.title.width) / 2;
         this.title.y = 15;
         addChild(this.title);
         this.error = new Label("",10,"left",16711680,true,"system");
         this.error.x = (this.width - this.error.width) / 2;
         this.error.y = this.height + 15;
         this.error.visible = false;
         addChild(this.error);
         x = (Config.maxwidth - this.width) / 2;
         y = (Config.height - this.height) / 2;
         this.blackBG = new BlackBG();
         this.blackBG.x = -x;
         this.blackBG.y = -y;
         addChildAt(this.blackBG,0);
      }
      
      public function setError(param1:String) : void
      {
         var text:String = param1;
         this.error.text = text;
         TweenMax.to(this.error,0.4,{
            "alpha":1,
            "onComplete":function():void
            {
               TweenMax.to(error,1,{
                  "alpha":0,
                  "delay":3
               });
            }
         });
      }
      
      public function close(param1:Event = null) : void
      {
         var basePrompt:BasePrompt = null;
         var e:Event = param1;
         this.closeButton.removeEventListener(MouseEvent.CLICK,this.close);
         basePrompt = this;
         TweenMax.to(basePrompt,0.4,{
            "alpha":0,
            "onComplete":function(param1:BasePrompt):void
            {
               if(param1 != null && param1.parent != null)
               {
                  param1.parent.removeChild(basePrompt);
               }
            },
            "onCompleteParams":[basePrompt]
         });
      }
      
      override public function get width() : Number
      {
         return this.ow;
      }
      
      override public function get height() : Number
      {
         return this.oh;
      }
   }
}

