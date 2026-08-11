package ui.profile.Crew
{
   import flash.events.MouseEvent;
   import playerio.Message;
   import ui.ConfirmPrompt;
   import ui.Prompt;
   
   public class NoCrewName extends assets_nocrewname
   {
      
      public function NoCrewName()
      {
         super();
         btn_setname.addEventListener(MouseEvent.CLICK,this.handleSetName);
      }
      
      protected function handleSetName(param1:MouseEvent) : void
      {
         var prompt:Prompt = null;
         var e:MouseEvent = param1;
         prompt = new Prompt("Set your crew name!","",null,25,true,false);
         prompt.savebtn.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var crewName:String = null;
            var cPrompt:ConfirmPrompt = null;
            var e:MouseEvent = param1;
            if(prompt.inputvar.text.length > 0)
            {
               crewName = prompt.inputvar.text;
               cPrompt = new ConfirmPrompt("Are you sure you want to name your crew \"" + crewName + "\"? This cannot be changed afterwards!",true,null,false);
               Global.base.showOnTop(cPrompt);
               cPrompt.btn_yes.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  var e:MouseEvent = param1;
                  Global.base.showLoadingScreen("Creating New Crew");
                  Global.base.requestRemoteMethod("createCrew",function(param1:Message):void
                  {
                     if(!param1.getBoolean(0))
                     {
                        prompt.setError(param1.getString(1));
                        Global.base.hideLoadingScreen();
                     }
                     else
                     {
                        Global.base.updateMemberItems(false);
                        Global.base.hideLoadingScreen();
                        prompt.close();
                     }
                     cPrompt.close();
                  },crewName);
               });
            }
         });
         prompt.savebtn.gotoAndStop(2);
         Global.base.showOnTop(prompt);
      }
   }
}

