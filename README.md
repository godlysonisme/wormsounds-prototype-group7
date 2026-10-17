# WormSounds

## Overview

Worm Sounds is a prototype game that aims to teach music theory and ear training
to beginner musicians. The game introduces musical notes, intervals, scales and
chords across three teaching levels. During the learning and practice stages,
players use piano keys to move a worm between notes on a musical staff. During
the LISTEN stage, the player hears a note sequence, then attempts to reproduce
it during the PLAY stage.

The game also includes an Endless Mode with randomised, increasingly longer note
sequences, a scrollable level-selection screen, a pause/resume menu, and a
high-score system. Level 1 includes an initial movement tutorial; Levels 2
and 3 begin directly with their learning stages.

## Setup and Running the App

Before running the project, run this in the terminal to download the dependencies:

```bash
flutter pub get
```

You can check that Flutter and the Android development tools are configured
correctly by running:

```bash
flutter doctor
```

### Running on an Android Emulator

In Android Studio, open:

**Tools → Device Manager**

Create an Android virtual device or start an existing emulator. The emulator should appear in the list of available devices.

The game can then be started using the **Run** button in Android Studio or
with the following terminal command:

```bash
flutter run
```

The game supports both portrait and landscape orientation and runs in
fullscreen mode.

## Testing

The project contains automated Flutter tests for the piano keyboard,
difficulty rating system, level results and score formatting.

To run all tests in the project, use:

```bash
flutter test
```

To run the tests while displaying the name and result of each individual
test, use:

```bash
flutter test --reporter expanded
```

## Development Using GPT Assistance

This game was developed feature by feature, with GPT helping in many
stages throughout. Each subheading is a stage, each containing the GPT
prompts used.

---
### Setting Up Piano Keys

This section was done mostly by hand, but GPT was used to optimise the code.

Prompt 1:
``` 
How can I optimize this code to repeat repetition?
```
---
### Setting up the Files and getting movement working
This section was entirely done by hand.

---
### Note Spawning + Level Stages
This section was entirely done by hand.

---
### Background, Worm Positioning + Staff Lines
This section was entirely done by hand.

---
### Phase Text + Phase Breaks
This section was entirely done by hand.

---
### Note Spacing + Hitboxes

Prompt 2:
```
Fix note spacing to make the notes not overlap because the 
worm cant hit two notes at the same time. Also fix the hitboxes 
of the incoming notes as at the moment the notes are a bit large 
and it looks as though the worm can sometimes hit two notes at once.
```
---
### Note Audio (Hit / Missed Notes)

Prompt 3:
```
Make each of the notes have their own unique sound that plays when the 
worm collides with them. 
```
Prompt 4:
```
How can I make the volume for the notes lower? 
```
---
### Vibrato Button + Worm Animation

Prompt 5:
```
Add a button for vibrato above the keyboard interface that 
the player can hold down whilst playing a note. Also add a vibrato 
effect for each of the note sounds that plays when vibrato is used. 
```
---
### Score Counter
This section was entirely done by hand.

---
### Title Screen / End Level Screen / Ratings

Prompt 6:
```
Add a title screen and an end level screen. The style of these 
should look similar to the level style itself. The title screen 
should have a difficulty selector, a start button, and the user's 
highest score. The end level screen should say the score of that 
level, the user's highest score, a letter rating of how they did, 
a restart button, and a back to title screen button. The difficulty 
selector will just adjust the strictness of the rating given at the 
end of the level, so on a harder difficulty it would be harder to 
get an A or A+.
```
---

---
### Additional Teaching Levels (Levels 2 and 3)
This section was entirely done by hand.

---
### Endless Mode

GPT assistance was used to add an Endless Mode alongside the three teaching
levels. It generates random note sequences, automatically plays them in the
LISTEN stage, and then asks the player to repeat the same sequence in the PLAY
stage. The number of notes increases as rounds progress, up to a maximum of
seven notes per sequence. The mode continues until the player exits.

The LISTEN and PLAY stages also have a moving timing indicator for **each note**,
so players can identify when a note will reach the worm without being shown its
pitch in advance.

Prompt 7:
```
Can you help me implement an Endless Mode in our existing Flutter and Flame
Worm Sounds game? I want random note sequences that alternate between LISTEN
and PLAY. The PLAY stage should repeat the exact sequence heard during LISTEN,
and the sequence should gradually get longer as the player progresses. Reuse
our existing note spawning, collision, audio and scoring systems.
```

Prompt 8:
```
Can you make the LISTEN and PLAY timing bars appear for every individual note
in Endless Mode rather than only appearing once at the start of each stage?
The bar should move alongside its corresponding note without giving away the
note's pitch.
```

---
### Pause, Resume and Exit to Menu

GPT assistance was used to add a pause button and pause menu shared by the
teaching levels and Endless Mode. Pausing freezes the Flame game loop so that
notes, the worm, timing indicators and phase progression stop moving. The
player can resume from where they stopped or exit back to the main menu.
When exiting Endless Mode, the game compares the current score with the saved
Endless high score and stores the new score if it is higher.

Prompt 9:
```
Add a pause button to every level, including Endless Mode. When pressed, the
game should stop progressing and show a menu with RESUME and EXIT TO MENU.
Resuming should continue from the exact position where the game was paused,
and the piano and vibrato controls should not accept input while paused.
```

Prompt 10:
```
When the player exits Endless Mode through the pause menu, save their score if
it is a new high score. Normal levels should continue to use their existing
end-of-level score and rating system.
```

---
### Level Selection Screen

GPT assistance was used to change the main menu from displaying individual
level buttons to displaying one LEVELS button. Selecting it opens a separate,
scrollable level-selection page. The page shows Levels 1, 2 and 3 as selectable
cards, with additional locked placeholder cards to represent possible future
levels. A back button returns the player to the main menu without changing the
selection. Endless Mode remains available separately on the main menu.

Prompt 11:
```
Replace the separate level buttons on the main menu with one LEVELS button.
When pressed, open a new level-selection screen with a scrollable grid of
levels. We only have three playable levels, so add locked placeholder cards
for the remaining spaces. Include a back button to the main menu, and allow
the player to select a level before starting it.
```

---
### Worm Rendering Order

GPT assistance was also used to adjust the visual layering of the worm. The
worm was given a higher rendering priority so it appears in front of incoming
notes and timing bars without changing the collision hitboxes.

Prompt 12:
```
How can I make the worm sprite appear visually in front of the notes when they
pass by? Keep its movement, collision detection and hitbox positions the same.
```