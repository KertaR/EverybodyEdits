/**
 * Player Instance for Everybody Edits Private Server
 */

class Player {
  constructor(id, socket, username = 'Guest') {
    this.id = id;
    this.socket = socket;
    this.username = username;
    this.userId = `user_${id}`;
    this.face = 0;             // Smiley ID
    this.aura = 0;             // Aura ID
    this.auraColor = 0;        // Aura Color ID
    this.smileyGoldBorder = false;
    this.chatColor = 0;
    this.badge = "";

    // Position & Physics State
    this.x = 16 * 16;          // Spawn X (in pixels)
    this.y = 16 * 16;          // Spawn Y (in pixels)
    this.speedX = 0;
    this.speedY = 0;
    this.modifierX = 0;
    this.modifierY = 0;
    this.horizontal = 0;
    this.vertical = 0;
    this.spacedown = false;
    this.spacejustdown = false;

    // Permissions & Flags
    this.canEdit = true;
    this.isGod = false;
    this.isMod = false;
    this.isOwner = true;
    this.isGoldMember = true;
    this.coins = 0;
    this.blueCoins = 0;
    this.deaths = 0;
  }

  send(msg) {
    if (!this.socket || this.socket.destroyed) return;
    try {
      const { PlayerIOProtocol } = require('./PlayerIOProtocol');
      const encoded = PlayerIOProtocol.encodeMessage(msg);
      this.socket.write(encoded);
    } catch (e) {
      console.error(`Error sending message to player ${this.id}:`, e);
    }
  }

  getAddMessageData() {
    // Parameter format matching PlayState.as `add` handler:
    // param2: id (int)
    // param3: name (String)
    // param4: connectedUserId (String)
    // param5: face (int)
    // param6: x (Number)
    // param7: y (Number)
    // param8: isInGodMode (Boolean)
    // param9: isInModMode (Boolean)
    // param10: hasChat (Boolean)
    // param11: coins (int)
    // param12: blueCoins (int)
    // param13: deaths (int)
    // param14: isGoldMember (Boolean)
    // param15: smileyGoldBorder (Boolean)
    // param16: isCrewMember (Boolean)
    // param17: aura (int)
    // param18: auraColor (int)
    // param19: chatColor (int)
    // param20: team (uint)
    // param21: badge (String)
    // param22: inCustomSmiley (Boolean)
    // param23: customSmileyBytes (ByteArray)
    return [
      this.id,
      this.username,
      this.userId,
      this.face,
      this.x,
      this.y,
      this.isGod,
      this.isMod,
      true, // hasChat
      this.coins,
      this.blueCoins,
      this.deaths,
      this.isGoldMember,
      this.smileyGoldBorder,
      false, // isCrewMember
      this.aura,
      this.auraColor,
      this.chatColor,
      0, // team
      this.badge,
      false, // inCustomSmiley
      Buffer.alloc(0) // customSmileyBytes
    ];
  }
}

module.exports = Player;
