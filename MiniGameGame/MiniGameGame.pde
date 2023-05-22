private GameModule currentModule;
private GameModule[] moduleCollection ={new Peggle(), new Tetris()};

public static int currentModuleNum;

boolean[] downKeys = new boolean[256];
boolean[] downCodedKeys = new boolean[256];

World[][] worldOne;
char[][] pgrid;
Player player = new Player();

int squaresize = 50;

boolean q = false;

public void SwitchModule(int i)
{
  if (i >= moduleCollection.length) return;
  if (currentModule != null); //EXIT
  currentModule = moduleCollection[i];
  currentModule.Enter();
  currentModuleNum = i;
}
public void NextModule()
{
  SwitchModule(currentModuleNum + 1);
}

void setup()
{
  size(640, 480);
  
  surface.setResizable(true);
  for (int i = 0; i < moduleCollection.length; i++)
  {
    moduleCollection[i].Setup();
  }
  SwitchModule(0);
}


boolean mouseIsPressed = false;
void draw()
{
  if (currentModule == null) return;
  currentModule.Draw();

  if (currentModule.isDone)
  {
    if(!q) {

    NextModule();
    q = true;
    }
    else {
      println("Victory!!!");
    }
  }


  if (mousePressed == true)
    currentModule.MouseInput(mouseX, mouseY, MouseInputFlags.pressedDown);

  else if (mousePressed == false && mouseIsPressed == true)
    currentModule.MouseInput(mouseX, mouseY, MouseInputFlags.released);

  else
    currentModule.MouseInput(mouseX, mouseY, MouseInputFlags.none);

  mouseIsPressed = mousePressed;
}
void keyPressed() {
  if (key == CODED) {
    //print("Code: " + keyCode + ". ");
    if (keyCode<256) {

      downCodedKeys[keyCode] = true;
    }
  } else {
    //print("Key: " + (int)key + ". ");
    if (key<256) {
      downKeys[key] = true;
    }
  }
}
void keyReleased() {
  if (key == CODED) {
    //print("LiftCode: " + keyCode + ". ");
    if (keyCode<256) {
      downCodedKeys[keyCode] = false;
    }
  } else {
    //print("LiftKey: " + (int)key + ". ");
    if (key<256) {
      downKeys[key] = false;
    }
  }
}
