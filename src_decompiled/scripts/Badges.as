package
{
   import playerio.Achievement;
   import ui.BadgeInstance;
   
   public class Badges
   {
      
      private static var _loaded:Boolean;
      
      private static var badges:Object = {};
      
      public function Badges()
      {
         super();
      }
      
      public static function getBadge(param1:String) : BadgeInstance
      {
         return badges[param1] as BadgeInstance;
      }
      
      public static function getCompletedBadges() : Vector.<BadgeInstance>
      {
         var _loc2_:BadgeInstance = null;
         var _loc1_:Vector.<BadgeInstance> = new Vector.<BadgeInstance>();
         for each(_loc2_ in badges)
         {
            if(_loc2_.item.completed)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public static function refresh(param1:Function = null) : void
      {
         var callback:Function = param1;
         _loaded = true;
         if(callback != null)
         {
            callback();
         }
      }
      
      public static function get loaded() : Boolean
      {
         return _loaded;
      }
   }
}

