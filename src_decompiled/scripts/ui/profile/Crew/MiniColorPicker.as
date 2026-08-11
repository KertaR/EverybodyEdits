package ui.profile.Crew
{
   import blitter.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import playerio.*;
   import utilities.ColorUtil;
   
   public class MiniColorPicker extends assets_profilecolor
   {
      
      private static var ColorWheel:Class = MiniColorPicker_ColorWheel;
      
      private static var colorWheelBMD:BitmapData = new ColorWheel().bitmapData;
      
      private var matrix:Matrix;
      
      private var previewColorColorTransform:ColorTransform;
      
      private var currentColor:uint;
      
      private var adjColor:uint;
      
      private var previewFill:MovieClip;
      
      private var adjusterFill:MovieClip;
      
      private var colorWheelBM:Bitmap;
      
      private var adjusterFillBMD:BitmapData;
      
      private var mouseDown:Boolean = false;
      
      private var adjMouseDown:Boolean;
      
      private var callback:Function;
      
      private var currentlyChecked:String;
      
      private var selectedColor:ColorTransform;
      
      private var newTextColor:uint;
      
      private var newPrimaryColor:uint;
      
      private var newSecondaryColor:uint;
      
      private var circleBorder:Sprite;
      
      private var colorWheelBMContainer:Sprite;
      
      public function MiniColorPicker(param1:uint, param2:uint, param3:uint, param4:Boolean, param5:Function, param6:Function)
      {
         var currentTextColor:uint = param1;
         var currentPrimaryColor:uint = param2;
         var currentSecondaryColor:uint = param3;
         var enabled:Boolean = param4;
         var callback:Function = param5;
         var saveCallback:Function = param6;
         this.colorWheelBM = new Bitmap(colorWheelBMD);
         this.colorWheelBMContainer = new Sprite();
         super();
         disabledOverlay.visible = !enabled;
         this.newTextColor = currentTextColor;
         this.newPrimaryColor = currentPrimaryColor;
         this.newSecondaryColor = currentSecondaryColor;
         this.callback = callback;
         this.matrix = new Matrix();
         bg_mail.gotoAndStop(1);
         this.previewFill = colorPreview.getChildByName("fill") as MovieClip;
         this.adjusterFill = brightnessAdjuster.getChildByName("fill") as MovieClip;
         this.adjusterFillBMD = new BitmapData(this.adjusterFill.width,this.adjusterFill.height);
         this.adjusterFillBMD.draw(this.adjusterFill);
         this.currentlyChecked = "text";
         textCheck.gotoAndStop(2);
         primaryCheck.gotoAndStop(1);
         secondaryCheck.gotoAndStop(1);
         textCheck.addEventListener(MouseEvent.CLICK,this.handleCheckClick);
         primaryCheck.addEventListener(MouseEvent.CLICK,this.handleCheckClick);
         secondaryCheck.addEventListener(MouseEvent.CLICK,this.handleCheckClick);
         input_hex.maxChars = 7;
         input_hex.restrict = "a-f A-F 0-9 #";
         input_hex.addEventListener(Event.CHANGE,this.handleHexChange);
         this.selectedColor = new ColorTransform();
         this.selectedColor.color = currentTextColor;
         input_hex.text = "#" + ColorUtil.DecimalToHex(currentTextColor);
         this.updatePreviewColor(currentTextColor,true);
         btn_save.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            if(currentlyChecked == "text" && currentColor != currentTextColor)
            {
               currentTextColor = currentColor;
               saveCallback();
            }
            else if(currentlyChecked == "primary" && currentColor != currentPrimaryColor)
            {
               currentPrimaryColor = currentColor;
               saveCallback();
            }
            else if(currentlyChecked == "secondary" && currentColor != currentSecondaryColor)
            {
               currentSecondaryColor = currentColor;
               saveCallback();
            }
         });
         this.colorWheelBMContainer.addChild(this.colorWheelBM);
         this.colorWheelBMContainer.addEventListener(MouseEvent.CLICK,this.colorWheelClick);
         this.colorWheelBMContainer.addEventListener(MouseEvent.MOUSE_MOVE,this.colorWheelMove);
         this.colorWheelBMContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.colorWheelDown);
         this.colorWheelBMContainer.x = colorPreview.x - this.colorWheelBM.width + colorPreview.width - 2;
         this.colorWheelBMContainer.y = colorPreview.y - this.colorWheelBM.height + colorPreview.height - 2;
         addChildAt(this.colorWheelBMContainer,getChildIndex(colorPreview) + 1);
         this.circleBorder = new Sprite();
         this.circleBorder.graphics.lineStyle(3,6710886);
         this.circleBorder.graphics.drawCircle(0,0,75);
         this.circleBorder.graphics.endFill();
         this.circleBorder.mouseEnabled = false;
         this.circleBorder.x = this.colorWheelBMContainer.x + this.circleBorder.width / 2 - 2;
         this.circleBorder.y = this.colorWheelBMContainer.y + this.circleBorder.height / 2 - 2;
         addChildAt(this.circleBorder,getChildIndex(colorPreview) + 2);
         brightnessAdjuster.getChildByName("fill").addEventListener(MouseEvent.MOUSE_DOWN,this.adjusterDown);
         brightnessAdjuster.getChildByName("fill").addEventListener(MouseEvent.MOUSE_OUT,this.adjusterOut);
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
      
      private function handleHexChange(param1:Event) : void
      {
         var _loc2_:String = null;
         if(this.currentlyChecked != "")
         {
            _loc2_ = input_hex.text.indexOf("#") != -1 ? input_hex.text.replace("#","") : input_hex.text;
            if(_loc2_.length >= 6)
            {
               input_hex.text = "#" + _loc2_;
               input_hex.text = input_hex.text.slice(0,7);
               bg_mail.gotoAndStop(input_hex.text.length == 7 ? 1 : 2);
               this.currentColor = uint("0x" + _loc2_);
               this.callback(this.currentlyChecked,this.currentColor);
               this.updatePreviewColor(this.currentColor);
               this.setTextValueBySelected(this.currentlyChecked);
            }
            else
            {
               bg_mail.gotoAndStop(2);
            }
         }
      }
      
      private function handleCheckClick(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case textCheck:
               this.currentlyChecked = "text";
               textCheck.gotoAndStop(2);
               primaryCheck.gotoAndStop(1);
               secondaryCheck.gotoAndStop(1);
               this.setTextValue(this.newTextColor);
               this.updatePreviewColor(this.newTextColor,true);
               break;
            case primaryCheck:
               this.currentlyChecked = "primary";
               textCheck.gotoAndStop(1);
               primaryCheck.gotoAndStop(2);
               secondaryCheck.gotoAndStop(1);
               this.setTextValue(this.newPrimaryColor);
               this.updatePreviewColor(this.newPrimaryColor,true);
               break;
            case secondaryCheck:
               this.currentlyChecked = "secondary";
               textCheck.gotoAndStop(1);
               primaryCheck.gotoAndStop(1);
               secondaryCheck.gotoAndStop(2);
               this.setTextValue(this.newSecondaryColor);
               this.updatePreviewColor(this.newSecondaryColor,true);
         }
      }
      
      private function setTextValueBySelected(param1:String) : void
      {
         switch(param1)
         {
            case "text":
               this.setTextValue(this.newTextColor);
               break;
            case "primary":
               this.setTextValue(this.newPrimaryColor);
               break;
            case "secondary":
               this.setTextValue(this.newSecondaryColor);
         }
      }
      
      private function setTextValue(param1:uint) : void
      {
         input_hex.text = "#" + ColorUtil.DecimalToHex(param1);
      }
      
      private function saveButtonHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(this.currentlyChecked != "")
         {
            _loc2_ = input_hex.text.indexOf("#") != -1 ? input_hex.text.replace("#","") : input_hex.text;
            if(input_hex.text.length >= 6)
            {
               input_hex.text = "#" + _loc2_;
               input_hex.text = input_hex.text.slice(0,7);
               bg_mail.gotoAndStop(input_hex.text.length == 7 ? 1 : 2);
               this.currentColor = uint("0x" + _loc2_);
               this.callback(this.currentlyChecked,this.currentColor);
               this.updatePreviewColor(this.currentColor);
               this.setTextValueBySelected(this.currentlyChecked);
            }
            else
            {
               bg_mail.gotoAndStop(2);
            }
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
      
      private function updatePreviewColor(param1:uint, param2:Boolean = false) : void
      {
         this.previewColorColorTransform = this.previewFill.transform.colorTransform;
         this.previewColorColorTransform.color = param1;
         this.previewFill.transform.colorTransform = this.previewColorColorTransform;
         if(param2 == false)
         {
            switch(this.currentlyChecked)
            {
               case "text":
                  this.newTextColor = this.currentColor;
                  break;
               case "primary":
                  this.newPrimaryColor = this.currentColor;
                  break;
               case "secondary":
                  this.newSecondaryColor = this.currentColor;
            }
            this.callback(this.currentlyChecked,this.currentColor);
         }
      }
      
      private function adjusterMove(param1:MouseEvent) : void
      {
         if(this.adjMouseDown)
         {
            this.getAdjusterColor(param1);
            this.updatePreviewColor(this.currentColor);
         }
      }
      
      private function adjusterClick(param1:MouseEvent) : void
      {
         this.getAdjusterColor(param1);
         this.updatePreviewColor(this.currentColor);
      }
      
      private function getAdjusterColor(param1:MouseEvent) : void
      {
         var _loc2_:uint = this.adjusterFillBMD.getPixel(3,param1.target.mouseY);
         var _loc3_:String = ColorUtil.DecimalToHex(_loc2_);
         this.updatePreviewColor(uint("0x" + _loc3_));
         input_hex.text = "#" + _loc3_;
         this.currentColor = uint("0x" + _loc3_);
         switch(this.currentlyChecked)
         {
            case "text":
               this.newTextColor = this.currentColor;
               break;
            case "primary":
               this.newPrimaryColor = this.currentColor;
               break;
            case "secondary":
               this.newSecondaryColor = this.currentColor;
         }
      }
      
      private function adjusterDown(param1:MouseEvent) : void
      {
         if(this.adjMouseDown == false)
         {
            this.adjMouseDown = true;
         }
      }
      
      private function adjusterOut(param1:MouseEvent) : void
      {
         if(this.adjMouseDown == true)
         {
            this.adjMouseDown = false;
         }
      }
      
      private function colorWheelMove(param1:MouseEvent) : void
      {
         if(this.mouseDown)
         {
            this.getColorWheelValue(param1);
            this.updatePreviewColor(this.currentColor);
            this.updateGradientBar(this.currentColor);
         }
      }
      
      private function colorWheelClick(param1:MouseEvent) : void
      {
         this.getColorWheelValue(param1);
         this.updatePreviewColor(this.currentColor);
         this.updateGradientBar(this.currentColor);
      }
      
      private function getColorWheelValue(param1:MouseEvent) : void
      {
         var _loc2_:uint = colorWheelBMD.getPixel(param1.target.mouseX,param1.target.mouseY);
         input_hex.text = "#" + ColorUtil.DecimalToHex(_loc2_);
         this.currentColor = _loc2_;
      }
      
      private function colorWheelDown(param1:MouseEvent) : void
      {
         if(this.mouseDown == false)
         {
            this.mouseDown = true;
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

