package ui
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.setInterval;
   
   public class RegisterWindow extends asset_registerwindow
   {
      
      protected var Slides:Class;
      
      private var slidesBMD:BitmapData;
      
      private var defaulttext:Object;
      
      private var displayAsPassword:Object;
      
      private var lock_overlay:Sprite;
      
      public var chosen_name:String;
      
      private var imageId:int = 0;
      
      private var image:Bitmap;
      
      private var images:Array;
      
      private var innerGlow:GlowFilter;
      
      private var lessInnerGlow:GlowFilter;
      
      private var capImg:Bitmap;
      
      public function RegisterWindow()
      {
         var tf:TextField;
         this.Slides = RegisterWindow_Slides;
         this.slidesBMD = new this.Slides().bitmapData;
         this.defaulttext = {};
         this.displayAsPassword = {};
         this.image = new Bitmap();
         this.images = [];
         this.capImg = new Bitmap(new BitmapData(1,1));
         super();
         filters = [new DropShadowFilter(0,45,0,1,40,40,1,1)];
         this.lock_overlay = new Sprite();
         this.lock_overlay.graphics.beginFill(0,0);
         this.lock_overlay.graphics.drawRect(0,0,width,height);
         this.lock_overlay.mouseEnabled = true;
         this.lock_overlay.visible = false;
         addChild(this.lock_overlay);
         this.defaulttext[inpemail.name] = inpemail.text;
         this.defaulttext[inppassword.name] = inppassword.text;
         this.defaulttext[inppassword2.name] = inppassword2.text;
         this.defaulttext[inpcaptcha.name] = inpcaptcha.text;
         this.displayAsPassword[inpemail.name] = false;
         this.displayAsPassword[inppassword.name] = true;
         this.displayAsPassword[inppassword2.name] = true;
         this.displayAsPassword[inpcaptcha.name] = false;
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         inpemail.addEventListener(FocusEvent.FOCUS_IN,this.handleFocus,false,0,true);
         inpemail.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocus,false,0,true);
         inpemail.tabIndex = 2;
         inppassword.addEventListener(FocusEvent.FOCUS_IN,this.handleFocus,false,0,true);
         inppassword.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocus,false,0,true);
         inppassword.tabIndex = 3;
         inppassword2.addEventListener(FocusEvent.FOCUS_IN,this.handleFocus,false,0,true);
         inppassword2.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocus,false,0,true);
         inppassword2.tabIndex = 4;
         inpcaptcha.addEventListener(FocusEvent.FOCUS_IN,this.handleFocus,false,0,true);
         inpcaptcha.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocus,false,0,true);
         inpcaptcha.tabIndex = 5;
         termsbutton.gotoAndStop(1);
         tf = termslink.tf;
         tf.htmlText = "I have read and accept the <a href=\'event:terms\'><u>Terms & Conditions</u></a>";
         tf.addEventListener(TextEvent.LINK,this.handleTextLink);
         registerbutton.gotoAndStop(2);
         registerbutton.mouseEnabled = false;
         registerbutton.mouseChildren = false;
         this.innerGlow = new GlowFilter();
         this.innerGlow.inner = true;
         this.innerGlow.color = 0;
         this.innerGlow.quality = BitmapFilterQuality.HIGH;
         this.innerGlow.blurX = 25;
         this.innerGlow.blurY = 25;
         this.innerGlow.strength = 1.5;
         this.lessInnerGlow = new GlowFilter();
         this.lessInnerGlow.inner = true;
         this.lessInnerGlow.color = 0;
         this.lessInnerGlow.quality = BitmapFilterQuality.HIGH;
         this.lessInnerGlow.blurX = 8;
         this.lessInnerGlow.blurY = 8;
         this.lessInnerGlow.strength = 1.5;
         this.setupImages();
         this.setImage(this.imageId);
         setInterval(this.StartSlideShow,4000);
      }
      
      private function setupImages() : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Bitmap = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = new BitmapData(261,150,true,0);
            _loc2_.copyPixels(this.slidesBMD,new Rectangle(261 * _loc1_,0,261,150),new Point(0,0));
            _loc3_ = new Bitmap(_loc2_);
            this.images.push(_loc3_);
            _loc1_++;
         }
      }
      
      private function StartSlideShow() : void
      {
         TweenMax.to(this.image,0.4,{
            "alpha":0,
            "onComplete":function():void
            {
               if(slideshowContainer.contains(image))
               {
                  slideshowContainer.removeChild(image);
               }
               ++imageId;
               if(imageId >= 6)
               {
                  imageId = 0;
               }
               setImage(imageId);
            }
         });
      }
      
      private function setImage(param1:int) : void
      {
         if(this.image == null)
         {
            return;
         }
         this.image = this.images[param1] as Bitmap;
         this.image.x = 1;
         this.image.y = 1;
         this.image.alpha = 0;
         this.image.filters = [this.innerGlow];
         slideshowContainer.addChild(this.image);
         TweenMax.to(this.image,0.4,{"alpha":1});
      }
      
      public function setCaptchaImage(param1:String) : void
      {
         if(captchaContainer != null)
         {
            while(captchaContainer.numChildren > 0)
            {
               captchaContainer.removeChildAt(0);
            }
         }
      }
      
      protected function handleTextLink(param1:TextEvent) : void
      {
         dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_TERMS,true,false));
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
      }
      
      public function lock(param1:Boolean) : void
      {
         this.lock_overlay.visible = param1;
      }
      
      protected function handleFocus(param1:FocusEvent) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         if(param1.type == FocusEvent.FOCUS_IN)
         {
            if(_loc2_.text == this.defaulttext[_loc2_.name])
            {
               _loc2_.defaultTextFormat = new TextFormat(null,null,0);
               _loc2_.displayAsPassword = this.displayAsPassword[_loc2_.name];
               _loc2_.text = "";
            }
         }
         else if(_loc2_.text == "")
         {
            _loc2_.defaultTextFormat = new TextFormat(null,null,10066329);
            _loc2_.displayAsPassword = false;
            _loc2_.text = this.defaulttext[_loc2_.name];
         }
      }
      
      public function hasEmptyFields() : Boolean
      {
         if(inpemail.text == this.defaulttext[inpemail.name])
         {
            bg_mail.gotoAndStop(2);
         }
         if(inppassword.text == this.defaulttext[inppassword.name])
         {
            bg_password.gotoAndStop(2);
         }
         if(inppassword2.text == this.defaulttext[inppassword2.name])
         {
            bg_password2.gotoAndStop(2);
         }
         if(inpcaptcha.text == this.defaulttext[inpcaptcha.name])
         {
            bg_captcha.gotoAndStop(2);
         }
         return bg_mail.currentFrame == 2 || bg_password.currentFrame == 2 || bg_password2.currentFrame == 2 || bg_captcha.currentFrame == 2;
      }
   }
}

