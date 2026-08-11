package ui
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Circ;
   import com.greensock.easing.Cubic;
   
   public class LoadingScreen extends assets_loadingscreen
   {
      
      public function LoadingScreen(param1:String)
      {
         var text:String = param1;
         super();
         this.textfield.alpha = 0;
         this.textfield.text = text;
         TweenMax.from(gear,0.25,{
            "y":gear.y - 100,
            "alpha":0,
            "ease":Circ.easeOut,
            "blurFilter":{
               "blurX":10,
               "blurY":10
            },
            "onComplete":function():void
            {
               TweenMax.from(gear,0.37,{
                  "glowFilter":{
                     "color":16777215,
                     "blurX":10,
                     "blurY":10,
                     "strength":1,
                     "alpha":1
                  },
                  "ease":Cubic.easeInOut
               });
            }
         });
         TweenMax.to(textfield,0.25,{"alpha":1});
      }
      
      public function close() : void
      {
         TweenMax.delayedCall(0.25,function():void
         {
            TweenMax.to(gear,0.25,{
               "y":gear.y - 100,
               "alpha":0,
               "ease":Circ.easeIn,
               "blurFilter":{
                  "blurX":10,
                  "blurY":10
               }
            });
            TweenMax.to(textfield,0.25,{
               "alpha":0,
               "blurFilter":{
                  "blurX":4,
                  "blurY":4
               },
               "onComplete":function():void
               {
                  if(Global.base.loading != null)
                  {
                     TweenMax.to(Global.base.loading,0.4,{
                        "alpha":0,
                        "onComplete":function():void
                        {
                           if(Global.base.overlayContainer.contains(Global.base.loading))
                           {
                              Global.base.overlayContainer.removeChild(Global.base.loading);
                              Global.base.loading = null;
                           }
                        }
                     });
                  }
               }
            });
         });
      }
   }
}

