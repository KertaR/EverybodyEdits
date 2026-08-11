package io.player.tools
{
   public class Badwords
   {
      
      public static var removeBadWords:Boolean = false;
      
      public static var badwordReplacement:String = "****";
      
      private static var badwords:Array = "ahole*,anal,anally,anus*,arse*,arss*,ashole*,asshole*,asswipe*,asslick*,*ballsac*,*ballsdeep*,*bastard*,biatch*,bish,*bitch*,*blowjob*,*bollock*,*boner,bukkak*,butthole*,buttlick*,buttplug*,buttwipe*,carpetmunch*,chink*,chode*,choad*,clit*,*cnts*,cock*,cok,cokbite*,cokhead*,cokjock*,cokmunch*,coks,coksuck*,coksmoke*,cuck,cuckold,cum,cunnie*,cunnilingus*,cunny*,*cunt*,*dick*,dik,dike*,diks,dildo*,douche*,doosh*,dooch*,*dumbars*,*dumars*,*dumass*,edjaculat*,ejacculat*,ejackulat*,ejaculat*,ejaculit*,ejakulat*,enema*,faeces*,fag*,fap,fapping*,*fatars*,*fatass*,fck*,*fcuk*,feces*,felatio*,felch*,feltch*,flikker*,*foreskin*,*forskin*,*fvck*,*fuck*,*fudgepack*,*fuk*,gaylord,*handjob*,hardon*,*hitler*,hoar,honkey*,*jackars*,*jackass*,*jackoff*,jap,*jerkoff*,jigaboo*,jiss*,*jizz*,kike*,knobjock*,knobrid*,knobsuck*,kooch*,kootch*,kraut*,kunt*,kyke*,*lardars*,*lardass*,lesbo*,lessie*,lezzie*,lezzy*,*masturbat*,minge*,minging*,mofo,muffdive*,munge*,munging*,*nazi*,*negro*,niga,*nigg*,niglet*,niqqa,nutsack*,*orgasm*,*orgasum*,panooch,pecker,peanis,peeenis,peeenus,peeenusss,peenis,peenus,peinus,penas,*penis*,penor,penus,phuc,phuck*,phuk*,pissflap,poon,poonani,poonanni,poonanny,poonany,poontang,porn*,pula,pule,punani,punanni,punanny,punany,pusse,pussee,pussie,pussies,pussy,pussying,pussylick*,pussysuck*,poossy*,poossie*,puuke,puuker,queef*,queer*,qweer*,qweir*,recktum*,rectum*,renob,retard*,rimming*,rimjob*,ruski*,sadist*,scank*,schlong*,schmuck*,scrote*,scrotum*,semen*,sex*,shag,shat,shemale*,*shit*,skank*,*slut*,spic,spick,spik,stalin,tard,teets,testic*,tit,tits,titt,titty*,tittie*,twat*,*vagina*,*vaginna*,*vaggina*,*vaagina*,*vagiina*,vag,vags,vaj,vajs,*vajina*,*vulva*,wank*,*whoar*,whoe,*whor*,*B=D*,*B==D*,*B===*,*===D,8===*"
      .toLowerCase().split(",");
      
      public function Badwords()
      {
         super();
      }
      
      public static function Filter(param1:String, param2:Boolean = false) : String
      {
         if(!Global.base.settings.wordFilter && !param2)
         {
            return param1;
         }
         if(param1 == null)
         {
            return param1;
         }
         var _loc3_:String = param1;
         _loc3_ = _loc3_.replace(/(\s){2,}/mgi," ");
         _loc3_ = _loc3_.replace("¡","i");
         var _loc4_:Array = _loc3_.split(" ");
         var _loc5_:Boolean = false;
         var _loc6_:* = 0;
         while(_loc6_ < _loc4_.length - 1)
         {
            if((_loc4_[_loc6_].length == 1 || _loc5_) && _loc4_[_loc6_ + 1].length == 1)
            {
               _loc4_[_loc6_] += _loc4_[_loc6_ + 1];
               _loc4_.splice(_loc6_ + 1,1);
               _loc6_--;
               _loc5_ = true;
            }
            else
            {
               _loc5_ = false;
            }
            _loc6_++;
         }
         var _loc7_:Boolean = false;
         var _loc8_:* = 0;
         while(_loc8_ < _loc4_.length)
         {
            if(isBadword(_loc4_[_loc8_]))
            {
               if(removeBadWords)
               {
                  _loc4_.splice(_loc8_--,1);
               }
               else
               {
                  _loc4_[_loc8_] = badwordReplacement;
               }
               _loc7_ = true;
            }
            _loc8_++;
         }
         if(_loc7_)
         {
            return _loc4_.join(" ");
         }
         return param1;
      }
      
      public static function isBadword(param1:String, param2:Boolean = false) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         param1 = param1.toLowerCase();
         var _loc3_:int = 0;
         while(_loc3_ < badwords.length)
         {
            _loc5_ = badwords[_loc3_];
            if(_loc5_.charAt(_loc5_.length - 1) == "*" && _loc5_.charAt(0) == "*")
            {
               _loc5_ = _loc5_.substr(1).substr(0,_loc5_.length - 2);
               if(param1.indexOf(_loc5_) != -1)
               {
                  return true;
               }
            }
            else if(_loc5_.charAt(0) == "*")
            {
               _loc5_ = _loc5_.substr(1);
               if(param1.length >= _loc5_.length && param1.indexOf(_loc5_) == param1.length - _loc5_.length)
               {
                  return true;
               }
            }
            else if(_loc5_.charAt(0) == "+")
            {
               _loc5_ = _loc5_.substr(1);
               if(param1.length > _loc5_.length && param1.indexOf(_loc5_) == param1.length - _loc5_.length)
               {
                  return true;
               }
            }
            else if(_loc5_.charAt(_loc5_.length - 1) == "*")
            {
               _loc5_ = _loc5_.substr(0,_loc5_.length - 1);
               if(param1.indexOf(_loc5_) == 0)
               {
                  return true;
               }
            }
            else if(param1.length >= _loc5_.length && _loc5_.charAt(_loc5_.length - 1) == "+")
            {
               _loc5_ = _loc5_.substr(0,_loc5_.length - 1);
               if(param1.length > _loc5_.length && param1.indexOf(_loc5_) == 0)
               {
                  return true;
               }
            }
            else if(param1 == _loc5_)
            {
               return true;
            }
            _loc3_++;
         }
         if(param2)
         {
            return false;
         }
         if(isBadword(param1.replace(/[^\w| ]/mgi,""),true))
         {
            return true;
         }
         _loc4_ = param1.replace(/[^\w| ]/mgi," ");
         if(_loc4_ != param1 && Filter(_loc4_) != _loc4_)
         {
            return true;
         }
         _loc4_ = param1;
         _loc4_ = _loc4_.replace(/\$/mgi,"s");
         _loc4_ = _loc4_.replace(/5/mgi,"s");
         _loc4_ = _loc4_.replace(/3/mgi,"b");
         _loc4_ = _loc4_.replace(/\!/mgi,"l");
         _loc4_ = _loc4_.replace(/0/mgi,"o");
         _loc4_ = _loc4_.replace(/1/mgi,"i");
         _loc4_ = _loc4_.replace(/\#/mgi,"h");
         _loc4_ = _loc4_.replace(/€/mgi,"e");
         _loc4_ = _loc4_.replace(/3/mgi,"e");
         _loc4_ = _loc4_.replace(/£/mgi,"e");
         _loc4_ = _loc4_.replace(/\(/mgi,"c");
         _loc4_ = _loc4_.replace(/2/mgi,"z");
         _loc4_ = _loc4_.replace(/z/mgi,"s");
         _loc4_ = _loc4_.replace(/4/mgi,"a");
         _loc4_ = _loc4_.replace(/8/mgi,"b");
         if(isBadword(_loc4_,true))
         {
            return true;
         }
         return false;
      }
   }
}

