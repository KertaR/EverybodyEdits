package
{
   import ui.lobby.FallingItemMode;
   
   public class Config
   {
      
      public static const playerio_game_id:String = "everybody-edits-su9rn58o40itdbnw69plyw";
      
      public static const client_type_version:String = "263";
      
      public static const server_type_version:int = 263;
      
      public static const server_type_normalroom:String = "Everybodyedits" + server_type_version;
      
      public static const server_type_betaroom:String = "Beta" + server_type_version;
      
      public static const server_type_guestserviceroom:String = "LobbyGuest" + server_type_version;
      
      public static const server_type_serviceroom:String = "Lobby" + server_type_version;
      
      public static const server_type_crewshop:String = "CrewLobby" + server_type_version;
      
      public static const domain:String = "everybodyedits.com";
      
      public static const site:String = "https://everybodyedits.com";
      
      public static const url_blog:String = "https://blog.everybodyedits.com";
      
      public static const url_goldmember_about_page:String = site + "/gold";
      
      public static const url_terms_page:String = site + "/terms";
      
      public static const url_help_page:String = site + "/help";
      
      public static const url_faq:String = site + "/faq";
      
      public static const url_forums:String = "https://forums.everybodyedits.com/";
      
      public static const url_merch:String = "https://teespring.com/stores/everybody-edits";
      
      public static const url_patreon:String = "https://patreon.com/everybodyedits/overview";
      
      public static var use_debug_server:Boolean = true;

      public static var run_in_development_mode:Boolean = true;
      
      public static var show_disabled_shopitems:Boolean = false;
      
      public static var development_mode_autojoin_room:String = "PWGosha";
      
      public static var debug_news:String = "";
      
      public static var developer_server:String = "127.0.0.1:8184";
      
      public static const forceKongregate:Boolean = false;
      
      public static const forceBeta:Boolean = false;
      
      public static const debug_profile:String = "";
      
      public static const debug_crew_profile:String = "";
      
      public static const disableCookie:Boolean = false;
      
      public static const show_debug_friendrequest:Boolean = false;
      
      public static const debug_friendrequest:String = "";
      
      public static const show_blacklist_invitation:Boolean = false;
      
      public static const debug_invitation:String = "";
      
      public static const termsVersion:int = 2;
      
      public static var physics_ms_per_tick:int = 10;
      
      public static var physics_variable_multiplyer:Number = 7.752;
      
      public static var physics_base_drag:Number = Math.pow(0.9981,physics_ms_per_tick) * 1.00016093;
      
      public static var physics_ice_no_mod_drag:Number = Math.pow(0.9993,physics_ms_per_tick) * 1.00016093;
      
      public static var physics_ice_drag:Number = Math.pow(0.9998,physics_ms_per_tick) * 1.00016093;
      
      public static var physics_no_modifier_drag:Number = Math.pow(0.99,physics_ms_per_tick) * 1.00016093;
      
      public static var physics_water_drag:Number = Math.pow(0.995,physics_ms_per_tick) * 1.00016093;
      
      public static var physics_mud_drag:Number = Math.pow(0.975,physics_ms_per_tick) * 1.00016093;
      
      public static var physics_lava_drag:Number = Math.pow(0.98,physics_ms_per_tick) * 1.00016093;
      
      public static var physics_toxic_drag:Number = Math.pow(0.99,physics_ms_per_tick) * 1.00016093;
      
      public static var physics_jump_height:Number = 26;
      
      public static var physics_gravity:Number = 2;
      
      public static var physics_boost:Number = 16;
      
      public static var physics_water_buoyancy:Number = -0.5;
      
      public static var physics_mud_buoyancy:Number = 0.4;
      
      public static var physics_lava_buoyancy:Number = 0.2;
      
      public static var physics_toxic_buoyancy:Number = -0.4;
      
      public static var physics_queue_length:int = 2;
      
      public static var camera_lag:Number = 1 / 16;
      
      public static var isMobile:Boolean = false;
      
      public static var enableDebugShadow:Boolean = false;
      
      public static var maxwidth:int = 850;
      
      public static const minwidth:int = 640;
      
      public static const width:int = 640;
      
      public static const height:int = 500;
      
      public static const maxFrameRate:int = 120;
      
      public static const lobbyFrameRate:int = 50;
      
      public static const displayFog:Boolean = false;
      
      public static const displayBanner:Boolean = false;
      
      public static const lobbyEffect:String = FallingItemMode.NONE;
      
      public static const effectReset:int = -1;
      
      public static const effectJump:int = 0;
      
      public static const effectFly:int = 1;
      
      public static const effectRun:int = 2;
      
      public static const effectProtection:int = 3;
      
      public static const effectCurse:int = 4;
      
      public static const effectZombie:int = 5;
      
      public static const effectLowGravity:int = 7;
      
      public static const effectFire:int = 8;
      
      public static const effectMultijump:int = 9;
      
      public static const effectGravity:int = 10;
      
      public static const effectPoison:int = 11;
      
      public static const max_Particles:int = 45;
      
      public static const guest_color:uint = 4281545523;
      
      public static const default_color:uint = 4293848814;
      
      public static const default_color_dark:uint = 4291611852;
      
      public static const friend_color:uint = 4278255360;
      
      public static const friend_color_dark:uint = 4278237952;
      
      public static const admin_color:uint = 4294947840;
      
      public static const moderator_color:uint = 4291731444;
      
      public static const developer_color:uint = 4281571839;
      
      public static const designer_color:uint = 4294932275;
      
      public static const campaign_curator_color:uint = 4286045695;
      
      public static const patron_color_1:uint = 4294967193;
      
      public function Config()
      {
         super();
      }
   }
}

