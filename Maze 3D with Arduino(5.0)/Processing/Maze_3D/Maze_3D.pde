//Maze 3D 5.0 by J.Y.CHO
import processing.opengl.*;
import processing.serial.*;
PImage img;
int z = -30;
int r = 30;
int[][] mz;
color[][] mz2;
boolean[][] mz3;
boolean[][] mz4;
PVector[] portal = new PVector[0];
int ex;
int ey;
int px;
int py;
int num;
int hei = 100;
int s = 500;
float cmx;
float cmy;
int half_wid;
int half_hei;
int mod = 1;
int mov = 0;
int sh = 0;
int sx;
int sy;
float mY = height * 2;
color nc = color(255, 0, 0);
color ec = color(0, 0, 255);
color cc = color(0, 255, 0);
color nt = color(0, 0, 255);
color et = color(255, 0, 0);
color ct = color(255, 0, 255);
String[] lst; 
Particle[] particles;
button[] btn;
PFont font;
Serial ser;
boolean mc;
float d = 0;
float d2 = 0;
float md = 0.2;
int sy2;
boolean use_keyboard = true;
boolean use_mouse = true;
String p_port;
String port;
int sel;
int iwid;
int ihei;
boolean sp = false;
boolean ep = false;
boolean hm = false;
String txt;
int mm = 200;
boolean success = false;
color col = color(0, 255, 0);
float deg;

void setup() {
  mov = 0;
  //stroke(255);
  noStroke();
  textureMode(NORMAL);
  img = loadImage("maze.png");
  mod = 0;
  font = createFont("Gulim", 72);
  iwid = img.width;
  ihei = img.height;
  println("image width: " + iwid);
  println("image height: " + ihei);
  mz = new int[iwid][ihei];
  mz2 = new color[iwid][ihei];
  mz3 = new boolean[iwid][ihei];
  mz4 = new boolean[iwid][ihei];
  for (int x=1; x<iwid+1; x++) {
    for (int y=1; y<ihei+1; y++) {
      mz3[x - 1][y - 1] = !hm;
      color c = img.get(x - 1, y - 1);
      float cr;
      float cg;
      float cb;
      int cr2;
      int cg2;
      int cb2;
      cr = red(c);
      cg = green(c);
      cb = blue(c);
      cr2 = int(cr);
      cg2 = int(cg);
      cb2 = int(cb);
      String name = "";
      if (cr2 == 0 && cg2 == 0 && cb2 == 0) {
        num = 1; //1: Wall
        name = "wall";
      } else if (cr2 == 255 && cg2 == 0 && cb2 == 0) {
        if (ep) {
          num = 0;
        } else {
          ex = x; //2: End
          ey = y;
          num = 2;
          ep = true;
          name = "end point";
        }
      } else if (cr2 == 0 && cg2 == 255 && cb2 == 0) {
        if (sp) {
          num = 0;
        } else {
          px = x; //3: Start
          py = y;
          sx = x;
          sy = y;
          num = 3;
          sp = true;
          name = "start point";
        }
      } else if (cr2 == 255 && cg2 == 255 && cb2 == 0) {
        num = 4; //4: Portal
        name = "portal";
        PVector[] nportal;
        nportal = new PVector[portal.length + 1];
        for (int i=0; i<portal.length; i++){
          nportal[i] = portal[i];
        }
        nportal[portal.length] = new PVector(x, y);
        portal = new PVector[portal.length + 1];
        portal = nportal;
      } else {
        num = 0; //0: Air
        name = "air";
      }
      //println("set " + x + "x" + y + " = " + num + "(" + name + ", r: " + cr + ", g: " + cg + ", b: " + cb + ")");
      int x2 = x - 1;
      int y2 = y - 1;
      mz[x2][y2] = num;
      mz2[x2][y2] = c;
    }
  }
  if(!sp){
    println("\nWarning: No start point");
  }
  if(!ep){
    println("\nWarning: No end point");
  }
  /*
  for (int i=0; i<portal.length; i++){
    println("X: " + portal[i].x + "; y: " + portal[i].y);
  }
  */
  println("\nFinding devices...");
  lst = Serial.list();
  println(lst.length + " device(s) found.");
  btn = new button [lst.length + 6];
  size(1870, 1030, OPENGL);
  textFont(font);
  textAlign(CENTER, CENTER);
  textSize(50);
  fill(0, 255, 0);
  text("시선", width / 2, 50);
  btn[0] = new button(0, 100, 260, 34, cc, ec, cc, ct, et, ct, "마우스로 시선 이동");
  btn[1] = new button(270, 100, 260, 34, nc, ec, cc, nt, et, ct, "컨트롤러로 시선 이동");
  text("움직임", width / 2, 150);
  btn[2] = new button(0, 200, 260, 34, cc, ec, cc, ct, et, ct, "키보드로 이동");
  btn[3] = new button(270, 200, 260, 34, nc, ec, cc, nt, et, ct, "컨트롤러로 이동");
  if(lst.length == 0){
    btn[1].enabled = false;
    btn[3].enabled = false;
    sy2 = 200;
  }else{
    text("연결하실 포트를 선택해 주세요.", width / 2, 250);
    for (int i=0; i<lst.length; i++) {
      println(" - " + lst[i]);
      int n1 = i + 1;
      int n2 = i % 7;
      /*********************/
      int n3 = n1 - n2;
      int n4 = n3 / 7;
      int n5 = n4 + 1;
      int bx1 = n2 * 82;
      int bx2 = n2 * 10;
      int by1 = n5 * 34;
      int by2 = n5 * 10;
      sy2 = by1 + by2 + 300;
      btn[i + 4] = new button(bx1 + bx2, sy2, 82, 34, nc, ec, cc, nt, et, ct, lst[i]);
    }
    port = lst[0];
    btn[4].nc = cc;
    btn[4].ec = ec;
    btn[4].cc = cc;
    btn[4].nt = ct;
    btn[4].et = et;
    btn[4].ct = ct;
  }
  btn[lst.length + 4] = new button(0, sy2 + 44, 260, 34, nc, ec, cc, nt, et, ct, "게임 시작");
}

void draw() {
  width = 1870;
  height = 1030;
  half_wid = width / 2;
  half_hei = height / 2;
  if (!ep || !sp){
    textFont(font);
    textSize(50);
    background(0, 0, 0);
    textSize(25);
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    if (!sp){
      text("시작 지점이 없습니다.", width / 2, 25);
    }
    if (!ep){
      text("도착 지점이 없습니다.", width / 2, 75);
    }
  }else if(width != 1870 || height != 1030){
    textFont(font);
    textSize(50);
    background(0, 0, 0);
    textSize(25);
    fill(0, 255, 0);
    textAlign(CENTER, CENTER);
    text("이 창의 크기는 가로 1870 픽셀, 세로 1030 픽셀이여야 합니다.", width / 2, height / 2);
  }else{
    if (mod == 0) {
      textFont(font);
      textSize(50);
      background(0, 0, 0);
      textSize(25);
      fill(0, 255, 0);
      textAlign(CENTER, CENTER);
      text("시선", width / 2, 50);
      text("움직임", width / 2, 150);
      text("연결하실 포트를 선택해 주세요.", width / 2, 250);
      for (int i=0; i<lst.length + 5; i++) {
        //println(i);
        if(use_mouse && use_keyboard){
          if(!(i > 3 && i < lst.length + 4)){
            btn[i].render();
          }
        }else{
          btn[i].render();
        }
        //println(str(i) + btn[i].isClicked());
        btn[i].ref();
        if (btn[i].isClicked()) {
          if (i < lst.length + 4 && 3 < i) {
            port = lst[lst.length - 1];
            for (int j=0; j<lst.length; j++) {
              int n1 = j + 1;
              int n2 = j % 7;
              /*********************/
              int n3 = n1 - n2;
              int n4 = n3 / 7;
              int n5 = n4 + 1;
              int bx1 = n2 * 82;
              int bx2 = n2 * 10;
              int by1 = n5 * 34;
              int by2 = n5 * 10;
              sy2 = by1 + by2 + 300;
              btn[j + 4].nc = nc;
              btn[j + 4].ec = ec;
              btn[j + 4].cc = cc;
              btn[j + 4].nt = nt;
              btn[j + 4].et = et;
              btn[j + 4].ct = ct;
              btn[j + 4] = new button(bx1 + bx2, sy2, 82, 34, nc, ec, cc, nt, et, ct, lst[j]);
            }
            btn[i].nc = cc;
            btn[i].ec = ec;
            btn[i].cc = cc;
            btn[i].nt = ct;
            btn[i].et = et;
            btn[i].ct = ct;
          } else {
            if (i == 0) {
              btn[0] = new button(0, 100, 260, 34, cc, ec, cc, ct, et, ct, "마우스로 시선 이동");
              btn[1] = new button(270, 100, 260, 34, nc, ec, cc, nt, et, ct, "컨트롤러로 시선 이동");
              use_mouse = true;
            } else if(i == 1) {
              btn[0] = new button(0, 100, 260, 34, nc, ec, cc, nt, et, ct, "마우스로 시선 이동");
              btn[1] = new button(270, 100, 260, 34, cc, ec, cc, ct, et, ct, "컨트롤러로 시선 이동");
              use_mouse = false;
            }else if (i == 2) {
              btn[2] = new button(0, 200, 260, 34, cc, ec, cc, ct, et, ct, "키보드로 이동");
              btn[3] = new button(270, 200, 260, 34, nc, ec, cc, nt, et, ct, "컨트롤러로 이동");
              use_keyboard = true;
            } else if(i == 3) {
              btn[2] = new button(0, 200, 260, 34, nc, ec, cc, nt, et, ct, "키보드로 이동");
              btn[3] = new button(270, 200, 260, 34, cc, ec, cc, ct, et, ct, "컨트롤러로 이동");
              use_keyboard = false;
            } else if(i == lst.length + 4){
              if(lst.length != 0 && !(use_mouse && use_keyboard) && p_port != port){
                println("Connecting to " + port + "...");
                ser = new Serial(this, port, 9600);
                p_port = port;
                println("Success.");
              }
              mod = 1;
            }
          }
        }
      }
    } else if (mod == 1) {
      background(0);
      lights();
      pushMatrix();
      translate(half_wid, half_hei, s * 2);
      cmx = mouseX - half_wid;
      if (use_mouse) {
        deg = map(mouseX, 0, width, -180, 180);
      } else {
        deg = d;
      }
      rotateY(radians(deg));
      for (int x=0; x<3; x++){
       for (int y=0; y<3; y++){
          int px2 = px + (x - 2);
          int py2 = py + (y - 2);
          boolean flag = px2 < iwid && px2 >= 0 && py2 < ihei && py2 >= 0;
          if (flag) {
            mz3[px2][py2] = true;
          }
        } 
      }
      for(int x=0; x<iwid; x++){
        for(int y=0; y<iwid; y++){
          mz4[x][y] = false;
        }
      }
      for (int l=0; l<11; l++){
          int px2 = int(px + (dtx(deg) * l) - 1);
          int py2 = int(py + (dty(deg) * l) - 1);
          boolean flag = px2 < iwid && px2 >= 0 && py2 < ihei && py2 >= 0;
          if (flag) {
            mz4[px2][py2] = true;
          }
      }
      for (int x=1; x<iwid+1; x++) {
        for (int y=1; y<ihei+1; y++) {
          int x2 = x - 1;
          int y2 = y - 1;
          int n = mz[x2][y2];
          if (n != 0) {
            if (n == 1) {
              fill(255, 255, 255); //Wall
            } else if (n == 2) {
              fill(0, 255, 0, 25); //End
            } else if (n == 3) {
              fill(255, 0, 0, 25); //Start
            } else if (n == 4) {
              fill(255, 255, 0, 25); //Portal
            }
            pushMatrix();
            translate((x - px) * s, 0, (y - py) * s);
            box(s, hei, s);
            popMatrix();
          } else {
            fill(mz2[x2][y2]);
            pushMatrix();
            translate((x - px) * s, hei / 2, (y - py) * s);
            box(s, 0.0001, s);
            popMatrix();
          }
          if (px == x && py == y) {
            pushMatrix();
            translate((x - px) * s, 0, (y - py) * s);
            fill(0, 255, 255);
            sphere(hei);
            popMatrix();
          }
        }
      }
      if (px == ex && py == ey) {
        mod = 2;
      }
      popMatrix();
      pushMatrix();
      for (int x=0; x<iwid; x++) {
        for (int y=0; y<ihei; y++) {
          int t = 205;
          if (!mz4[x][y]) {
            t = 50;
          }
          if (mz3[x][y]) {
            fill(mz2[x][y], t);
          } else {
            fill(0, 255, 0, t);
          }
          pushMatrix();
          rect(x * 3, y * 3, 3, 3);
          popMatrix();
        }
      }
      popMatrix();
      int cpx = px - 1;
      int cpy = py - 1;
      fill(0, 255, 255);
      rect(cpx * 3, cpy * 3, 3, 3);
      surface.setTitle(px + "x" + py + "; " + deg + "deg");
    } else if (mod == 2) {
      rotateY(0);
      background(0);
      success = mov <= mm;
      if (success) {
        txt = "Success!!!";
        col = color(0, 255, 0);
      } else {
        txt = "Fail!!!";
        col = color(255, 0, 0);
      }
      fill(col);
      surface.setTitle(txt);
      textFont(font);
      textAlign(CENTER);
      textSize(100);
      text(txt, width / 2, height / 2);
      textSize(50);
      text("moved:", width / 2 - 300, height / 2 + 50);
      textSize(200);
      text(mov, width / 2, height / 2 + 200);
      particles = new Particle [100];
      for (int i = 0; i < particles.length; i++) {
        particles[i] = new Particle(txt);
      }
      mod = 3;
    } else if (mod == 3) {
      background(0);
      for (int i = 0; i < particles.length; i++) {
        particles[i].display();
        particles[i].move();
      }
      fill(col);
      textAlign(CENTER);
      textSize(100);
      text(txt, width / 2, height / 2);
      textSize(50);
      text("moved:", width / 2 - 300, height / 2 + 50);
      textSize(200);
      text(mov, width / 2, height / 2 + 200);
    }
  }
}

void serialEvent(Serial p) {
  if (mod == 1) {
    String st = p.readStringUntil('\n');
    if (st != null) {
      String st2 = st.trim();
      println("Received: \"" + st2 + "\"");
      char ch = st2.charAt(0);
      if(!use_keyboard){
        if (ch == 'w') {
          println("'W' Detected!!!");
          move(0, true);
        } else if (ch == 's') {
          println("'S' Detected!!!");
          move(180, true);
        } else if (ch == 'a') {
          println("'A' Detected!!!");
          move(270, true);
        } else if (ch == 'd') {
          println("'D' Detected!!!");
          move(90, true);
        }
      }
      if (!use_mouse) { 
        if (ch == 'r') {
          px = sx;
          py = sy;
        } else if (ch == 'f') {
          d -= md;
        } else if (ch == 'h') {
          d += md;
        }
      }
    }
  }
}

void s_wd() {
  ser.write("wd");
  println("wd");
}

void keyPressed() {
  if(mod == 1 && use_keyboard){
    if (key == ENTER) {
      px = sx;
      py = sy;
    } else if (key == 'w' || key == 'W') {
      move(0, false);
    } else if (key == 's' || key == 'S') {
      move(180, false);
    } else if (key == 'a' || key == 'A') {
      move(270, false);
    } else if (key == 'd' || key == 'D') {
      move(90, false);
    }
  }
  if(key == 'o' || key == 'O'){
    mod = 0;
  }
}

void tp() {
  if (mz[px - 1][py - 1] == 4) {
    println("portal detected");
    println("px: " + px + "; py: " + py);
    if (portal.length > 1){
      PVector pp = new PVector(px, py);
      PVector np = new PVector(px, py);
      while (np.x == pp.x && np.y == pp.y){
        np = portal[round(random(0, portal.length))];
      }
      px = round(np.x);
      py = round(np.y);
      println("px: " + np.x + "; py: " + np.y);
    }
  }
}

float dtx(float in){
  return cos(radians(in - 90));
}

float dty(float in){
  return sin(radians(in - 90));
}

void move(float md, boolean use_wd){
  int mx = px + round(dtx(deg + md));
  int my = py + round(dty(deg + md));
  //println("X: " + str(px) + ", Y: " + str(py) + ", MX: " + str(mx) + ", MY: " + str(my) + ", deg: " + str(deg) + ", md: " + str(md));
  if(isIndexOutOfRange(md)){
    if(mz[mx - 1][my - 1] != 1){
      px = mx;
      py = my;
      mov += 1;
      tp();
    }else{
      if(use_wd){
        s_wd();
      }
    }
  }
}

boolean isIndexOutOfRange(float md){
  int mx = px + round(dtx(deg + md));
  int my = py + round(dty(deg + md));
  boolean out = mx >= 1 && mx <= iwid && my >= 1 && my <= ihei;
  return out;
}
