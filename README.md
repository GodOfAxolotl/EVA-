# EVA-

An evolutionary Algorithm for wayfinding

This program is owned and maintained by GodOfAxolotl, feel free to use it for your own projects.


How to start the Program?

The program is written in Procesing/Java. Either you start it with the IDE or start the included .exe file. 
You will find that the program is in german, so here is a little explaination in english:

In the upper left corner you can choose on of 5 parkours or a sandbox. In every parkour you can change the position of the 
obstacles. Look at the controlls for an explaination.

On the left side under the parkours you can toggle diffrent algorithms to help the fitness function find the best fitness. 
LineWork checks if the subject (dot) has free sight to the goal and gives it more fitness this way. It colors 'blind' dots,
which can't see the goal in red and seeing dots in black. LiteWork does the same but without the coloring which saves ressources. 
Blur is a blur behind the dots. 

The green dot is the Heron Dot and an exact copy of the best dot of the previous generation 

Controls:

1,2,3,4,5,6,7,8,9,0 - Choose one of 10 possible obsacles which will be movable

G                 - grab your choosen obstacle, it will be stuck on your mouse

D                 - drop your choosen obstacle

R                 - rotate your choosen obstacle

Space             - Pause and resume

M                 - back to menu

E                 - Higher mutation chances, can accelerate or slow down the pathfining, gives funny results I think it's funny

I                 - Only show the dots with the highest fitness

