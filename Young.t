/*
ESCAPE
David Lu
First individual written game code, without use of classes (inefficient coding)
Very limited comments
Message for teacher at end, alternate ending included in comments

Started: March 30, 2016
Last edit: June 2, 2016
Special thanks to Emily, William, Justin, and Computer Science Grade 11 teacher Mrs. Young
*/


setscreen ("graphics:1000;600")
setscreen ("title:ESCAPE - David Lu")

%FONTS
var font : int := Font.New ("sans serif:16") %regular
var fontu : int := Font.New ("sans serif:12:underline")
var fontl : int := Font.New ("sans serif:24") %large
var fontxl : int := Font.New ("sans serif:50") %very big
var fontt : int := Font.New ("sans serif:24:italic,bold") %title
var fontwolf : int := Font.New ("sans serif:200") %huge wolf
var fontover : int := Font.New ("sans serif:100:underline") %GAME OVER

%GAME VARIABLES
var periods : string
var current_room : int
var visited : array 1 .. 9 of int  %visited rooms
var possibles_moveroom : array 1 .. 9 of string := init ("ds", "asd", "as", "wds", "awds", "was", "wd", "awd", "wa") %just movement
var possibles_room : array 1 .. 9 of string %Room specific
var possible : string %Calculation for possible actions at each room
var input : string %input from user
var clues_found : array 1 .. 4 of int
var items : array 1 .. 4 of string
var check_exit : int
var check_total_exit : int
var check_nope : int
var time_tick : int
var tick : int
var condition7 : int
var final_check : int
var wolf : int
var wolf_check : int
var oil : int

%CUSTOMIZE THE FINAL CLUE
var clues_info : array 1 .. 4 of string := init ("14", "73", "62", "51")
var clues_info_empty : array 1 .. 4 of string := init ("--", "--", "--", "--")
var full_code : string := "14736251"

%CONSTANTS
const x_choice := 200
const y_choice := 450
const y_change := 75

%COLOURS
var background := 90 %BACKGROUND COLOUR
const colour_corner := 23 %OUTSIDE
const colour_inside := 14 %INSIDE MOVE DIRECTIONS
const menu_inside := 38 %INSIDE CLUES AND INVENTORY
const title_colour_inside := 12 %TITLE INSIDE
const colour_input := 0 %INPUT COLOUR
const box := 10 %width of the boxes

%PROCEDURES
procedure Pause
    Font.Draw ("Press anything to continue...", 700, 150, font, black)
    drawfillbox (975, 25, 800, 100, colour_corner)
    drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
    locatexy (880, 60)
    Input.Pause
end Pause

procedure Pause_end
    Font.Draw ("Press anything to restart...", 700, 150, font, black)
    drawfillbox (975, 25, 800, 100, colour_corner)
    drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
    locatexy (880, 60)
    Input.Pause
end Pause_end

procedure display_outside
    drawfillbox (0, 0, 1000, 600, 7)
    drawfillbox (25, 25, 975, 575, background)
    drawfillbox (25, 500 - 18, 200, 575, colour_corner)
    drawfillbox (25 + box, 500 + box - 18, 200 - box, 575 - box, title_colour_inside)
    Font.Draw ("ESCAPE", 45, 525, fontt, 7)
    Font.Draw ("by: David Lu", 80, 505, fontu, 7)
end display_outside

procedure create_possibles (room : int, var possible : string)
    possible := possibles_room (room) + possibles_moveroom (room) + "ic"
end create_possibles

procedure get_input_long (var input : string, letter : string)
    var answer : string
    loop
	drawfillbox (975, 25, 800, 100, colour_corner)
	drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
	Font.Draw ("Input: ", 820, 57, font, black)
	locatexy (880, 60)
	get answer : *
	exit when length (answer) > 0 and index (letter, answer) not= 0
	Font.Draw ("Sorry, try again.", 700, 150, font, black)
	delay (750)
	drawfillbox (700, 140, 850, 170, background)
    end loop
    input := answer
end get_input_long

procedure get_input (var input : string)
    var answer : string (1)
    loop
	drawfillbox (975, 25, 800, 100, colour_corner)
	drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
	Font.Draw ("Input: ", 820, 57, font, black)
	locatexy (880, 60)
	getch (answer)
	exit when length (answer) > 0 and length (answer) < 2 and index (possible, answer) not= 0
	Font.Draw ("Sorry, try again.", 700, 150, font, black)
	delay (750)
	drawfillbox (700, 140, 850, 170, background)
    end loop
    input := answer
end get_input

procedure get_input_alone (var input : string, letter : string)
    var answer : string (1)
    loop
	drawfillbox (975, 25, 800, 100, colour_corner)
	drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
	Font.Draw ("Input: ", 820, 57, font, black)
	locatexy (880, 60)
	getch (answer)
	exit when length (answer) > 0 and index (letter, answer) not= 0
	Font.Draw ("Sorry, try again.", 700, 150, font, black)
	delay (750)
	drawfillbox (700, 140, 850, 170, background)
    end loop
    input := answer
end get_input_alone

procedure display_move_rooms (current_room : int)
    var the_string := possibles_moveroom (current_room)
    if index (the_string, "s") not= 0 then
	drawfillbox (450 - box, 25, 550 + box, 60 + box + box, colour_corner)
	drawfillbox (450, 25 + box, 550, 60 + box, colour_inside)
	Font.Draw ("Down (s)", 460, 45, font, black)
    end if
    if index (the_string, "a") not= 0 then
	drawfillbox (25, 290 - box, 105 + box + box, 325 + box, colour_corner)
	drawfillbox (25 + box, 290, 105 + box, 325, colour_inside)
	Font.Draw ("Left (a)", 40, 300, font, black)
    end if
    if index (the_string, "w") not= 0 then
	drawfillbox (450 - box, 540 - box - box, 550 + box, 575, colour_corner)
	drawfillbox (450, 540 - box, 550, 575 - box, colour_inside)
	Font.Draw ("Up (w)", 470, 540, font, black)
    end if
    if index (the_string, "d") not= 0 then
	drawfillbox (890 - box - box, 290 - box, 975, 325 + box, colour_corner)
	drawfillbox (890 - box, 290, 975 - box, 325, colour_inside)
	Font.Draw ("Right (d)", 885, 300, font, black)
    end if
end display_move_rooms

procedure display_game
    display_outside
    drawfillbox (625, 500, 800, 575, colour_corner)
    drawfillbox (625 + box, 500 + box, 800 - box, 575 - box, menu_inside)
    Font.Draw ("Clues (c)", 670, 535, font, black)
    drawfillbox (800, 500, 975, 575, colour_corner)
    drawfillbox (800 + box, 500 + box, 975 - box, 575 - box, menu_inside)
    Font.Draw ("Inventory (i)", 830, 535, font, black)
end display_game

procedure display_room (room : int)
    var location : array 1 .. 9, 1 .. 2 of int := init (40, 180, 110, 180, 180, 180, 40, 110, 110, 110, 180, 110, 40, 40, 110, 40, 180, 40)
    const size := 50
    drawbox (location (room, 1), location (room, 2), location (room, 1) + size, location (room, 2) + size, 7)
end display_room

procedure inventory
    cls
    display_outside
    Font.Draw ("Inventory", 200, 400, fontxl, 7)
    for item : 1 .. 4
	Font.Draw ("Item: ", 250, 350 - (item * 40), fontl, 7)
	Font.Draw (items (item), 400, 350 - (item * 40), fontl, 7)
    end for
    Font.Draw ("Quit (q)", 700, 150 + y_change div 2, font, 7)
    get_input_alone (input, "q")
end inventory

procedure clues
    cls
    display_outside
    var number : int := 0
    for x : 1 .. 4
	if clues_found (x) = 1 then
	    number := number + 1
	end if
    end for
    Font.Draw ("Clues: " + intstr (number), 350, 450, fontxl, 7)
    for clue : 1 .. 4
	if clues_found (clue) = 1 then
	    Font.Draw (clues_info (clue), 200 + 100 * clue, 300, fontl, 7)
	else
	    Font.Draw (clues_info_empty (clue), 200 + 100 * clue, 300, fontl, 7)
	end if
    end for
    Font.Draw ("Quit (q)", 700, 150 + y_change div 2, font, 7)
    get_input_alone (input, "q")
end clues

procedure display_map (current_room : int)
    var location : array 1 .. 9, 1 .. 2 of int := init (40, 180, 110, 180, 180, 180, 40, 110, 110, 110, 180, 110, 40, 40, 110, 40, 180, 40)
    const size := 50
    drawbox (30, 30, 240, 255, 7)
    Font.Draw ("MAP", 117, 235, font, 7)
    for room : 1 .. 9
	if visited (room) = 1 then
	    display_room (room)
	end if
    end for
    drawfillstar (location (current_room, 1), location (current_room, 2), location (current_room, 1) + size, location (current_room, 2) + size, 7)
end display_map

procedure update_possibilities
    if items (1) = "?" then
	possibles_room (1) := "t"
    end if
    if items (2) = "Cup" then
	if oil = 1 then
	    possibles_room (1) := "f"
	else
	    possibles_room (1) := ""
	end if
	if items (1) = "Oil" and oil = 0 then
	    possibles_room (1) := "o"
	end if
    elsif items (2) = "Cup (filled)" then
	possibles_room (1) := ""
    end if
    if items (3) = "Key" then
	possibles_room (4) := "u"
    end if
    if items (2) = "Cup (filled)" then
	possibles_room (5) := "p"
    end if
    if clues_found (2) = 1 then
	possibles_room (5) := ""
    end if
    if clues_found (4) = 1 then
	possibles_room (6) := ""
    end if
end update_possibilities

procedure room1 (input : string)
    if input = "t" then
	items (2) := "Cup"
    elsif input = "o" then
	oil := 1
    elsif input = "f" then
	items (2) := "Cup (filled)"
    end if
end room1

procedure room2 (input : string)
    var answer : string := input
    if input = "e" then
	check_total_exit := 1
    elsif input = "y" then
	loop
	    cls
	    display_outside
	    display_map (current_room)
	    drawfillbox (975, 25, 800, 100, colour_corner)
	    drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
	    Font.Draw ("Input: ", 820, 57, font, black)
	    Font.Draw ("The number is: Wrong entry will return you to the room. ", x_choice, y_choice, font, 7)
	    locatexy (880, 60)
	    get answer : *
	    exit
	end loop
	if answer = full_code then
	    final_check := 1
	else
	    Font.Draw ("Sorry, try again.", 700, 150, font, black)
	    delay (750)
	    drawfillbox (700, 140, 850, 170, background)
	end if
    end if
end room2

procedure room3 (input : string)
    var answer : string
    loop
	cls
	display_outside
	display_map (current_room)
	drawfillbox (975, 25, 800, 100, colour_corner)
	drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
	Font.Draw ("Input: ", 820, 57, font, black)
	Font.Draw ("What is the code? Wrong entry will return you to the room. ", x_choice, y_choice, font, 7)
	locatexy (880, 60)
	get answer : *
	exit
    end loop
    if answer = "turing" then
	Font.Draw ("Congratulations, inside the box is clue number 3!", x_choice, y_choice - y_change, font, 7)
	check_exit := 1 + check_exit
	clues_found (3) := 1
	possibles_room (3) := ""
	Pause
    else
	Font.Draw ("Sorry, try again.", 700, 150, font, black)
	delay (750)
	drawfillbox (700, 140, 850, 170, background)
    end if
end room3

%ROOM 4 AT END OF PROCEDURE DEFINITIONS UNDER THE KEY GAME

procedure room5 (input : string)
    if input = "p" then
	tick := time_tick
	items (2) := "Cup (empty)"
    elsif input = "y" then
	if items (1) = "Gloves" then
	    Font.Draw ("You found clue 2 at the top of the shelf!", x_choice, y_choice - 2 * y_change, font, 7)
	    check_exit := 1 + check_exit
	    clues_found (2) := 1
	    Pause
	else
	    Font.Draw ("Not safe...", x_choice, y_choice - 2 * y_change, font, 7)
	    Pause
	end if
    end if
end room5

procedure room6 (input : string)
    if input = "b" then
	Font.Draw ("Inside were a flashlight and a piece of paper.", x_choice, y_choice - (y_change div 2), font, 7)
	Font.Draw ("Congratulations! You got clue 4, and a flashlight", x_choice, y_choice - y_change, font, 7)
	check_exit := 1 + check_exit
	items (4) := "Flashlight"
	Pause
	clues_found (4) := 1
    end if
end room6

procedure room7 (input : string)
    if input = "f" then
	condition7 := condition7 + 1
    elsif input = "p" then
	drawfillbox (480, 420, 650, 480, background)
	Font.Draw ("A WOLF LEAPS OUT OF THE CAGE AND BEGINS TO CHASE YOU!", x_choice, y_choice - y_change, font, 7)
	Font.Draw ("YOU MUST KILL THE WOLF OR YOU WILL DIE!", x_choice, y_choice - 2 * y_change, font, 7)
	Pause
	possibles_room (7) := ""
	condition7 := 2
	wolf := 9
    end if
end room7

procedure room8 (input : string)
    %Do nothing
end room8

procedure room9 (input : string)
    if input = "1" then
	items (1) := "Knife"
	Font.Draw ("You took the knife", x_choice + 300, y_choice - y_change, font, black)
	Pause
    elsif input = "2" then
	items (1) := "Hammer"
	Font.Draw ("You took the hammer", x_choice + 300, y_choice - y_change, font, black)
	Pause
    elsif input = "3" then
	items (1) := "Batteries"
	Font.Draw ("You took the batteries", x_choice + 300, y_choice - y_change, font, black)
	Pause
    elsif input = "4" then
	items (1) := "Gloves"
	Font.Draw ("You took the gloves", x_choice + 300, y_choice - y_change, font, black)
	Pause
    elsif input = "5" then
	items (1) := "Oil"
	Font.Draw ("You took the oil.", x_choice + 300, y_choice - y_change, font, black)
	Pause
    end if
end room9

procedure display_room_options (current_room : int)
    if current_room = 1 then
	Font.Draw ("This room appears to be a kitchen", x_choice, y_choice, font, 7)
	if items (2) = "?" then
	    Font.Draw ("There is a cup. Take it (t)", x_choice, y_choice - y_change, font, 7)

	elsif index (items (2), "Cup") not= 0 then
	    Font.Draw ("The cup is gone.", x_choice, y_choice - y_change, font, 7)
	end if
	if oil = 1 then
	    if items (2) = "Cup (filled)" or items (2) = "Cup (empty)" then
		Font.Draw ("There is a working sink.", x_choice, y_choice - 2 * y_change, font, 7)
	    else
		Font.Draw ("There is a working sink. Fill the cup with water (f)", x_choice, y_choice - 2 * y_change, font, 7)
	    end if
	elsif items (2) = "Cup" and items (1) = "Oil" then
	    Font.Draw ("There is a rusty sink. Oil it (o)", x_choice, y_choice - (y_change * 2), font, 7)
	else
	    Font.Draw ("There is a rusty sink.", x_choice, y_choice - (y_change * 2), font, 7)
	end if
    elsif current_room = 2 then
	Font.Draw ("The door to exit is in front of you. You need 4 clues to exit.", x_choice, y_choice, font, 7)
	possibles_room (2) := ""
	if check_exit = 4 then
	    if final_check = 0 then
		Font.Draw ("Enter code (y)", x_choice, y_choice - y_change, font, 7)
		possibles_room (2) := "y"
	    elsif final_check = 1 then
		Font.Draw ("Escape (e)", x_choice, y_choice - y_change, font, 7)
		possibles_room (2) := "e"
	    end if
	end if
    elsif current_room = 3 then
	if possibles_room (3) = "" then
	    Font.Draw ("Numbers are written above a box: 40 42 36 18 28 14", x_choice, y_choice, font, 7)
	    Font.Draw ("The box is empty.", x_choice, y_choice - y_change, font, 7)
	else
	    Font.Draw ("Numbers are written above a box: 40 42 36 18 28 14", x_choice, y_choice, font, 7)
	    Font.Draw ("The box is locked, try to unlock it? (t)", x_choice, y_choice - y_change, font, 7)
	end if
    elsif current_room = 4 then
	if clues_found (1) = 1 then
	    Font.Draw ("The diary is open on the desk.", x_choice, y_choice, font, 7)
	elsif items (3) = "Key" then
	    Font.Draw ("There is a locked diary on a desk. Unlock with your key (u) ", x_choice, y_choice, font, 7)
	else
	    Font.Draw ("There is a locked diary on a desk. ", x_choice, y_choice, font, 7)
	end if
    elsif current_room = 5 then
	Font.Draw ("There is a tall shelf, with a cactus beside it.", x_choice, y_choice, font, 7)
	if items (2) = "Cup (filled)" then
	    Font.Draw ("Water the cactus (p)", x_choice, y_choice - y_change, font, 7)
	elsif items (2) = "Cup (empty)" then
	    if time_tick - tick > 25 then
		if clues_found (2) = 1 then
		    Font.Draw ("You have found this clue", x_choice, y_choice - y_change, font, 7)
		else
		    possibles_room (5) := "y"
		    Font.Draw ("The cactus is tall, climb it (y)", x_choice, y_choice - y_change, font, 7)
		end if
	    else
		periods := ""
		for x : 1 .. (time_tick - tick)
		    periods := periods + "..."
		end for
		Font.Draw ("The cactus is growing" + periods, x_choice, y_choice - y_change, font, 7)
	    end if
	end if
    elsif current_room = 6 then
	if clues_found (4) = 1 then
	    Font.Draw ("The container is broken", x_choice, y_choice, font, 7)
	elsif items (1) = "Hammer" then
	    possibles_room (6) := "b"
	    Font.Draw ("There is a glass container. Use the hammer (b)", x_choice, y_choice, font, 7)
	else
	    Font.Draw ("There is a glass container.", x_choice, y_choice, font, 7)
	end if
    elsif current_room = 7 then
	if condition7 = 0 then
	    if items (4) = "Flashlight" and items (1) = "Batteries" then
		Font.Draw ("The room is dark. Use the flashlight (f)", x_choice, y_choice, font, 7)
		possibles_room (7) := "f"
	    else
		if items (4) = "Flashlight" then
		    possibles_room (7) := ""
		    Font.Draw ("The room is dark. But for some reason your flashlight won't turn on.", x_choice, y_choice, font, 7)
		else
		    possibles_room (7) := ""
		    Font.Draw ("The room is dark.", x_choice, y_choice, font, 7)
		end if
	    end if
	elsif condition7 = 1 then
	    possibles_room (7) := "p"
	    Font.Draw ("There is a cage. Open (p)", x_choice, y_choice, font, 7)
	elsif condition7 = 2 then
	    possibles_room (7) := ""
	    Font.Draw ("THE WOLF IS ABOUT TO POUNCE!", x_choice, y_choice, font, 7)
	elsif condition7 = 3 then
	    if items (4) = "Flashlight" and items (1) = "Batteries" then
		Font.Draw ("The room is dark. Use the flashlight (f)", x_choice, y_choice, font, 7)
		possibles_room (7) := "f"
	    else
		if items (4) = "Flashlight" then
		    possibles_room (7) := ""
		    Font.Draw ("The room is dark. But for some reason your flashlight won't turn on.", x_choice, y_choice, font, 7)
		else
		    possibles_room (7) := ""
		    Font.Draw ("The room is dark.", x_choice, y_choice, font, 7)
		end if
	    end if
	elsif condition7 = 4 then
	    Font.Draw ("You came back, and in the cage was a key!", x_choice, y_choice, font, 7)
	    items (3) := "Key"
	    condition7 := 5
	    Pause
	elsif condition7 = 5 then
	    Font.Draw ("The dark room is empty.", x_choice, y_choice, font, 7)
	end if
    elsif current_room = 8 then
	Font.Draw ("There is a blackboard on the wall, and on it written some equations.", x_choice, y_choice, font, 7)
	Font.Draw ("It says:   2 = a, 4 = b, 6 = c .....", x_choice, y_choice - y_change, font, 7)
	Font.Draw ("Wonder what that could mean?", x_choice, y_choice - y_change * 2, font, 7)
    elsif current_room = 9 then
	Font.Draw ("It's a workshop. There is a shelf of tools.", x_choice, y_choice, font, 7)
	Font.Draw ("You look in the tool box, and there are 5 tools -- but you can only hold one at a time.", x_choice, y_choice - (y_change div 2), font, 7)
	Font.Draw ("Pick a tool: ", x_choice, y_choice - y_change, font, 7)
	Font.Draw ("Knife (1)", x_choice + 110, y_choice - y_change, font, 7)
	Font.Draw ("Hammer (2)", x_choice + 110, y_choice - (y_change + y_change div 2), font, 7)
	Font.Draw ("Batteries (3)", x_choice + 110, y_choice - 2 * y_change, font, 7)
	Font.Draw ("Gloves (4)", x_choice + 110, y_choice - 2 * y_change - y_change div 2, font, 7)
	Font.Draw ("Oil (5)", x_choice + 110, y_choice - 3 * y_change, font, 7)
    end if
end display_room_options

proc get_input_end (var input : string, letter : string)
    var answer : string
    display_outside
    Font.Draw ("The wolf pounces on you.", x_choice, y_choice, font, 7)
    loop
	Font.Draw ("What is your input?", 700, 200, font, black)
	drawfillbox (975, 25, 800, 100, colour_corner)
	drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
	locatexy (880, 60)
	get answer : *
	exit when length (answer) > 0 and index (letter, answer) not= 0
	Font.Draw ("Sorry, try again.", 700, 150, font, black)
	delay (750)
	drawfillbox (700, 140, 850, 170, colour_input)
    end loop
    input := answer
end get_input_end

proc end_game
    cls
    display_outside
    Font.Draw ("You leave the building, and re-enter the world.", 200, 400, font, 7)
    Font.Draw ("You have now finished the game, congratulations!", 200, 350, font, 7)
    delay (3000)
    cls
    display_outside
    % Regular Ending
    Font.Draw ("Thank you for all my friends that played a role in the creation of this game.", 200, 400, font, 7)
    Font.Draw ("Thanks for playing and enjoy your day!", 200, 350, font, 7)
    /* YOUNG ENDING
    Font.Draw ("To Ms. Young, ", 75, 450, font, 7)
    Font.Draw ("Your amazing teaching, patience, and knowledge gave me the skills to create this game.", 100, 400, font, 7)
    Font.Draw ("I hope you enjoyed this class as much as I did, and I'm sad to see you go. ", 100, 350, font, 7)
    Font.Draw ("I hope you enjoy your retirement.", 200, 300, font, 7)
    Font.Draw ("Thank you for dealing with us.", 100, 250, font, 7)
    Font.Draw ("Your student, ", 500, 150, fontl, 7)
    Font.Draw ("David Lu", 600, 100, fontt, 7)
    */
end end_game


procedure start
    display_outside
    Font.Draw ("You open your eyes.", 150, 420, fontl, 7)
    Font.Draw ("You sit up suddenly.", 150, 375, fontl, 7)
    delay (1500)
    Font.Draw ("Where are you?", 500, 300, fontl, 7)
    delay (700)
    Font.Draw ("What's going on?", 500, 250, fontl, 7)
    delay (700)
    Font.Draw ("What happened?", 500, 200, fontl, 7)
    delay (300)
    Pause
    cls
    display_outside
    Font.Draw ("You look around, you are in a room.", 100, 400, fontl, 7)
    Font.Draw ("There is a door in front of you that says:", 100, 350, fontl, 7)
    Font.Draw ("Find 4 clues to escape.", 150, 300, fontl, 7)
    delay (2000)
    Font.Draw ("Navigate the house, find the clues, and make your way out!", 100, 250, fontl, 7)
    delay (800)
    Pause
end start

procedure gameover
    Font.Draw ("The wolf attacks you, and being defenseless, you fall.", 290, 105, font, 7)
    Pause
    cls
    display_outside
    drawfillbox (70 - box * 2, 200 - box * 2, 930 + box * 2, 400 + box * 2, colour_corner)
    drawfillbox (70, 200, 930, 400, menu_inside)
    Font.Draw ("GAME OVER", 100, 250, fontover, 7)
end gameover



%KEY GAME

%how to change the key's picture. Change the file name, width and length
%and potentially the squares (if the pic is bigger it won't fit

var x : int
var y : int
var button : int

var pic : int := Pic.FileNew ("key_perhaps.bmp") %change this
var sprite : int := Sprite.New (pic)
Sprite.SetHeight (sprite, 2)
var pic_lock : int := Pic.FileNew ("lock_perhaps.bmp")

var x1 : int %Sprite updating
var y1 : int
var picx : int := 50
var picy : int := 50
const pic_width := 115 %change this
const pic_height := 110

var boxx := 700 %key position
var boxy := 350
var boxx2 := 890
var boxy2 := 539

var box_1 : array 1 .. 4 of int := init (200, 25, 300, 425) %three boxes
var box_2 : array 1 .. 4 of int := init (450, 175, 550, 575)
var box_3 : array 1 .. 4 of int := init (550, 175, 820, 275)

procedure Pause_game
    Font.Draw ("You missed... Press anything to restart.", 400, 50, font, black)
    drawfillbox (975, 25, 800, 100, colour_corner)
    drawfillbox (975 - box, 25 + box, 800 + box, 100 - box, colour_input)
    locatexy (880, 60)
    Input.Pause
    drawfillbox (400, 25, 975, 150, background)
end Pause_game

function check (bx1, by1, bx2, by2 : int) : boolean
    var x1 := picx
    var x2 := picx + pic_width
    var y1 := picy
    var y2 := picy + pic_height
    var answer : boolean := true

    if (x2 > bx1 and x2 < bx2 + pic_width) or (x1 > bx1 - pic_width and x1 < bx2) then
	if (y1 > by1 - pic_height and y1 < by2) or (y2 < by2 + pic_height and y2 > by1) then
	    answer := false
	end if
    end if
    result answer
end check

procedure grand_check_game
    var game_check : boolean
    if check (box_1 (1), box_1 (2), box_1 (3), box_1 (4)) = false or
	    check (box_2 (1), box_2 (2), box_2 (3), box_2 (4)) = false or
	    check (box_3 (1), box_3 (2), box_3 (3), box_3 (4)) = false or
	    check (0, 0, 999, 25) = false or
	    check (0, 0, 25, 599) = false or
	    check (0, 575, 999, 599) = false or
	    check (975, 0, 999, 599) = false then
	game_check := false
    else
	game_check := true
    end if
    if game_check = false then
	Pause_game
	picx := 50
	picy := 50
    end if
end grand_check_game

procedure maze
    Pic.Draw (pic_lock, 700, 350, picCopy)
    drawfillbox (box_1 (1), box_1 (2), box_1 (3), box_1 (4), 7)
    drawfillbox (box_2 (1), box_2 (2), box_2 (3), box_2 (4), 7)
    drawfillbox (box_3 (1), box_3 (2), box_3 (3), box_3 (4), 7)
    loop
	Mouse.Where (x, y, button)
	if button = 1 and x > picx and x < (picx + pic_width) and y > picy and y < (picy + pic_height) then
	    x1 := x - picx
	    y1 := y - picy
	    loop
		Mouse.Where (x, y, button)
		if button = 1 then
		    picx := x - x1
		    picy := y - y1
		    Sprite.SetPosition (sprite, picx, picy, false)
		    grand_check_game
		else
		    exit
		end if
	    end loop
	end if
	Sprite.SetPosition (sprite, picx, picy, false)
	grand_check_game
	Sprite.Show (sprite)
	if picx > boxx and picy > boxy and (picx + pic_width) < boxx2 and (picy + pic_height) < boxy2 then
	    exit
	end if
    end loop
end maze

proc mini_game
    %background := 0
    display_outside
    maze
    Font.Draw ("Congratulations, inside was clue number 1!", 350, 50, font, 7)
    Pause
    %background := 90
    Sprite.Free(sprite)
end mini_game

%END OF GAME

%room 4 because it uses game
procedure room4 (input : string)
    if input = "u" then
	Font.Draw ("There appears to be some sort of maze your key must complete to get to the lock!", x_choice, y_choice - y_change div 2, font, 7)
	Font.Draw ("Use your mouse, and move the key. Don't touch the black, and get to the lock!", x_choice, y_choice - y_change, font, 7)
	Pause
	cls
	mini_game
	check_exit := 1 + check_exit
	clues_found (1) := 1
    end if
end room4
%mini_game
%end_game

%-------------------------------------------------------------------------------DISPLAY----------------------------------------------------------------------------
%-------------------------------------------------------------------------------DISPLAY----------------------------------------------------------------------------
%-------------------------------------------------------------------------------DISPLAY----------------------------------------------------------------------------
%-------------------------------------------------------------------------------DISPLAY----------------------------------------------------------------------------
%-------------------------------------------------------------------------------DISPLAY----------------------------------------------------------------------------

start
loop  %game loop
    current_room := 2
    for i : 1 .. 9
	visited (i) := 0
	possibles_room (i) := ""
    end for
    visited (2) := 1
    possibles_room (3) := "tturing"
    possibles_room (9) := "12345"
    for thing : 1 .. 4
	clues_found (thing) := 0
	items (thing) := "?"
    end for
    check_exit := 0
    check_total_exit := 0
    check_nope := 1
    time_tick := 0
    condition7 := 0
    final_check := 0
    wolf := 10
    wolf_check := 0
    oil := 0
    loop
	exit when check_total_exit = 1
	if wolf = 0 then
	    check_total_exit := 1
	end if
	display_game
	display_move_rooms (current_room)
	display_map (current_room)
	display_room_options (current_room)
	update_possibilities
	create_possibles (current_room, possible)
	if wolf not= 10 and items (1) = "Knife" then
	    possible := possible + "k"
	end if
	if wolf not= 10 then
	    Font.Draw (intstr (wolf), 420, 225, fontwolf, 7)
	    wolf := wolf - 1
	    if items (1) = "Knife" then
		Font.Draw ("Kill the wolf (k)", 400, 150, fontl, 7)
	    end if
	end if
	get_input (input)
	time_tick := time_tick + 1
	if input = "w" then
	    if condition7 = 1 then
		condition7 := 0
	    end if
	    current_room := current_room - 3
	    visited (current_room) := 1
	elsif input = "a" then
	    if condition7 = 1 then
		condition7 := 0
	    end if
	    current_room := current_room - 1
	    visited (current_room) := 1
	elsif input = "s" then
	    if condition7 = 1 then
		condition7 := 0
	    end if
	    current_room := current_room + 3
	    visited (current_room) := 1
	elsif input = "d" then
	    if condition7 = 1 then
		condition7 := 0
	    end if
	    current_room := current_room + 1
	    visited (current_room) := 1
	elsif input = "i" then
	    inventory
	elsif input = "c" then
	    clues
	elsif input = "k" then
	    wolf := 10
	    Font.Draw ("You killed the wolf with your knife, and you are safe!", 400, 110, font, 7)
	    condition7 := 3
	    wolf_check := 1
	    Pause
	else
	    if current_room = 1 then
		room1 (input)
	    elsif current_room = 2 then
		room2 (input)
	    elsif current_room = 3 then
		room3 (input)
	    elsif current_room = 4 then
		room4 (input)
	    elsif current_room = 5 then
		room5 (input)
	    elsif current_room = 6 then
		room6 (input)
	    elsif current_room = 7 then
		room7 (input)
	    elsif current_room = 8 then
		room8 (input)
	    elsif current_room = 9 then
		room9 (input)
	    end if
	end if
    end loop

    if wolf = -1 then
	gameover
	Pause_end
    else
	exit
    end if
end loop

end_game

%End of program thank you! =D

