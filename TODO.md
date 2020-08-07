# TODO.md

## Base stuff

* Make a proper icon that is not the default icon that comes with a new Godot project.

### Stage.tscn

* ~~Get the controls up and running in the base stage without tying it to the
  tempo.~~
  * ~~Tie the movement to the tempo.~~
* ~~Get tempo mechanic figured out.~~
* ~~Replace the background with an image.~~
* ~~Add the HUD. It's attached to the game's camera, but the HUD
  isn't complete. See the subsection "HUD.tscn".~~ Used a `CanvasLayer` for the HUD.
* ~~Get the HUD and debug info to scale and align correctly with the camera's zoom.~~
* ~~Get the camera to zoom in a way where it'll zoom out when the characters
  are spaced out, and zoom in when they are close to each other.~~
* ~~Flesh out the controls.~~ Used a hacky implementation in the place of animations and hitboxes.
* ~~Add `StartTimerLabel` and interface it with the Stage's script.~~
* ~~Add `PostWinTimer` and interafaces it with the Stage's script.~~
* ~~Fix the 4-button, 2-hit round win exploit (it previously was a game win exploit).~~

### Debug.tscn (COMPLETE)

* ~~Add frame rate.~~
* ~~Add animation frame rate.~~
* ~~Draw hitboxes when enabled.~~ I'm considering against it.
* ~~Program the debug HUD.~~
  * ~~Interface the frame rate.~~
  * ~~Interface the animation frame rate.~~

### HUD.tscn (COMPLETE)

* ~~Add `Player1Name`~~
* ~~Add `Player1HPBar`.~~
* ~~Add `Player1Wins`.~~
* ~~Add `Player2Name`.~~
* ~~Add `Player2HPBar`.~~
* ~~Add `Player2Wins`.~~
* ~~Add `RoundTimer`.~~
* ~~Make the art for the HP bar background.~~
* ~~Make the art for the HP bar fill.~~
* ~~Make the art for the win counter for 0 wins.~~
* ~~Make the art for the win counter for 1 win.~~
  * ~~For player 1.~~
  * ~~And player 2.~~
* ~~Make the art for the win counter for 2 wins.~~
* ~~Get the HUD to scale correctly.~~
* ~~Program the HUD.~~
  * ~~Interface the health of the characters.~~
  * ~~And their wins.~~
  * ~~And the time of the game.~~

### Character.tscn

* ~~Create sprite for player character.~~
* ~~Make sure players don't go out of bounds on the stage.~~ (The grid prevents
  this.)
* ~~Get damage to work correctly.~~
* ~~Implement combos.~~
  * ~~Light punch.~~
  * ~~Heavy punch.~~
  * ~~Light kick.~~
  * ~~Heavy kick.~~
  * More combos.

## Additional stuff

### MainMenu.tscn

* ~~Add "Start Game" button.~~ (For right now, it only loads into a match.)
  * ~~Program it.~~
* ~~Add "Settings" button.~~
  * ~~Program it (after SettingsMenu.tscn has been made).~~
* ~~Add "Quit to Desktop" button.~~
  * ~~Program it.~~
* ~~Get controller controls working.~~

### PauseMenu.tscn

* ~~Add "Resume Game" button.~~
  * ~~Program it.~~
* ~~Add "Settings" button.~~
  * ~~Program it (after OptionsMenu.tscn has been made).~~
* ~~Add "Quit to Character Select" button.~~
  * Program it (after CharacterSelect.tscn has been made).
* ~~Add "Quit to Main Menu" button.~~
  * ~~Program it.~~
  * ~~Fix the bug that prevents the main menu buttons from working after
    clicking this button.~~
* ~~Add "Quit to Desktop" button.~~
  * ~~Program it.~~
* ~~Get the controller controls working.~~

### WinMenu.tscn

* ~~Add win label.~~
* ~~Add rematch button.~~
  * ~~Program it.~~
* ~~Add character select button.~~
  * Program it.
* ~~Add quit to main menu button.~~
  * ~~Program it.~~
* ~~Add quit to desktop button.~~
  * ~~Program it.~~
* ~~Get the controller controls working.~~

### QuitConfirmation.tscn

* ~~Add "Yes" button.~~
  * ~~Program it.~~
* ~~Add "No" button.~~
  * ~~Program it.~~
* ~~Get the controller controls working.~~

### SettingsMenu.tscn

* ~~Add video settings.~~
  * ~~Add resolution setting.~~
  * ~~Add refresh rate setting.~~
  * ~~Add Vsync setting.~~
  * ~~Add fullscreen setting.~~
  * ~~Add borderless setting.~~
  * ~~Get them working.~~
* ~~Add audio settings.~~
  * ~~Add master slider.~~
  * ~~Add music slider.~~
  * ~~Add sound effects slider.~~
  * ~~Add menu sounds slider.~~
  * ~~Get them working.~~
* Add control settings.
  * Add "Menu Control Mode" setting (in an options button). (These settings don't
  apply in the character select screen, where the Menu Control Mode defaults to
  2-player Individual Control).
    * ~~Add label and options box.~~
    * ~~Add "Player 1 Exclusive Control" setting. (Makes it to where player 1 has
      all of the control of the menus and pausing.)~~
    * ~~Add "2-Player Simultaneous Control" setting. (Makes it to where both
      players control pausing and navigating the cursor in the menus
      simultaneously. Not recommended
      when having guests over with itchy button fingers/thumbs.)~~
    * Add "2-Player Individual Control" setting. (Makes it to where both players
      get their own cursor for navigating menus when not in a game. They must be
      on the same UI element to confirm the selection (this does not happen in
      the character select screen). Both players have control over pausing, but
      only the player who paused the game has control over the pause menu.).
    * Add the character select screen as an exception to the control mode.
  * ~~Add bindings list.~~
    * ~~Add lables and buttons.~~
    * ~~Have the buttons get their text from the InputMap.~~
    * ~~Get the rebinding functionality working.~~
* ~~Get controls working.~~
* ~~Get config validation working correctly.~~

### DeviceSwap.tscn

* ~~Add the (basic) UI.~~
* ~~Add the functionality.~~
* ~~Add it to the main menu.~~

### CharacterSelect.tscn (not yet added)

* Add character preview.
  * For player 1.
  * And player 2.
* Add character roster (with only the red rectangle).
* Get controls working for both players.
* Make it to where after both players have selected their characters, prompt
  the players to go to the stage select screen (whoever gets to do so depends
  on the Menu Control Mode).

### StageSelect.tscn (not yet added)

* Add stage list.
* Add stage preview.
* Get controller controls working.

### MusicSelect.tscn (not yet added)

* Add music list (no music has been added yet).
* Add metadata (artist, song name, album name (if any), tempo, length (not that
  it really matters since matches are 99 seconds long), places to buy/listen (e.g.
  Spotify, iTunes, Bandcamp, Deezer, Beatport, YouTube, etc.)).
* Get controller controls working.

## Menu Styling Checklist

* MainMenu.tscn
* PauseMenu.tscn
* WinMenu.tscn
* QuitConfirmation.tscn
* SettingsMenu.tscn
* DeviceSwap.tscn
* CharacterSelect.tscn
* StageSelect.tscn
* MusicSelect.tscn

## Reformatting

Adhere to this guide: <https://www.gdquest.com/docs/guidelines/best-practices/godot-gdscript/>

* ~~Leave 2 blanks between functions.~~
* Signals should be named in past tense and below the `extend` keyword of every
  script.
* Prefix pseudo-private variables with an `_`.
* Rank variables in this order: enums, constants, exported, public,
  pseudo-private, onready. Separate these types with a blank line.
* Use static types where applicable for better type hinting with autocompletion,
  and use type inference when possible (except when `Variant`s are desirable).
* Write docstrings.
* Create a `src` folder and put the scripts and scenes in them. Name the folders
  inside them in `PascalCase` and update references when changed.
* Create an `assets` folder and move all assets to there.
  * Create a `fonts` folder and move the fonts in there. Do not rename the
    fonts.
  * Create a `stagebackgrounds` folder and move the single stage background in
    there.
  * Move the music folder into the `assets` folder.
  * Create a `characterspritesheets` folder and move the character spritesheets
    in there.
  * Create a `hud` folder and move all HUD assets to there.
  * Update all references when changed.
* Get rid of the (p1_|p2_)one_win assets. The `one_win` assets are used instead.
