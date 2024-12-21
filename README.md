Alisa Yurevich, Morgan Schmidt, Owen Liao, Susan Nguyen

Tufts ES4: Introduction to Digital Logic

December 17, 2024

Our game utilized an FPGA to create a visual-based memory game where four cats “meow” in a pseudo-random sequence on a screen. The user attempts to repeat this sequence by pushing four corresponding arcade buttons. If the user’s sequence is correct, the game progresses to a new round of randomized meows. When the user fails to repeat the sequence, the game ends. This implementation is divided into three main parts: VGA, ROM graphics, and game logic. 
The VGA controlled the display of the game on the screen, receiving signals from a sequence generator to trigger the appropriate cat “MEOW” speech bubble. The display was refreshed every clock cycle to ensure the screen reflected the active sequence. This encoding was accomplished through sending six-bit RGB values to the VGA adapter, which were determined by ROM graphics.
The ROM graphics stored RGB values to correspond to each pixel, recognizing the pixel through its address. When the game switched between screens, the graphics implemented in the VGA pattern generator changed to match the intended screen. Everything on the screen was stored in ROM as a sprite, except for the background which remained on the screen throughout the game. 
The third major component of our game was the game logic, implemented in two parts: playing the sequence for the user and detecting the user’s input. A state machine generates a pseudo-random sequence and displays it for the user. The game processes user input only after the sequence has finished playing, preventing the user from pressing buttons during playback that affect the game state. The sequence detector compares the user's input to the output from the play sequence state machine. These two state machines work together to ensure proper game functionality.
