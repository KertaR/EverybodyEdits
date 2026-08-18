package
{
   import blitter.Bl;
   import items.ItemId;
   import playerio.Connection;
   import sounds.*;
   import states.PlayState;
   import utilities.Random;
   
   public class Me extends Player
   {
      
      private static var keys:Object = {
         "6":"red",
         "7":"green",
         "8":"blue",
         "408":"cyan",
         "409":"magenta",
         "410":"yellow"
      };
      
      protected var coinCountChanged:Boolean = false;
      
      protected var tickID:int = 0;
      
      public var ticks:int = 0;
      
      public var completed:Boolean = false;
      
      public function Me(param1:World, param2:String, param3:Connection, param4:PlayState)
      {
         super(param1,param2,true,param3,param4);
      }
      
      override protected function getPlayerInput() : void
      {
         if (this.isFrozen)
         {
            leftdown = 0;
            updown = 0;
            rightdown = 0;
            downdown = 0;
            spacejustdown = false;
            spacedown = false;
            horizontal = 0;
            vertical = 0;
            speedX = 0;
            speedY = 0;
            modifierX = 0;
            modifierY = 0;
            Bl.resetJustPressed();
            return;
         }
         leftdown = Bl.isKeyDown(37) || KeyBinding.left.isDown(true) ? -1 : 0;
         updown = Bl.isKeyDown(38) || KeyBinding.up.isDown(true) ? -1 : 0;
         rightdown = Bl.isKeyDown(39) || KeyBinding.right.isDown(true) ? 1 : 0;
         downdown = Bl.isKeyDown(40) || KeyBinding.down.isDown(true) ? 1 : 0;
         spacejustdown = KeyBinding.jump.isJustPressed(true);
         spacedown = KeyBinding.jump.isDown(true);
         horizontal = leftdown + rightdown;
         vertical = updown + downdown;
         Bl.resetJustPressed();
      }
      
      private function spawnCoinPatricle(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = param3 ? 5 : Random.nextInt(1,4);
         world.addParticle(new Particle(world,_loc4_,param1 * 16 + 6,param2 * 16 + 6,Math.random() - Math.random() / 10,Math.random() - Math.random() / 10,0.023,0.023,Math.random() * 360,Math.random() * 90));
      }
      
      override protected function touchBlock(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         multiJumpEffectDisplay.update();
         this.coinCountChanged = false;
         switch(current)
         {
            case ItemId.COIN_GOLD:
            case ItemId.COIN_BLUE:
               SoundManager.playMiscSound(SoundId.COIN);
               world.setTileComplex(0,param1,param2,current + 10,null);
               if(current == ItemId.COIN_GOLD)
               {
                  ++coins;
               }
               else
               {
                  ++bcoins;
               }
               this.coinCountChanged = true;
               if(!Global.base.settings.particles)
               {
                  break;
               }
               _loc4_ = 0;
               while(_loc4_ < 4)
               {
                  this.spawnCoinPatricle(param1,param2,current == ItemId.COIN_BLUE);
                  _loc4_++;
               }
               break;
            case ItemId.RESET_POINT:
               if(param3 || !KeyBinding.risky.isDown() || resetSend)
               {
                  break;
               }
               connection.send("reset",param1,param2);
               resetSend = true;
         }
         if(pastx != param1 || pasty != param2)
         {
            switch(current)
            {
               case ItemId.PIANO:
                  if(SoundManager.playPianoSound(world.lookup.getInt(param1,param2)))
                  {
                     world.lookup.setBlink(param1,param2,30);
                  }
                  break;
               case ItemId.DRUMS:
                  if(SoundManager.playDrumSound(world.lookup.getInt(param1,param2)))
                  {
                     world.lookup.setBlink(param1,param2,30);
                  }
                  break;
               case ItemId.GUITAR:
                  if(SoundManager.playGuitarSound(world.lookup.getInt(param1,param2)))
                  {
                     world.lookup.setBlink(param1,param2,30);
                  }
            }
            if(!param3)
            {
               switch(current)
               {
                  case ItemId.CROWN:
                     if(!hascrown && !param3)
                     {
                        connection.send("crown",param1,param2);
                     }
                     break;
                  case ItemId.SWITCH_PURPLE:
                     _loc5_ = world.lookup.getInt(param1,param2);
                     _loc6_ = !this.switches[_loc5_];
                     connection.send("ps",param1,param2,0,_loc5_,_loc6_);
                     pressPurpleSwitch(_loc5_,_loc6_);
                     break;
                  case ItemId.SWITCH_ORANGE:
                     _loc7_ = world.lookup.getInt(param1,param2);
                     _loc8_ = !this.world.orangeSwitches[_loc7_];
                     connection.send("ps",param1,param2,1,_loc7_,_loc8_);
                     state.pressOrangeSwitch(_loc7_,_loc8_);
                     break;
                  case ItemId.RESET_PURPLE:
                     _loc9_ = world.lookup.getInt(param1,param2);
                     if(_loc9_ == 1000 || Boolean(this.switches[_loc9_]))
                     {
                        connection.send("ps",param1,param2,0,_loc9_,false);
                        pressPurpleSwitch(_loc9_,false);
                     }
                     break;
                  case ItemId.RESET_ORANGE:
                     _loc10_ = world.lookup.getInt(param1,param2);
                     if(_loc10_ == 1000 || Boolean(this.world.orangeSwitches[_loc10_]))
                     {
                        connection.send("ps",param1,param2,1,_loc10_,false);
                        state.pressOrangeSwitch(_loc10_,false);
                     }
                     break;
                  case 411:
                  case 412:
                  case 413:
                  case 414:
                  case ItemId.SLOW_DOT_INVISIBLE:
                  case 1519:
                     world.lookup.setBlink(param1,param2,-100);
                     break;
                  case ItemId.DIAMOND:
                     connection.send("diamondtouch",param1,param2);
                     frame = 31;
                     break;
                  case ItemId.CAKE:
                     connection.send("caketouch",param1,param2);
                     break;
                  case ItemId.HOLOGRAM:
                     connection.send("hologramtouch",param1,param2);
                     frame = 100;
                     break;
                  case ItemId.CHECKPOINT:
                  case ItemId.SPAWN:
                     checkpoint_x = param1;
                     checkpoint_y = param2;
                     connection.send("checkpoint",param1,param2);
                     break;
                  case ItemId.BRICK_COMPLETE:
                     if(!hascrownsilver && !resetSend)
                     {
                        this.completed = true;
                        connection.send("levelcomplete",param1,param2,this.ticks);
                     }
                     break;
                  case ItemId.GOD_BLOCK:
                     if(_canToggleGod)
                     {
                        break;
                     }
                     connection.send("godblocktouch",param1,param2);
                     break;
                  case ItemId.MAP_BLOCK:
                     _loc11_ = Global.base.ui2instance.minimapEnabled;
                     Global.base.ui2instance.playerMapEnabled = true;
                     if(!_loc11_)
                     {
                        Global.base.ui2instance.configureInterface();
                        Global.base.SystemSay("You may now use the minimap.","* System");
                     }
                     connection.send("minimap",param1,param2);
                     break;
                  case ItemId.KEY_RED:
                  case ItemId.KEY_GREEN:
                  case ItemId.KEY_BLUE:
                  case ItemId.KEY_CYAN:
                  case ItemId.KEY_MAGENTA:
                  case ItemId.KEY_YELLOW:
                     connection.send("pressKey",param1,param2,keys[current]);
                     state.switchKey(keys[current],true);
                     break;
                  case ItemId.EFFECT_JUMP:
                     _loc12_ = world.lookup.getInt(param1,param2);
                     if(jumpBoost == _loc12_)
                     {
                        break;
                     }
                     jumpBoost = _loc12_;
                     connection.send("effect",param1,param2,Config.effectJump);
                     setEffect(Config.effectJump,jumpBoost != 0,jumpBoost);
                     break;
                  case ItemId.EFFECT_FLY:
                     _loc13_ = world.lookup.getBoolean(param1,param2);
                     if(hasLevitation == _loc13_)
                     {
                        break;
                     }
                     hasLevitation = _loc13_;
                     connection.send("effect",param1,param2,Config.effectFly);
                     setEffect(Config.effectFly,hasLevitation);
                     break;
                  case ItemId.EFFECT_RUN:
                     _loc14_ = world.lookup.getInt(param1,param2);
                     if(speedBoost == _loc14_)
                     {
                        break;
                     }
                     speedBoost = _loc14_;
                     connection.send("effect",param1,param2,Config.effectRun);
                     setEffect(Config.effectRun,speedBoost != 0,speedBoost);
                     break;
                  case ItemId.EFFECT_LOW_GRAVITY:
                     _loc15_ = world.lookup.getBoolean(param1,param2);
                     if(low_gravity == _loc15_)
                     {
                        break;
                     }
                     low_gravity = _loc15_;
                     connection.send("effect",param1,param2,Config.effectLowGravity);
                     setEffect(Config.effectLowGravity,low_gravity);
                     break;
                  case ItemId.EFFECT_CURSE:
                     _loc16_ = world.lookup.getInt(param1,param2) > 0;
                     if(cursed == _loc16_ || isInvulnerable)
                     {
                        break;
                     }
                     cursed = _loc16_;
                     connection.send("effect",param1,param2,Config.effectCurse);
                     if(!cursed)
                     {
                        setEffect(Config.effectCurse,cursed);
                     }
                     break;
                  case ItemId.EFFECT_ZOMBIE:
                     _loc17_ = world.lookup.getInt(param1,param2) > 0;
                     if(zombie == _loc17_ || isInvulnerable)
                     {
                        break;
                     }
                     zombie = _loc17_;
                     connection.send("effect",param1,param2,Config.effectZombie);
                     if(!zombie)
                     {
                        setEffect(Config.effectZombie,zombie);
                     }
                     break;
                  case ItemId.EFFECT_POISON:
                     _loc18_ = world.lookup.getInt(param1,param2) > 0;
                     if(poison == _loc18_ || isInvulnerable)
                     {
                        break;
                     }
                     poison = _loc18_;
                     connection.send("effect",param1,param2,Config.effectPoison);
                     if(!poison)
                     {
                        setEffect(Config.effectPoison,poison);
                     }
                     break;
                  case ItemId.NPC_ZOMBIE:
                     if(zombie || isInvulnerable)
                     {
                        break;
                     }
                     zombie = true;
                     connection.send("effect",param1,param2,Config.effectZombie);
                     setEffect(Config.effectZombie,true);
                     break;
                  case ItemId.EFFECT_PROTECTION:
                     _loc19_ = world.lookup.getBoolean(param1,param2);
                     if(isInvulnerable == _loc19_)
                     {
                        break;
                     }
                     isInvulnerable = _loc19_;
                     if(isInvulnerable)
                     {
                        cursed = false;
                        zombie = false;
                        poison = false;
                        isOnFire = false;
                     }
                     connection.send("effect",param1,param2,Config.effectProtection);
                     setEffect(Config.effectProtection,isInvulnerable);
                     break;
                  case ItemId.EFFECT_RESET:
                     connection.send("effect",param1,param2,Config.effectReset);
                     resetEffects(false);
                     break;
                  case ItemId.EFFECT_TEAM:
                     UpdateTeamDoors(param1,param2);
                     break;
                  case ItemId.LAVA:
                     if(isOnFire || isInvulnerable)
                     {
                        break;
                     }
                     isOnFire = true;
                     connection.send("effect",param1,param2,Config.effectFire);
                     break;
                  case ItemId.WATER:
                  case ItemId.MUD:
                  case ItemId.TOXIC_WASTE:
                     if(!isOnFire)
                     {
                        break;
                     }
                     isOnFire = false;
                     connection.send("effect",param1,param2,Config.effectFire);
                     setEffect(Config.effectFire,isOnFire);
                     break;
                  case ItemId.EFFECT_MULTIJUMP:
                     _loc20_ = world.lookup.getInt(param1,param2);
                     if(_loc20_ == maxJumps)
                     {
                        break;
                     }
                     maxJumps = _loc20_;
                     connection.send("effect",param1,param2,Config.effectMultijump);
                     setEffect(Config.effectMultijump,maxJumps != 1,maxJumps);
                     break;
                  case ItemId.EFFECT_GRAVITY:
                     _loc21_ = world.lookup.getInt(param1,param2);
                     if(flipGravity == _loc21_)
                     {
                        break;
                     }
                     flipGravity = _loc21_;
                     connection.send("effect",param1,param2,Config.effectGravity);
                     setEffect(Config.effectGravity,flipGravity != 0,flipGravity);
               }
            }
            pastx = param1;
            pasty = param2;
         }
      }
      
      override protected function sendMovement(param1:int, param2:int) : void
      {
         if(this.oh != horizontal || this.ov != vertical || ospacedown != spacedown || ospaceJP != spacejustdown && spacejustdown || this.coinCountChanged || enforceMovement)
         {
            connection.send("m",this.x,this.y,this.speedX,this.speedY,this.modifierX,this.modifierY,horizontal,vertical,gravityMultiplier,spacedown,spacejustdown,this.tickID);
            this.oh = horizontal;
            this.ov = vertical;
            this.ospacedown = spacedown;
            this.ospaceJP = spacejustdown;
            ++this.tickID;
            spacejustdown = false;
            if(this.coinCountChanged)
            {
               connection.send("c",coins,bcoins,param1,param2,this.tickID);
            }
         }
         enforceMovement = false;
      }
      
      override protected function updateStuff() : void
      {
         if(!this.completed && (Boolean(this.ticks || horizontal || vertical) || Boolean(spacedown)))
         {
            this.ticks += 1;
         }
      }
   }
}

