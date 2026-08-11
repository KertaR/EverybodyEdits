package sounds
{
   import flash.media.Sound;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   
   public class SoundManager
   {
      
      private static var Coin:Class = SoundManager_Coin;
      
      private static var Banned:Class = SoundManager_Banned;
      
      private static var Over9000:Class = SoundManager_Over9000;
      
      private static var WootUp:Class = SoundManager_WootUp;
      
      private static var Like:Class = SoundManager_Like;
      
      private static var Unlike:Class = SoundManager_Unlike;
      
      private static var Favorite:Class = SoundManager_Favorite;
      
      private static var Unfavorite:Class = SoundManager_Unfavorite;
      
      private static var Magic:Class = SoundManager_Magic;
      
      private static var DontPanic:Class = SoundManager_DontPanic;
      
      private static var Click:Class = SoundManager_Click;
      
      private static var Gong:Class = SoundManager_Gong;
      
      private static var miscSounds:Object = {};
      
      private static var piano1:Class = SoundManager_piano1;
      
      private static var piano2:Class = SoundManager_piano2;
      
      private static var piano3:Class = SoundManager_piano3;
      
      private static var piano4:Class = SoundManager_piano4;
      
      private static var piano5:Class = SoundManager_piano5;
      
      private static var piano6:Class = SoundManager_piano6;
      
      private static var piano7:Class = SoundManager_piano7;
      
      private static var piano8:Class = SoundManager_piano8;
      
      private static var piano9:Class = SoundManager_piano9;
      
      private static var piano10:Class = SoundManager_piano10;
      
      private static var piano11:Class = SoundManager_piano11;
      
      private static var piano12:Class = SoundManager_piano12;
      
      private static var piano13:Class = SoundManager_piano13;
      
      private static var piano14:Class = SoundManager_piano14;
      
      private static var piano15:Class = SoundManager_piano15;
      
      private static var piano16:Class = SoundManager_piano16;
      
      private static var piano17:Class = SoundManager_piano17;
      
      private static var piano18:Class = SoundManager_piano18;
      
      private static var piano19:Class = SoundManager_piano19;
      
      private static var piano20:Class = SoundManager_piano20;
      
      private static var piano21:Class = SoundManager_piano21;
      
      private static var piano22:Class = SoundManager_piano22;
      
      private static var piano23:Class = SoundManager_piano23;
      
      private static var piano24:Class = SoundManager_piano24;
      
      private static var piano25:Class = SoundManager_piano25;
      
      private static var piano26:Class = SoundManager_piano26;
      
      private static var piano27:Class = SoundManager_piano27;
      
      private static var piano28:Class = SoundManager_piano28;
      
      private static var piano29:Class = SoundManager_piano29;
      
      private static var piano30:Class = SoundManager_piano30;
      
      private static var piano31:Class = SoundManager_piano31;
      
      private static var piano32:Class = SoundManager_piano32;
      
      private static var piano33:Class = SoundManager_piano33;
      
      private static var piano34:Class = SoundManager_piano34;
      
      private static var piano35:Class = SoundManager_piano35;
      
      private static var piano36:Class = SoundManager_piano36;
      
      private static var piano37:Class = SoundManager_piano37;
      
      private static var piano38:Class = SoundManager_piano38;
      
      private static var piano39:Class = SoundManager_piano39;
      
      private static var piano40:Class = SoundManager_piano40;
      
      private static var piano41:Class = SoundManager_piano41;
      
      private static var piano42:Class = SoundManager_piano42;
      
      private static var piano43:Class = SoundManager_piano43;
      
      private static var piano44:Class = SoundManager_piano44;
      
      private static var piano45:Class = SoundManager_piano45;
      
      private static var piano46:Class = SoundManager_piano46;
      
      private static var piano47:Class = SoundManager_piano47;
      
      private static var piano48:Class = SoundManager_piano48;
      
      private static var piano49:Class = SoundManager_piano49;
      
      private static var piano50:Class = SoundManager_piano50;
      
      private static var piano51:Class = SoundManager_piano51;
      
      private static var piano52:Class = SoundManager_piano52;
      
      private static var piano53:Class = SoundManager_piano53;
      
      private static var piano54:Class = SoundManager_piano54;
      
      private static var piano55:Class = SoundManager_piano55;
      
      private static var piano56:Class = SoundManager_piano56;
      
      private static var piano57:Class = SoundManager_piano57;
      
      private static var piano58:Class = SoundManager_piano58;
      
      private static var piano59:Class = SoundManager_piano59;
      
      private static var piano60:Class = SoundManager_piano60;
      
      private static var piano61:Class = SoundManager_piano61;
      
      private static var piano62:Class = SoundManager_piano62;
      
      private static var piano63:Class = SoundManager_piano63;
      
      private static var piano64:Class = SoundManager_piano64;
      
      private static var piano65:Class = SoundManager_piano65;
      
      private static var piano66:Class = SoundManager_piano66;
      
      private static var piano67:Class = SoundManager_piano67;
      
      private static var piano68:Class = SoundManager_piano68;
      
      private static var piano69:Class = SoundManager_piano69;
      
      private static var piano70:Class = SoundManager_piano70;
      
      private static var piano71:Class = SoundManager_piano71;
      
      private static var piano72:Class = SoundManager_piano72;
      
      private static var piano73:Class = SoundManager_piano73;
      
      private static var piano74:Class = SoundManager_piano74;
      
      private static var piano75:Class = SoundManager_piano75;
      
      private static var piano76:Class = SoundManager_piano76;
      
      private static var piano77:Class = SoundManager_piano77;
      
      private static var piano78:Class = SoundManager_piano78;
      
      private static var piano79:Class = SoundManager_piano79;
      
      private static var piano80:Class = SoundManager_piano80;
      
      private static var piano81:Class = SoundManager_piano81;
      
      private static var piano82:Class = SoundManager_piano82;
      
      private static var piano83:Class = SoundManager_piano83;
      
      private static var piano84:Class = SoundManager_piano84;
      
      private static var piano85:Class = SoundManager_piano85;
      
      private static var piano86:Class = SoundManager_piano86;
      
      private static var piano87:Class = SoundManager_piano87;
      
      private static var piano88:Class = SoundManager_piano88;
      
      public static var pianoSounds:Vector.<Sound> = new Vector.<Sound>();
      
      private static var drums01:Class = SoundManager_drums01;
      
      private static var drums02:Class = SoundManager_drums02;
      
      private static var drums03:Class = SoundManager_drums03;
      
      private static var drums04:Class = SoundManager_drums04;
      
      private static var drums05:Class = SoundManager_drums05;
      
      private static var drums06:Class = SoundManager_drums06;
      
      private static var drums07:Class = SoundManager_drums07;
      
      private static var drums08:Class = SoundManager_drums08;
      
      private static var drums09:Class = SoundManager_drums09;
      
      private static var drums10:Class = SoundManager_drums10;
      
      private static var drums11:Class = SoundManager_drums11;
      
      private static var drums12:Class = SoundManager_drums12;
      
      private static var drums13:Class = SoundManager_drums13;
      
      private static var drums14:Class = SoundManager_drums14;
      
      private static var drums15:Class = SoundManager_drums15;
      
      private static var drums16:Class = SoundManager_drums16;
      
      private static var drums17:Class = SoundManager_drums17;
      
      private static var drums18:Class = SoundManager_drums18;
      
      private static var drums19:Class = SoundManager_drums19;
      
      private static var drums20:Class = SoundManager_drums20;
      
      public static var drumSounds:Vector.<Sound> = new Vector.<Sound>();
      
      private static var guitar1:Class = SoundManager_guitar1;
      
      private static var guitar2:Class = SoundManager_guitar2;
      
      private static var guitar3:Class = SoundManager_guitar3;
      
      private static var guitar4:Class = SoundManager_guitar4;
      
      private static var guitar5:Class = SoundManager_guitar5;
      
      private static var guitar6:Class = SoundManager_guitar6;
      
      private static var guitar7:Class = SoundManager_guitar7;
      
      private static var guitar8:Class = SoundManager_guitar8;
      
      private static var guitar9:Class = SoundManager_guitar9;
      
      private static var guitar10:Class = SoundManager_guitar10;
      
      private static var guitar11:Class = SoundManager_guitar11;
      
      private static var guitar12:Class = SoundManager_guitar12;
      
      private static var guitar13:Class = SoundManager_guitar13;
      
      private static var guitar14:Class = SoundManager_guitar14;
      
      private static var guitar15:Class = SoundManager_guitar15;
      
      private static var guitar16:Class = SoundManager_guitar16;
      
      private static var guitar17:Class = SoundManager_guitar17;
      
      private static var guitar18:Class = SoundManager_guitar18;
      
      private static var guitar19:Class = SoundManager_guitar19;
      
      private static var guitar20:Class = SoundManager_guitar20;
      
      private static var guitar21:Class = SoundManager_guitar21;
      
      private static var guitar22:Class = SoundManager_guitar22;
      
      private static var guitar23:Class = SoundManager_guitar23;
      
      private static var guitar24:Class = SoundManager_guitar24;
      
      private static var guitar25:Class = SoundManager_guitar25;
      
      private static var guitar26:Class = SoundManager_guitar26;
      
      private static var guitar27:Class = SoundManager_guitar27;
      
      private static var guitar28:Class = SoundManager_guitar28;
      
      private static var guitar29:Class = SoundManager_guitar29;
      
      private static var guitar30:Class = SoundManager_guitar30;
      
      private static var guitar31:Class = SoundManager_guitar31;
      
      private static var guitar32:Class = SoundManager_guitar32;
      
      private static var guitar33:Class = SoundManager_guitar33;
      
      private static var guitar34:Class = SoundManager_guitar34;
      
      private static var guitar35:Class = SoundManager_guitar35;
      
      private static var guitar36:Class = SoundManager_guitar36;
      
      private static var guitar37:Class = SoundManager_guitar37;
      
      private static var guitar38:Class = SoundManager_guitar38;
      
      private static var guitar39:Class = SoundManager_guitar39;
      
      private static var guitar40:Class = SoundManager_guitar40;
      
      private static var guitar41:Class = SoundManager_guitar41;
      
      private static var guitar42:Class = SoundManager_guitar42;
      
      private static var guitar43:Class = SoundManager_guitar43;
      
      private static var guitar44:Class = SoundManager_guitar44;
      
      private static var guitar45:Class = SoundManager_guitar45;
      
      private static var guitar46:Class = SoundManager_guitar46;
      
      private static var guitar47:Class = SoundManager_guitar47;
      
      private static var guitar48:Class = SoundManager_guitar48;
      
      private static var guitar49:Class = SoundManager_guitar49;
      
      public static var guitarSounds:Vector.<Sound> = new Vector.<Sound>();
      
      public static var guitarMap:Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,1,2,3,4,5,6,7,8,9,10,11,12,13,14,26,27,28,29,30,21,22,23,24,25,1,2,3,4,5,6,7,8,9,10,31,32,33,34,35,36,27,28,29,30,21,22,23,24,25,1,2,3,4,5,37,38,39,40,41,42,32,33,34,35,36,27,28,29,30,21,22,23,24,25,43,44,45,46,47,48,38,39,40,41,42,32,33,34,35,36,27,28,29,30];
      
      public function SoundManager()
      {
         super();
      }
      
      public static function init() : void
      {
         miscSounds[SoundId.COIN] = new Coin();
         miscSounds[SoundId.BANNED] = new Banned();
         miscSounds[SoundId.OVER9000] = new Over9000();
         miscSounds[SoundId.WOOT_UP] = new WootUp();
         miscSounds[SoundId.LIKE] = new Like();
         miscSounds[SoundId.UNLIKE] = new Unlike();
         miscSounds[SoundId.FAVORITE] = new Favorite();
         miscSounds[SoundId.UNFAVORITE] = new Unfavorite();
         miscSounds[SoundId.MAGIC] = new Magic();
         miscSounds[SoundId.DONTPANIC] = new DontPanic();
         miscSounds[SoundId.CLICK] = new Click();
         miscSounds[SoundId.GONG] = new Gong();
         pianoSounds.push(new piano1() as Sound,new piano2() as Sound,new piano3() as Sound,new piano4() as Sound,new piano5() as Sound,new piano6() as Sound,new piano7() as Sound,new piano8() as Sound,new piano9() as Sound,new piano10() as Sound,new piano11() as Sound,new piano12() as Sound,new piano13() as Sound,new piano14() as Sound,new piano15() as Sound,new piano16() as Sound,new piano17() as Sound,new piano18() as Sound,new piano19() as Sound,new piano20() as Sound,new piano21() as Sound,new piano22() as Sound,new piano23() as Sound,new piano24() as Sound,new piano25() as Sound,new piano26() as Sound,new piano27() as Sound,new piano28() as Sound,new piano29() as Sound,new piano30() as Sound,new piano31() as Sound,new piano32() as Sound,new piano33() as Sound,new piano34() as Sound,new piano35() as Sound,new piano36() as Sound,new piano37() as Sound,new piano38() as Sound,new piano39() as Sound,new piano40() as Sound,new piano41() as Sound,new piano42() as Sound,new piano43() as Sound,new piano44() as Sound
         ,new piano45() as Sound,new piano46() as Sound,new piano47() as Sound,new piano48() as Sound,new piano49() as Sound,new piano50() as Sound,new piano51() as Sound,new piano52() as Sound,new piano53() as Sound,new piano54() as Sound,new piano55() as Sound,new piano56() as Sound,new piano57() as Sound,new piano58() as Sound,new piano59() as Sound,new piano60() as Sound,new piano61() as Sound,new piano62() as Sound,new piano63() as Sound,new piano64() as Sound,new piano65() as Sound,new piano66() as Sound,new piano67() as Sound,new piano68() as Sound,new piano69() as Sound,new piano70() as Sound,new piano71() as Sound,new piano72() as Sound,new piano73() as Sound,new piano74() as Sound,new piano75() as Sound,new piano76() as Sound,new piano77() as Sound,new piano78() as Sound,new piano79() as Sound,new piano80() as Sound,new piano81() as Sound,new piano82() as Sound,new piano83() as Sound,new piano84() as Sound,new piano85() as Sound,new piano86() as Sound,new piano87() as Sound,new piano88() as Sound);
         drumSounds.push(new drums01() as Sound,new drums02() as Sound,new drums03() as Sound,new drums04() as Sound,new drums05() as Sound,new drums06() as Sound,new drums07() as Sound,new drums08() as Sound,new drums09() as Sound,new drums10() as Sound,new drums11() as Sound,new drums12() as Sound,new drums13() as Sound,new drums14() as Sound,new drums15() as Sound,new drums16() as Sound,new drums17() as Sound,new drums18() as Sound,new drums19() as Sound,new drums20() as Sound);
         guitarSounds.push(new guitar1() as Sound,new guitar2() as Sound,new guitar3() as Sound,new guitar4() as Sound,new guitar5() as Sound,new guitar6() as Sound,new guitar7() as Sound,new guitar8() as Sound,new guitar9() as Sound,new guitar10() as Sound,new guitar11() as Sound,new guitar12() as Sound,new guitar13() as Sound,new guitar14() as Sound,new guitar15() as Sound,new guitar16() as Sound,new guitar17() as Sound,new guitar18() as Sound,new guitar19() as Sound,new guitar20() as Sound,new guitar21() as Sound,new guitar22() as Sound,new guitar23() as Sound,new guitar24() as Sound,new guitar25() as Sound,new guitar26() as Sound,new guitar27() as Sound,new guitar28() as Sound,new guitar29() as Sound,new guitar30() as Sound,new guitar31() as Sound,new guitar32() as Sound,new guitar33() as Sound,new guitar34() as Sound,new guitar35() as Sound,new guitar36() as Sound,new guitar37() as Sound,new guitar38() as Sound,new guitar39() as Sound,new guitar40() as Sound,new guitar41() as Sound,new guitar42() as Sound
         ,new guitar43() as Sound,new guitar44() as Sound,new guitar45() as Sound,new guitar46() as Sound,new guitar47() as Sound,new guitar48() as Sound,new guitar49() as Sound);
      }
      
      public static function playAnySound(param1:String) : Boolean
      {
         var id:String = param1;
         try
         {
            if(id.indexOf("piano") == 0)
            {
               return playPianoSound(int(id.substr(5)));
            }
            if(id.indexOf("drum") == 0)
            {
               return playDrumSound(int(id.substr(4)));
            }
            if(id.indexOf("guitar") == 0)
            {
               return playGuitarSound(int(id.substr(6)));
            }
            return playMiscSound(id);
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public static function playMiscSound(param1:String) : Boolean
      {
         return playSound(miscSounds[param1]);
      }
      
      public static function playPianoSound(param1:int) : Boolean
      {
         return playSound(pianoSounds[param1 + 27]);
      }
      
      public static function playDrumSound(param1:int) : Boolean
      {
         return playSound(drumSounds[param1]);
      }
      
      public static function playGuitarSound(param1:int) : Boolean
      {
         return playSound(guitarSounds[param1]);
      }
      
      public static function playSound(param1:Sound) : Boolean
      {
         if(Global.base.settings.volume <= 0)
         {
            return false;
         }
         SoundMixer.soundTransform = new SoundTransform(Global.base.settings.volume / 100);
         param1.play();
         return true;
      }
   }
}

