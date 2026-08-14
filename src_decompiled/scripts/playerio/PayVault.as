package playerio
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import playerio.generated.PayVault;
   import playerio.generated.PlayerIOError;
   import playerio.generated.messages.PayVaultContents;
   import playerio.utils.Converter;
   import playerio.utils.HTTPChannel;
   import playerio.VaultItem;
   
   public class PayVault extends playerio.generated.PayVault
   {
      
      private var _version:String = null;
      
      private var _coins:Number = 0;
      
      private var _items:Array = [];
      
      public function PayVault(param1:HTTPChannel, param2:Client)
      {
         super(param1,param2);
      }
      
      public function get coins() : Number
      {
         return _coins;
      }
      
      public function get items() : Array
      {
         return _items;
      }
      
      public function readHistory(param1:uint, param2:uint, param3:Function = null, param4:Function = null) : void
      {
         var page:uint = param1;
         var pageSize:uint = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         if(callback != null)
         {
            callback([]);
         }
      }
      
      public function refresh(param1:Function = null, param2:Function = null) : void
      {
         var callback:Function = param1;
         var errorHandler:Function = param2;
         _version = "1.0";
         
         var called:Boolean = false;
         var done:Function = function():void
         {
            if(!called)
            {
               called = true;
               if(callback != null) callback();
            }
         };
         
         try
         {
            var loader:URLLoader = new URLLoader();
            var targetUsername:String = "";
            if(_client && _client.connectUserId && _client.connectUserId != "simpleguest")
            {
               targetUsername = _client.connectUserId;
            }
            else if(Global.playerObject != null && Global.playerObject.name != null && Global.playerObject.name != "" && Global.playerObject.name.toLowerCase() != "guest")
            {
               targetUsername = Global.playerObject.name;
            }
            else if(Global.currentUsername != null && Global.currentUsername != "")
            {
               targetUsername = Global.currentUsername;
            }
            if(targetUsername == "") return;

            if(targetUsername.indexOf("simple") == 0 && targetUsername != "simpleguest")
            {
               targetUsername = targetUsername.substr(6);
            }
            var req:URLRequest = new URLRequest("http://localhost:8080/api/user/" + encodeURIComponent(targetUsername));
            loader.addEventListener(Event.COMPLETE, function(e:Event):void
            {
               try
               {
                  var res:Object = JSON.parse(loader.data);
                  if(res.success && res.user)
                  {
                     _coins = res.user.gems != null ? Number(res.user.gems) : 500;
                     var isSelf:Boolean = Global.playerObject != null && Global.playerObject.name != null && Global.playerObject.name.toLowerCase() == targetUsername.toLowerCase();
                     if(isSelf && Global.playerObject != null)
                     {
                        Global.playerObject.gems = _coins;
                        if(res.user.energy != null) Global.playerObject.energy = int(res.user.energy);
                        if(res.user.maxEnergy != null) Global.playerObject.maxEnergy = int(res.user.maxEnergy);
                        if(res.user.itemEnergyProgress != null) Global.playerObject.itemEnergyProgress = res.user.itemEnergyProgress;
                     }
                     var pvArr:Array = res.user.payVault || [];
                     _items = [];
                     for each(var itemKey:String in pvArr)
                     {
                        _items.push(new VaultItem("id_" + itemKey, itemKey, new Date()));
                     }
                  }
               }
               catch(err:Error) {}
               done();
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
            {
               done();
            });
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:Event):void
            {
               done();
            });
            loader.load(req);
         }
         catch(eLoad:Error)
         {
            done();
         }
      }
      
      public function credit(param1:uint, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var amount:uint = param1;
         var reason:String = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         if(true)
         {
            if(callback != null)
            {
               callback();
            }
            return;
         }
         _payVaultCredit(amount,reason,function(param1:PayVaultContents):void
         {
            parseVault(param1);
            if(callback != null)
            {
               callback();
            }
         },errorHandler);
      }
      
      public function debit(param1:uint, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var amount:uint = param1;
         var reason:String = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         if(true)
         {
            if(callback != null)
            {
               callback();
            }
            return;
         }
         _payVaultDebit(amount,reason,function(param1:PayVaultContents):void
         {
            parseVault(param1);
            if(callback != null)
            {
               callback();
            }
         },errorHandler);
      }
      
      public function consume(param1:Array, param2:Function = null, param3:Function = null) : void
      {
         var item:VaultItem;
         var items:Array = param1;
         var callback:Function = param2;
         var errorHandler:Function = param3;
         if(true)
         {
            if(callback != null)
            {
               callback();
            }
            return;
         }
         var ids:Array = [];
         var a:int = 0;
         while(a < items.length)
         {
            item = items[a] as VaultItem;
            if(item == null)
            {
               throw new playerio.generated.PlayerIOError("Element is not a VaultItem: " + items[a],2);
            }
            ids.push(item.id);
            a = a + 1;
         }
         _payVaultConsume(ids,function(param1:PayVaultContents):void
         {
            parseVault(param1);
            if(callback != null)
            {
               callback();
            }
         },errorHandler);
      }
      
      public function getBuyDirectInfo(param1:String, param2:Object, param3:Array, param4:Function = null, param5:Function = null) : void
      {
         if(true)
         {
            if(param4 != null)
            {
               param4({});
            }
            return;
         }
         _payVaultPaymentInfo(param1,param2,Converter.toBuyItemInfoArray(param3),param4,param5);
      }
      
      public function getBuyCoinsInfo(param1:String, param2:Object, param3:Function = null, param4:Function = null) : void
      {
         if(true)
         {
            if(param3 != null)
            {
               param3({});
            }
            return;
         }
         _payVaultPaymentInfo(param1,param2,null,param3,param4);
      }
      
      public function buy(param1:Array, param2:Boolean, param3:Function = null, param4:Function = null) : void
      {
         var items:Array = param1;
         var storeItems:Boolean = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         if(true)
         {
            if(callback != null)
            {
               callback();
            }
            return;
         }
         _payVaultBuy(items,storeItems,function(param1:PayVaultContents):void
         {
            parseVault(param1);
            if(callback != null)
            {
               callback();
            }
         },errorHandler);
      }
      
      public function give(param1:Array, param2:Function = null, param3:Function = null) : void
      {
         var items:Array = param1;
         var callback:Function = param2;
         var errorHandler:Function = param3;
         if(true)
         {
            if(callback != null)
            {
               callback();
            }
            return;
         }
         _payVaultGive(Converter.toBuyItemInfoArray(items),function(param1:PayVaultContents):void
         {
            parseVault(param1);
            if(callback != null)
            {
               callback();
            }
         },errorHandler);
      }
      
      public function usePaymentInfo(param1:String, param2:Object, param3:Function = null, param4:Function = null) : void
      {
         var provider:String = param1;
         var providerArguments:Object = param2;
         var callback:Function = param3;
         var errorHandler:Function = param4;
         if(true)
         {
            if(callback != null)
            {
               callback({});
            }
            return;
         }
         _payVaultUsePaymentInfo(provider,providerArguments,function(param1:Object, param2:PayVaultContents):void
         {
            parseVault(param2);
            if(callback != null)
            {
               callback(param1);
            }
         },errorHandler);
      }
      
      public function has(param1:String) : Boolean
      {
         try
         {
            var _loc3_:int = 0;
            var _loc2_:* = null;
            _loc3_ = 0;
            var arr:Array = this._items || [];
            while(_loc3_ < arr.length)
            {
               _loc2_ = arr[_loc3_];
               if(_loc2_ && _loc2_.itemKey == param1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         catch(e:Error) {}
         return false;
      }
      
      public function first(param1:String) : VaultItem
      {
         try
         {
            var _loc3_:int = 0;
            var _loc2_:* = null;
            _loc3_ = 0;
            var arr:Array = this._items || [];
            while(_loc3_ < arr.length)
            {
               _loc2_ = arr[_loc3_];
               if(_loc2_ && _loc2_.itemKey == param1)
               {
                  return _loc2_ as VaultItem;
               }
               _loc3_++;
            }
         }
         catch(e:Error) {}
         return null;
      }
      
      public function count(param1:String) : uint
      {
         try
         {
            var _loc4_:int = 0;
            var _loc2_:* = null;
            var _loc3_:int = 0;
            _loc4_ = 0;
            var arr:Array = this._items || [];
            while(_loc4_ < arr.length)
            {
               _loc2_ = arr[_loc4_];
               if(_loc2_ && _loc2_.itemKey == param1)
               {
                  _loc3_++;
               }
               _loc4_++;
            }
            return _loc3_;
         }
         catch(e:Error) {}
         return 0;
      }
      
      private function parseVault(param1:PayVaultContents) : void
      {
         if(param1 != null)
         {
            _version = param1.version;
            _coins = param1.coins;
            _items = Converter.toVaultItemArray(param1.items);
         }
      }
   }
}
