package ui.profile
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import playerio.DatabaseObject;
   import sample.ui.components.Label;
   import ui.WorldPreview;
   
   public class ProfileCrew extends Sprite
   {
      
      private var icon:Bitmap;
      
      private var crewName:Label;
      
      private var spacing:int = 5;
      
      private var id:String;
      
      private var _name:String;
      
      private var logoId:String;
      
      private var refreshCallback:Function;
      
      private var noLogo:Label;
      
      private var noLogoSprite:Sprite;
      
      public function ProfileCrew(param1:String, param2:String, param3:String, param4:Function)
      {
         super();
         this.id = param1;
         this._name = param2;
         this.logoId = param3;
         if(param4 != null)
         {
            this.refreshCallback = param4;
         }
         this.crewName = new Label(param2,12,"left",16777215,false,"system");
         addChild(this.crewName);
         this.setCrewLogo(param3);
         buttonMode = true;
         useHandCursor = true;
         addEventListener(MouseEvent.CLICK,this.handleClick);
      }
      
      protected function handleClick(param1:MouseEvent) : void
      {
         var _loc2_:NavigationEvent = null;
         if(Global.normalStart)
         {
            _loc2_ = new NavigationEvent(NavigationEvent.SHOW_CREW_PROFILE,true);
            _loc2_.crewname = this._name;
            dispatchEvent(_loc2_);
         }
         else
         {
            navigateToURL(new URLRequest(Config.site + "/crews/" + this.id),"_blank");
         }
      }
      
      private function setCrewLogo(param1:String) : void
      {
         var logoId:String = param1;
         if(logoId != "")
         {
            Global.base.client.bigDB.load("Worlds",logoId,function(param1:DatabaseObject):void
            {
               if(param1 == null)
               {
                  return;
               }
               var _loc2_:WorldPreview = new WorldPreview(param1,false);
               icon = _loc2_.bitmap;
               addChild(icon);
               redraw();
            });
         }
         else
         {
            this.noLogoSprite = new Sprite();
            this.noLogoSprite.graphics.lineStyle(1,10066329);
            this.noLogoSprite.graphics.beginFill(0,1);
            this.noLogoSprite.graphics.drawRect(0,0,100,100);
            this.noLogoSprite.graphics.endFill();
            addChild(this.noLogoSprite);
            this.noLogo = new Label("\nNo\nLogo",18,"center",16777215,true,"system");
            addChild(this.noLogo);
            this.redraw();
         }
      }
      
      private function redraw() : void
      {
         this.crewName.x = 3 + (width - this.crewName.width) / 2;
         this.crewName.y = this.spacing;
         var _loc1_:Number = Math.max(this.crewName.width,this.logoId != "" ? this.icon.width : this.noLogoSprite.width) + 5;
         if(this.logoId != "")
         {
            this.icon.x = (_loc1_ - this.icon.width) / 2;
            this.icon.y = this.crewName.y + this.crewName.height + 2;
         }
         else
         {
            this.noLogoSprite.x = (_loc1_ - this.noLogoSprite.width) / 2;
            this.noLogoSprite.y = this.crewName.y + this.crewName.height + 2;
            this.noLogo.x = (_loc1_ - this.noLogo.width) / 2;
            this.noLogo.y = (height - this.noLogo.height) / 2;
         }
         graphics.lineStyle(1,3355443);
         graphics.beginFill(1118481);
         graphics.drawRoundRect(0,0,_loc1_,height + 10,5,5);
         graphics.endFill();
         if(this.refreshCallback != null)
         {
            this.refreshCallback();
         }
      }
   }
}

