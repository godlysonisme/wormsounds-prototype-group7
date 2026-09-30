# WormSounds

## Overview

Worm Sounds is a prototype game that aims at teaching music theory to 
beginner musicians. This game teaches players about the tritone interval. 
Worm Sounds has many features, most of which are listed below, but most 
notably, it includes a teaching phase and a playing phase. In the teaching 
phase the player listens to the notes in the tritone interval and is then 
made to match the tune in the playing phase by using a set of keys to match 
the notes height.

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