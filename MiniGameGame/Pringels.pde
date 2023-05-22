public enum MouseInputFlags
{
  pressedDown, released, hold, none
}
public abstract class GameModule
{
  public boolean isDone = false;
  public void MouseInput(float x, float y, MouseInputFlags clickFlag)
  {
    //This is empty for inheritance reasons
  }
  public void Setup()
  {
    //This is empty for inheritance reasons
  }
  public abstract void Draw();
  public abstract void Enter();
  public abstract void Exit();
}

public class Peggle extends GameModule
{
  Ball ball = new Ball();

  Target[] targets = {new Target(100, 100), new Target(150, 100), new Target(200, 100), new Target(250, 100), new Target(300, 100),
    new Target(350, 100), new Target(400, 100), new Target(450, 100), new Target(500, 100),
    new Target(100, 150), new Target(500, 150), new Target(100, 200), new Target(500, 200), };

  float aimX;
  float aimY;

  boolean canFireAgain = true;
  float shooterX;
  float shooterY;

  float barrelA;
  float barrelX;
  float barrelY;

  PImage background;

  public void MouseInput(float x, float y, MouseInputFlags clickFlag)
  {
    aimX = x;
    aimY = y;
    barrelA = atan2(shooterY - aimY, shooterX - aimX);


    switch(clickFlag)
    {
    case pressedDown:
      if (canFireAgain)
      {
        canFireAgain = false;
        float dst = sqrt((shooterX - aimX) * (shooterX - aimX) + (shooterY - aimY) * (shooterY - aimY));
        float fireDirX = (shooterX - aimX) / dst;
        float fireDirY = (shooterY - aimY) / dst;

        ball.dirX = -fireDirX;
        ball.dirY = -fireDirY;
        ball.x = shooterX;
        ball.y = shooterY;
      } else
      {
        if (ball.isOffScreen) canFireAgain = true;
      }
      break;
    }
  }

  public void Draw()
  {
    image(background, 0, 0, width, height);

    translate(shooterX, shooterY);
    rotate(barrelA);
    rect(-10, -5, 10, 10);
    resetMatrix();

    circle(shooterX, shooterY, 10);
    if (!canFireAgain)circle(ball.x, ball.y, 10);

    ball.UpdatePos();
    ball.TargetCheck(targets);

    for (int i = 0; i < targets.length; i++)
    {
      if (targets[i] != null && !targets[i].isHit) targets[i].Draw();
    }


    isDone = ball.hits >= targets.length;
  }

  public void Enter()
  {
    shooterX = width/2;
    shooterY = height - 50;

    ball.x = shooterX;
    ball.y = shooterY;

    background = loadImage("wall.png");



    for (int i = 0; i < targets.length; i++)
    {
      targets[i].Enter();
    }
  }
  public void Exit()
  {
  }

  public void Setup()
  {

    ArrayList<Target> t = new ArrayList<Target>();
    for (int yt = 0; yt < 3; yt++)
    {
      for (int xt = 0; xt < 11; xt++)
      {
        t.add(new Target(width/2 - 250 + (50 * xt), height/2 - 150 + (50 * yt)));
      }
    }

    Target[] newT = new Target[t.size()];
    for (int i = 0; i < newT.length; i++)
    {
      newT[i] = t.get(i);
    }
    targets = newT;
  }

  class Ball
  {
    public boolean isOffScreen = true;
    public int hits = 0;

    float dirX;
    float dirY;

    float radius;
    float speed = 10;

    float x;
    float y;
    public void Fire(float _dirX, float _dirY)
    {
      dirX = _dirX;
      dirY = _dirY;
    }

    public void UpdatePos()
    {
      x += dirX * speed;
      y += dirY * speed;

      if (x <= 0 || x >= width) dirX = -dirX;
      if (y <= 0) dirY = -dirY;
      isOffScreen = y >= height;
    }

    public void TargetCheck(Target[] targets)
    {
      for (int i = 0; i < targets.length; i++)
      {
        float tx = targets[i].x;
        float ty = targets[i].y;
        float sx = targets[i].sizeX;
        float sy = targets[i].sizeY;

        if (abs(tx - x) < sx && abs(ty - y) < sy && !targets[i].isHit)
        {
          if (abs(tx - x) > abs(ty - y)) dirX = -dirX;
          else dirY = -dirY;
          targets[i].isHit = true;
          hits++;
        }
      }
    }
  }

  public class Target
  {
    float sizeX = 25;
    float sizeY = 25;

    float addSize = 25;

    float x;
    float y;

    boolean isHit = false;

    PImage texture;

    public Target(float _x, float _y)
    {
      x = _x;
      y = _y;
    }

    public void Enter()
    {
      texture = loadImage("gemstone.png");
    }

    public void Draw()
    {
      //rect(x - sizeX, y - sizeY, sizeX * 2, sizeY * 2);
      image(texture, x - sizeX, y - sizeY, sizeX + addSize, sizeY + addSize);
    }
  }
}
