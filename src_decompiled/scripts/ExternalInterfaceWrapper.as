package
{
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.system.Security;
   
   public class ExternalInterfaceWrapper extends EventDispatcher
   {
      
      public function ExternalInterfaceWrapper()
      {
         super();
         Security.allowDomain(Config.domain);
         try
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.addCallback("showUserProfile",this.showUserProfile);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function showUserProfile(param1:String) : void
      {
         var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_PROFILE);
         _loc2_.username = param1;
         dispatchEvent(_loc2_);
      }
   }
}

