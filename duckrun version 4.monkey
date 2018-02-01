'Libraries and global variables
Import mojo
Global Game:Game_app
'Global score
Global movementspeed = 3

'Main program starts here:
Function Main ()
Game = New Game_app
End

'All game code goes here:
Class Game_app Extends App
Field menu: Image 'start screen
Field background: Image 'background screen
Field gameover: Image 'gameover screen
Global GameState:String = "MENU"
Field score:Int=0 'players score
Field player: Duck
Field enemy_collection:List<log>
Field worm_collection:List<worm>


Method OnCreate ()
'All the initialisation for the game goes here:
	PlayMusic("RiverMusic.ogg", 1) 'plays the background music
	SetUpdateRate 60
	menu = LoadImage ("homepage.png") 'loads image for the menu
	background = LoadImage ("background.png") 'loads image for the game
	player = New Duck 'creates a new player sprite, calls the duck class
	enemy_collection = New List<log> 'a new list for enemy_collection is created
	worm_collection = New List <worm> 'a new list for worm_collection is created
	enemy_collection.AddLast(New log(90,0)) 'draws a new log at the location
	enemy_collection.AddLast(New log(205,0))
	worm_collection.AddLast(New worm(320,0))'draws a new worm at the location
	gameover = LoadImage ("gameover.png") 'loads image for gameover screen
End

Method OnUpdate ()
'All the game logic goes here:
	Select GameState 'creates game states
		Case "GAMEOVER" 'gameover screen
			If KeyHit(KEY_ENTER) Then
			score = 0
			GameState="MENU" 'allows the player to go back to the start menu so that they can play again
			Endif
		Case "MENU"'menu screen
			If KeyHit (KEY_SPACE) Then GameState="PLAYING"
		Case "PLAYING"
			If KeyHit (KEY_ESCAPE) Then GameState="MENU" 
			If KeyDown(KEY_LEFT) Then player.Move(-15) 'allows the player to move left and right using the arrow keys
			If KeyDown(KEY_RIGHT) Then player.Move(15)
'Handle log movement
	For Local enemy:=Eachin enemy_collection
		If enemy.y>480-16 Then 'creates a condition to remove the log once they have reached the bottom of the screen
			enemy_collection.Remove enemy
			enemy_collection.AddLast(New log(90,0)) 'and add new logs and worms
			enemy_collection.AddLast(New log(320,0))
			worm_collection.AddLast(New worm(205,0))
		End
	End
	For Local worm:=Eachin worm_collection 'creates a condition if the player collides with the worm
		If intersects(player.x,player.y,10,21,worm.x,worm.y,100,50) Then 
			worm_collection.Remove worm 'removes the worm
			score = score + 1 'adds one to the score
		End
	End
	For Local enemy:=Eachin enemy_collection 'creates a condition if the player collides with the enemy
	For Local worm:=Eachin worm_collection
		If intersects(player.x,player.y,10,21,enemy.x,enemy.y,100,50) Then 
			enemy_collection = New List<log> 'a new list for enemy_collection is created so that the logs and worms previously are removed
			worm_collection = New List <worm> 'a new list for worm_collection is created
			enemy_collection.AddLast(New log(90,0)) 'draws a new log at the location
			enemy_collection.AddLast(New log(205,0))
			worm_collection.AddLast(New worm(320,0))'draws a new worm at the location
			score = -1 'sets score to = -1 (so the game ends)
		End
	End
	End
End
End

Method OnRender ()
'All the graphics drawing goes here:
	Select GameState
		Case "MENU"
			DrawImage menu, 0,0 'draws the menu picture - whole screen
		Case "GAMEOVER"
			DrawImage gameover, 0, 0 'draws the gameover picture - whole screen
		Case "PLAYING"
			DrawImage background, 0, 0 'draws the background picture as a background
			DrawImage player.sprite, player.x, player.y 'draws the player sprite
			DrawText(score, 40, 60, 2, 2) 'draws the score in the corner of the screen
			For Local enemy:= Eachin enemy_collection
				DrawImage enemy.sprite, enemy.x, enemy.y 'draws the log
				enemy.y += 1 'moves the enemy down the y-axis
			End
			For Local worm:=Eachin worm_collection 
				DrawImage worm.sprite, worm.x, worm.y 'draws the worm
				worm.y += 1 'moves the worm down the y-axis
			End
		End
		If score <0 Then GameState = "GAMEOVER" 'condition - if the score is less than 0 then the game ends
	End
End		
		
Class Duck 'creates a new class for the player
	Field sprite:Image = LoadImage ("duck.png") 'draws the image of the duck
	Field x:Float = 205 'the image is drawn at these co-ordinates
	Field y:Float = 280
	Method Move(x_distance:Int)
		x+=x_distance 'x=the distance of x
		If x<90 Then x=90 'creates a maximum and minimum that the duck can move
		If x>320 Then x=320
	End
End

Class log 'creates a new class for the alien
	Field sprite:Image = LoadImage ("log.png") 'draws the image of the log
	Field x:Float 'the image moves, so no co-ordinates are set
	Field y:Float
	Method New(x_spawn:Int, y_spawn:Int) 'creates a method so that a new log can be drawn when method is called
		x = x_spawn
		y = y_spawn
	End
	Method Move(y_distance:Int) 'this indicates the y moves down the axis
		y+=y_distance
	End
End

Class worm 'creates a new class for the worm
	Field sprite:Image = LoadImage ("worm.png") 'draws the image of the worm
	Field x:Float 'the image moves, so no set co-ordinates
	Field y:Float
	Method New(x_spawn:Int, y_spawn:Int) 'creates a methods os that a new log can be drawn when the method is called
		x = x_spawn
		y = y_spawn
	End
	Method Move(y_distance:Int) 'the worm moves down the y-axis
		y+=y_distance
	End
End

Function intersects:Bool (x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int) 'creates a function for the intersect
	If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False 'if the co-ordinates don't match than the intersect is false
	If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	Return True 'if not true is returned
End