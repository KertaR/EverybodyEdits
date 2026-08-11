package playerio
{
   import flash.display.Stage;
   import flash.net.LocalConnection;
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import playerio.generated.PlayerIOError;
   import playerio.generated.QuickConnect;
   import playerio.generated.messages.KeyValuePair;
   import playerio.generated.messages.PlayerInsightState;
   import playerio.utils.HTTPChannel;
   import playerio.utils.Utilities;
   
   public class QuickConnect extends playerio.generated.QuickConnect
   {
      
      private var connections:Array = [];
      
      public function QuickConnect(param1:HTTPChannel)
      {
         super(param1);
      }
      
      public function simpleConnect(param1:Stage, param2:String, param3:String, param4:String, param5:* = null, param6:* = null, param7:* = null) : void
      {
         var stage:Stage = param1;
         var gameId:String = param2;
         var usernameOrEmail:String = param3;
         var password:String = param4;
         var playerInsightSegments:* = param5;
         var callback:* = param6;
         var errorHandler:* = param7;
         if(stage == null || stage.stage == null)
         {
            throw new Error("Parsed stage is not attached to document stage",2);
         }
         if(playerInsightSegments is Function)
         {
            simpleConnect(stage,gameId,usernameOrEmail,password,null,playerInsightSegments,callback);
            return;
         }
         _simpleConnect(gameId,usernameOrEmail,password,playerInsightSegments,Utilities.clientAPI,Utilities.getSystemInfo(),function(param1:String, param2:String, param3:Boolean, param4:String, param5:String, param6:PlayerInsightState):void
         {
            if(param3 && Minilogo.showLogo)
            {
               stage.addChild(new Minilogo());
            }
            var _loc7_:HTTPChannel = PlayerIO.getChannel();
            _loc7_.token = param1;
            callback(new Client(stage,_loc7_,gameId,param4,param1,param2,param3,param6));
         },errorHandler);
      }
      
      public function simpleRegister(param1:Stage, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:Object, param9:* = null, param10:* = null, param11:* = null, param12:* = null) : void
      {
         var stage:Stage = param1;
         var gameId:String = param2;
         var email:String = param5 || param3 || "Guest";

         var cbSuccess:Function = null;
         if(param9 is Function) {
            cbSuccess = param9 as Function;
         } else if(param10 is Function) {
            cbSuccess = param10 as Function;
         } else if(param11 is Function) {
            cbSuccess = param11 as Function;
         }

         var uname:String = email;
         if(uname.indexOf("@") != -1)
         {
            uname = uname.split("@")[0];
         }
         if(uname == "") uname = "Guest";

         try
         {
            var req:URLRequest = new URLRequest("http://localhost:8080/api/register");
            req.method = "POST";
            req.contentType = "application/json";
            req.data = '{"username":"' + uname + '","password":"' + (param4 || "admin") + '","email":"' + (email || "") + '"}';
            var loader:flash.net.URLLoader = new flash.net.URLLoader();
            loader.load(req);
         }
         catch(e:Error) {}

         var clientUserId:String = "simple" + uname;
         var dummyClient:Client = new Client(stage, null, gameId, "", "", clientUserId, false, null);
         dummyClient.multiplayer.developmentServer = "127.0.0.1:8184";

         if(cbSuccess != null)
         {
            cbSuccess(dummyClient);
         }
      }
      
      override public function simpleGetCaptcha(param1:String, param2:int, param3:int, param4:Function = null, param5:Function = null) : void
      {
         if(param4 != null)
         {
            param4("localCaptchaKey", "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
         }
      }
      
      override public function simpleRecoverPassword(param1:String, param2:String, param3:Function = null, param4:Function = null) : void
      {
         super.simpleRecoverPassword(param1,param2,param3,param4);
      }
      
      public function facebookConnect(param1:Stage, param2:String, param3:String, param4:String, param5:* = null, param6:* = null, param7:* = null, param8:* = null) : void
      {
         throw new Error("ERROR: facebookConnect is deprecated as Facebook is switching to OAuth. Please use facebookOAuthConnect instead.");
      }
      
      public function facebookOAuthConnect(param1:Stage, param2:String, param3:String, param4:* = null, param5:* = null, param6:* = null, param7:* = null) : void
      {
         var stage:Stage = param1;
         var gameId:String = param2;
         var accessToken:String = param3;
         var partnerId:* = param4;
         var playerInsightSegments:* = param5;
         var callback:* = param6;
         var errorHandler:* = param7;
         if(stage == null || stage.stage == null)
         {
            throw new Error("Parsed stage is not attached to document stage",2);
         }
         if(partnerId is Function)
         {
            facebookOAuthConnect(stage,gameId,accessToken,null,null,partnerId,playerInsightSegments);
            return;
         }
         if(playerInsightSegments is Function)
         {
            facebookOAuthConnect(stage,gameId,accessToken,partnerId,null,playerInsightSegments,callback);
            return;
         }
         _facebookOAuthConnect(gameId,accessToken,partnerId,playerInsightSegments,Utilities.clientAPI,Utilities.getSystemInfo(),function(param1:String, param2:String, param3:Boolean, param4:String, param5:String, param6:String, param7:PlayerInsightState):void
         {
            if(param3 && Minilogo.showLogo)
            {
               stage.addChild(new Minilogo());
            }
            var _loc8_:HTTPChannel = PlayerIO.getChannel();
            _loc8_.token = param1;
            callback(new Client(stage,_loc8_,gameId,param4,param1,param2,param3,param7),param5);
         },errorHandler);
      }
      
      public function kongregateConnect(param1:Stage, param2:String, param3:String, param4:String, param5:* = null, param6:* = null, param7:* = null) : void
      {
         var stage:Stage = param1;
         var gameId:String = param2;
         var userId:String = param3;
         var gameAuthToken:String = param4;
         var playerInsightSegments:* = param5;
         var callback:* = param6;
         var errorHandler:* = param7;
         if(stage == null || stage.stage == null)
         {
            throw new Error("Parsed stage is not attached to document stage",2);
         }
         if(playerInsightSegments is Function)
         {
            kongregateConnect(stage,gameId,userId,gameAuthToken,null,playerInsightSegments,callback);
            return;
         }
         _kongregateConnect(gameId,userId,gameAuthToken,playerInsightSegments,Utilities.clientAPI,Utilities.getSystemInfo(),function(param1:String, param2:String, param3:Boolean, param4:String, param5:PlayerInsightState):void
         {
            if(param3 && Minilogo.showLogo)
            {
               stage.addChild(new Minilogo());
            }
            var _loc6_:HTTPChannel = PlayerIO.getChannel();
            _loc6_.token = param1;
            callback(new Client(stage,_loc6_,gameId,param4,param1,param2,param3,param5));
         },errorHandler);
      }
      
      public function facebookOAuthConnectPopup(param1:Stage, param2:String, param3:String, param4:Array = null, param5:* = null, param6:* = null, param7:* = null, param8:* = null) : void
      {
         var legacy:Boolean;
         var e:playerio.generated.PlayerIOError;
         var url:String;
         var variables:URLVariables;
         var commid:String;
         var request:URLRequest;
         var receivingLC:LocalConnection;
         var stage:Stage = param1;
         var gameId:String = param2;
         var window:String = param3;
         var permissions:Array = param4;
         var partnerId:* = param5;
         var playerInsightSegments:* = param6;
         var callback:* = param7;
         var errorHandler:* = param8;
         if(stage == null || stage.stage == null)
         {
            throw new Error("Parsed stage is not attached to document stage",2);
         }
         if(partnerId is Function)
         {
            facebookOAuthConnectPopup(stage,gameId,window,permissions,null,partnerId,playerInsightSegments);
            return;
         }
         if(playerInsightSegments is Function)
         {
            facebookOAuthConnectPopup(stage,gameId,window,permissions,partnerId,null,playerInsightSegments,callback);
            return;
         }
         legacy = false;
         if(gameId.substring(0,1) == "@")
         {
            legacy = true;
            gameId = gameId.substring(1);
         }
         if(/\[|\]/gi.test(gameId))
         {
            e = new playerio.generated.PlayerIOError("The Player.IO Game id \"" + gameId + "\" contains invalid characters, did you insert your game id?",1);
            if(errorHandler != null)
            {
               errorHandler(e);
               return;
            }
            throw e;
         }
         if(legacy)
         {
            url = "http://fb.playerio.com/fb/" + gameId + "/_fb_quickconnect_oauth";
         }
         else
         {
            url = "http://" + gameId + ".fb.playerio.com/fb/_fb_quickconnect_oauth";
         }
         variables = new URLVariables();
         commid = Math.floor(new Date().getTime()).toString() + (Math.random() * 999999 >> 0).toString();
         variables.req_perms = permissions ? permissions.join(",") : "";
         variables.communicationId = commid;
         variables.partnerId = partnerId;
         variables.clientapi = Utilities.clientAPI;
         variables.clientinfo = Utilities.getSystemInfoString();
         variables.playerinsightsegments = (playerInsightSegments || []).join(",");
         request = new URLRequest(url);
         request.data = variables;
         request.method = "POST";
         try
         {
            navigateToURL(request,window);
         }
         catch(e:Error)
         {
            trace("Error occurred!");
         }
         receivingLC = new LocalConnection();
         connections.push(receivingLC);
         receivingLC.client = {"oauth2":function(param1:String, param2:String, param3:String, param4:String = "", param5:Boolean = true, param6:String = "", param7:String = null, param8:String = "-1", param9:String = ""):void
         {
            var _loc11_:int = 0;
            var _loc13_:Array = null;
            var _loc10_:KeyValuePair = null;
            if(param5 && Minilogo.showLogo)
            {
               stage.addChild(new Minilogo());
            }
            var _loc15_:HTTPChannel = PlayerIO.getChannel();
            _loc15_.token = param1;
            var _loc12_:PlayerInsightState = new PlayerInsightState();
            _loc12_.playersOnline = parseInt(param8 || "-1");
            var _loc14_:Array = (param9 || "").split(",");
            _loc11_ = 0;
            while(_loc11_ < _loc14_.length)
            {
               _loc13_ = _loc14_[_loc11_].split(":");
               _loc10_ = new KeyValuePair();
               _loc10_.key = _loc13_[0];
               _loc10_.value = _loc13_[1];
               _loc12_.segments.push(_loc10_);
               _loc11_++;
            }
            callback(new Client(stage,_loc15_,gameId,param6,param1,param4,param5,_loc12_),param2,param3);
         }};
         receivingLC.allowDomain("*");
         receivingLC.connect("_facebook_" + commid);
      }
      
      public function facebookConnectPopup(param1:Stage, param2:String, param3:String, param4:Array = null, param5:* = null, param6:* = null, param7:* = null) : void
      {
         throw new Error("FacebookConnectPopup is no longer supported by Facebook. Please use FacebookConnectOAuthPopup");
      }
   }
}

