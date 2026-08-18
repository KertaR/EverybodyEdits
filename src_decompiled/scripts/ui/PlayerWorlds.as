package ui
{
   import flash.globalization.DateTimeFormatter;
   import playerio.Client;
   import playerio.RoomInfo;
   
   public class PlayerWorlds
   {
      
      public static var roomSizes:Object = [];
      
      public function PlayerWorlds()
      {
         super();
      }
      
      public static function addFavorites(param1:Array, param2:Client) : void
      {
         var _loc4_:String = null;
         var _loc5_:RoomInfo = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc3_:Object = Global.playerObject.favorites;
         for(_loc4_ in _loc3_)
         {
            _loc5_ = findWorld(param1,_loc4_);
            if(_loc5_)
            {
               _loc5_.data.inFavorites = true;
            }
            else
            {
               _loc6_ = _loc3_[_loc4_] as String;
               _loc7_ = {
                  "id":_loc4_,
                  "data":{
                     "name":(_loc5_ ? _loc5_.data.name : _loc6_),
                     "owned":true,
                     "needskey":true,
                     "inFavorites":true,
                     "beta":false
                  }
               };
               param1.push(_loc7_);
            }
         }
      }
      
      public static function addSavedWorlds(param1:Array, param2:Client) : void
      {
         var _loc3_:Object = null;
         if(Global.playerObject.room0 != null)
         {
            _loc3_ = findWorld(param1,Global.playerObject.room0);
            if(_loc3_ != null)
            {
               _loc3_.data.myworld = true;
            }
         }
         if(Global.playerObject.betaonlyroom != null)
         {
            _loc3_ = findWorld(param1,Global.playerObject.betaonlyroom);
            if(_loc3_ != null)
            {
               _loc3_.data.myworld = true;
            }
         }
         if(Global.playerObject.homeworld != null)
         {
            _loc3_ = findWorld(param1,Global.playerObject.homeworld);
            if(_loc3_ != null)
            {
               _loc3_.data.myworld = true;
            }
         }
         if(Global.playerObject.rooms != null)
         {
            for(var rKey:String in Global.playerObject.rooms)
            {
               var rId:String = Global.playerObject.rooms[rKey];
               if(rId != null && rId != "")
               {
                  _loc3_ = findWorld(param1, rId);
                  if(_loc3_ != null)
                  {
                     _loc3_.data.myworld = true;
                  }
               }
            }
         }
          var getCount:Function = function(key:String):int
          {
             try
             {
                if(param2 != null && param2.payVault != null)
                {
                   return param2.payVault.count(key);
                }
             }
             catch(e:Error)
             {
             }
             return 0;
          };
          roomSizes = {};
          addWorlds(param1,"0",getCount("world0"),"Small","25x25");
          addWorlds(param1,"1",getCount("world1"),"Medium","50x50");
          addWorlds(param1,"2",getCount("world2"),"Large","100x100");
          addWorlds(param1,"3",getCount("world3"),"Massive","200x200");
          addWorlds(param1,"4",getCount("world4"),"Wide","400x50");
          addWorlds(param1,"5",getCount("world5"),"Great","400x200");
          addWorlds(param1,"6",getCount("world6"),"Tall","100x400");
          addWorlds(param1,"7",getCount("world7"),"Ultra Wide","636x50");
          addWorlds(param1,"8",getCount("world8"),"Low Gravity","110x110");
          addWorlds(param1,"11",getCount("world11"),"Huge","300x300");
          addWorlds(param1,"12",getCount("world12"),"Vertical Great","200x400");
          addWorlds(param1,"13",getCount("world13"),"Big","150x150");
      }
      
       private static function findWorld(param1:Array, param2:String) : Object
       {
          var _loc3_:int = 0;
          while(_loc3_ < param1.length)
          {
             var item:Object = param1[_loc3_];
             if(item != null)
             {
                var curId:String = item is RoomInfo ? (item as RoomInfo).id : (item.id != null ? String(item.id) : "");
                if(curId == param2)
                {
                   return item;
                }
             }
             _loc3_++;
          }
          return null;
       }
      
      private static function addWorlds(param1:Array, param2:String, param3:int, param4:String, param5:String) : Array
      {
         var _loc8_:RoomInfo = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Object = null;
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < param3)
         {
            _loc8_ = findWorld(param1,Global.playerObject.rooms["world" + param2 + "x" + _loc7_]);
            if(_loc8_)
            {
               _loc8_.data.myworld = true;
            }
            else
            {
               _loc8_ = findWorld(param1,param2 + "x" + _loc7_);
               if(_loc8_ == null)
               {
                  _loc9_ = Global.playerObject.roomnames["world" + param2 + "x" + _loc7_] || param4 + " " + (_loc7_ + 1);
                  _loc10_ = param5 + " - " + param4 + " " + (_loc7_ + 1);
                  _loc11_ = {
                     "id":param2 + "x" + _loc7_,
                     "data":{
                        "name":(_loc8_ ? _loc8_.data.name : _loc9_),
                        "owned":true,
                        "needskey":true,
                        "myworld":true,
                        "beta":false,
                        "size":_loc10_
                     }
                  };
                  param1.push(_loc11_);
                  _loc6_.push(_loc11_);
               }
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      public static function getHistory(param1:Array) : void
      {
         var _loc2_:DateTimeFormatter = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         if(!Config.disableCookie)
         {
            _loc2_ = new DateTimeFormatter("en-US");
            _loc2_.setDateTimePattern("f");
            _loc3_ = [];
            if(Global.cookie.data.history != null)
            {
               _loc3_ = Global.cookie.data.history;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc6_ = {
                  "id":_loc5_.id,
                  "data":{
                     "name":_loc5_.name,
                     "owned":true,
                     "needskey":true,
                     "time":_loc5_.time,
                     "size":_loc2_.format(_loc5_.time),
                     "isHistory":true
                  }
               };
               param1.push(_loc6_);
               _loc4_++;
            }
         }
      }
   }
}

