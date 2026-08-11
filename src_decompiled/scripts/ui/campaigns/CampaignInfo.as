package ui.campaigns
{
   import ui2.CampaignInfo;
   
   public class CampaignInfo extends ui2.CampaignInfo
   {
      
      private var _difficulty:int = 0;
      
      private var _tier:int = 1;
      
      private var _maxTier:int = 1;
      
      private var _campaignName:String;
      
      public function CampaignInfo()
      {
         super();
         this.displayLockedInfo("UNKNOWN");
      }
      
      public function displayInfo(param1:String, param2:int, param3:int, param4:int, param5:Boolean) : void
      {
         this._campaignName = param1;
         this._difficulty = param2;
         this._tier = param3;
         this._maxTier = param4;
         gotoAndStop(2);
         campaignNameTF.text = param1;
         tierTF.text = param3 + 1 + "/" + param4;
         if(0 <= param2 && param2 < 11)
         {
            difficultyIcon.gotoAndStop(param2 + 1);
         }
         else
         {
            difficultyIcon.gotoAndStop(1);
         }
         this.updateStatus(param5);
      }
      
      public function updateStatus(param1:Boolean) : void
      {
         statusIcon.gotoAndStop(param1 ? 2 : 1);
      }
      
      public function displayLockedInfo(param1:String) : void
      {
         gotoAndStop(1);
         infoTF.text = "This world is part of the " + param1 + " campaign.\nYou will need to unlock it in order to track your progress.";
      }
      
      public function displayGuestInfo(param1:String) : void
      {
         gotoAndStop(1);
         infoTF.text = "This world is part of the " + param1 + " campaign.\nYou will need to register in order to track your progress.";
      }
      
      public function displayBetaOnlyInfo(param1:String) : void
      {
         gotoAndStop(1);
         infoTF.text = "This world is part of a campaign currently only available to Beta members. Get Beta if you would like to play it now!";
      }
      
      public function displayLockedCampaignInfo(param1:String) : void
      {
         gotoAndStop(1);
         infoTF.text = "This world is part of a locked campaign.\n Play other campaigns to unlock it!";
      }
      
      public function get campaignName() : String
      {
         return this._campaignName;
      }
      
      public function get difficulty() : int
      {
         return this._difficulty;
      }
      
      public function get tier() : int
      {
         return this._tier;
      }
      
      public function get maxTier() : int
      {
         return this._maxTier;
      }
   }
}

