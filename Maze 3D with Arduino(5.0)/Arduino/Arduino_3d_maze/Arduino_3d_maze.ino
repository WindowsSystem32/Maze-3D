//Arduino 3D Maze 4.0 by J.Y.CHO
/*************핀 설정*************/
/* 조이스틱 */
int vrx = A0; //조이스틱의 'vrx'가 연결된 핀
int vrxMn = 0;//조이스틱의 'vrx'의 최솟값
int vrxMx =1024;//조이스틱의 'vrx'의 최댓값
int vry = A1; //조이스틱의 'vry'가 연결된 핀
int vryMn = 0;//조이스틱의 'vry'의 최솟값
int vryMx = 1024;//조이스틱의 'vry'의 최댓값
int sw = 8; //조이스틱의 'sw'가 연결된 핀
int sw_prs_m = 1; //조이스틱의 'sw' 핀 설정 모드
/*  
sw_prs_m 값에 따른 'sw' 핀 설정 모드:
  0: 누르면 HIGH
  1: 누르면 LOW
  2: 누르면 HIGH (INPUT_PULLUP로 설정)
  3: 누르면 LOW (INPUT_PULLUP로 설정)*/
/*   버튼   */
int btnw = 2; //전진 신호를 보낼 때 사용할 버튼
int btns = 4; //후진 신호를 보낼 때 사용할 버튼
int btna = 5; //왼쪽으로 이동 신호를 보낼 때 사용할 버튼
int btnd = 3; //오른쪽으로 이동 신호를 보낼 때 사용할 버튼
int btn_prs_m = 3; //버튼 설정 모드
/*  
btn_prs_m 값에 따른 버튼 설정 모드:
  0: 누르면 HIGH
  1: 누르면 LOW
  2: 누르면 HIGH (INPUT_PULLUP로 설정)
  3: 누르면 LOW (INPUT_PULLUP로 설정)*/
/*   진동 모듈   */
int motor = A4; //진동 모듈이 연결된 핀
bool use_motor = true; //진동 모듈 사용 여부
/********************************/
int t = 250; //진동이 울리는 시간(밀리초) 설정
int ds = 250; //조이스틱을 움직이면 신호를 보내고 대기할 시간(밀리초) 설정

void setup() {
  pinMode(vrx, INPUT);
  pinMode(vry, INPUT);
  pinMode(motor, OUTPUT);
  if(sw_prs_m == 2 or sw_prs_m == 3){ //스위치가 INPUT_PULLUP로 설정되어야 할 때
    pinMode(sw, INPUT_PULLUP);
  }else{
    pinMode(sw, INPUT);
  }
  if(btn_prs_m == 2 or btn_prs_m == 3){ //버튼이 INPUT_PULLUP로 설정되어야 할 때
    pinMode(btnw, INPUT_PULLUP);
    pinMode(btna, INPUT_PULLUP);
    pinMode(btns, INPUT_PULLUP);
    pinMode(btnd, INPUT_PULLUP);
  }else{
    pinMode(btnw, INPUT);
    pinMode(btna, INPUT);
    pinMode(btns, INPUT);
    pinMode(btnd, INPUT);
  }
  digitalWrite(motor, LOW);
  Serial.begin(9600);
}

void loop() {
  int vx = analogRead(vrx);
  int vxc = map(vx, vrxMn, vrxMx, 1, 6);
  int vy = analogRead(vry);
  int vyc = map(vy, vryMn, vryMx, 1, 6);
  int prs;
  int wprs;
  int aprs;
  int sprs;
  int dprs;
  //{sw_prs_m; btn_prs_m}버튼 모드(0: 누르면 HIGH, 1: 누르면 LOW, 2: INPUT_PULLUP으로 설정(누르면 HIGH), 3: INPUT_PULLUP으로 설정(누르면 LOW))
  if(btn_prs_m == 1 or btn_prs_m == 3){
    wprs = convert(digitalRead(btnw));
    sprs = convert(digitalRead(btns));
    aprs = convert(digitalRead(btna));
    dprs = convert(digitalRead(btnd));
  }else{
    wprs = digitalRead(btnw);
    sprs = digitalRead(btns);
    aprs = digitalRead(btna);
    dprs = digitalRead(btnd);
  }
  if(sw_prs_m == 1 or sw_prs_m == 3){
    prs = convert(digitalRead(sw));
  }else{
    prs = digitalRead(sw);
  }
  bool del = false;
  if (wprs == HIGH) { //W
    Serial.println("w");
    del = true;
  }else if (sprs == HIGH) { //S
    Serial.println("s");
    del = true;
  }else if (aprs == HIGH) { //A
    Serial.println("a");
    del = true;
  }else if (dprs == HIGH) { //D
    Serial.println("d");
    del = true;
  }
  if (vxc == 1) { //왼쪽으로 시선 회전
    Serial.println("f");
  }else if (vxc == 5) { //오른쪽으로 시선 회전
    Serial.println("h");
  }
  if(prs == HIGH){
    Serial.println("r");
  }
  if(Serial.available()){
    if(Serial.readString() == "wd" and use_motor){
      digitalWrite(motor, HIGH);
      delay(t);
      digitalWrite(motor, LOW);
    }
  }
  if(del){
    delay(ds);
  }
}

int convert(int input){
  int output;
  if(input == HIGH){
    output = LOW;
  }else{
    output = HIGH;
  }
  return output;
}
