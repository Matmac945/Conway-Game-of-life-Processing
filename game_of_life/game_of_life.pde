import controlP5.*;

ControlP5 cp5_1, cp5_2, cp5_3;

int rows = 100;
int columns = 100;
boolean on_off = true;
boolean recording = false;
int size_x, size_y;
int[][] grid = new int[columns][rows];
void setup() {
  size(800, 825);
  background(60, 60, 60);

  size_x = width/columns;
  size_y = (height-25)/rows;

  cp5_1 = new ControlP5(this);
  cp5_2 = new ControlP5(this);
  cp5_3 = new ControlP5(this);
  cp5_1.addButton("animate").setValue(0).setPosition(0, 0).setSize(50, 25);
  cp5_2.addButton("randomize").setValue(0).setPosition(60, 0).setSize(50, 25);
  cp5_3.addButton("Empty").setValue(0).setPosition(120, 0).setSize(50, 25);
}

void draw() {
  background(60);

  for (int i = 0; i < rows; i++ ) {
    for (int j = 0; j < columns; j++) {
      if (grid[i][j] == 1) fill(200, 200, 200);
      else                 fill(0, 0, 0, 0);
      stroke(127);
      rect(size_x*i, (size_y*j)+25, size_x, size_y );
    }
  }
  if (on_off) { 
    generate();
    textSize(12);
    textAlign(CENTER, CENTER);
    fill(200);
    text("Evolving", width - 40, 10);
  } else {
    textSize(12);
    textAlign(CENTER, CENTER);
    fill(200);
    text("Static", width - 40, 10);
  }
  if (recording) {
    saveFrame("output/gol_####.png");
    fill(255,0,0);
    ellipse(width/2, height/2, 50, 50);
  }
}

void generate() {
  int[][] next = new int[columns][rows];

  for (int x = 0; x < columns; x++) {
    for (int y = 0; y < rows; y++) {

      int neighbors = 0;
      for (int i = -1; i <= 1; i++) {
        for (int j = - 1; j <= 1; j++) {
          neighbors += grid[wrapAround(x+i, columns)][wrapAround(y+j, rows)];
        }
      }

      neighbors -= grid[x][y];

      if ((grid[x][y] == 1) && (neighbors < 2))       next[x][y] = 0;
      else if ((grid[x][y] == 1) && (neighbors > 3))  next[x][y] = 0;
      else if ((grid[x][y] == 0) && (neighbors == 3)) next[x][y] = 1;
      else                                            next[x][y] = grid[x][y];
    }
  }
  grid = next;
}

int wrapAround(int index, int max_size) {
  int value = 0;
  if (index < 0) {        
    value = index + max_size;
  } else if (index >= max_size) { 
    value = index % max_size;
  } else {
    value = index;
  }
  return value;
}

void mousePressed() {
  if (mouseY > 25) {
    int mouse_x = int(mouseX/size_x);
    int mouse_y = int((mouseY-25)/size_y);
    println(mouse_x, mouse_y);
    if (grid[mouse_x][mouse_y] == 0) {
      grid[mouse_x][mouse_y] = 1;
    } else if (grid[mouse_x][mouse_y] == 1) {
      grid[mouse_x][mouse_y] = 0;
    }
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    recording = !recording;
  }
}

public void animate() {
  println("on off");
  if (on_off)  on_off = false; 
  else        on_off = true;
}

public void randomize() { 
  for (int i = 0; i < columns; i++ ) {
    for (int j = 0; j < rows; j++) {
      int life = int(random(0, 10));
      if (life > 6) grid[i][j] = 1;
      else         grid[i][j] = 0;
    }
  }
}

public void Empty() { 
  for (int i = 0; i < columns; i++ ) {
    for (int j = 0; j < rows; j++) {
      grid[i][j] = 0;
    }
  }
}
