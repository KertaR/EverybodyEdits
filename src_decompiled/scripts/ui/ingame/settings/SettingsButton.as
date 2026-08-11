package ui.ingame.settings
{
   import blitter.BlText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   
   public class SettingsButton extends Sprite
   {
      
      public static var DEFAULT_WIDTH:int = 54;
      
      public static var DEFAULT_HEIGHT:int = 29;
      
      public var WIDTH:int = DEFAULT_WIDTH;
      
      public var HEIGHT:int = DEFAULT_HEIGHT;
      
      private var label:BlText;
      
      private var text:String;
      
      private var matrix:Matrix;
      
      private var subOptions:Array;
      
      public var subOptionsContainer:Sprite;
      
      private var triangle:Sprite;
      
      private var clickCallback:Function;
      
      private var image:Bitmap;
      
      private var imageBMD:BitmapData;
      
      public function SettingsButton(param1:String, param2:BitmapData, param3:Function, param4:Array = null)
      {
         super();
         this.text = param1;
         this.imageBMD = param2;
         this.subOptions = param4;
         this.clickCallback = param3;
         var _loc5_:Boolean = param1 == "" && param2 == null;
         if(!_loc5_)
         {
            this.buttonMode = true;
            this.useHandCursor = true;
            this.mouseEnabled = true;
            this.setSubOptions(param4);
            if(param3 != null)
            {
               this.setClickCallback(param3);
            }
         }
         this.matrix = new Matrix();
         this.matrix.createGradientBox(this.WIDTH,this.HEIGHT,Math.PI / 2);
         this.redraw();
      }
      
      private function redraw() : void
      {
         var _loc1_:Bitmap = null;
         graphics.clear();
         graphics.lineStyle(1,8092539);
         graphics.beginGradientFill(GradientType.LINEAR,[3223857,2105376],[1,1],[0,255],this.matrix,SpreadMethod.PAD);
         graphics.drawRect(0,-1,this.WIDTH,this.HEIGHT);
         graphics.endFill();
         if(this.text != "")
         {
            this.label = new BlText(13,this.WIDTH,16777215,"center","visitor");
            this.label.text = this.text;
            _loc1_ = new Bitmap(this.label.clone());
            _loc1_.x = Math.round((this.WIDTH - _loc1_.width) / 2 + 1);
            _loc1_.y = Math.round((this.HEIGHT - _loc1_.height) / 2 - 1);
            addChild(_loc1_);
         }
         if(this.imageBMD != null)
         {
            this.updateImage(this.imageBMD);
         }
         mouseChildren = false;
      }
      
      public function updateImage(param1:BitmapData) : void
      {
         if(this.image != null && contains(this.image))
         {
            removeChild(this.image);
         }
         this.image = new Bitmap(param1);
         this.image.x = Math.round((this.WIDTH - this.image.width) / 2);
         this.image.y = Math.round((this.HEIGHT - this.image.height) / 2) - 1;
         addChild(this.image);
      }
      
      public function toggleSubOptionsVisible(param1:Boolean) : void
      {
         this.subOptionsContainer.visible = param1;
      }
      
      protected function handleMouse(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               this.toggleSubOptionsVisible(true);
               break;
            case MouseEvent.MOUSE_OUT:
               this.toggleSubOptionsVisible(false);
         }
      }
      
      public function setClickCallback(param1:Function) : void
      {
         if(param1 != null)
         {
            addEventListener(MouseEvent.CLICK,param1);
         }
      }
      
      public function setSubOptions(param1:Array) : void
      {
         var i:int = 0;
         var tSize:int = 0;
         var button:SettingsButton = null;
         var subOptions:Array = param1;
         if(subOptions != null && subOptions.length > 0)
         {
            this.subOptionsContainer = new Sprite();
            this.subOptionsContainer.visible = false;
            i = 0;
            while(i < subOptions.length)
            {
               button = subOptions[i] as SettingsButton;
               button.y = i * this.HEIGHT;
               this.subOptionsContainer.addChild(button);
               i++;
            }
            tSize = 4;
            this.triangle = new Sprite();
            this.triangle.x = this.WIDTH - tSize;
            this.triangle.mouseEnabled = false;
            this.triangle.graphics.clear();
            this.triangle.graphics.beginFill(16777215);
            this.triangle.graphics.moveTo(0,0);
            this.triangle.graphics.lineTo(tSize,0);
            this.triangle.graphics.lineTo(tSize,tSize);
            this.triangle.graphics.lineTo(0,0);
            this.triangle.graphics.endFill();
            addChild(this.triangle);
            this.subOptionsContainer.x = this.WIDTH;
            this.subOptionsContainer.y = -((subOptions.length - 1) * 29);
            addChild(this.subOptionsContainer);
            addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
            this.setClickCallback(function():void
            {
               toggleSubOptionsVisible(!subOptionsContainer.visible);
            });
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this.WIDTH = param1;
         this.HEIGHT = param2;
         this.redraw();
      }
   }
}

