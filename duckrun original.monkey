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
Field player:Rocket
Field fish_collection:List<flounder>
Field missile_collection:List<Laser>
Field enemy_collection:List<alien>


Method OnCreate ()
'All the initialisation for the game goes here:
PlayMusic("RiverMusic.ogg", 1)
SetUpdateRate 60
menu = LoadImage ("homepage.png")
background = LoadImage ("background.png")
player = New Rocket
fish_collection = New List<flounder>
enemy_collection = New List<alien>
fish_collection.AddLast(New flounder(150,250))
enemy_collection.AddLast(New alien(50,250))
enemy_collection.AddLast(New alien(250,250))
enemy_collection.AddLast(New alien(450,250))
missile_collection = New List<Laser>
gameover = LoadImage ("gameover.png") 'loads image for gameover screen
End

Method OnUpdate ()
'All the game logic goes here:
Select GameState
Case "GAMEOVER" 'gameover screen
Case "MENU"
If KeyHit (KEY_SPACE) Then GameState="PLAYING"
Case "PLAYING"
If KeyHit (KEY_ESCAPE) Then GameState="MENU" 
If KeyDown(KEY_LEFT) Then player.Move(-15)
If KeyDown(KEY_RIGHT) Then player.Move(15)
If KeyHit(KEY_SPACE) Then
missile_collection.AddLast(New Laser(player.x,player.y))
End
'Handle missile movement
For Local missile:=Eachin missile_collection
missile.Move(5)
If missile.y<10 Then missile_collection.Remove missile
Next
For Local missile:=Eachin missile_collection
For Local fish:=Eachin fish_collection
If intersects(missile.x,missile.y,10,21,fish.x,fish.y,100,50) Then
fish_collection.Remove fish
missile_collection.Remove missile
score = score + 1
fish_collection.AddLast(New flounder (fish.x , fish.y - 50))
End
For Local missile:=Eachin missile_collection
For Local enemy:=Eachin enemy_collection
If intersects(missile.x,missile.y,10,21,enemy.x,enemy.y,100,50) Then
missile_collection.Remove missile
score = score - 1
End
End
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
'Cls 000, 128, 255
DrawImage player.sprite, player.x, player.y
DrawText(score, 20, 40, 2, 2)
For Local fish:=Eachin fish_collection
DrawImage fish.sprite, fish.x, fish.y
For Local enemy:= Eachin enemy_collection
DrawImage enemy.sprite, enemy.x, enemy.y

Select currentdir
Case "left"
fish.x-=1
enemy.x-=1.0
Case "right"
fish.x+=1
enemy.x+=1.0
End Select
If fish.x<0 Then currentdir = "right" 
If fish.x>640-16 Then currentdir = "left" 
If enemy.x<0 Then currentdir = "right" 
If enemy.x>640-16 Then currentdir = "left"
If fish.y = 0 Then GameState = "GAMEOVER"
If score <0 Then GameState = "GAMEOVER"
Next
For Local missile:=Eachin missile_collection
DrawImage missile.sprite, missile.x, missile.y
Next
End
End 
End
End

Class Rocket
Field sprite:Image = LoadImage ("duck.png")
Field x:Float = 300
Field y:Float = 380
Method Move(x_distance:Int)
x+=x_distance
If x<0 Then x=0
If x>590 Then x=590
End
End

Class flounder
Field sprite:Image = LoadImage ("fish.png")
Field x:Float
Field y:Float
Method New(x_spawn:Int, y_spawn:Int)
x = x_spawn
y = y_spawn
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
End

Class Laser
Field sprite:Image = LoadImage ("bubble.png")
Field x:Float
Field y:Float

Method New(x_spawn:Int,y_spawn:Int)
x = x_spawn+54
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