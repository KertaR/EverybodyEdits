package
{
   import com.greensock.*;
   import flash.display.MovieClip;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getDefinitionByName;
   
   public class loader extends MovieClip
   {
      
      private var systemFont:Class;
      
      private var t:TextField;
      
      public function loader()
      {
         var tf:TextFormat;
         var loader:preloader = null;
         var maskW:Number = NaN;
         this.systemFont = loader_systemFont;
         this.t = new TextField();
         super();
         stage.quality = StageQuality.MEDIUM;
         loader = new preloader();
         loader.x = (stage.stageWidth - loader.width) / 2;
         loader.y = (stage.stageHeight - loader.height) / 2;
         loader.mask1.scaleX = 0;
         maskW = loader.width;
         tf = new TextFormat("system",36,12303291,null,null,null,null,null,"center");
         this.t.embedFonts = true;
         this.t.defaultTextFormat = tf;
         this.t.text = "0%0%0%";
         this.t.selectable = false;
         this.t.width = this.t.textWidth * 3;
         this.t.height = this.t.textHeight + 5;
         this.t.x = stage.stageWidth / 2 - this.t.width / 2;
         this.t.y = loader.y + loader.height - 20;
         this.t.alpha = 0;
         this.t.antiAliasType = AntiAliasType.ADVANCED;
         addChild(this.t);
         addChild(loader);
         TweenMax.to(loader,0.35,{
            "delay":0.5,
            "y":loader.y - 25,
            "onComplete":function():void
            {
               TweenMax.to(t,0.8,{"alpha":1});
            }
         });
         addEventListener(Event.ENTER_FRAME,function(param1:Event):void
         {
            if(stage.loaderInfo.bytesTotal == 0)
            {
               return;
            }
            var _loc3_:Number = stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal;
            loader.mask1.width = Math.round(_loc3_ * maskW);
            loader.mask2.width = maskW - loader.mask1.width;
            t.text = "" + Math.round(_loc3_ * 100) + "%";
            if(stage.loaderInfo.bytesLoaded != stage.loaderInfo.bytesTotal)
            {
               return;
            }
            removeChild(loader);
            removeChild(t);
            nextFrame();
            stage.quality = StageQuality.HIGH;
            var _loc4_:Class = Class(getDefinitionByName("EverybodyEdits"));
            addChild(new _loc4_());
            removeEventListener(Event.ENTER_FRAME,arguments.callee);
         });
      }
   }
}

