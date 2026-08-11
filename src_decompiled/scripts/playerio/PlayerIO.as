package playerio
{
   import flash.display.Stage;
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import playerio.generated.PlayerIO;
   import playerio.utils.HTTPChannel;
   
   /**
    * PlayerIO stub – completely bypassed for private server use.
    * No HTTP calls are made. All methods return a local Client immediately.
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
       * Static connect() – returns a dummy Client instantly, no network calls.
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
       * Static authenticate() – returns a dummy Client instantly, no network calls.
       */
      public static function authenticate(param1:Stage, param2:String, param3:String, param4:Object, param5:* = null, param6:* = null, param7:* = null) : void
      {
         var cbAuth:Function = (param6 is Function ? param6 : (param5 is Function ? param5 : null)) as Function;
         var email:String = (param4 && (param4.email || param4.username)) ? String(param4.email || param4.username) : "Guest";
         var uname:String = email;
         if(uname.indexOf("@") != -1)
         {
            uname = uname.split("@")[0];
         }
         if(uname == "") uname = "Guest";
         try
         {
            var req:URLRequest = new URLRequest("http://localhost:8080/api/login");
            req.method = "POST";
            req.contentType = "application/json";
            req.data = '{"username":"' + uname + '","password":"' + ((param4 && param4.password) ? String(param4.password) : "admin") + '"}';
            var loader:flash.net.URLLoader = new flash.net.URLLoader();
            loader.load(req);
         }
         catch(e:Error) {}

         var clientUserId:String = "simple" + uname;
         var dummyClient:Client = new Client(param1, null, param2, "", "", clientUserId, false, null);
         dummyClient.multiplayer.developmentServer = "127.0.0.1:8184";
         if(cbAuth != null)
         {
            cbAuth(dummyClient);
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
