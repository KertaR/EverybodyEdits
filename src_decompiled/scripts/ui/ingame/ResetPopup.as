package ui.ingame
{
   import blitter.BlSprite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class ResetPopup extends BlSprite
   {
      
      private var ResetPopupImage:Class;
      
      private var resetPopupBMD:BitmapData;
      
      public function ResetPopup()
      {
         var _loc1_:TextField = null;
         this.ResetPopupImage = ResetPopup_ResetPopupImage;
         this.resetPopupBMD = new this.ResetPopupImage().bitmapData;
         _loc1_ = new TextField();
         _loc1_.y = this.resetPopupBMD.height + 14;
         _loc1_.multiline = true;
         _loc1_.selectable = false;
         _loc1_.wordWrap = false;
         _loc1_.width = 75;
         _loc1_.height = 50;
         _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         _loc1_.autoSize = TextFieldAutoSize.CENTER;
         var _loc2_:TextFormat = new TextFormat("Tahoma",9,16777215);
         _loc2_.align = TextFormatAlign.CENTER;
         _loc1_.defaultTextFormat = _loc2_;
         _loc1_.appendText("Press Y to restart world.");
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Sprite = new Sprite();
         var _loc5_:Number = Math.max(_loc1_.width + 6,90);
         var _loc6_:Number = Math.max(_loc1_.y + _loc1_.height,30);
         var _loc7_:String = GradientType.LINEAR;
         var _loc8_:Array = [0,0];
         var _loc9_:Array = [0.5,0.3];
         var _loc10_:Array = [0,255];
         var _loc11_:Matrix = new Matrix();
         _loc11_.createGradientBox(20,_loc6_ + 3,Math.PI / 2,0,0);
         var _loc12_:String = SpreadMethod.PAD;
         _loc4_.graphics.beginGradientFill(_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
         _loc4_.graphics.lineStyle(0,16777215);
         _loc4_.graphics.moveTo(0,0);
         _loc4_.graphics.lineTo(_loc5_,0);
         _loc4_.graphics.lineTo(_loc5_,_loc6_ + 3);
         _loc4_.graphics.lineTo(_loc5_ / 2 + 3,_loc6_ + 3);
         _loc4_.graphics.lineTo(_loc5_ / 2,_loc6_ + 10);
         _loc4_.graphics.lineTo(_loc5_ / 2 - 3,_loc6_ + 3);
         _loc4_.graphics.lineTo(0,_loc6_ + 3);
         _loc4_.graphics.lineTo(0,0);
         _loc4_.graphics.lineStyle(0,0);
         var _loc13_:Sprite = new Sprite();
         var _loc14_:BitmapData = new BitmapData(_loc4_.width,_loc4_.height,true,0);
         _loc14_.draw(_loc4_);
         _loc13_.x = 1;
         _loc13_.addChild(new Bitmap(_loc14_));
         var _loc15_:GlowFilter = new GlowFilter(0,0.5,4,4,3,3,false,true);
         _loc13_.filters = [_loc15_];
         _loc1_.x = (_loc5_ - _loc1_.width) / 2 >> 0;
         _loc3_.addChild(_loc1_);
         _loc3_.addChildAt(_loc4_,0);
         _loc3_.addChildAt(_loc13_,0);
         var _loc16_:BitmapData = new BitmapData(_loc3_.width + 4,_loc3_.height + 4,true,0);
         _loc16_.draw(_loc3_);
         var _loc17_:Matrix = new Matrix();
         _loc17_.translate((_loc5_ - this.resetPopupBMD.width) / 2,10);
         _loc16_.draw(this.resetPopupBMD,_loc17_);
         super(_loc16_,0,0,_loc16_.width,_loc16_.height,1);
         rect = _loc16_.rect;
         frames = 1;
         width = rect.width;
         height = rect.height;
         x = -(width / 2 >> 0) + 8;
         y = -height + 3;
      }
      
      override public function drawPoint(param1:BitmapData, param2:Point, param3:int = 0) : void
      {
         draw(param1,param2.x,param2.y);
      }
   }
}

