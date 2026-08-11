package ui.roomlist
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import io.player.tools.Badwords;
   import playerio.*;
   import sample.ui.components.Label;
   import ui.WorldPreview;
   import utilities.ColorUtil;
   
   public class MinimapPreview extends Sprite
   {
      
      private static const PAD:Number = 8;
      
      private var _width:Number = 200;
      
      private var _height:Number = 200;
      
      private var bg:Sprite;
      
      private var close:ProfileCloseButton;
      
      private var loading:assets_miniloading;
      
      private var labelTitle:Label;
      
      private var contOwner:Sprite;
      
      private var labelOwner:Label;
      
      private var contCrew:Sprite;
      
      private var labelCrew:Label;
      
      private var labelDesc:Label;
      
      private var labelMapHidden:Label;
      
      private var minimap:DisplayObject;
      
      private var worldName:String;
      
      private var worldDesc:String;
      
      private var worldOwner:String;
      
      private var worldCrew:String;
      
      private var minimapBMD:BitmapData;
      
      public function MinimapPreview(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:BitmapData = null)
      {
         var worldId:String = param1;
         var worldName:String = param2;
         var worldDesc:String = param3;
         var worldOwner:String = param4;
         var worldCrew:String = param5;
         var minimapBMD:BitmapData = param6;
         this.bg = new Sprite();
         this.close = new ProfileCloseButton();
         this.loading = new assets_miniloading();
         this.labelTitle = new Label("Loading world info...",14,"center",16777215,false,"system");
         super();
         this.worldName = worldName;
         this.worldDesc = worldDesc;
         this.worldOwner = worldOwner;
         this.worldCrew = worldCrew;
         this.minimapBMD = minimapBMD;
         this.bg.filters = [new DropShadowFilter(0,0,0,1,16,16,1,3)];
         addChild(this.bg);
         this.close.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            Global.base.removeWorldPreview();
         });
         this.close.y = PAD;
         addChild(this.close);
         this.labelTitle.x = this.labelTitle.y = PAD;
         addChild(this.labelTitle);
         addChild(this.loading);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         this.adjust();
         this.loadLevel(worldId);
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
      }
      
      private function loadLevel(param1:String) : void
      {
         var rid:String = param1;
         if(this.minimapBMD)
         {
            this.showWorld(null,this.worldOwner,this.worldCrew);
         }
         else if(Boolean(rid) && rid != "")
         {
            Global.base.client.bigDB.load("Worlds",rid,function(param1:DatabaseObject):void
            {
               var o:DatabaseObject = param1;
               if(!o)
               {
                  handleError();
               }
               else if(!o.owner)
               {
                  handleError();
               }
               else if(worldOwner)
               {
                  showWorld(o,worldOwner,worldCrew);
               }
               else
               {
                  Global.base.requestRemoteMethod("getOwnerNames",function(param1:Message):void
                  {
                     var _loc2_:String = param1.getString(0);
                     var _loc3_:String = param1.getString(1);
                     if(_loc2_ != "" && (_loc3_ != "" || !o.Crew))
                     {
                        showWorld(o,_loc2_,_loc3_ != "" ? _loc3_ : null);
                     }
                  },o.owner,o.Crew || "");
               }
            },this.handleError);
         }
         else
         {
            this.handleError();
         }
      }
      
      private function showWorld(param1:DatabaseObject, param2:String, param3:String) : void
      {
         var that:MinimapPreview;
         var prefix:String;
         var desc:String;
         var preview:WorldPreview = null;
         var bm:Bitmap = null;
         var bmd:BitmapData = null;
         var o:DatabaseObject = param1;
         var owner:String = param2;
         var crew:String = param3;
         this.labelTitle.text = Badwords.Filter(this.worldName || o && o.name || "");
         if(Boolean(this.loading) && Boolean(this.loading.parent))
         {
            this.loading.parent.removeChild(this.loading);
         }
         that = this;
         if(crew)
         {
            this.contCrew = new Sprite();
            this.contCrew.y = Math.round(this.labelTitle.y + this.labelTitle.height);
            this.contCrew.buttonMode = true;
            this.contCrew.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_CREW_PROFILE,true);
               _loc2_.crewname = crew;
               dispatchEvent(_loc2_);
               Global.base.removeWorldPreview();
            });
            addChild(this.contCrew);
            this.labelCrew = new Label("By " + crew,12,"left",11184810,false,"visitor");
            this.contCrew.addChild(this.labelCrew);
         }
         this.contOwner = new Sprite();
         this.contOwner.y = Math.round(this.contCrew ? this.contCrew.y + this.contCrew.height - 4 : this.labelTitle.y + this.labelTitle.height);
         this.contOwner.buttonMode = true;
         this.contOwner.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_PROFILE,true);
            _loc2_.username = owner;
            dispatchEvent(_loc2_);
            Global.base.removeWorldPreview();
         });
         addChild(this.contOwner);
         prefix = crew ? "Hosted by " : "By ";
         this.labelOwner = new Label(prefix + owner,12,"left",11184810,false,"visitor");
         this.labelOwner.setTextFormat(new TextFormat(null,null,Player.getNameColor(owner)),prefix.length,this.labelOwner.text.length);
         ColorUtil.colorizeUsername(this.labelOwner,prefix.length);
         this.contOwner.addChild(this.labelOwner);
         desc = Badwords.Filter(this.worldDesc || o && o.worldDescription || "");
         if(desc != "")
         {
            this.labelDesc = new Label(desc,12,"center",14671839,true);
            this.labelDesc.x = PAD;
            this.labelDesc.y = Math.round(this.contOwner.y + this.contOwner.height - 4);
            addChild(this.labelDesc);
         }
         if(Boolean(o) && Boolean(o.LobbyPreviewEnabled == false) || !o && !Global.base.ui2instance.minimapEnabled)
         {
            this.labelMapHidden = new Label("Minimap hidden\nby world owner.",14,"center",6710886,true,"system");
            this.labelMapHidden.x = PAD;
            addChild(this.labelMapHidden);
         }
         else if(o)
         {
            preview = new WorldPreview(o,true,false,Global.base.removeWorldPreview);
            preview.fill();
            this.minimap = preview;
            addChild(this.minimap);
         }
         else if(this.minimapBMD)
         {
            bm = new Bitmap();
            bmd = new BitmapData(this.minimapBMD.width,this.minimapBMD.height,false,0);
            bmd.copyPixels(this.minimapBMD,this.minimapBMD.rect,new Point());
            bm.bitmapData = bmd;
            this.minimap = bm;
            addChild(this.minimap);
         }
         this.adjust();
      }
      
      private function handleError(param1:Error = null) : void
      {
         if(!param1)
         {
         }
         this.labelTitle.text = "Error loading info! :(";
         if(Boolean(this.loading) && this.loading.parent == this)
         {
            removeChild(this.loading);
         }
         this.adjust();
      }
      
      private function adjust() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = Math.max(200,Math.ceil(this.labelTitle.textWidth + 4 + (PAD + this.close.width) * 2));
         if(this.minimap)
         {
            _loc1_ = Math.max(_loc1_,this.minimap.width);
         }
         this._width = _loc1_ + PAD * 2;
         this.labelTitle.width = _loc1_;
         if(this.contCrew)
         {
            this.contCrew.x = Math.round((this._width - this.contCrew.width) / 2);
         }
         if(this.contOwner)
         {
            this.contOwner.x = Math.round((this._width - this.contOwner.width) / 2);
         }
         if(this.labelDesc)
         {
            this.labelDesc.width = _loc1_;
         }
         var _loc2_:Number = Math.round(this.labelDesc ? this.labelDesc.y + this.labelDesc.height : (this.contOwner ? this.contOwner.y + this.contOwner.height : this.labelTitle.y + this.labelTitle.height));
         if(this.minimap)
         {
            this.minimap.x = Math.round((this._width - this.minimap.width) / 2);
            this.minimap.y = _loc2_ + 2;
            this._height = Math.round(this.minimap.y + this.minimap.height + PAD);
         }
         else
         {
            _loc3_ = this._height - _loc2_ - PAD;
            if(Boolean(this.loading) && this.loading.parent == this)
            {
               this.loading.x = Math.round(this._width / 2);
               this.loading.y = Math.round(_loc2_ + _loc3_ / 2);
            }
            else if(this.labelMapHidden)
            {
               this.labelMapHidden.width = _loc1_;
               this.labelMapHidden.y = Math.round(_loc2_ + (_loc3_ - this.labelMapHidden.height) / 2);
            }
         }
         this.close.x = this._width - this.close.width - PAD;
         this.bg.graphics.clear();
         this.bg.graphics.beginFill(2236962);
         this.bg.graphics.drawRoundRect(0,0,this._width,this._height,10);
         this.handleResize();
      }
      
      private function handleResize(param1:Event = null) : void
      {
         x = Math.round((Global.width - this._width) / 2);
         y = Math.max(0,Math.round((Config.height - this._height) / 2));
      }
      
      private function handleAttach(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         stage.addEventListener(Event.RESIZE,this.handleResize);
         this.handleResize();
      }
      
      private function handleRemove(param1:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.handleResize);
      }
   }
}

