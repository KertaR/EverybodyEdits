package playerio
{
   import playerio.generated.Multiplayer;
   import playerio.utils.HTTPChannel;
   import playerio.generated.messages.ServerEndpoint;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   
   public class Multiplayer extends playerio.generated.Multiplayer
   {
      
      private var _developmentServer:String = null;
      
      private var _client:Client;
      
      public function Multiplayer(param1:HTTPChannel, param2:Client)
      {
         super(param1,param2);
      }
      
      public function createRoom(param1:String, param2:String, param3:Boolean, param4:Object, param5:Function = null, param6:Function = null) : void
      {
         _createRoom(param1,param2,param3,param4,_developmentServer != null,param5,param6);
      }
      
      public function joinRoom(param1:String, param2:Object, param3:Function = null, param4:Function = null) : void
      {
         var roomId:String = param1;
         var joinData:Object = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         if(true)
         {
            var ep1:ServerEndpoint = new ServerEndpoint();
            ep1.address = "127.0.0.1";
            ep1.port = 8184;
            doConnect(roomId, roomId, [ep1], joinData, callback, errorHandler);
            return;
         }
         _joinRoom(roomId,joinData,_developmentServer != null,function(param1:String, param2:Array):void
         {
            doConnect(roomId,param1,param2,joinData,callback,errorHandler);
         },errorHandler);
      }
      
      public function createJoinRoom(param1:String, param2:String, param3:Boolean, param4:Object, param5:Object, param6:Function = null, param7:Function = null) : void
      {
         var roomId:String = param1;
         var roomType:String = param2;
         var visible:Boolean = param3;
         var roomData:Object = param4;
         var joinData:Object = param5;
         var callback:Function = param6;
         var errorHandler:Function = param7;
         if(true)
         {
            var ep2:ServerEndpoint = new ServerEndpoint();
            ep2.address = "127.0.0.1";
            ep2.port = 8184;
            doConnect(roomId, roomId, [ep2], joinData, callback, errorHandler);
            return;
         }
         _createJoinRoom(roomId,roomType,visible,roomData,joinData,_developmentServer != null,function(param1:String, param2:String, param3:Array):void
         {
            doConnect(param1,param2,param3,joinData,callback,errorHandler);
         },errorHandler);
      }
      
       public function listRooms(param1:String, param2:Object, param3:int, param4:int, param5:Function = null, param6:Function = null) : void
       {
          if(param5 != null)
          {
             if(param4 > 0)
             {
                param5([]);
                return;
             }
             var hasCalled:Boolean = false;
             var safeCallback:Function = function(result:Array):void
             {
                if(!hasCalled)
                {
                   hasCalled = true;
                   param5(result);
                }
             };

             var timer:Timer = new Timer(500, 1);
             timer.addEventListener(TimerEvent.TIMER, function(e:Event):void
             {
                timer.stop();
                var fallbackRooms:Array = [];
                var dynOwner:String = Global.playerObject != null && Global.playerObject.name != null ? Global.playerObject.name : "";
                fallbackRooms.push(new RoomInfo("PW_default", "PW", 1, {
                   "name": "Home World",
                   "owner": dynOwner,
                   "plays": "1",
                   "Likes": "0",
                   "Favorites": "0",
                   "size": "200x200",
                   "myworld": true
                }));
                safeCallback(fallbackRooms);
             });
             timer.start();

             try
             {
                var loader:URLLoader = new URLLoader();
                var req:URLRequest = new URLRequest("http://localhost:8080/api/worlds");
                loader.addEventListener(Event.COMPLETE, function(e:Event):void
                {
                   timer.stop();
                   try
                   {
                      var raw:String = String(loader.data);
                      var arr:Array = JSON.parse(raw) as Array;
                      var rooms:Array = [];
                      if(arr != null)
                      {
                         for(var i:int = 0; i < arr.length; i++)
                         {
                            var item:Object = arr[i];
                            var rName:String = String(item.title || item.id);
                            var rOwner:String = String(item.owner || (Global.playerObject != null && Global.playerObject.name != null ? Global.playerObject.name : ""));
                            var isMine:Boolean = Global.playerObject != null && Global.playerObject.name != null && item.owner != null && String(item.owner).toLowerCase() == Global.playerObject.name.toLowerCase();
                            var r:RoomInfo = new RoomInfo(item.id, "PW", int(item.onlineUsers || 0), {
                               "name": rName,
                               "owner": rOwner,
                               "plays": String(item.plays || 1),
                               "Likes": String(item.likes || 0),
                               "Favorites": String(item.favorites || 0),
                               "size": String((item.width || 200) + "x" + (item.height || 200)),
                               "needskey": Boolean(item.needskey),
                               "myworld": isMine
                            });
                            rooms.push(r);
                         }
                      }
                      safeCallback(rooms);
                   }
                   catch(err:Error)
                   {
                      var fallbackRooms:Array = [];
                      var dynOwner:String = Global.playerObject != null && Global.playerObject.name != null ? Global.playerObject.name : "";
                      fallbackRooms.push(new RoomInfo("PW_default", "PW", 1, {
                         "name": "Home World",
                         "owner": dynOwner,
                         "plays": "1",
                         "Likes": "0",
                         "Favorites": "0",
                         "size": "200x200",
                         "myworld": true
                      }));
                      safeCallback(fallbackRooms);
                   }
                });
                loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
                {
                   timer.stop();
                   var fallbackRooms2:Array = [];
                   var dynOwner2:String = Global.playerObject != null && Global.playerObject.name != null ? Global.playerObject.name : "";
                   fallbackRooms2.push(new RoomInfo("PW_default", "PW", 1, {
                      "name": "Home World",
                      "owner": dynOwner2,
                      "plays": "1",
                      "Likes": "0",
                      "Favorites": "0",
                      "size": "200x200",
                      "myworld": true
                   }));
                   safeCallback(fallbackRooms2);
                });
                loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void
                {
                   timer.stop();
                   var fallbackRooms3:Array = [];
                   var dynOwner3:String = Global.playerObject != null && Global.playerObject.name != null ? Global.playerObject.name : "";
                   fallbackRooms3.push(new RoomInfo("PW_default", "PW", 1, {
                      "name": "Home World",
                      "owner": dynOwner3,
                      "plays": "1",
                      "Likes": "0",
                      "Favorites": "0",
                      "size": "200x200",
                      "myworld": true
                   }));
                   safeCallback(fallbackRooms3);
                });
                loader.load(req);
             }
             catch(eLoader:Error)
             {
                timer.stop();
                var fallbackRooms4:Array = [];
                var dynOwner4:String = Global.playerObject != null && Global.playerObject.name != null ? Global.playerObject.name : "";
                fallbackRooms4.push(new RoomInfo("PW_default", "PW", 1, {
                   "name": "Home World",
                   "owner": dynOwner4,
                   "plays": "1",
                   "Likes": "0",
                   "Favorites": "0",
                   "size": "200x200",
                   "myworld": true
                }));
                safeCallback(fallbackRooms4);
             }
          }
       }
      
      public function set developmentServer(param1:String) : void
      {
         this._developmentServer = param1;
      }
      
      public function get developmentServer() : String
      {
         return this._developmentServer;
      }
      
      private function doConnect(param1:String, param2:String, param3:Array, param4:Object, param5:Function, param6:Function) : void
      {
         new Connection(client,param1,param2,param3,param4,param5,param6,_developmentServer || "127.0.0.1:8184");
      }
   }
}

