# Global Game Jam 2026 Game

Our game for the Global Game Jam 2026 (GGJ) 🥳

## 🧙 Dev setup

- Install Godot 4.6
- Install the GDScript formatter
	- Start Godot and open the script editor
	- Click on "Format" in the top bar of the script editor
	- Click "Install or Update Formatter"
	- Go to `Editor > Editor Settings`, search for "formatter" and enable "Format on save"
	- Additional info (e.g. for VS Code): https://www.gdquest.com/library/gdscript_formatter/

## 📜 Project structure

```
godot-game-jam-template
├── addons
│   └── GDQuest_GDScript_formatter
├── assets
│   ├── audio
│   ├── fonts
│   │   └── AnnotationMono
│   └── img
├── resources
├── scenes
│   ├── game
│   ├── game_manager
│   └── ui
│       ├── credits
│       ├── main_menu
│       └── settings
└── scripts
	└── globals
```

- **addons**: Do not modify anything manually in this folder. Addons are installed from the asset library.
- **assets**: Images, audio files, sound effects, etc.
- **resources**: Reusable Godot resources like themes etc.
- **scenes**: Hierarchical file structure. An enemy scene would be placed in `scenes/game/enemy/enemy.tscn`.
- **scripts**: Scripts that don't belong to a specific scene. Globals, enums, helpers, etc.

### Global scripts & enums

- `E` (scripts/enums.gd)
  Place all enums that are used accross nodes/scenes in this class.
  Access enums using the class name `E`, e.g. `E.EnemyType.Goblin`.
- `GlobalSignals` (scripts/globals/global_signals.gd)
  Global message bus. For notifying other nodes using signals. Fire and forget style.
- `GlobalState` (scripts/globals/global_state.gd)
  Global game state, e.g. score, stats etc. Stored in the save file.
- `GlobalSettings` (scripts/globals/global_settings.gd)
  Settings for the game, e.g. audio volume. Stored in the save file.
- `SaveFile` (scripts/globals/save_file.gd)
  Stores data in a file and loads it when the game starts.
  The file is stored in [Godot's default user:// directory](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#accessing-persistent-user-data-user).

## ✨ Assets used

- Font: [AnnotationMono v0.2 Bold by Qwerasd](https://github.com/qwerasd205/AnnotationMono) (OFL-1.1)
- Addon: [GDScript-formatter addon by GDQuest](https://github.com/GDQuest/GDScript-formatter) (MIT)
- Click sound: [Switch 006 from Kenney's Interface Sounds](https://kenney.nl/assets/interface-sounds) (CC0)
- Ground Texture1: [AmbientCG Ground 071](https://ambientcg.com/view?id=Ground071)
- Ground Texture2: [AmbientGG Ground 095A](https://ambientcg.com/view?id=Ground095A)
- Plank Texture: [AmbientCG Planks 023B](https://ambientcg.com/view?id=Planks023B)
