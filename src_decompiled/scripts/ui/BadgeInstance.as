package ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import playerio.Achievement;
   
   public class BadgeInstance extends Sprite
   {
      
      private static var NoBadge:Class = BadgeInstance_NoBadge;
      
      private static var noBadgeBMD:BitmapData = new NoBadge().bitmapData;
      
      private var _item:Achievement;
      
      public function BadgeInstance(param1:Achievement = null)
      {
         var loader:Loader = null;
         var url:String = null;
         var item:Achievement = param1;
         super();
         this._item = item;
         if(item != null)
         {
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
            {
               var _loc2_:Sprite = new Sprite();
               _loc2_.addChild(loader);
               addChild(_loc2_);
            });
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(param1:IOErrorEvent):void
            {
               if(!Global.base.client || Boolean(Global.base.client.errorLog))
               {
                  return;
               }
               Global.base.client.errorLog.writeError("Badge image load failed.","BadgeId: \'" + item.id + "\', UserId: \'" + Global.base.client.connectUserId + "\'",param1.toString(),null);
            });
            url = Config.site + "/Achievements/" + (item.id == "adv" ? "avd" : item.id) + ".png";
            loader.load(new URLRequest(url));
         }
         else
         {
            addChild(new Bitmap(noBadgeBMD));
         }
      }
      
      public function get item() : Achievement
      {
         return this._item;
      }
      
      public function get id() : String
      {
         if(this.item == null)
         {
            return "";
         }
         return this.item.id;
      }
      
      public function get title() : String
      {
         if(this.item == null)
         {
            return "No";
         }
         return this.item.title;
      }
   }
}

