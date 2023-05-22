
class World {
  byte health;
  boolean passable;
  color worldColor;

  World(boolean border) {
    health = 10;
    if (border) {
      passable = false;
    worldColor = color(125,125,125);
    }
    else {
      passable = true;
      worldColor = color(0,0,0);
    }
  }


  void draw(int tempXdir, int tempYdir, int tempSquaresize) {
    fill(worldColor, 255*(10-(health%10)));
    square(tempXdir*tempSquaresize, tempYdir*tempSquaresize, tempSquaresize);
  }
}

class WorldObject {
  byte squaresize;
  //boolean running = true;
  PVector place = new PVector(1, 3);
  PVector direction = new PVector(1, 0);  //float xdir, ydir;
  boolean passable, destructible;
  color worldObjectColor;

  WorldObject() {
    squaresize = 50;
    passable = boolean(round(random(0, 1)));
    worldObjectColor = color(125,125,125);
    destructible = false;
  }
  void draw() {
    fill(worldObjectColor);
    square(place.x*squaresize, place.y*squaresize, squaresize);
  }
}

class TetrisTemplate {


   PVector[][] temps = new PVector[4][4];

    
    int timeX = 0;

    int timeY = 0;

    int[][] tempsX = new int[4][4];

    int[][] tempsY = new int[4][4];



    TetrisTemplate() {

    }
    private int[] setterXY( int a, int b,int c, int d) {
        int[] lol = {a,b,c,d};
        return lol;
    }
    TetrisTemplate setX(int a,int b,int c,int d) {
        this.tempsX[this.timeX] = this.setterXY(a,b,c,d);
        this.timeX += 1;
        return this;

    }

    TetrisTemplate setY(int a,int b,int c,int d) {
        this.tempsY[this.timeY] = this.setterXY(a,b,c,d);
        this.timeY += 1;
        return this;
    }

    private PVector[] createTemp(int[] x, int[] y) {
        PVector[] template = new PVector[4];

        for (int i = 0; i< x.length; i++) {
            PVector point = new PVector(x[i],y[i]);
            template[i] = point;
        }        
        return template;

    }
    PVector[][] build() {
        for(int i = 0; i< this.tempsX.length;i++){
        this.temps[i] = this.createTemp(this.tempsX[i],this.tempsY[i]);
        }
        return this.temps;
    }
}

class TetrisBlock extends FallingWO {

   Piece[] pieces = new Piece[4];


    PVector[][] temps = new PVector[4][4];


    int chosen = 1;

    TetrisBlock(PieceTmp temps2) {
        super();
        this.passable = false;
        this.temps = temps2.Temp;

        for (int i = 0; i< this.temps[chosen].length; i++) {
            Piece obj = new Piece(0);
            PVector point = this.temps[chosen][i].copy();
            point.add(this.place.copy());
            obj.place = point;
            obj.worldObjectColor = temps2.Col;

            this.pieces[i] = obj;

        }
    }


    boolean checkAll(Piece[] pieces2) {
        boolean returner = true;
        
        for(int i = 0; i< pieces2.length;i++) {
        
        if (pieces2[i].checkDown()) {
            returner = false;
        }
        }
        return returner;
    }
    void sync(Piece[] pieces2,PVector[][] temps2,int choice) {



        for (int i = 0; i< pieces2.length; i++) {

            pieces2[i].place = this.place.copy().add(temps2[choice][i].copy());


            pgrid[int(pieces2[i].place.x)][int(pieces2[i].place.y)] = '1'; 
    }

    }

    void draw2(Piece[] pieces2) {
        for(WorldObject piece: pieces2) {
            piece.draw();
        }
    }

    void update() {
        if(this.checkAll(this.pieces)) {
            this.applyGrav();
        }
        this.sync(this.pieces,this.temps,this.chosen);
    }
    void sackoe() {

        this.sync(this.pieces,this.temps,this.chosen);
    }

    void draw() {
    this.draw2(this.pieces);
    }
}

class Player extends FallingWO {
  int health;
  
  Player() {
    super();
    worldObjectColor = color(255, 0, 0);
    this.health = 1;
  }
  void moveForward() {
    print(place + " : " + direction);
    if (int(place.y+direction.y)>0 && int(place.x+direction.x)>0) {
      place.add(direction);
      println(" .Now: " + place);
    }
  }
  
  private boolean checkDown() {
    
      if (pgrid[int(this.place.x)][int(this.place.y+1)] != '1') {
        return true;
      } 
      return false;
  }
  private boolean checkDown(PVector puppDir) {
    
      if (worldOne[int(this.place.x)][int(this.place.y+puppDir.y)].passable) {
        return true;
      } 
      return false;
  }
  private void appDirection(PVector direction2) {
    if (this.checkDown(direction2)) {
        this.place.add(direction2);
      }
  }
  void applyGrav() {
      this.direction = (new PVector(0,1));

      if (pgrid[int(this.place.x)][int(this.place.y + this.direction.y)] != '1') {
        this.place.add(this.direction);
      }
  }

  boolean isDead() {
    if (health>0) {
      return false;
    } else {
      return true;
    }
  }
  void action() {
    PVector sumDirection = new PVector(0, 0);  //
    if (downCodedKeys[38]) {
      if (!this.checkDown()) {
      sumDirection.add(new PVector(0, -4));
      }
    }
    if (downCodedKeys[37]) {
      sumDirection.add(new PVector(-1, 0));
    }
    if (downCodedKeys[39]) {
      sumDirection.add(new PVector(1, 0));
    }
    //Can't move out of map
    if (int(player.place.x+sumDirection.x)<0 || int(player.place.x+sumDirection.x)>worldOne.length-1) {
      sumDirection.x=0;
    }
    if (int(player.place.y+sumDirection.y)<0 || int(player.place.y+sumDirection.y)>worldOne[0].length-1) {
      sumDirection.y=0;
    }
    //
    if (sumDirection.mag()>0) {
      this.direction=sumDirection;
        if (this.checkDown(this.direction)){
          if (pgrid[int(this.place.x+direction.x)][int(this.place.y)] != '1' ){ 
              this.place.add(this.direction);
          }
          else  {
            this.place.y += this.direction.y;
          }
      }
    }
    //
    pgrid[int(this.place.x+direction.x)][int(this.place.y)] = '3';
  }
}

class PieceTmp {
    PVector[][] Temp;

    color Col;

    PieceTmp(PVector[][] tmp, color col) {
        this.Temp = tmp;

        this.Col = col;
    }
}

class PieceTemps {

PieceTmp LTemp =new PieceTmp( new TetrisTemplate()
        .setX(-1,-1,0,1)
        .setY(-1,0,0,0)
        .setX(0,1,0,0)
        .setY(-1,-1,0,1)
        .setX(-1,0,1,1)
        .setY(0,0,0,1)
        .setX(-1,0,0,0)
        .setY(1,1,0,-1)
        .build(),color(49, 115, 173));
PieceTmp ZTemp =new PieceTmp( new TetrisTemplate()
        .setX(-1,0,0,1)
        .setY(0,0,1,1)
        .setX(0,0,1,1)
        .setY(-1,0,0,1)
        .setX(-1,0,0,1)
        .setY(1,1,0,0)
        .setX(-1,-1,0,0)
        .setY(-1,0,0,1)
        .build(), color(55,173,49));

PieceTmp LLTemp = new PieceTmp( new TetrisTemplate()
        .setX(-1,0,1,1)
        .setY(0,0,0,-1)
        .setX(0,0,0,1)
        .setY(-1,0,1,1)
        .setX(-1,-1,0,1)
        .setY(0,1,0,0)
        .setX(-1,0,0,0)
        .setY(-1,-1,0,1)
        .build(),color(219,130,29));

PieceTmp TTemp = new PieceTmp( new TetrisTemplate()
        .setX(-1,0,0,1)
        .setY(0,0,-1,0)
        .setX(0,0,0,1)
        .setY(-1,0,1,0)
        .setX(-1,0,0,1)
        .setY(0,0,1,0)
        .setX(-1,0,0,0)
        .setY(0,-1,0,1)
        .build(),color(168,29,219));

PieceTmp ZZTemp = new PieceTmp( new TetrisTemplate()
        .setX(-1,0,0,1)
        .setY(-1,-1,0,0)
        .setX(0,0,1,1)
        .setY(0,1,0,-1)
        .setX(-1,0,0,1)
        .setY(0,0,1,1)
        .setX(-1,-1,0,0)
        .setY(0,1,0,1)
        .build(),color(237,57,57));

PieceTmp STemp= new PieceTmp( new TetrisTemplate()
        .setX(-1,-1,0,0)
        .setY(-1,0,-1,0)
        .setX(-1,-1,0,0)
        .setY(-1,0,-1,0)
        .setX(-1,-1,0,0)
        .setY(-1,0,-1,0)
        .setX(-1,-1,0,0)
        .setY(-1,0,-1,0)
        .build(),color(242,225,34));

PieceTmp ITemp= new PieceTmp( new TetrisTemplate()
        .setX(-2,-1,0,1)
        .setY(0,0,0,0)
        .setX(0,0,0,0)
        .setY(-2,-1,0,1)
        .setX(-2,-1,0,1)
        .setY(0,0,0,0)
        .setX(0,0,0,0)
        .setY(-2,-1,0,1)
        .build(),color(139,192,232));
 
PieceTmp[] TempTypes = new PieceTmp[7];

    PieceTemps() {

        this.TempTypes[0] = this.LLTemp;
        this.TempTypes[1] = this.ZTemp;
        this.TempTypes[2] = this.TTemp;
        this.TempTypes[3] = this.LTemp;
        this.TempTypes[4] = this.ZZTemp;
        this.TempTypes[5] = this.ITemp;
        this.TempTypes[6] = this.STemp;
         

    }
    PieceTmp getRand() {
        int rand = int(random(6));

        return this.TempTypes[rand];
    }
}

class Piece extends FallingWO {
    Piece(int x) {
        super();
        this.worldObjectColor = color(125,125,255);
        this.place.x = x;
        this.passable = false;
    }
    boolean checkDown() {
        if(pgrid[int(this.place.x)][int(this.place.y+1)] == '1') {
            return true;
        }

        else if(pgrid[int(this.place.x)][int(this.place.y+1)] == '3') {
            player.health -= 1;
            println("Dead");
            return false;
        }
        else {
            return false;
        }
    }


}

class FallingWO extends WorldObject {
    FallingWO() {
        super();
    }

    void applyGrav() {
        if (this.place.y  < 20 ) {
            this.place.y += 1;
        } 
    }

}
public class Tetris extends GameModule {
    


int time = 0;
int old_time = 0;
int add_time = 0;
boolean change = false;

int framerate = 10;


char[][] grid;

PieceTemps temps = new PieceTemps();


TetrisBlock[] blocks = {};

void addBlock() {
  TetrisBlock blockman = new TetrisBlock(temps.getRand());

  int chosen = int(random(3));
  int x_place = int(random(3,8));
  blockman.place.x = x_place;
blockman.chosen = chosen;
blocks = (TetrisBlock[]) append(blocks,blockman);
  
}

boolean end = false;

public void Setup(){}

public void Exit(){}

public void Enter() {
  surface.setSize(600, 1100);
  //size(1280, 960);
  //size(1440, 900);
  //size(1600, 900);
  //size(1680, 1050);
  //size(1920, 1080);
  //fullScreen();
  addBlock();
  

  background(0);
  fill(255);
  stroke(255);
  worldOne = new World[width/50][height/50];  //x , y
  grid = new char[width/50][height/50];
  
  pgrid = new char[width/50][height/50];
  println("Dungeon size is: " + worldOne.length + " in x direction &: " + worldOne[0].length + " in y direction");
  for (int xline = squaresize; xline<width; xline+=squaresize) {
    line(xline, 0, xline, height);
  }
  for (int yline = squaresize; yline<height; yline+=squaresize) {
    line(0, yline, width, yline);
  }
  for (int ydir = 0; ydir<worldOne[0].length; ydir++) {
    for (int xdir = 0; xdir<worldOne.length; xdir++) {
      if (ydir == 0 || ydir == worldOne[0].length-1 || xdir == 0 || xdir == worldOne.length-1){
      worldOne[xdir][ydir] = new World(true);
      grid[xdir][ydir] = '1';
    pgrid[xdir][ydir] = '1';
      
    }
    else {
      worldOne[xdir][ydir] = new World(false);
      if(ydir == 3) {

        World wordlTemp =  new World(false);

    wordlTemp.worldColor = color(113,240,157);

      worldOne[xdir][ydir] = wordlTemp;

      }
      grid[xdir][ydir] = '0';
    pgrid[xdir][ydir] = '0';
      
    }
    }
  }
  
  frameRate(framerate);
  println("Finished setup @: " + millis());
}

public void Draw() {

  if(!end) {

  time = millis();


  if(time-old_time > 500 ) {

    change = true;
    old_time = time;
  
  }
  else {
    change = false;

  }
  
  if (time-add_time > 3000) {
    addBlock();
    add_time = time;
  }

  for (int i = 0; i< grid.length; i++) {
    for (int b = 0; b < grid[i].length; b++) {
      pgrid[i][b] = grid[i][b];
    }
  }





  for(TetrisBlock blocksu: blocks) {


    if(change) {
      blocksu.update();
    }

    blocksu.sackoe();
  }
  
  
  player.applyGrav();

  player.action();
  // for (int i = 0; i< pgrid.length; i++) {
  //  for (int b = 0; b < pgrid[i].length; b++ ){
  //   print(pgrid[i][b]);
  //  } 
  //  println("");
  // }

  if (player.place.y < 3) {
    end = true;
  }
  if (player.isDead()) {
    background(255, 0, 0);
  } else {
    for (int xdir = 0; xdir<worldOne.length; xdir++) {
      for (int ydir = 0; ydir<worldOne[0].length; ydir++) {
        worldOne[xdir][ydir].draw(xdir, ydir, squaresize);
      }
    }
    
  for(TetrisBlock blocksu: blocks) {
    blocksu.draw();
  }
    player.draw();
  }
  }
  else {
    text("Epic Win", width/2, height/2);
    this.isDone = true;
  }
}


}