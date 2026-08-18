/**
 * QuestManager for Everybody Edits v264
 * Handles Daily Login Streaks, Daily Quests / Missions, and Rewards
 */

class QuestManager {
  constructor(userManager) {
    this.userManager = userManager;

    this.dailyQuestsTemplates = [
      { id: 'daily_blocks_50', title: 'Napi Építő', desc: 'Helyezz el 50 blokkot ma.', stat: 'dailyBlocksPlaced', target: 50, rewardXP: 100, rewardGems: 30, icon: '🧱' },
      { id: 'daily_jumps_100', title: 'Napi Ugró', desc: 'Ugorj 100-at valamelyik pályán.', stat: 'dailyJumps', target: 100, rewardXP: 80, rewardGems: 25, icon: '🦘' },
      { id: 'daily_chat_15', title: 'Napi Társalgó', desc: 'Írj 15 üzenetet a játékos chaten.', stat: 'dailyChat', target: 15, rewardXP: 60, rewardGems: 20, icon: '💬' },
      { id: 'daily_worlds_2', title: 'Napi Felfedező', desc: 'Látogass meg 2 különböző világot.', stat: 'dailyWorlds', target: 2, rewardXP: 120, rewardGems: 40, icon: '🧭' },
      { id: 'daily_portal_5', title: 'Napi Dimenzióugró', desc: 'Használj 5 portált vagy warpot.', stat: 'dailyPortals', target: 5, rewardXP: 100, rewardGems: 35, icon: '🌀' },
    ];
  }

  getTodayDateString() {
    return new Date().toISOString().split('T')[0];
  }

  /**
   * Process daily login streak for a user
   */
  processDailyLogin(user) {
    if (!user) return null;
    const today = this.getTodayDateString();

    if (!user.quests) {
      user.quests = {
        lastLoginDate: '',
        streak: 0,
        dailyStats: {},
        activeQuests: [],
        claimedToday: false
      };
    }

    const lastDate = user.quests.lastLoginDate;
    let streakAwarded = false;
    let rewardGems = 0;
    let rewardEnergy = 0;
    let rewardXP = 0;

    if (lastDate !== today) {
      // Check if consecutive day
      if (lastDate) {
        const last = new Date(lastDate);
        const curr = new Date(today);
        const diffDays = Math.round((curr - last) / (1000 * 60 * 60 * 24));
        if (diffDays === 1) {
          user.quests.streak = (user.quests.streak || 0) + 1;
        } else if (diffDays > 1) {
          user.quests.streak = 1;
        }
      } else {
        user.quests.streak = 1;
      }

      user.quests.lastLoginDate = today;
      user.quests.dailyStats = {};
      user.quests.claimedToday = true;

      // Assign daily quests (rotate 3 quests)
      user.quests.activeQuests = this.dailyQuestsTemplates.slice(0, 3).map(q => ({
        id: q.id,
        completed: false,
        claimed: false
      }));

      // Calculate streak reward
      const streakDay = Math.min(7, user.quests.streak);
      rewardGems = streakDay * 20;
      rewardEnergy = Math.min(100, streakDay * 15);
      rewardXP = streakDay * 50;

      user.gems = (user.gems || 0) + rewardGems;
      user.energy = Math.min(user.maxEnergy || 200, (user.energy || 0) + rewardEnergy);
      user.xp = (user.xp || 0) + rewardXP;

      this.userManager.saveUser(user.username);
      streakAwarded = true;
    }

    return {
      streakAwarded,
      streak: user.quests.streak,
      rewardGems,
      rewardEnergy,
      rewardXP,
      today
    };
  }

  /**
   * Track daily quest progress
   */
  trackDailyStat(user, statKey, amount = 1, onComplete = null) {
    if (!user || !user.quests) return;
    const today = this.getTodayDateString();
    if (user.quests.lastLoginDate !== today) {
      this.processDailyLogin(user);
    }

    if (!user.quests.dailyStats) user.quests.dailyStats = {};
    user.quests.dailyStats[statKey] = (user.quests.dailyStats[statKey] || 0) + amount;

    // Check active quests
    let changed = false;
    for (const q of (user.quests.activeQuests || [])) {
      if (q.completed) continue;
      const tpl = this.dailyQuestsTemplates.find(t => t.id === q.id);
      if (tpl && tpl.stat === statKey) {
        const curVal = user.quests.dailyStats[statKey] || 0;
        if (curVal >= tpl.target) {
          q.completed = true;
          q.claimed = true;
          user.gems = (user.gems || 0) + tpl.rewardGems;
          user.xp = (user.xp || 0) + tpl.rewardXP;
          changed = true;
          if (onComplete) {
            onComplete(`🎉 [NAPI KÜLDETÉS TELJESÍTVE] ${tpl.title}: ${tpl.desc} (+${tpl.rewardGems} 💎, +${tpl.rewardXP} XP)`);
          }
        }
      }
    }

    if (changed) {
      this.userManager.saveUser(user.username);
    }
  }

  /**
   * Get user's daily quests status
   */
  getUserQuests(user) {
    if (!user) return null;
    this.processDailyLogin(user);

    const stats = user.quests ? (user.quests.dailyStats || {}) : {};
    const questList = (user.quests ? user.quests.activeQuests : []).map(q => {
      const tpl = this.dailyQuestsTemplates.find(t => t.id === q.id) || {};
      const current = stats[tpl.stat] || 0;
      const progress = Math.min(100, Math.round((current / (tpl.target || 1)) * 100));
      return {
        id: q.id,
        title: tpl.title || q.id,
        desc: tpl.desc || '',
        icon: tpl.icon || '⭐',
        current,
        target: tpl.target || 1,
        progress,
        completed: Boolean(q.completed),
        claimed: Boolean(q.claimed),
        rewardGems: tpl.rewardGems || 0,
        rewardXP: tpl.rewardXP || 0
      };
    });

    return {
      streak: user.quests ? user.quests.streak : 1,
      today: this.getTodayDateString(),
      quests: questList
    };
  }
}

module.exports = QuestManager;
