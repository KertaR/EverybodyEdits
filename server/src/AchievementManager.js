/**
 * Achievement & Level / XP Progression Manager for Everybody Edits
 */
class AchievementManager {
  constructor(userManager) {
    this.userManager = userManager;

    this.achievements = [
      {
        id: 'builder_1',
        title: 'Kezdő Építész',
        description: 'Helyezz el 100 blokkot a pályákon.',
        statKey: 'blocksPlaced',
        target: 100,
        rewardXP: 50,
        rewardGems: 25,
        icon: '🧱'
      },
      {
        id: 'builder_2',
        title: 'Mester Építész',
        description: 'Helyezz el 1,000 blokkot a pályákon.',
        statKey: 'blocksPlaced',
        target: 1000,
        rewardXP: 250,
        rewardGems: 100,
        icon: '🏰'
      },
      {
        id: 'builder_3',
        title: 'Világteremtő',
        description: 'Helyezz el 5,000 blokkot a pályákon.',
        statKey: 'blocksPlaced',
        target: 5000,
        rewardXP: 1000,
        rewardGems: 500,
        icon: '🌌'
      },
      {
        id: 'jumper_1',
        title: 'Ugróbajnok',
        description: 'Ugorj 100 alkalommal a pályákon.',
        statKey: 'jumps',
        target: 100,
        rewardXP: 50,
        rewardGems: 20,
        icon: '🦘'
      },
      {
        id: 'jumper_2',
        title: 'Parkour Legenda',
        description: 'Ugorj 1,000 alkalommal a pályákon.',
        statKey: 'jumps',
        target: 1000,
        rewardXP: 250,
        rewardGems: 100,
        icon: '🏃'
      },
      {
        id: 'chatter_1',
        title: 'Társasági Arc',
        description: 'Küldj el 50 üzenetet a játékos chaten.',
        statKey: 'chatMessages',
        target: 50,
        rewardXP: 50,
        rewardGems: 20,
        icon: '💬'
      },
      {
        id: 'explorer_1',
        title: 'Világjáró',
        description: 'Látogass meg 3 különböző világot.',
        statKey: 'worldsVisited',
        target: 3,
        rewardXP: 100,
        rewardGems: 50,
        icon: '🧭'
      },
      {
        id: 'spender_1',
        title: 'Nagy Költekező',
        description: 'Vásárolj blokkokat vagy smileyt a boltban.',
        statKey: 'itemsPurchased',
        target: 5,
        rewardXP: 150,
        rewardGems: 50,
        icon: '💎'
      },
      {
        id: 'level_5',
        title: 'Feltörekvő Csillag',
        description: 'Érd el az 5-ös szintet.',
        statKey: 'level',
        target: 5,
        rewardXP: 300,
        rewardGems: 100,
        icon: '⭐'
      },
      {
        id: 'level_10',
        title: 'EE Legenda',
        description: 'Érd el a 10-es szintet.',
        statKey: 'level',
        target: 10,
        rewardXP: 1000,
        rewardGems: 500,
        icon: '👑'
      },
      {
        id: 'portal_traveler',
        title: 'Dimenzió Vándor',
        description: 'Használj 10 warpot vagy portált.',
        statKey: 'portalsUsed',
        target: 10,
        rewardXP: 150,
        rewardGems: 50,
        icon: '🌀'
      },
      {
        id: 'daily_master',
        title: 'Hűséges Játékos',
        description: 'Érj el 5 napos bejelentkezési sorozatot.',
        statKey: 'streak',
        target: 5,
        rewardXP: 300,
        rewardGems: 100,
        icon: '🔥'
      },
      {
        id: 'social_star',
        title: 'Közösség Kedvence',
        description: 'Küldj 20 privát üzenetet játékosoknak.',
        statKey: 'dmsSent',
        target: 20,
        rewardXP: 200,
        rewardGems: 60,
        icon: '💌'
      },
      {
        id: 'world_creator',
        title: 'Világépítő Mester',
        description: 'Mentsd el a saját pályádat legalább 10 alkalommal.',
        statKey: 'worldSaves',
        target: 10,
        rewardXP: 250,
        rewardGems: 80,
        icon: '🛠️'
      }
    ];
  }

  /**
   * Calculate current level, required XP for next level, and progress percentage
   */
  calculateLevel(xp = 0) {
    xp = Number(xp) || 0;
    // Formula: level = floor(sqrt(xp / 100)) + 1
    const level = Math.max(1, Math.floor(Math.sqrt(xp / 100)) + 1);
    const currentLevelBaseXP = ((level - 1) * (level - 1)) * 100;
    const nextLevelXP = (level * level) * 100;
    const levelDiff = nextLevelXP - currentLevelBaseXP;
    const userProgress = xp - currentLevelBaseXP;
    const percent = Math.min(100, Math.max(0, Math.round((userProgress / (levelDiff || 1)) * 100)));

    return {
      level,
      xp,
      currentLevelBaseXP,
      nextLevelXP,
      xpRemaining: Math.max(0, nextLevelXP - xp),
      percent
    };
  }

  /**
   * Ensure user object has stats & achievements fields
   */
  initUserStats(user) {
    if (!user.xp) user.xp = 0;
    if (!user.level) user.level = this.calculateLevel(user.xp).level;
    if (!user.stats) {
      user.stats = {
        blocksPlaced: 0,
        blocksCleared: 0,
        jumps: 0,
        chatMessages: 0,
        itemsPurchased: (user.payVault && user.payVault.length) || 0,
        worldsVisited: ['PW_default']
      };
    }
    if (!Array.isArray(user.achievements)) {
      user.achievements = [];
    }
  }

  /**
   * Add XP and check for level ups
   */
  addXP(user, amount = 0, notifyFn = null) {
    if (!user || amount <= 0) return;
    this.initUserStats(user);

    const oldLevel = this.calculateLevel(user.xp).level;
    user.xp += amount;
    const newProgress = this.calculateLevel(user.xp);
    user.level = newProgress.level;

    if (newProgress.level > oldLevel) {
      const bonusGems = newProgress.level * 25;
      user.gems = (user.gems || 0) + bonusGems;
      if (notifyFn) {
        notifyFn(
          `🎉 LEVEL UP! ${user.username} reached Level ${newProgress.level}! (+${bonusGems} Bonus Gems!)`,
          'levelup'
        );
      }
      this.checkAchievements(user, notifyFn);
    }

    this.userManager.saveUser(user.username);
  }

  /**
   * Track a statistic for a user and check for achievement completions
   */
  trackStat(user, statKey, amount = 1, notifyFn = null) {
    if (!user) return;
    this.initUserStats(user);

    if (statKey === 'worldsVisited') {
      if (typeof amount === 'string') {
        if (!user.stats.worldsVisited.includes(amount)) {
          user.stats.worldsVisited.push(amount);
        }
      }
    } else {
      user.stats[statKey] = (user.stats[statKey] || 0) + amount;
    }

    this.checkAchievements(user, notifyFn);
    this.userManager.saveUser(user.username);
  }

  /**
   * Check all achievements against current user stats
   */
  checkAchievements(user, notifyFn = null) {
    if (!user) return;
    this.initUserStats(user);

    const currentAchievements = new Set(user.achievements.map(a => (typeof a === 'string' ? a : a.id)));

    for (const ach of this.achievements) {
      if (currentAchievements.has(ach.id)) continue;

      let statValue = 0;
      if (ach.statKey === 'level') {
        statValue = user.level || 1;
      } else if (ach.statKey === 'worldsVisited') {
        statValue = (user.stats.worldsVisited && user.stats.worldsVisited.length) || 1;
      } else {
        statValue = user.stats[ach.statKey] || 0;
      }

      if (statValue >= ach.target) {
        // Unlock achievement!
        user.achievements.push({
          id: ach.id,
          title: ach.title,
          unlockedAt: new Date().toISOString()
        });

        // Grant rewards
        user.gems = (user.gems || 0) + ach.rewardGems;
        this.addXP(user, ach.rewardXP, null); // Add XP without recursive loop

        if (notifyFn) {
          notifyFn(
            `🏆 ACHIEVEMENT UNLOCKED: [${ach.icon} ${ach.title}] - ${ach.description} (+${ach.rewardXP} XP, +${ach.rewardGems} Gems!)`,
            'achievement'
          );
        }
      }
    }
  }

  /**
   * Get detailed achievements list for a user including progress
   */
  getUserAchievements(user) {
    this.initUserStats(user);
    const unlockedMap = new Map();
    for (const a of user.achievements) {
      if (typeof a === 'string') unlockedMap.set(a, { unlocked: true, unlockedAt: null });
      else unlockedMap.set(a.id, { unlocked: true, unlockedAt: a.unlockedAt });
    }

    const lvlInfo = this.calculateLevel(user.xp);

    const list = this.achievements.map(ach => {
      const isUnlocked = unlockedMap.has(ach.id);
      let currentVal = 0;
      if (ach.statKey === 'level') currentVal = user.level || 1;
      else if (ach.statKey === 'worldsVisited') currentVal = (user.stats.worldsVisited && user.stats.worldsVisited.length) || 1;
      else currentVal = user.stats[ach.statKey] || 0;

      const progress = Math.min(100, Math.round((currentVal / ach.target) * 100));

      return {
        id: ach.id,
        title: ach.title,
        description: ach.description,
        icon: ach.icon,
        rewardXP: ach.rewardXP,
        rewardGems: ach.rewardGems,
        target: ach.target,
        current: currentVal,
        progress,
        unlocked: isUnlocked,
        unlockedAt: isUnlocked ? unlockedMap.get(ach.id).unlockedAt : null
      };
    });

    return {
      levelInfo: lvlInfo,
      stats: user.stats,
      achievements: list,
      totalUnlocked: user.achievements.length,
      totalAvailable: this.achievements.length
    };
  }
}

module.exports = AchievementManager;
