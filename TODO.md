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
  isn't complete. See the subsection "HUD.tscn".~~
* Get the HUD and debug info to scale and align correctly with the camera's zoom.
* Get the camera to zoom in a way where it'll zoom out when the characters
  are spaced out, and zoom in when they are close to each other.
* Flesh out the controls.
* ~~Add `StartTimerLabel` and interface it with the Stage's script.~~

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

## Additional stuff

### MainMenu.tscn

* ~~Add "Start Game" button.~~
* ~~Add "Options" button.~~
* ~~Add "Quit to Desktop" button.~~
* Get controls working.

### PauseMenu.tscn

* ~~Add "Resume Game" button.~~
* ~~Add "Options" button.~~
* ~~Add "Quit to Character Select" button.~~
* ~~Add "Quit to Main Menu" button.~~
* ~~Add "Quit to Desktop" button.~~
* Get controls working.

### OptionsMenu.tscn (not yet added and won't be added for the capstone) 

* Add video settings.
  * Add resolution setting.
  * Add refresh rate setting.
  * Add VSync setting.
  * Add fullscreen/windowed/borderless setting.
* Add control settings.
  * Add "Menu Control Mode" setting (in a combo box). (These settings don't
  apply in the character select screen, where the Menu Control Mode defaults to
  2-player Individual Control).
    * Add "Player 1 Exclusive Control" setting. (Makes it to where player 1 has
      all of the control of the menus and pausing.)
    * Add "2-Player Simultaneous Control" setting. (Makes it to where both
      players control pausing and navigating the cursor in the menus
      simultaneously. This does not work in the Options Menu. Not recommended
      when having guests over with itchy button fingers/thumbs.)
    * Add "2-Player Individual Control" setting. (Makes it to where both players
      get their own cursor for navigating menus when not in a game. They must be
      on the same UI element to confirm the selection (this does not happen in
      the character select screen). Both players have control over pausing, but
      only the player who paused the game has control over the pause menu.).
* Get controls working.

### CharacterSelect.tscn (not yet added and won't be added for the captstone)

* Add character preview.
  * For player 1.
  * And player 2.
* Add character roster (with only the red rectangle).
* Get controls working for both players.
* Make it to where after both players have selected their characters, prompt
  the players to start the game (whoever gets to start the game depends on the
  Menu Control Mode).

### StageSelect.tscn (not yet added and won't be added for the capstone)

* Add stage list.
* Add stage preview.
* Get controls working.

### MusicSelect.tscn (not yet added and won't be added for the capstone)

* Add music list (no music has been added yet).
* Add metadata (artist, song name, album name (if any), tempo, length (not that
  it really matters since matches are 99 seconds long), places to buy/listen (e.g.
  Spotify, iTunes, Bandcamp, Deezer, Beatport, YouTube, etc.)).
* Get controls working.

### First character

* Implement combos for first character (the red rectangle).
  * Light punch.
  * Heavy punch
  * Light kick.
  * Heavy kick.
