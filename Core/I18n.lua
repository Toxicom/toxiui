local TXUI, F, E, I, V, P, G , I18n = unpack((select(2, ...)))

I18n.themes = {
    gradientMode = {
        powerColorMap = {
            [I.Enum.GradientMode.Color.SHIFT] = { -- 左侧
                ALT_POWER = "替换备用能量", -- swap alt
                MANA = "法力值", -- mana
                RAGE = "怒气", -- rage
                FOCUS = "集中值", -- focus
                ENERGY = "能量", -- energy
                RUNIC_POWER = "符文能量", -- runic
                PAIN = "痛苦", -- pain
                FURY = "恶魔之怒", -- fury
                LUNAR_POWER = "星界能量", -- astral
                INSANITY = "疯狂", -- insanity
                MAELSTROM = "漩涡值", -- maelstrom
            },

            [I.Enum.GradientMode.Color.NORMAL] = { -- 右侧
                ALT_POWER = "替换备用能量", -- swap alt
                MANA = "法力值", -- mana
                RAGE = "怒气", -- rage
                FOCUS = "集中值", -- focus
                ENERGY = "能量", -- energy
                RUNIC_POWER = "符文能量", -- runic
                PAIN = "痛苦", -- pain
                FURY = "恶魔之怒", -- fury
                LUNAR_POWER = "星界能量", -- astral
                INSANITY = "疯狂", -- insanity
                MAELSTROM = "漩涡值", -- maelstrom
            },
        },
        specialColorMap = {
            [I.Enum.GradientMode.Color.NORMAL] = { -- RIGHT
                DISCONNECTED = "断线", -- disconnect
                TAPPED = "被攻击", -- tapped
                DEAD = "死亡", -- dead
            },
            [I.Enum.GradientMode.Color.SHIFT] = { -- LEFT
                DISCONNECTED = "断线", -- disconnect
                TAPPED = "被攻击", -- tapped
                DEAD = "死亡", -- dead
            },
        },
        castColorMap = {
            [I.Enum.GradientMode.Color.NORMAL] = { -- 右侧
                DEFAULT = "默认", -- cast def.
                NOINTERRUPT = "无法打断", -- cast non.
                INTERRUPTED = "被打断", -- cast was stopped
                INTERRUPTCD = "打断冷却中", -- interrupt is on cd, and will not come off cd during cast
                INTERRUPTSOON = "即将打断", -- interrupt is on cd, but will be ready inside the cast
            },
            [I.Enum.GradientMode.Color.SHIFT] = { -- 左侧
                DEFAULT = "默认", -- cast def.
                NOINTERRUPT = "无法打断", -- cast non.
                INTERRUPTED = "被打断", -- cast was stopped
                INTERRUPTCD = "打断冷却中", -- interrupt is on cd, and will not come off cd during cast
                INTERRUPTSOON = "即将打断", -- interrupt is on cd, but will be ready inside the cast
            },
        }
    }
}

I18n.armory = {
    stats = {
        mode = {
            -- Attributes Category
            STRENGTH = "力量",
            AGILITY = "敏捷",
            INTELLECT = "智力",
            STAMINA = "耐力",
            HEALTH = "生命值",
            POWER = "能量",
            ARMOR = "护甲",
            STAGGER = "躲闪",
            MANAREGEN = "法力回复",
            ENERGY_REGEN = "能量回复",
            RUNE_REGEN = "符文回复",
            FOCUS_REGEN = "集中回复",
            MOVESPEED = "移动速度",

            -- Enhancements Category
            ATTACK_DAMAGE = "攻击伤害",
            ATTACK_AP = "攻击强度",
            ATTACK_ATTACKSPEED = "攻击速度",
            SPELLPOWER = "法术强度",
            CRITCHANCE = "暴击几率",
            HASTE = "急速",
            MASTERY = "精通",
            VERSATILITY = "全能",
            LIFESTEAL = "吸血",
            AVOIDANCE = "闪避",
            SPEED = "速度",
            DODGE = "躲闪",
            PARRY = "招架",
            BLOCK = "格挡",
        }
    }
}