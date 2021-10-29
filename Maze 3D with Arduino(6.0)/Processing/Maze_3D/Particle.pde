class Particle {
  float x;
  float y;
  int r;
  int g;
  int b;
  float vx;
  float vy;
  float speed;
  float m_s = 3;
  String txt = "도착!!";

  Particle(String str) {
    gen(str);
  }

  void display() {
    noStroke();
    fill(r,g,b);
    textSize(15);
    text(txt,x,y);
  }

  void move() {
    x += speed;
    if(x > width){
      gen(txt);
    }
  }
  
  void gen(String str) {
    txt = str;
    x = 0;
    y = random(15, height - 15);
    speed = random(1,m_s);
    r = int(random(0, 255));
    g = int(random(0, 255));
    b = int(random(0, 255));
  }
}
