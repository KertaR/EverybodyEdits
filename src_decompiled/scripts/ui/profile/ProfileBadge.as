package ui.profile
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import playerio.*;
   import sample.ui.components.*;
   import ui.BadgeInstance;
   import ui.HoverLabel;
   import ui.campaigns.Clock;
   import ui.campaigns.ClockTime;
   
   public class ProfileBadge extends Box
   {
      
      private static var Corners:Class = ProfileBadge_Corners;
      
      private static var cornersBMD:BitmapData = new Corners().bitmapData;
      
      private static const tempRect:Rectangle = new Rectangle(0,0,32,32);
      
      private static const tempPoint:Point = new Point();
      
      private var hoverLabel:HoverLabel;
      
      private var hovertimer:uint;
      
      public function ProfileBadge(param1:Achievement, param2:Array = null, param3:int = 0)
      {
         var _loc8_:Object = null;
         var _loc9_:BitmapData = null;
         var _loc10_:Bitmap = null;
         var _loc11_:Clock = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         super();
         margin(NaN,NaN,0);
         var _loc4_:Sprite = new Sprite();
         var _loc5_:BadgeInstance = Badges.getBadge(param1.id);
         _loc5_.x = _loc5_.y = 0;
         _loc4_.addChild(_loc5_);
         _loc4_.x = 23;
         _loc4_.y = 0;
         addChild(_loc4_);
         var _loc6_:Label = new Label(param1.title,13,"center",16777215,false,"visitor");
         _loc6_.width = 100;
         _loc6_.y = 64;
         _loc6_.x = 55 - _loc6_.width / 2;
         addChild(_loc6_);
         var _loc7_:int = 0;
         if(param2)
         {
            _loc7_ = 5;
            for each(_loc8_ in param2)
            {
               if(Boolean(_loc8_.enabled) && _loc8_.rank < _loc7_)
               {
                  _loc7_ = int(_loc8_.rank);
               }
            }
         }
         if(_loc7_ > 0)
         {
            _loc9_ = new BitmapData(32,32,true,0);
            tempRect.x = param3 * 32;
            _loc9_.copyPixels(cornersBMD,tempRect,tempPoint);
            _loc10_ = new Bitmap(_loc9_);
            _loc4_.addChild(_loc10_);
            _loc11_ = new Clock(_loc7_);
            _loc11_.x = _loc11_.y = 4;
            _loc4_.addChild(_loc11_);
         }
         if(param2)
         {
            _loc12_ = "";
            _loc13_ = 0;
            while(_loc13_ < param2.length)
            {
               if(Boolean(param2[_loc13_].enabled) && param2[_loc13_].time >= 0)
               {
                  _loc12_ += (_loc12_ == "" ? "" : "\n") + "Level " + (_loc13_ + 1) + ": " + ClockTime.format(param2[_loc13_].time);
               }
               _loc13_++;
            }
            if(_loc12_ != "")
            {
               this.hoverLabel = new HoverLabel();
               this.hoverLabel.visible = false;
               this.hoverLabel.draw(_loc12_);
               this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
               this.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
               this.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouse);
            }
         }
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(e.type == MouseEvent.MOUSE_OVER)
         {
            this.hovertimer = setTimeout(function():void
            {
               parent.addChild(hoverLabel);
               hoverLabel.alpha = 0;
               TweenMax.to(hoverLabel,0.25,{"alpha":1});
               hoverLabel.visible = true;
               setHoverLabelPosition();
            },400);
         }
         else if(e.type == MouseEvent.MOUSE_MOVE)
         {
            if(this.hoverLabel.visible)
            {
               this.setHoverLabelPosition();
            }
         }
         else if(e.type == MouseEvent.MOUSE_OUT)
         {
            TweenMax.to(this.hoverLabel,0.2,{"alpha":0});
            clearInterval(this.hovertimer);
         }
      }
      
      private function setHoverLabelPosition() : void
      {
         this.hoverLabel.x = parent.mouseX;
         if(this.hoverLabel.x > parent.width / 2)
         {
            this.hoverLabel.x -= this.hoverLabel.w + 12;
         }
         else
         {
            this.hoverLabel.x += 12;
         }
         this.hoverLabel.y = parent.mouseY;
      }
   }
}

