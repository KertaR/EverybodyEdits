package ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import playerio.Connection;
   import playerio.Message;
   import utilities.ColorUtil;
   
   public class BackgroundColorSelector extends assets_colorselector
   {
      
      private static var ColorWheel:Class = BackgroundColorSelector_ColorWheel;
      
      private static var colorWheelBMD:BitmapData = new ColorWheel().bitmapData;
      
      private var matrix:Matrix;
      
      private var adjColor:uint;
      
      private var previewColorColorTransform:ColorTransform;
      
      private var previewFill:MovieClip;
      
      private var adjusterFill:MovieClip;
      
      private var adjusterFillBMD:BitmapData;
      
      private var mouseDown:Boolean = false;
      
      private var adjMouseDown:Boolean;
      
      private var colorWheelBM:Bitmap;
      
      private var circleBorder:Sprite;
      
      private var colorWheelBMContainer:Sprite;
      
      private var conn:Connection;
      
      public function BackgroundColorSelector(param1:Connection)
      {
         var i:int;
         var hexCode:TextField = null;
         var c:Connection = param1;
         this.colorWheelBM = new Bitmap(colorWheelBMD);
         this.colorWheelBMContainer = new Sprite();
         super();
         this.conn = c;
         this.matrix = new Matrix();
         bg_mail.gotoAndStop(1);
         this.previewFill = colorPreview.getChildByName("fill") as MovieClip;
         this.adjusterFill = brightnessAdjuster.getChildByName("fill") as MovieClip;
         this.adjusterFillBMD = new BitmapData(this.adjusterFill.width,this.adjusterFill.height);
         this.adjusterFillBMD.draw(this.adjusterFill);
         i = 0;
         while(i < 4)
         {
            hexCode = getChildByName("hexLabel" + (i + 1)) as TextField;
            hexCode.text = "#" + (Global.cookie.data.previousColors[i] == null ? "000000" : ColorUtil.DecimalToHex(Global.cookie.data.previousColors[i]));
            hexCode.addEventListener(MouseEvent.CLICK,this.hexLabelClick);
            hexCode.addEventListener(MouseEvent.MOUSE_OUT,this.hexLabelOut);
            hexCode.addEventListener(MouseEvent.MOUSE_OVER,this.hexLabelOver);
            i++;
         }
         input_hex.maxChars = 7;
         input_hex.restrict = "a-fA-F0-9#";
         if(Global.backgroundEnabled)
         {
            input_hex.text = "#" + ColorUtil.DecimalToHex(Global.bgColor);
            this.updatePreviewColor(Global.bgColor);
            this.updateGradientBar(Global.bgColor);
         }
         else
         {
            input_hex.text = "none";
         }
         checkbox_background.buttonMode = true;
         checkbox_background.gotoAndStop(Global.backgroundEnabled ? 2 : 1);
         checkbox_background.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            checkbox_background.gotoAndStop(checkbox_background.currentFrame == 1 ? 2 : 1);
            var _loc2_:Boolean = checkbox_background.currentFrame == 2;
            input_hex.text = _loc2_ ? hexLabel4.text : "none";
            Global.backgroundEnabled = _loc2_;
         });
         this.colorWheelBMContainer.addChild(this.colorWheelBM);
         this.colorWheelBMContainer.addEventListener(MouseEvent.CLICK,this.colorWheelClick);
         this.colorWheelBMContainer.addEventListener(MouseEvent.MOUSE_MOVE,this.colorWheelMove);
         this.colorWheelBMContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.colorWheelDown);
         this.colorWheelBMContainer.x = colorPreview.x - this.colorWheelBM.width + colorPreview.width - 2;
         this.colorWheelBMContainer.y = colorPreview.y - this.colorWheelBM.height + colorPreview.height - 2;
         addChild(this.colorWheelBMContainer);
         this.circleBorder = new Sprite();
         this.circleBorder.graphics.lineStyle(3,6710886);
         this.circleBorder.graphics.drawCircle(0,0,75);
         this.circleBorder.graphics.endFill();
         this.circleBorder.mouseEnabled = false;
         this.circleBorder.x = this.colorWheelBMContainer.x + this.circleBorder.width / 2 - 2;
         this.circleBorder.y = this.colorWheelBMContainer.y + this.circleBorder.height / 2 - 2;
         addChild(this.circleBorder);
         brightnessAdjuster.getChildByName("fill").addEventListener(MouseEvent.MOUSE_DOWN,this.adjusterDown);
         brightnessAdjuster.getChildByName("fill").addEventListener(MouseEvent.CLICK,this.adjusterClick);
         brightnessAdjuster.getChildByName("fill").addEventListener(MouseEvent.MOUSE_MOVE,this.adjusterMove);
         addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
      }
      
      public function handleSave() : void
      {
         var _loc1_:String = null;
         if(Global.backgroundEnabled)
         {
            _loc1_ = input_hex.text.indexOf("#") != -1 ? input_hex.text.replace("#","") : input_hex.text;
            if(input_hex.text.length >= 6)
            {
               input_hex.text = "#" + _loc1_;
               input_hex.text = input_hex.text.slice(0,7);
               bg_mail.gotoAndStop(input_hex.text.length == 7 ? 1 : 2);
               if(input_hex.text.length == 7)
               {
                  this.conn.send("say","/bgcolor " + input_hex.text);
               }
            }
            else
            {
               bg_mail.gotoAndStop(2);
            }
         }
         else
         {
            this.conn.send("say","/bgcolor none");
         }
      }
      
      public function handleBackgroundChange(param1:Message, param2:uint) : void
      {
         Global.backgroundEnabled = (param2 >> 24 & 0xFF) == 255;
         if(Global.backgroundEnabled)
         {
            this.updateColorArray(Global.bgColor);
            this.updateHexLabels();
            this.updateGradientBar(Global.bgColor);
            this.updatePreviewColor(Global.bgColor);
            input_hex.text = "#" + ColorUtil.DecimalToHex(Global.bgColor);
            checkbox_background.gotoAndStop(2);
         }
         else
         {
            input_hex.text = "none";
            checkbox_background.gotoAndStop(1);
            this.updatePreviewColor(2105376);
            this.adjusterFill.graphics.clear();
         }
      }
      
      private function updateColorArray(param1:uint) : void
      {
         var _loc2_:int = 0;
         if(Global.cookie.data.previousColors.indexOf(param1) == -1)
         {
            Global.cookie.data.previousColors.push(param1);
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               Global.cookie.data.previousColors[_loc2_] = Global.cookie.data.previousColors[_loc2_ + 1];
               _loc2_++;
            }
            Global.cookie.data.previousColors.length = 4;
         }
      }
      
      private function updateHexLabels() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            (getChildByName("hexLabel" + (_loc1_ + 1)) as TextField).text = "#" + (Global.cookie.data.previousColors[_loc1_] == null ? "000000" : ColorUtil.DecimalToHex(Global.cookie.data.previousColors[_loc1_]));
            _loc1_++;
         }
      }
      
      private function updateGradientBar(param1:uint) : void
      {
         this.matrix.createGradientBox(21,165,Math.PI / 2,0,0);
         this.adjusterFill.graphics.clear();
         this.adjusterFill.graphics.beginGradientFill(GradientType.LINEAR,[16777215,param1,0],[1,1,1],[0,127.5,255],this.matrix,SpreadMethod.PAD);
         this.adjusterFill.graphics.drawRect(0,0,21,165);
         this.adjusterFill.graphics.endFill();
         this.adjusterFillBMD.draw(this.adjusterFill);
      }
      
      private function updatePreviewColor(param1:uint) : void
      {
         this.previewColorColorTransform = this.previewFill.transform.colorTransform;
         this.previewColorColorTransform.color = param1;
         this.previewFill.transform.colorTransform = this.previewColorColorTransform;
      }
      
      private function adjusterMove(param1:MouseEvent) : void
      {
         if(this.adjMouseDown && Global.backgroundEnabled)
         {
            this.getAdjusterColor(param1);
            this.updatePreviewColor(Global.bgColor);
         }
      }
      
      private function adjusterClick(param1:MouseEvent) : void
      {
         if(Global.backgroundEnabled)
         {
            this.getAdjusterColor(param1);
            this.updatePreviewColor(Global.bgColor);
         }
      }
      
      private function getAdjusterColor(param1:MouseEvent) : void
      {
         var _loc2_:uint = this.adjusterFillBMD.getPixel(3,param1.target.mouseY);
         var _loc3_:String = ColorUtil.DecimalToHex(_loc2_);
         this.updatePreviewColor(_loc2_);
         input_hex.text = "#" + _loc3_;
         Global.bgColor = _loc2_;
      }
      
      private function adjusterDown(param1:MouseEvent) : void
      {
         if(this.adjMouseDown == false)
         {
            this.adjMouseDown = true;
         }
      }
      
      private function colorWheelMove(param1:MouseEvent) : void
      {
         if(this.mouseDown && Global.backgroundEnabled)
         {
            this.getColorWheelValue(param1);
            this.updatePreviewColor(Global.bgColor);
            this.updateGradientBar(Global.bgColor);
         }
      }
      
      private function colorWheelClick(param1:MouseEvent) : void
      {
         if(Global.backgroundEnabled)
         {
            this.getColorWheelValue(param1);
            this.updatePreviewColor(Global.bgColor);
            this.updateGradientBar(Global.bgColor);
         }
      }
      
      private function getColorWheelValue(param1:MouseEvent) : void
      {
         var _loc2_:uint = colorWheelBMD.getPixel(param1.target.mouseX,param1.target.mouseY);
         var _loc3_:String = ColorUtil.DecimalToHex(_loc2_);
         input_hex.text = "#" + _loc3_;
         Global.bgColor = _loc2_;
      }
      
      private function colorWheelDown(param1:MouseEvent) : void
      {
         if(this.mouseDown == false)
         {
            this.mouseDown = true;
         }
      }
      
      private function hexLabelClick(param1:MouseEvent) : void
      {
         if(Global.backgroundEnabled)
         {
            this.conn.send("say","/bgcolor " + (param1.target as TextField).text);
         }
      }
      
      private function hexLabelOver(param1:MouseEvent) : void
      {
         if(Global.backgroundEnabled)
         {
            this.setHexLabelColor(param1,16777215);
         }
      }
      
      private function hexLabelOut(param1:MouseEvent) : void
      {
         if(Global.backgroundEnabled)
         {
            this.setHexLabelColor(param1,10066329);
         }
      }
      
      private function setHexLabelColor(param1:MouseEvent, param2:uint) : void
      {
         if(!(param1.target as TextField).getTextFormat().color != param2)
         {
            (param1.target as TextField).setTextFormat(new TextFormat(null,null,param2));
         }
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         if(this.mouseDown)
         {
            this.mouseDown = false;
         }
         if(this.adjMouseDown)
         {
            this.adjMouseDown = false;
         }
      }
   }
}

