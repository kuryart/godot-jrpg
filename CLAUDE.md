# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Godot JRPG is a Godot 4.6 framework/addon for building classic 2D JRPGs, inspired by RPG Maker VX Ace. All code lives under `addons/godot_jrpg/` and is written in GDScript.

## Commands

**Install third-party plugins (required after cloning):**
```
godot --headless -s plug.gd install
```

**Run the project:**
```
godot --path .
```

**Run headless (for simulation/testing):**
```
godot --headless --path .
```

**Run a specific test scene:**
```
godot --path . --scene addons/godot_jrpg/tests/battle/test_battle.tscn
```

Tests are Godot scenes in `addons/godot_jrpg/tests/`. There is no CLI test runner — test scenes must be opened and run inside the Godot editor or via `godot --scene`.

## Architecture

### Autoloads (Singletons)

Registered in `project.godot`. These are always available globally:

- **`GameManager`** — state machine (`INTRO`, `TITLE`, `MAP`, `MAP_ACT`, `MENU`, `BATTLE`, `BATTLE_ACT`, `DIALOGUE`, `GAME_OVER`). Controls `can_open_menu` and `can_act` flags. Also handles save/load.
- **`MenuManager`** — stack-based menu system. Menus push/pop on a stack; manages process mode and focus history.
- **`InputManager`** — emits `input_setup_complete` signal after input devices are configured.
- **`EventRunner`** — runs `CommandList` resources sequentially, awaiting commands marked `is_wait`.
- **`Audio`**, **`UI`**, **`VFXManager`** — audio playback, UI helpers, and visual effects.

### Battle System

The battle system has a hard split between logic and presentation:

- **`BattleEngine`** (`nodes/battle/battle_engine.gd`) — pure logic. Has `visuals_enabled` flag for headless simulation/RL mode.
- **`BattleUI`** (`nodes/battle/battle_ui.gd`) — all visual elements.
- **`BattleSignals`** (`resources/battle/battle_signals.gd`) — a shared `Resource` (.tres) that both engine and UI reference to communicate via signals without direct coupling.

**Battle flow uses the State pattern via `BattlePhase` subclasses** (`resources/battle/phases/`):
1. `BattlePhaseInit` → `BattlePhaseStart` → `BattlePhaseSelection`
2. `BattlePhasePlayers` iterates through players; each chooses an action via `BattlePhaseFight` / `BattlePhaseAttackTarget` / `BattlePhaseItemTarget` / `BattlePhaseSkillTarget`
3. `BattlePhaseResolveActions` — resolves all actions from `action_pool` ordered by speed (insertion sort). Also triggers enemy decisions here.
4. `BattlePhaseUpkeep` → loops back or ends in `BattlePhaseVictory` / `BattlePhaseGameOver`

**Action pool pattern:** When a battler picks an action (attack/defend/item/skill), a `BattleAction` subclass is created and pushed into `BattleEngine.action_pool`. `BattlePhaseResolveActions` then calls `action.resolve(engine)` on each in speed order.

### Actor / Battler Hierarchy

```
Actor (Resource)
  └── Battler
        ├── Player   — adds level, XP, PlayerClass, EquipmentSlots
        └── Enemy
```

`Battler` holds `Stats`, `status: Array[Status]`, `traits: TraitList`, and a `BattlerController`. Stats have base values plus level-growth values; final values go through `TraitAggregator`.

### Trait System

`TraitAggregator` (per battler) collects `TraitList` entries from: player class, all equipped items, all active statuses, and the battler's own traits. It exposes facade methods like `get_stat_modified()`, `get_elemental_damage_dealt_modified()`, etc.

`Trait` subclasses fall into three families:
- **Value traits** (`TraitStat`, `TraitDamageDealt`, `TraitElementDamageDealt`, …) — modify numeric values via `sum + multiplier`.
- **Flag traits** (`TraitFlag`, `TraitCanUseSkill`, …) — boolean restrictions.
- **Chance traits** (`TraitStatusChanceAttack`, …) — attach status effects on events.

Call `trait_aggregator.refresh()` after any equipment change, status change, or level-up.

### Formula System

All game-math uses pluggable `Formula extends Resource` objects with a `calculate(parameter)` method. Swap formulas in the inspector without touching game logic. Families:

- Damage: `FormulaHitChance`, `FormulaCriticalChance`, `FormulaDamage`, `FormulaCriticalDamage`
- Effect-specific: `FormulaEffectChance`, `FormulaEffectCriticalChance`, `FormulaEffectDamage`, `FormulaEffectCriticalDamage`
- Progression: `FormulaXP`, `FormulaStatGrowth`

Each formula family has several built-in implementations (e.g. RPG Maker-style, Pokémon-style, sigmoid, Fire Emblem-style).

### Controller System

`BattlerController` subclasses decide actions for each battler:
- `PlayerManualController` — reads real player input.
- `PlayerNPCController` — AI-controlled player (calls `brain.get_action(context)`).
- `PlayerSimulationController`, `PlayerRLController` — for headless simulation / RL agents.
- `EnemyController`, `EnemyAIController` — enemy decision-making via `Brain` resources.

### Event / Command System

Map events use `Event` nodes with an `EventBus` child. Triggering an event runs a `CommandList` through `EventRunner`. Built-in `Command` subclasses: `CommandStartBattle`, `CommandChangeScene`, `CommandStartDialogue`, `CommandPlaySFX`, `CommandCameraShake`, `CommandWait`, `CommandChangeFace`.

### Item / Equipment / Inventory

- `Stuff → Item` — consumable/passive items with `EffectList` and `TraitList`. `used_on` controls MAP/BATTLE/BOTH availability.
- `Stuff → ItemEquippable → Weapon/Armor/Shield/Head/Accessory`
- `EquipmentSlots` holds one slot per type; `Player.change_equipment()` swaps items and refreshes the trait aggregator.
- `Inventory` stores `Dictionary[Item, int]` and `Dictionary[ItemEquippable, int]`.

### Menu System

`MenuManager` maintains a stack of `Control` menus. Opening a menu: instantiate → add as child of scene root → `MenuManager.register_menu()`. Closing: `queue_free()` → `MenuManager.unregister_menu()` auto-restores the previous menu and focus. Cancel input at the map level opens the main menu.

### Third-Party plugins
- Never make changes in third-party plugins directories, only in addons/godot-jrpg.

### Other instructions
- Avoid solving problems with `await get_tree().process_frame`.
- Use methods in the form `_method` (with underline) only for methods connected to a signal, like `_on_signal_emmited`.
