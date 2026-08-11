package ui.ingame.sam
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import items.ItemManager;
   import items.ItemSmiley;
   import playerio.Message;
   import sample.ui.components.Label;
   
   public class Hotbar extends Sprite
   {
      
      private var handleSmileyDown:Function;
      
      private var ui2:UI2;
      
      private var _hotbarSmileys:Array = new Array();
      
      public function Hotbar(param1:UI2, param2:Function)
      {
         super();
         this.ui2 = param1;
         this.handleSmileyDown = param2;
         this.setSmileys(Global.base.settings.smileys);
      }
      
      public function addSmiley(param1:SmileyInstance, param2:int, param3:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:ItemSmiley = null;
         var _loc6_:int = 0;
         var _loc7_:SmileyInstance = null;
         var _loc8_:Rectangle = null;
         var _loc9_:* = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         for each(_loc4_ in this._hotbarSmileys)
         {
            _loc5_ = ItemManager.getSmileyById(_loc4_);
            if(_loc5_.id == param1.item.id)
            {
               return false;
            }
         }
         if(this._hotbarSmileys.length > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < numChildren)
            {
               _loc7_ = getChildAt(_loc6_) as SmileyInstance;
               if(_loc7_)
               {
                  _loc8_ = new Rectangle(_loc7_.x,_loc7_.y,_loc7_.width,_loc7_.height);
                  if(_loc8_.contains(param2,param3))
                  {
                     _loc9_ = int(this._hotbarSmileys.length);
                     while(_loc9_ > _loc7_.index)
                     {
                        _loc10_ = int(this._hotbarSmileys[_loc9_]);
                        _loc11_ = int(this._hotbarSmileys[_loc9_ - 1]);
                        this._hotbarSmileys[_loc9_] = this._hotbarSmileys[_loc9_ - 1];
                        _loc9_--;
                     }
                     this._hotbarSmileys[_loc7_.index] = param1.item.id;
                     break;
                  }
               }
               _loc6_++;
            }
         }
         if(this._hotbarSmileys.indexOf(param1.item.id) == -1)
         {
            this._hotbarSmileys.push(param1.item.id);
         }
         if(this._hotbarSmileys.length >= 10)
         {
            this._hotbarSmileys.splice(10,this._hotbarSmileys.length);
         }
         this.redrawHotbarSmileys();
         return this._hotbarSmileys.indexOf(param1.item.id) != -1;
      }
      
      public function removeSmiley(param1:SmileyInstance) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ItemSmiley = null;
         for each(_loc2_ in this._hotbarSmileys)
         {
            _loc3_ = ItemManager.getSmileyById(_loc2_);
            if(_loc3_.id == param1.item.id)
            {
               this._hotbarSmileys.splice(param1.index,1);
               param1.destroy(true);
            }
         }
         this.redrawHotbarSmileys();
      }
      
      public function redrawHotbarSmileys(param1:Boolean = true) : void
      {
         var ox:int;
         var oy:int;
         var i:int;
         var smileyItem:ItemSmiley = null;
         var smiley:SmileyInstance = null;
         var dragToHotbar:Label = null;
         var message:Message = null;
         var j:int = 0;
         var save:Boolean = param1;
         removeChildren();
         ox = 5;
         oy = 5;
         i = 0;
         while(i < this._hotbarSmileys.length)
         {
            smileyItem = ItemManager.getSmileyById(this._hotbarSmileys[i]);
            smiley = new SmileyInstance(smileyItem,this.ui2,Global.playerInstance.wearsGoldSmiley,i);
            smiley.x = ox;
            smiley.y = oy;
            smiley.scaleX = 1;
            smiley.scaleY = 1;
            ox += 16 + 5;
            addChild(smiley);
            smiley.hitBox.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               handleSmileyDown(param1,true);
            });
            i++;
         }
         if(this._hotbarSmileys.length == 0)
         {
            dragToHotbar = new Label("Save smileys by dragging them here",12,"left",16777215,false,"visitor");
            dragToHotbar.x = (width - dragToHotbar.width) / 2;
            dragToHotbar.y = 12;
            addChild(dragToHotbar);
         }
         if(save)
         {
            message = new Message("hotbarSmileys");
            j = 0;
            while(j < this._hotbarSmileys.length)
            {
               message.add(this._hotbarSmileys[j]);
               j++;
            }
            this.ui2.connection.sendMessage(message);
            Global.base.settings.smileys = this._hotbarSmileys;
         }
      }
      
      public function setSmileys(param1:Array) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         this._hotbarSmileys = param1;
         this.redrawHotbarSmileys(false);
      }
      
      public function get hotbarSmileys() : Array
      {
         return this._hotbarSmileys;
      }
      
      override public function get height() : Number
      {
         return 36;
      }
   }
}

