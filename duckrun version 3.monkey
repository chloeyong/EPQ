'Libraries and globals
Import mojo
Global Game:Game_app
Global score
'Global currentdir:String="right"
Global movementspeed = 1

'Main program starts here:
Function Main ()
Game = New Game_app
End

'All game code goes here:
Class Game_app Extends App
Field menu: Image
Field background: Image
Field gameover: Image 'gameover screen
Global GameState:String = "MENU"
Field player: Duck
Field enemy_collection:List<log>
Field worm_collection:List<worm>


Method OnCreate ()
'All the initialisation for the game goes here:
PlayMusic("RiverMusic.ogg", 1)
SetUpdateRate 60
menu = LoadImage ("homepage.png")
background = LoadImage ("background.png")
player = New Duck
enemy_collection = New List<log>
worm_collection = New List <worm>
enemy_collection.AddLast(New log(90,0))
enemy_collection.AddLast(New log(205,0))
worm_collection.AddLast(New worm(320,0))
gameover = LoadImage ("gameover.png") 'loads image for gameover screen
End

Method OnUpdate ()
'All the game logic goes here:
Select GameState
Case "GAMEOVER" 'gameover screen
If KeyHit(KEY_ENTER) Then GameState="MENU" 'allows the player to go back to the start menu so that they can play again
Case "MENU"
If KeyHit (KEY_SPACE) Then GameState="PLAYING"
Case "PLAYING"
If KeyHit (KEY_ESCAPE) Then GameState="MENU" 
If KeyDown(KEY_LEFT) Then player.Move(-15)
If KeyDown(KEY_RIGHT) Then player.Move(15)
End
'Handle log movement
For Local enemy:=Eachin enemy_collection
If enemy.y>480-16 Then 
enemy_collection.Remove enemy
enemy_collection.AddLast(New log(90,0))
enemy_collection.AddLast(New log(320,0))
worm_collection.AddLast(New worm(205,0))
End
For Local enemy:=Eachin enemy_collection
If intersects(player.x,player.y,10,21,enemy.x,enemy.y,100,50) Then 
score = -1
End
For Local worm:=Eachin worm_collection
If intersects(player.x,player.y,10,21,worm.x,worm.y,100,50) Then 
worm_collection.Remove worm
score = score + 1
End
End
End
End
End

Method OnRender ()
'All the graphics drawing goes here:
Select GameState
Case "MENU"
DrawImage menu, 0,0
Case "GAMEOVER"
DrawImage gameover, 0, 0
Case "PLAYING"
DrawImage background, 0, 0 'draws the background picture as a background
DrawImage player.sprite, player.x, player.y
DrawText(score, 40, 60, 2, 2)
For Local enemy:= Eachin enemy_collection
DrawImage enemy.sprite, enemy.x, enemy.y
enemy.y += 1
For Local worm:=Eachin worm_collection
DrawImage worm.sprite, worm.x, worm.y
worm.y += 1
If score <0 Then GameState = "GAMEOVER"
Next
End
End 
End
End

Class Duck
Field sprite:Image = LoadImage ("duck.png")
Field x:Float = 205
Field y:Float = 280
Method Move(x_distance:Int)
x+=x_distance
If x<90 Then x=90
If x>320 Then x=320
End
End

Class log
Field sprite:Image = LoadImage ("log.png")
Field x:Float
Field y:Float
Method New(x_spawn:Int, y_spawn:Int)
x = x_spawn
y = y_spawn
End
End

Class worm
Field sprite:Image = LoadImage ("worm.png")
Field x:Float
Field y:Float
Method New(x_spawn:Int, y_spawn:Int)
x = x_spawn
y = y_spawn
End
End

Function intersects:Bool (x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
Return True
End