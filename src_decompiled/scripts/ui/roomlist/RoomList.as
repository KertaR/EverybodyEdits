package ui.roomlist
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import io.player.tools.Badwords;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   import states.LobbyState;
   
   public class RoomList extends asset_roomlist
   {
      
      private static var lastTab:int = -1;
      
      public static const SORT_BY_ONLINE:int = 0;
      
      public static const SORT_BY_PLAYS:int = 1;
      
      public static const SORT_BY_LIKES:int = 2;
      
      public static const SORT_BY_NAME:int = 3;
      
      private var container:Rows;
      
      private var base:ScrollBox;
      
      private var callback:Function;
      
      private var reloadWorldsCallback:Function;
      
      private var rooms:Array;
      
      private var roomsSorted:Array;
      
      private var sortby:int = 0;
      
      private var searchEmpty:Boolean = true;
      
      private var currentTab:MovieClip;
      
      private var canReload:Boolean = true;
      
      public var loading:Boolean = false;
      
      private var clipLoading:loadingrooms;
      
      private var clipNone:norooms;
      
      private var clipBuy:BuyWorld;
      
      private var clipCreate:CreateOpenWorld;
      
      private var clipRegister:GuestRegisterForWorlds;
      
      public function RoomList(param1:Function, param2:Function)
      {
         var callback:Function = param1;
         var reloadWorldsCallback:Function = param2;
         this.container = new Rows();
         this.rooms = [];
         this.roomsSorted = [];
         super();
         this.base = new ScrollBox().margin(0,1,1,1).add(this.container);
         this.container.spacing(0);
         this.container.forceScale = false;
         this.base.scrollMultiplier = 10;
         addChildAt(this.base,getChildIndex(sortMenu));
         this.callback = callback;
         this.reloadWorldsCallback = reloadWorldsCallback;
         this.base.x = 2 + 6;
         this.base.y = 2 + 38;
         this.base.width = 420 - 3 - 6;
         this.base.height = 325 - 3;
         tabPlay.buttonMode = tabSandbox.buttonMode = tabBuild.buttonMode = tabFavorites.buttonMode = tabRecent.buttonMode = true;
         btn_reload.buttonMode = btn_id.buttonMode = true;
         sortMenu.gotoAndStop(1);
         sortMenu.btnOnline.visible = sortMenu.btnPlays.visible = sortMenu.btnLikes.visible = sortMenu.btnName.visible = false;
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         tf_search.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):void
         {
            if(!searchEmpty && tf_search.text == "")
            {
               tf_search.textColor = 6710886;
               tf_search.text = "Search...";
               searchEmpty = true;
            }
         });
         tf_search.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            render();
         });
         this.setTab(lastTab <= 0 ? tabPlay : (lastTab == 1 ? tabSandbox : (lastTab == 2 ? tabBuild : (lastTab == 3 ? tabFavorites : tabRecent))));
         if(Global.cookie.data.hasOwnProperty("sortby"))
         {
            delete Global.cookie.data.sortby;
         }
         else if(Global.cookie.data.hasOwnProperty("sortnew"))
         {
            this.setSort(Global.cookie.data.sortnew);
         }
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case tabPlay:
            case tabSandbox:
            case tabBuild:
            case tabFavorites:
            case tabRecent:
               this.setTab(param1.target as MovieClip);
               break;
            case btn_reload:
               if(this.canReload)
               {
                  this.enableRefreshButton(false);
                  this.reloadWorldsCallback();
               }
               break;
            case btn_id:
               (Global.base.state as LobbyState).showLoadRoom();
               break;
            case tf_search:
               if(this.searchEmpty)
               {
                  tf_search.textColor = 0;
                  tf_search.text = "";
                  this.searchEmpty = false;
               }
               break;
            case sortMenu.btnMain:
               this.toggleSortMenu(sortMenu.currentFrame == 1);
               break;
            case sortMenu.btnOnline:
               this.setSort(SORT_BY_ONLINE);
               break;
            case sortMenu.btnPlays:
               this.setSort(SORT_BY_PLAYS);
               break;
            case sortMenu.btnLikes:
               this.setSort(SORT_BY_LIKES);
               break;
            case sortMenu.btnName:
               this.setSort(SORT_BY_NAME);
         }
      }
      
      private function toggleSortMenu(param1:Boolean) : void
      {
         sortMenu.gotoAndStop(param1 ? 2 : 1);
         sortMenu.btnOnline.visible = sortMenu.btnPlays.visible = sortMenu.btnLikes.visible = sortMenu.btnName.visible = param1;
      }
      
      private function setSort(param1:int) : void
      {
         this.sortby = param1;
         Global.cookie.data.sortnew = param1;
         this.toggleSortMenu(false);
         this.updateSortLabel();
         this.sortRooms();
      }
      
      private function updateSortLabel() : void
      {
         if(this.currentTab == tabBuild || this.currentTab == tabRecent)
         {
            sortMenu.label.text = "---";
         }
         else
         {
            sortMenu.label.text = this.sortby == SORT_BY_ONLINE ? "Online" : (this.sortby == SORT_BY_PLAYS ? "Plays" : (this.sortby == SORT_BY_LIKES ? "Likes" : "Name"));
         }
      }
      
      private function setTab(param1:MovieClip) : void
      {
         if(this.currentTab == param1)
         {
            return;
         }
         lastTab = param1 == tabPlay ? 0 : (param1 == tabSandbox ? 1 : (param1 == tabBuild ? 2 : (param1 == tabFavorites ? 3 : 4)));
         this.toggleSortMenu(false);
         tabPlay.gotoAndStop(param1 == tabPlay ? 2 : 1);
         tabSandbox.gotoAndStop(param1 == tabSandbox ? 2 : 1);
         tabBuild.gotoAndStop(param1 == tabBuild ? 2 : 1);
         tabFavorites.gotoAndStop(param1 == tabFavorites ? 2 : 1);
         tabRecent.gotoAndStop(param1 == tabRecent ? 2 : 1);
         swapChildren(param1,this.currentTab || tabRecent);
         this.currentTab = param1;
         this.updateSortLabel();
         sortMenu.mouseChildren = this.currentTab != tabBuild && this.currentTab != tabRecent;
         sortMenu.alpha = this.currentTab == tabBuild || this.currentTab == tabRecent ? 0.25 : 1;
         this.sortRooms();
      }
      
      public function setRooms(param1:Array) : void
      {
         this.rooms = param1;
         this.sortRooms();
      }
      
      private function sortRooms() : void
      {
         this.roomsSorted = this.rooms.slice(0);
         if(!this.loading && this.currentTab != tabRecent)
         {
            this.roomsSorted.sort(function(param1:Object, param2:Object):int
            {
               var _loc5_:int = 0;
               var _loc6_:int = 0;
               var _loc7_:int = 0;
               var _loc8_:int = 0;
               var _loc9_:int = 0;
               var _loc10_:int = 0;
               if(sortby == SORT_BY_ONLINE)
               {
                  _loc5_ = int(int(param1.onlineUsers) || 0);
                  _loc6_ = int(int(param2.onlineUsers) || 0);
                  if(_loc5_ != _loc6_)
                  {
                     return _loc5_ >= 45 ? 1 : (_loc6_ >= 45 ? -1 : (_loc5_ > _loc6_ ? -1 : 1));
                  }
               }
               else if(sortby == SORT_BY_PLAYS)
               {
                  _loc7_ = int(int(parseInt(param1.data.plays)) || 0);
                  _loc8_ = int(int(parseInt(param2.data.plays)) || 0);
                  if(_loc7_ != _loc8_)
                  {
                     return _loc7_ > _loc8_ ? -1 : 1;
                  }
               }
               else if(sortby == SORT_BY_LIKES)
               {
                  _loc9_ = int(int(parseInt(param1.data.Likes)) || 0);
                  _loc10_ = int(int(parseInt(param2.data.Likes)) || 0);
                  if(_loc9_ != _loc10_)
                  {
                     return _loc9_ > _loc10_ ? -1 : 1;
                  }
               }
               var _loc3_:String = param1.data.name || param1.id;
               var _loc4_:String = param2.data.name || param2.id;
               return _loc3_ < _loc4_ ? -1 : 1;
            });
         }
         this.render();
      }
      
      private function render() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Room = null;
         this.container.removeAllChildren();
         if(this.loading)
         {
            if(!this.clipLoading)
            {
               this.clipLoading = new loadingrooms();
            }
            this.container.addChild(this.clipLoading);
         }
         else
         {
            _loc1_ = true;
            _loc2_ = this.searchEmpty ? "" : tf_search.text;
            _loc3_ = 0;
            while(_loc3_ < this.roomsSorted.length)
            {
               _loc4_ = this.roomsSorted[_loc3_];
               _loc5_ = _loc4_.data.name || "";
               _loc6_ = _loc4_.data.size || "";
               if((_loc2_ == "" || _loc5_.toLocaleLowerCase().indexOf(_loc2_.toLocaleLowerCase()) != -1 || _loc6_.toLocaleLowerCase().indexOf(_loc2_.toLocaleLowerCase()) != -1) && (Boolean(!this.containsBadwords(_loc5_)) || Boolean(_loc4_.data.myworld)))
               {
                  if(!(this.currentTab != tabSandbox && Boolean(_loc4_.data.openworld)))
                  {
                     if(!(Boolean(_loc4_.data.beta) && !Global.player_is_beta_member))
                     {
                        if(!(this.currentTab == tabFavorites && !_loc4_.data.inFavorites))
                        {
                           if(!(Boolean(this.currentTab != tabFavorites) && Boolean(_loc4_.data.inFavorites) && (_loc4_.onlineUsers || 0) < 1))
                           {
                              if(!(this.currentTab == tabBuild && !_loc4_.data.myworld))
                              {
                                 if(!(Boolean(this.currentTab != tabBuild && this.currentTab != tabPlay) && Boolean(_loc4_.data.myworld) && (_loc4_.onlineUsers || 0) < 1))
                                 {
                                    if(!(this.currentTab == tabSandbox && !_loc4_.data.openworld))
                                    {
                                       if(!(this.currentTab == tabRecent && !_loc4_.data.isHistory))
                                       {
                                          if(!(this.currentTab != tabRecent && Boolean(_loc4_.data.isHistory)))
                                          {
                                             _loc7_ = new Room(_loc4_.id,this.makePrettyName(_loc5_),_loc4_.data.description || "",_loc4_.data.size || "200x200",int(_loc4_.onlineUsers) || 0,int(parseInt(_loc4_.data.plays)) || 1,int(parseInt(_loc4_.data.Favorites)) || 0,int(parseInt(_loc4_.data.Likes)) || 0,_loc4_.data.inFavorites,_loc4_.data.IsCampaign == "True",_loc4_.data.myworld ? true : false,_loc4_.data.owned,Boolean(_loc4_.data.needskey),_loc4_.data.LobbyPreviewEnabled != "False",Boolean(_loc4_.data.isHistory),_loc4_,this.callback,this.unfavorite);
                                             _loc1_ = false;
                                             this.container.addChild(_loc7_);
                                          }
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
               _loc3_++;
            }
            if(_loc1_)
            {
               if(!this.clipNone)
               {
                  this.clipNone = new norooms();
               }
               this.container.addChild(this.clipNone);
            }
         }
         if(this.currentTab == tabSandbox)
         {
            if(!this.clipCreate)
            {
               this.clipCreate = new CreateOpenWorld();
            }
            this.container.addChild(this.clipCreate);
         }
         else if(this.currentTab == tabBuild)
         {
            if(Global.player_is_guest)
            {
               if(!this.clipRegister)
               {
                  this.clipRegister = new GuestRegisterForWorlds();
               }
               this.container.addChild(this.clipRegister);
            }
            else
            {
               if(!this.clipBuy)
               {
                  this.clipBuy = new BuyWorld();
               }
               this.container.addChild(this.clipBuy);
            }
         }
         this.base.refresh();
         this.base.scrollY = 1;
      }
      
      private function unfavorite(param1:String) : void
      {
         var _loc4_:Room = null;
         var _loc5_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.container.numChildren)
         {
            _loc4_ = this.container.getChildAt(_loc2_) as Room;
            if(_loc4_ != null && _loc4_.key == param1)
            {
               _loc4_.ltitle.x -= 17;
               _loc4_.favstar.visible = false;
               _loc4_.favstar.mouseEnabled = false;
               _loc4_.favstar.buttonMode = false;
               _loc4_.favstar.useHandCursor = false;
               break;
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.rooms.length)
         {
            if(this.rooms[_loc3_].id == param1)
            {
               _loc5_ = this.rooms[_loc3_].data;
               if(_loc5_.inFavorites != null)
               {
                  _loc5_.inFavorites = false;
               }
            }
            _loc3_++;
         }
         Global.playerObject.removeFavorite(param1);
      }
      
      public function enableRefreshButton(param1:Boolean) : void
      {
         var value:Boolean = param1;
         TweenMax.delayedCall(value ? 3 : 0,function():void
         {
            canReload = btn_reload.mouseEnabled = btn_reload.mouseChildren = value;
            TweenMax.to(btn_reload,0.25,{"alpha":(value ? 1 : 0.5)});
         });
      }
      
      private function containsBadwords(param1:String) : Boolean
      {
         return Badwords.Filter(param1) != param1;
      }
      
      private function makePrettyName(param1:String) : String
      {
         return param1.replace(/[ \t]{2,}/gi," ");
      }
   }
}

