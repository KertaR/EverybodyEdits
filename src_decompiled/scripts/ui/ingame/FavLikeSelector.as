package ui.ingame
{
   import blitter.Bl;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import ui.HoverLabel;
   
   public class FavLikeSelector extends MovieClip
   {
      
      private static var Favorite:Class = FavLikeSelector_Favorite;
      
      public static var favBMD:BitmapData = new Favorite().bitmapData;
      
      private static var Like:Class = FavLikeSelector_Like;
      
      public static var likeBMD:BitmapData = new Like().bitmapData;
      
      private var masker:Sprite = new Sprite();
      
      private var bg:Sprite = new Sprite();
      
      private var favButtonContainer:Sprite = new Sprite();
      
      private var likeButtonContainer:Sprite = new Sprite();
      
      public var basiswidth:Number = 70;
      
      private var favButtonBMD:BitmapData = new BitmapData(35,28,true,0);
      
      private var favButton:Bitmap = new Bitmap(this.favButtonBMD);
      
      private var likeButtonBMD:BitmapData = new BitmapData(35,28,true,0);
      
      private var likeButton:Bitmap = new Bitmap(this.likeButtonBMD);
      
      private var hoverlabel:HoverLabel;
      
      private var hovertimer:uint;
      
      private var disabledFav:Boolean;
      
      private var disabledLike:Boolean;
      
      public function FavLikeSelector(param1:int, param2:int)
      {
         super();
         this.hoverlabel = new HoverLabel();
         this.hoverlabel.visible = false;
         addChild(this.bg);
         addChild(this.masker);
         this.mask = this.masker;
         this.bg.filters = [new DropShadowFilter(0,45,0,1,4,4,1,3)];
         this.setFavoriteState(param1);
         this.setLikeState(param2);
         this.favButtonContainer.buttonMode = true;
         this.favButtonContainer.useHandCursor = true;
         this.favButtonContainer.addChild(this.favButton);
         addChild(this.favButtonContainer);
         this.likeButtonContainer.buttonMode = true;
         this.likeButtonContainer.useHandCursor = true;
         this.likeButtonContainer.addChild(this.likeButton);
         addChild(this.likeButtonContainer);
         this.likeButtonContainer.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse,false,0,true);
         this.likeButtonContainer.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse,false,0,true);
         this.likeButtonContainer.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
         this.likeButtonContainer.addEventListener(MouseEvent.CLICK,this.handleLikeButton);
         this.favButtonContainer.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse,false,0,true);
         this.favButtonContainer.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse,false,0,true);
         this.favButtonContainer.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
         this.favButtonContainer.addEventListener(MouseEvent.CLICK,this.handleFavButton);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
      }
      
      public function disableFavoriteButton() : void
      {
         this.favButtonContainer.buttonMode = false;
         this.favButtonContainer.useHandCursor = false;
         this.disabledFav = true;
      }
      
      public function disableLikeButton() : void
      {
         this.likeButtonContainer.buttonMode = false;
         this.likeButtonContainer.useHandCursor = false;
         this.disabledLike = true;
      }
      
      private function handleLikeButton(param1:MouseEvent) : void
      {
         if(this.disabledLike)
         {
            return;
         }
         if(!Bl.data.liked)
         {
            Global.base.giveLike();
         }
         else
         {
            Global.base.removeLike();
         }
      }
      
      private function handleFavButton(param1:MouseEvent) : void
      {
         if(this.disabledFav)
         {
            return;
         }
         if(!Bl.data.inFavorites)
         {
            Global.base.addToFavorites();
         }
         else
         {
            Global.base.removeFromFavorites();
         }
      }
      
      public function setFavoriteState(param1:int) : void
      {
         this.favButtonBMD.copyPixels(favBMD,new Rectangle(param1 * 35,0,35,28),new Point());
      }
      
      public function setLikeState(param1:int) : void
      {
         this.likeButtonBMD.copyPixels(likeBMD,new Rectangle(param1 * 35,0,35,28),new Point());
      }
      
      private function redraw() : void
      {
         if(this.favButton)
         {
            this.favButtonContainer.x = this.basiswidth / 2;
         }
         var _loc1_:Graphics = this.bg.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,8092539,1);
         _loc1_.beginFill(3289649,0.85);
         _loc1_.drawRect(0,0,this.basiswidth / 2,28);
         _loc1_.beginFill(3289649,0.85);
         _loc1_.drawRect(this.basiswidth / 2,0,this.basiswidth / 2,28);
         _loc1_.endFill();
         this.y = -58;
         var _loc2_:Graphics = this.masker.graphics;
         _loc2_.clear();
         _loc2_.beginFill(16777215,1);
         _loc2_.drawRect(-5,-5,this.basiswidth + 11,33);
         _loc2_.endFill();
      }
      
      protected function handleMouseMove(param1:MouseEvent = null) : void
      {
         if(!this.hoverlabel.visible)
         {
            return;
         }
         this.hoverlabel.x = parent.mouseX - this.hoverlabel.width / 2;
         this.hoverlabel.y = parent.mouseY - this.hoverlabel.height - 15;
         if(this.hoverlabel.x + this.hoverlabel.width > Config.width)
         {
            this.hoverlabel.x = Config.width - this.hoverlabel.width;
         }
      }
      
      protected function handleMouse(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            this.hovertimer = setTimeout(this.showHoverLabel,1000,param1.target);
         }
         else
         {
            this.hoverlabel.visible = false;
            clearInterval(this.hovertimer);
         }
      }
      
      public function showHoverLabel(param1:Sprite) : void
      {
         parent.addChild(this.hoverlabel);
         var _loc2_:String = "";
         if(param1 == this.likeButtonContainer)
         {
            if(Bl.data.liked)
            {
               _loc2_ = "Unlike this world!";
            }
            else if(!this.disabledLike)
            {
               _loc2_ = "Give this world a like!";
            }
            else
            {
               _loc2_ = "You must rejoin to like this world again.";
            }
         }
         else if(param1 == this.favButtonContainer)
         {
            if(Bl.data.inFavorites)
            {
               _loc2_ = "Remove this world from your favorites!";
            }
            else if(!this.disabledFav)
            {
               _loc2_ = "Add this world to your favorites!";
            }
            else
            {
               _loc2_ = "You must rejoin to favorite this world again.";
            }
         }
         this.hoverlabel.draw(_loc2_);
         this.hoverlabel.visible = true;
         this.handleMouseMove();
      }
      
      override public function get width() : Number
      {
         return this.basiswidth;
      }
      
      private function handleAttach(param1:Event) : void
      {
         this.redraw();
      }
   }
}

