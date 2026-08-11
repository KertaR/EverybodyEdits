package ui.shop
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.events.MouseEvent;
   
   public class ButtonBuy extends assets_buybutton
   {
      
      private var dollars:Boolean = false;
      
      public function ButtonBuy(param1:String)
      {
         super();
         stop();
         this.mouseEnabled = true;
         mouseChildren = false;
         buttonMode = true;
         tf_gems.text = param1;
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse,false,0,true);
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         super.mouseEnabled = param1;
      }
      
      protected function handleMouse(param1:MouseEvent) : void
      {
         this.setGlow(param1.type == MouseEvent.MOUSE_OVER ? 20 : 0);
      }
      
      public function showAsDollars() : void
      {
         gotoAndStop(2);
         this.dollars = true;
      }
      
      public function setGlow(param1:Number) : void
      {
         TweenMax.to(this,1 / 15,{
            "glowFilter":{
               "alpha":1,
               "color":(this.dollars == true ? 16758314 : 10223872),
               "blurX":param1,
               "blurY":param1,
               "strength":(this.dollars == true ? 0.5 : 2)
            },
            "ease":Linear.easeNone
         });
      }
   }
}

