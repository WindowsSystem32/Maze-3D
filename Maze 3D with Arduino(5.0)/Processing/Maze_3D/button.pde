class button{
  Boolean mouse_enter = false;
  Boolean click = false;
  Boolean enabled = true;
  int px;
  int py;
  int wid;
  int hei;
  color nc;
  color ec;
  color cc;
  color nt;
  color et;
  color ct;
  String text;
  button(int btnx, int btny, int btnwid, int btnhei, color normal, color mouseenter, color mouseclick, color normaltxt, color mouseentertxt, color mouseclicktxt, String txt){
    px = btnx;
    py = btny;
    wid = btnwid;
    hei = btnhei;
    nc = normal;
    ec = mouseenter;
    cc = mouseclick;
    nt = normaltxt;
    et = mouseentertxt;
    ct = mouseclicktxt;
    text = txt;
  }
  boolean isClicked(){
    ref();
    return click;
  }
  boolean mouseenter(){
    ref();
    return  mouse_enter;
  }
  void render(){
    int px2 = px + wid;
    int py2 = py + hei;
    boolean flag1;
    flag1 = mouseX <= px2 && mouseX >= px && mouseY <= py2 && mouseY >= py;
    mouse_enter = flag1;
    boolean flag2;
    flag2 = click == false && flag1 && mousePressed && mouseButton == LEFT;
    click = flag2;
    if(click){
      fill(cc);
    }else if(mouse_enter){
      fill(ec);
    }else{
      fill(nc);
    }
    rect(px, py, wid, hei);
    if(click){
      fill(ct);
    }else if(mouse_enter){
      fill(et);
    }else{
      fill(nt);
    }
    textAlign(CENTER, CENTER);
    int wid2 = wid / 2;
    int hei2 = hei / 2;
    int px3 = px + wid2;
    int py3 = py + hei2;
    textSize(24);
    text(text, px3, py3);
  }
  
  void ref(){
    int px2 = px + wid;
    int py2 = py + hei;
    boolean flag1;
    flag1 = mouseX <= px2 && mouseX >= px && mouseY <= py2 && mouseY >= py && enabled;
    mouse_enter = flag1;
    boolean flag2;
    flag2 = click == false && flag1 && mousePressed && mouseButton == LEFT && enabled;
    click = flag2;
  }
  
  void change_setting(int btnx, int btny, int btnwid, int btnhei, color normal, color mouseenter, color mouseclick, color normaltxt, color mouseentertxt, color mouseclicktxt, String txt){
    px = btnx;
    py = btny;
    wid = btnwid;
    hei = btnhei;
    nc = normal;
    ec = mouseenter;
    cc = mouseclick;
    nt = normaltxt;
    et = mouseentertxt;
    ct = mouseclicktxt;
    text = txt;
  }
}
