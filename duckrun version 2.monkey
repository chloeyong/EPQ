'Libraries and globals
Import mojo
Global Game:Game_app
Global score
'flounderbounce
Global currentdir:String="right"
Global movementspeed = 3
'flounder bounce

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
Field enemy_collection:List<alien>
'Field player_collection: List<Duck>


Method OnCreate ()
'All the initialisation for the game goes here:
PlayMusic("RiverMusic.ogg", 1)
SetUpdateRate 60
menu = LoadImage ("homepage.png")
background = LoadImage ("background.png")
player = New Duck
enemy_collection = New List<alien>
'player_collection = New List<Duck>
enemy_collection.AddLast(New alien(75,0))
enemy_collection.AddLast(New alien(225,0))
enemy_collection.AddLast(New alien(375,0))
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
'For Local enemy:=Eachin enemy_collection
'If enemy.y<10 Then enemy_collection.Remove enemy
'Next
For Local enemy:=Eachin enemy_collection
'For Local player:=Eachin player_collection
If intersects(player.x,player.y,10,21,enemy.x,enemy.y,100,50) Then
score = 0
'End
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
'Cls 000, 128, 255
DrawImage player.sprite, player.x, player.y
DrawText(score, 20, 40, 2, 2)
For Local enemy:= Eachin enemy_collection
DrawImage enemy.sprite, enemy.x, enemy.y

Select currentdir
Case "left"
enemy.y-=1.0
Case "right"
enemy.y+=1.0
End Select
If enemy.y>480-16 Then currentdir = "left"
If enemy.y<0 Then currentdir = "right"
If score <0 Then GameState = "GAMEOVER"
Next
'For Local alien:=Eachin enemy_collection
'DrawImage alien.sprite, alien.x, alien.y
'Next
End
End 
End

Class Duck
Field sprite:Image = LoadImage ("duck.png")
Field x:Float = 300
Field y:Float = 280
Method Move(x_distance:Int)
x+=x_distance
If x<0 Then x=0
If x>590 Then x=590
End
End

Class alien
Field sprite:Image = LoadImage ("log.png")
Field x:Float
Field y:Float
Method New(x_spawn:Int, y_spawn:Int)
x = x_spawn
y = y_spawn
End

Method Move(y_distance:Int)
y-=y_distance
End
End

Function intersects:Bool (x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
Return True
End