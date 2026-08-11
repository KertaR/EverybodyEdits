package ui.ingame
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Sine;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class EffectDisplay extends Sprite
   {
      
      public var effects:Vector.<EffectMarker> = new Vector.<EffectMarker>();
      
      public var multiJumpCounter:MultiJumpCounter;
      
      private var zombieCounter:ZombieCounter;
      
      private var curseCounter:CurseCounter;
      
      public function EffectDisplay(param1:int, param2:int)
      {
         super();
         this.zombieCounter = new ZombieCounter(param2);
         addChild(this.zombieCounter);
         this.curseCounter = new CurseCounter(param1);
         addChild(this.curseCounter);
         this.multiJumpCounter = new MultiJumpCounter();
         addChild(this.multiJumpCounter);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         this.refresh();
      }
      
      public function addEffect(param1:BitmapData, param2:int, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc7_:Number = NaN;
         var _loc5_:EffectMarker = new EffectMarker(param1,param2,param3,param4);
         this.effects.push(_loc5_);
         this.sortEffects();
         var _loc6_:int = 0;
         while(_loc6_ < this.effects.length)
         {
            addChild(this.effects[_loc6_]);
            _loc7_ = this.effects[_loc6_] == _loc5_ ? 0 : 0.2;
            this.moveToPosition(this.effects[_loc6_],_loc6_,_loc7_);
            this.effects[_loc6_].refresh();
            _loc6_++;
         }
         TweenMax.to(_loc5_,0,{
            "x":-_loc5_.width,
            "alpha":0
         });
         TweenMax.to(_loc5_,0.2,{
            "x":0,
            "alpha":1,
            "ease":Sine
         });
      }
      
      public function removeEffect(param1:int) : void
      {
         var id:int = param1;
         var i:int = 0;
         while(i < this.effects.length)
         {
            if(this.effects[i].id == id)
            {
               TweenMax.to(this.effects[i],0.3,{
                  "x":-this.effects[i].width,
                  "alpha":0,
                  "onComplete":function(param1:EffectMarker):void
                  {
                     removeChild(param1);
                  },
                  "onCompleteParams":[this.effects[i]]
               });
               this.effects.splice(i,1);
               i--;
            }
            else
            {
               this.moveToPosition(this.effects[i],i,0.5);
            }
            i++;
         }
      }
      
      public function removeAll() : void
      {
         var i:int = 0;
         while(i < this.effects.length)
         {
            TweenMax.to(this.effects[i],0.3,{
               "x":-this.effects[i].width,
               "alpha":0,
               "onComplete":function(param1:EffectMarker):void
               {
                  removeChild(param1);
               },
               "onCompleteParams":[this.effects[i]]
            });
            i++;
         }
         this.effects = new Vector.<EffectMarker>();
      }
      
      public function update() : void
      {
         this.multiJumpCounter.update();
         this.zombieCounter.update();
         this.curseCounter.update();
         this.refresh();
      }
      
      public function setLimits(param1:int, param2:int) : void
      {
         this.curseCounter.setLimit(param1);
         this.zombieCounter.setLimit(param2);
      }
      
      public function refresh() : void
      {
         this.multiJumpCounter.y = 0;
         this.zombieCounter.y = 0;
         this.curseCounter.y = 0;
         if(this.zombieCounter.visible)
         {
            this.curseCounter.y = this.zombieCounter.y + this.zombieCounter.height + 2 >> 0;
         }
         else
         {
            this.curseCounter.y = 0;
         }
         if(this.zombieCounter.visible && this.curseCounter.visible)
         {
            this.multiJumpCounter.y = this.curseCounter.y + this.curseCounter.height + 2 >> 0;
         }
         else if(this.zombieCounter.visible)
         {
            this.multiJumpCounter.y = this.zombieCounter.y + this.zombieCounter.height + 2 >> 0;
         }
         else if(this.curseCounter.visible)
         {
            this.multiJumpCounter.y = this.curseCounter.y + this.curseCounter.height + 2 >> 0;
         }
         else
         {
            this.multiJumpCounter.y = 0;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.effects.length)
         {
            this.moveToPosition(this.effects[_loc1_],_loc1_,0.5);
            this.effects[_loc1_].refresh();
            _loc1_++;
         }
      }
      
      private function sortEffects() : void
      {
         this.effects.sort(function(param1:EffectMarker, param2:EffectMarker):int
         {
            return param1.timeLeft < param2.timeLeft ? 1 : -1;
         });
      }
      
      private function moveToPosition(param1:EffectMarker, param2:int, param3:int) : void
      {
         var _loc4_:int = param2 * (EffectMarker.HEIGHT + 2);
         if(this.multiJumpCounter.visible)
         {
            _loc4_ += this.multiJumpCounter.height + 2;
         }
         if(this.zombieCounter.visible)
         {
            _loc4_ += this.zombieCounter.height + 2;
         }
         if(this.curseCounter.visible)
         {
            _loc4_ += this.curseCounter.height + 2;
         }
         TweenMax.to(param1,param3,{
            "y":_loc4_,
            "ease":Back
         });
      }
   }
}

