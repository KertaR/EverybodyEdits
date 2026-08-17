package playerio
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import playerio.generated.PlayerIO;
   import playerio.utils.HTTPChannel;
   
   /**
    * PlayerIO stub – connects to local Everybody Edits server.
    */
   public final class PlayerIO extends playerio.generated.PlayerIO
   {
      
      public static var useSecureApiRequests:Boolean = false;
      
      public function PlayerIO()
      {
         super();
      }
      
      internal static function getChannel() : HTTPChannel
      {
         return new HTTPChannel(false);
      }
      
      /**
       * Static connect() – returns a dummy Client instantly for guest connections.
       */
      public static function connect(param1:Stage, param2:String, param3:String, param4:String, param5:String, param6:* = null, param7:* = null, param8:* = null, param9:* = null) : void
      {
         var cbConnect:Function = (param8 is Function ? param8 : (param6 is Function ? param6 : (param7 is Function ? param7 : null))) as Function;
         var dummyClient:Client = new Client(param1, null, param2, "", "", param4 || "simpleguest", false, null);
         dummyClient.multiplayer.developmentServer = "127.0.0.1:8184";
         if(cbConnect != null)
         {
            cbConnect(dummyClient);
         }
      }
      
      /**
       * Static authenticate() – authenticates against /api/login and enforces correct password.
       */
      public static function authenticate(param1:Stage, param2:String, param3:String, param4:Object, param5:* = null, param6:* = null, param7:* = null) : void
      {
         var cbAuth:Function = (param6 is Function ? param6 : (param5 is Function ? param5 : null)) as Function;
         var cbError:Function = (param7 is Function ? param7 : (param6 is Function && !(param5 is Function) ? null : null)) as Function;
         var email:String = (param4 && (param4.email || param4.username || param4.userId)) ? String(param4.email || param4.username || param4.userId) : "Guest";
         var uname:String = email;
         if(uname.indexOf("@") != -1)
         {
            uname = uname.split("@")[0];
         }
         if(uname.indexOf("simple") == 0 && uname != "simpleguest")
         {
            uname = uname.substr(6);
         }
         if(uname == "") uname = "Guest";

         if(uname.toLowerCase().indexOf("guest") == 0)
         {
            var guestUserId:String = "simple" + uname;
            var guestClient:Client = new Client(param1, null, param2, "", "", guestUserId, false, null);
            guestClient.multiplayer.developmentServer = "127.0.0.1:8184";
            if(cbAuth != null)
            {
               cbAuth(guestClient);
            }
            return;
         }

         var reqPass:String = (param4 && param4.password !== undefined) ? String(param4.password) : "";
         try
         {
            var req:URLRequest = new URLRequest("http://localhost:8080/api/login");
            req.method = "POST";
            req.contentType = "application/json";
            req.data = '{"username":"' + uname + '","password":"' + reqPass + '"}';
            var loader:flash.net.URLLoader = new flash.net.URLLoader();
            loader.addEventListener(flash.events.Event.COMPLETE, function(e:flash.events.Event):void {
               try
               {
                  var res:Object = JSON.parse(loader.data);
                  if(res && res.success)
                  {
                     var clientUserId:String = "simple" + uname;
                     var dummyClient:Client = new Client(param1, null, param2, "", "", clientUserId, false, null);
                     dummyClient.multiplayer.developmentServer = "127.0.0.1:8184";
                     if(cbAuth != null)
                     {
                        cbAuth(dummyClient);
                     }
                  }
                  else
                  {
                     var errMsg:String = (res && res.error) ? String(res.error) : "Password incorrect";
                     if(cbError != null)
                     {
                        cbError(new PlayerIOError(errMsg, 1));
                     }
                  }
               }
               catch(err:Error)
               {
                  if(cbError != null)
                  {
                     cbError(new PlayerIOError("Connection error", 1));
                  }
               }
            });
            loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent):void {
               if(cbError != null)
               {
                  cbError(new PlayerIOError("Network error", 1));
               }
            });
            loader.load(req);
         }
         catch(e:Error)
         {
            if(cbError != null)
            {
               cbError(new PlayerIOError("Login request failed", 1));
            }
         }
      }
      
      public static function get quickConnect() : QuickConnect
      {
         return new QuickConnect(getChannel());
      }
      
      public static function gameFS(param1:String) : GameFS
      {
         return new GameFS(param1, null);
      }
   }
}
