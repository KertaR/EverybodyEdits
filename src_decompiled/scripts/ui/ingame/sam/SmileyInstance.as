package ui.ingame.sam
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import items.ItemSmiley;
   import ui.HoverLabel;
   import ui2.ui2smileyinstance;
   
   public class SmileyInstance extends ui2smileyinstance
   {
      
      private var _item:ItemSmiley;
      
      private var _sp:Sprite = new Sprite();
      
      private var _ss:UI2;
      
      private var _hitBox:Sprite;
      
      private var hoverLabel:HoverLabel;
      
      private var hovertimer:uint;
      
      private var _index:int;
      
      public var bm:Bitmap;
      
      private var _hoverZoom:Boolean;
      
      public function SmileyInstance(param1:ItemSmiley, param2:UI2, param3:Boolean, param4:int = -1, param5:Boolean = true)
      {
         super();
         this._item = param1;
         this._ss = param2;
         this._index = param4;
         this._hoverZoom = param5;
         this.hoverLabel = new HoverLabel();
         this.hoverLabel.visible = false;
         this.bm = new Bitmap(param1.bmd);
         this.updateBorder(param3);
         this._sp.mouseEnabled = false;
         this._sp.mouseChildren = false;
         addChild(this._sp);
         this._hitBox = new Sprite();
         this._hitBox.graphics.beginFill(0,0);
         this._hitBox.graphics.drawRect(0,0,26,26);
         this._hitBox.graphics.endFill();
         addChild(this.hitBox);
         if(param5)
         {
            this._sp.filters = [new DropShadowFilter(3,45,0,0.6,3,3)];
            this._hitBox.buttonMode = true;
            this._hitBox.useHandCursor = true;
            this._hitBox.doubleClickEnabled = true;
            this._hitBox.addEventListener(MouseEvent.DOUBLE_CLICK,this.handleSmileyDoubleClick);
            this._hitBox.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            this._hitBox.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
         }
      }
      
      public function updateBorder(param1:Boolean) : void
      {
         if(Boolean(this.bm) && this._sp.contains(this.bm))
         {
            this._sp.removeChild(this.bm);
         }
         this.bm = new Bitmap(param1 ? this.item.bmdGold : this.item.bmd);
         this._sp.addChild(this.bm);
      }
      
      protected function handleSmileyDoubleClick(param1:MouseEvent) : void
      {
         if(Global.playerObject.goldmember)
         {
            Global.base.setGoldBorder(!Global.playerInstance.wearsGoldSmiley);
         }
      }
      
      protected function handleMouse(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(parent)
         {
            switch(e.type)
            {
               case MouseEvent.MOUSE_OVER:
                  if(this._hoverZoom)
                  {
                     this.scaleImage(this,2,0.3);
                     this.hovertimer = setTimeout(function():void
                     {
                        if(parent)
                        {
                           parent.addChild(hoverLabel);
                        }
                        hoverLabel.alpha = 0;
                        TweenMax.to(hoverLabel,0.25,{"alpha":1});
                        hoverLabel.draw(item.name + " [" + item.id + "]");
                        hoverLabel.visible = true;
                        setHoverLabelPosition();
                     },400);
                  }
                  break;
               case MouseEvent.MOUSE_OUT:
                  this.scaleImage(this,1,0.3);
                  TweenMax.to(this.hoverLabel,0.2,{"alpha":0});
                  clearInterval(this.hovertimer);
                  break;
               case MouseEvent.MOUSE_MOVE:
                  if(this.hoverLabel.visible)
                  {
                     this.hoverLabel.draw(this.item.name);
                     this.setHoverLabelPosition();
                  }
            }
         }
      }
      
      public function scaleImage(param1:*, param2:Number, param3:Number = 0.2, param4:int = 1, param5:Function = null) : void
      {
         var smiley:SmileyInstance = null;
         var object:* = param1;
         var scale:Number = param2;
         var time:Number = param3;
         var alpha:int = param4;
         var onCompleteCallback:Function = param5;
         smiley = object as SmileyInstance;
         TweenMax.to(smiley.sp,time,{
            "alpha":alpha,
            "scaleX":scale,
            "scaleY":scale,
            "onUpdate":function():void
            {
               smiley.sp.x = (26 - smiley.sp.width) / 2;
               smiley.sp.y = (26 - smiley.sp.height) / 2;
               if(parent)
               {
                  parent.setChildIndex(smiley,parent.numChildren - 1);
               }
            },
            "onComplete":onCompleteCallback,
            "ease":Back.easeOut
         });
      }
      
      private function setHoverLabelPosition() : void
      {
         if(parent)
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
            this.hoverLabel.y = parent.mouseY - this.hoverLabel.height / 2;
         }
      }
      
      public function get item() : ItemSmiley
      {
         return this._item;
      }
      
      public function get sp() : Sprite
      {
         return this._sp;
      }
      
      public function get hitBox() : Sprite
      {
         return this._hitBox;
      }
      
      public function destroy(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.scaleImage(this,0.1,0.3,0,this.removeThis);
         }
         else
         {
            this.removeThis();
         }
      }
      
      private function removeThis() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
   }
}

