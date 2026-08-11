package ui.crews
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextFormat;
   import io.player.tools.Badwords;
   import items.ItemManager;
   import sample.ui.components.Label;
   import ui.ingame.sam.SmileyInstance;
   import utilities.ColorUtil;
   
   public class CrewMemberItem extends Sprite
   {
      
      private var smiley:SmileyInstance;
      
      private var WIDTH:int = 291;
      
      private var HEIGHT:int = 85;
      
      private var rank:CrewRank;
      
      private var description:String;
      
      private var usernameLabel:Label;
      
      private var playerDescription:Label;
      
      private var playerTitle:Label;
      
      private var editLabel:Label;
      
      private var ranks:CrewRanks;
      
      private var descriptionContainer:Sprite;
      
      private var _username:String;
      
      public function CrewMemberItem(param1:String, param2:int, param3:String, param4:int, param5:Boolean, param6:String, param7:CrewRanks)
      {
         var infoTotalHeight:int;
         var username:String = param1;
         var r:int = param2;
         var desc:String = param3;
         var face:int = param4;
         var goldBorder:Boolean = param5;
         var crewId:String = param6;
         var ranks:CrewRanks = param7;
         this.editLabel = new Label("Edit",8,"left",12303291,false,"system");
         super();
         this._username = username;
         this.rank = ranks.getRank(r);
         this.description = desc;
         this.ranks = ranks;
         this.editLabel.visible = false;
         this.editLabel.x = this.WIDTH - this.editLabel.width;
         this.editLabel.y = this.HEIGHT - this.editLabel.height - 2;
         addChild(this.editLabel);
         graphics.beginFill(10066329,1);
         graphics.drawRoundRect(0,0,this.WIDTH,this.HEIGHT,10,10);
         graphics.beginFill(2434341,1);
         graphics.drawRoundRect(1,1,this.WIDTH - 2,this.HEIGHT - 2,10,10);
         this.smiley = new SmileyInstance(ItemManager.getSmileyById(face),null,goldBorder);
         this.smiley.mouseChildren = false;
         this.smiley.scaleX = 0.5;
         this.smiley.scaleY = 0.5;
         this.smiley.x = (85 - 8) / 2;
         this.smiley.y = (this.HEIGHT - 13) / 2;
         this.smiley.alpha = 0;
         addChild(this.smiley);
         this.usernameLabel = new Label(username.toUpperCase(),15,"left",Player.getNameColor(username),false,"system");
         ColorUtil.colorizeUsername(this.usernameLabel);
         this.usernameLabel.x = 85;
         addChild(this.usernameLabel);
         this.playerTitle = new Label("",8,"left",9803157,true,"system");
         this.playerTitle.x = 85;
         this.playerTitle.width = this.WIDTH - this.playerTitle.x - 5;
         if(this.rank != null)
         {
            this.playerTitle.text = "Rank: " + this.rank.name;
            this.playerTitle.antiAliasType = AntiAliasType.ADVANCED;
            this.playerTitle.setTextFormat(new TextFormat("system",8,13421772),0,6);
         }
         addChild(this.playerTitle);
         this.playerDescription = new Label("",8,"left",9803157,true,"system");
         this.playerDescription.x = 85;
         this.playerDescription.width = this.WIDTH - this.playerDescription.x - 5;
         if(this.description != "")
         {
            this.playerDescription.text = "Description: " + Badwords.Filter(this.description);
            this.playerDescription.antiAliasType = AntiAliasType.ADVANCED;
            this.playerDescription.setTextFormat(new TextFormat("system",8,13421772),0,12);
         }
         if(ranks != null)
         {
            if(ranks.myRank != null)
            {
               if(ranks.myRank.canManageMembers)
               {
                  buttonMode = true;
                  useHandCursor = true;
                  addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
                  {
                     Global.base.showMemberSettings(crewId,username,rank,ranks,description);
                  });
                  addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
                  {
                     graphics.clear();
                     graphics.beginFill(10066329,1);
                     graphics.drawRoundRect(0,0,WIDTH,HEIGHT,10,10);
                     graphics.beginFill(3355443,1);
                     graphics.drawRoundRect(1,1,WIDTH - 2,HEIGHT - 2,10,10);
                     editLabel.visible = true;
                  });
                  addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
                  {
                     graphics.clear();
                     graphics.beginFill(10066329,1);
                     graphics.drawRoundRect(0,0,WIDTH,HEIGHT,10,10);
                     graphics.beginFill(2434341,1);
                     graphics.drawRoundRect(1,1,WIDTH - 2,HEIGHT - 2,10,10);
                     editLabel.visible = false;
                  });
                  addChild(this.playerDescription);
               }
               else
               {
                  addChild(this.playerDescription);
               }
            }
         }
         infoTotalHeight = this.usernameLabel.height + this.playerTitle.height + this.playerDescription.height;
         this.usernameLabel.y = (this.HEIGHT - infoTotalHeight) / 2;
         this.playerTitle.y = this.usernameLabel.y + this.usernameLabel.height;
         this.playerDescription.y = this.playerTitle.y + this.playerTitle.height - 3;
      }
      
      public function updateItem(param1:String, param2:int) : void
      {
         this.description = param1;
         this.playerDescription.width = this.WIDTH - this.playerDescription.x - 5;
         this.playerDescription.text = "Description: " + this.description;
         this.playerDescription.antiAliasType = AntiAliasType.ADVANCED;
         this.playerDescription.setTextFormat(new TextFormat("system",8,13421772),0,12);
         this.rank = this.ranks.getRank(param2);
         this.playerTitle.text = "Rank: " + this.rank.name;
         this.playerTitle.width = this.WIDTH - this.playerTitle.x - 5;
         this.playerTitle.antiAliasType = AntiAliasType.ADVANCED;
         this.playerTitle.setTextFormat(new TextFormat("system",8,13421772),0,6);
         var _loc3_:int = this.usernameLabel.height + this.playerTitle.height + this.playerDescription.height;
         this.usernameLabel.y = (this.HEIGHT - _loc3_) / 2;
         this.playerTitle.y = this.usernameLabel.y + this.usernameLabel.height;
         this.playerDescription.y = this.playerTitle.y + this.playerTitle.height - 3;
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      public function startAnimations(param1:Number, param2:Number) : void
      {
         var duration:Number = param1;
         var durationMultiplier:Number = param2;
         alpha = 0;
         if(durationMultiplier > 3)
         {
            durationMultiplier = 3;
         }
         TweenMax.to(this,duration * durationMultiplier,{
            "alpha":1,
            "onComplete":function():void
            {
               TweenMax.to(smiley,duration * durationMultiplier,{
                  "alpha":1,
                  "scaleX":4,
                  "scaleY":4,
                  "x":(85 - 26 * 4) / 2,
                  "y":(HEIGHT - 26 * 4) / 2,
                  "onComplete":function():void
                  {
                     TweenMax.to(smiley,0.2,{
                        "scaleX":3,
                        "scaleY":3,
                        "x":(85 - 26 * 3) / 2,
                        "y":(HEIGHT - 26 * 3) / 2
                     });
                  }
               });
            }
         });
      }
   }
}

