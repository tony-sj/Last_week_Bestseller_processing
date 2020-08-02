int cnt; //장르별 내려받는 책 수
int maxbook = 45; //장르별 최대 책 수
String[] url={
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001&sumgb=06&FetchSize=75",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001019&sumgb=06&FetchSize=45",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001002&sumgb=06&FetchSize=45",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001026&sumgb=06&FetchSize=45",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001016&sumgb=06&FetchSize=45",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001047&sumgb=06&FetchSize=45",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001022&sumgb=06&FetchSize=45",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001020&sumgb=06&FetchSize=45",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001011&sumgb=06&FetchSize=45",
  "http://www.yes24.com/24/category/bestseller?CategoryNumber=001001007&sumgb=06&FetchSize=45"
};
int kind = url.length;
boolean[] visited = new boolean[kind];

float[] gcount = new float[kind];
float g=0;
float preh=0;

PFont myFont;

String[] kinds = {"종합","인문","과학","자기계발","어린이","에세이","사회","인물","건강","예술"};
int[] kbutton = {200,420,640,860,1080}; //x 위치
PImage[] gernre = new PImage[kind];
PImage all = new PImage();
PImage logo = new PImage();

boolean loadall=false;
boolean chkall=false;
int loaded=0;

boolean moving=false;

boolean started=false;
boolean ok=false;
float waveh=180;
float a=0;

int cx=50;
int cy=100;
int chartcnt=0; //현재 페이지(1~upper)
int rowCount;
Book[][] books = new Book[kind][100];
float yoff=0.0;
float tu = 255;
boolean tuok=false; //그라데이션 효과 스위치
int upper = 3; //페이지 수
int rate = 0; //현재 장르 상태

boolean UIdebug = false;


void setup(){
  size(1500, 900);
  background(0);
  for(int i=0;i<kind;i++)
    for(int j=0;j<100;j++)
      books[i][j]=new Book();
  //frameRate(120);
  //String[] fontList = PFont.list();
  //printArray(fontList);
  
  all=loadImage("loadbutton.png");
  all.resize(100, 100);
  logo=loadImage("SASA.png");
  logo.resize(120,0);
  
  for(int i=0;i<kind;i++){
    downdata(i);
    gernre[i] = loadImage(kinds[i]+".png");
    gernre[i].resize(150,150);
  }
  
  for(int k=0;k<maxbook;k++)
    for(int i=1;i<kind;i++)
      for(int j=0;j<maxbook;j++)
        if(books[0][k].code.equals(books[i][j].code)==true){
          gcount[i]+=1;
          g+=1;
        }
}


void draw(){
  //println(started);
  imageMode(CORNERS);
  println(started, loadall, ok, rate);
  //for(int i=1;i<kind;i++) print(gcount[i]);
  
  //종합 우선
  if(!started&&!visited[0]&&!UIdebug){
    println(1);
    //downdata(0);
    loading(cnt);
    cnt++;
    if(cnt==maxbook){
      visited[0]=true;
      cnt=0;
      loaded++;
      maxbook=45;
    }
  }
  
  if(!loadall&&!started&&(visited[0]||UIdebug)){
    println(2);
    opening();
  }
  
  if(loadall&&started){
    println(3);
    if(rate!=0) maxbook=45;
    imageMode(CORNERS);
    if(visited[rate]&&rate<kind) rate++;
    loading(cnt);
    cnt++;
    if(cnt==maxbook){
      loaded++;
      visited[rate]=true;
      rate++;
      if(loaded==kind){
        loadall=false;
        started=false;
        ok=false;
        waveh=180;
        a=0;
        yoff=0;
        tuok=false;
        rate=0;
        chkall=false;
      }
      cnt=0;
    }
  }
      
  if(!loadall&&started&&!visited[rate]){
    println(4);
    loading(cnt);
    cnt++;
    if(cnt==maxbook){
      visited[rate]=true;
      loaded++;
      cnt=0;
    }
  }
  
  if(!loadall&&started&&visited[rate]){
    println(5);
    mainevent();
  }
}


void gchart(int i){
  //ellipse(kbutton[i%5]+100,waveh+200+250*(i/5),160,160);
  textAlign(CENTER);
  textSize(12);
  fill(6,66,100,100);
  preh=-PI/2;
  float ang = map(gcount[i],0,g,0,2*PI);
  arc(kbutton[i%5]+100,waveh+200+250*(i/5),160,160,preh,ang);
}


void loading(int c){
  downBooksign(rate, c);
  if(!UIdebug){
    books[rate][c].name = split(downstar(books[rate][c].code),"/")[2];
    books[rate][c].star = float(split(downstar(books[rate][c].code),"/")[0]);
    books[rate][c].price = split(downstar(books[rate][c].code),"/")[1];
  }
  fill(0);
  rect(0,0,width,height);
  noStroke();
  fill(100);
  rect(width/2 - 400, height/2+100, 800, 8, 7);
  fill(255);
  rect(width/2-400,height/2+100,map(c,0,maxbook,0,800),8,7);
  image(books[rate][c].booksign,width/2-80,height/2-230);
}


void opening(){
  background(0);
  myFont = createFont("Arial", 32);
  textFont(myFont);
  fill(255);
  noStroke();
  if(ok==true){
    waveh+=a;
    a+=0.2;
  }
  beginShape();
  float xoff=0;
  for(float x=0;x<=width;x+=10){
    float y = map(noise(xoff, yoff),0,1,waveh,waveh+70);
    if(waveh>1100){
      //if(!visited[rate]) downdata(rate);
      if(chkall) loadall=true;
      started=true;
      tuok=false;
      return;
    }
    vertex(x,y);
    xoff+=0.008;
  }
  
  yoff+=0.01;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
  
  textSize(200);
  textAlign(CENTER);
  text("BEST SELLERS", width/2, waveh+50);
  
  for(int i=0;i<kind;i++){
    imageMode(CENTER);
    image(gernre[i],kbutton[i%5]+100,waveh+200+250*(i/5));
    if(!ok){
      fill(127,205,255,70);
      if(visited[i]) fill(6,66,200,70);
    }
    else fill(29,162,216,70);
    //if(mouseX>kbutton[i%5]+25&&mouseX<kbutton[i%5]+175&&mouseY>waveh+125+250*(i/5)-10&&mouseY<waveh+275+250*(i/5)+10){
    if(dist(mouseX,mouseY,kbutton[i%5]+100,waveh+200+250*(i/5))<=80){
      fill(29,162,216,70);
      if(visited[i]) fill(6,66,200,110);
      if(mousePressed){
        ok=true;
        rate=i;
        upper=3;
        maxbook=15*upper;
      }
    }
    /*
    rectMode(CORNER);
    rect(kbutton[i%5],waveh+200+120*(i/5),200,100,20);
    */
    
    ellipseMode(CENTER);
    ellipse(kbutton[i%5]+100,waveh+200+250*(i/5),160,160);
    
    if(i>0) gchart(i);
    
    fill(0);
    //if(visited[i]) fill(255);
    myFont = createFont("나눔스퀘어 Bold", 32);
    textFont(myFont);
    textAlign(CENTER);
    textSize(20);
    text(kinds[i],kbutton[i%5]+100,waveh+300+250*(i/5));
    
    if(loaded<kind) loadbutton();
    
  }
  
  imageMode(CORNERS);
  image(logo,30,waveh+630);
  
  if(UIdebug){
    fill(0);
    text("UI Debug Mode", width/2, height-30);
  }
  tum();
}


void downdata(int k){
  String[] links = loadStrings(url[k]);
  println(links.length);
  int bx=cx;
  int by=cy;
  for(int i=0;i<links.length;i++){
    String front="<img src=\"http://image.yes24.com/goods/";
    String back="/S\"";
    String p=(WebCrawl(links[i], front, back, 1));
    if(p!="0"){
      books[k][cnt].code = p;
      println(cnt, books[k][cnt].code);
      books[k][cnt].rank=cnt;
      books[k][cnt].x=bx;
      books[k][cnt].y=by;
      //books[k][cnt].name=downname(books[k][cnt].code);
      cnt++;
      bx+=180;
      if(bx>800){
        bx=cx;
        by+=260;
      }
      if(by>800) by=cy;
    }
  }
  cnt = 0;
}


String downstar(String c){
  String[] links = loadStrings("http://www.yes24.com/Product/Goods/"+c);
  String p = new String();
  String s = new String();
  String pp = new String();
  String ss = new String();
  String ppp = new String();
  String sss = new String();
  boolean u=false;
  boolean uu=false;
  boolean uuu=false;
  for(int i=0;i<links.length;i++){
    String front="<em class=\"yes_b\">";
    String back="</em>";
    String ff="<em class=\"yes_m\">";
    String bb="</em>";
    String fff="<h2 class=\"gd_name\">";
    String bbb="</h2>";
    p = WebCrawl(links[i], front, back, 2);
    if(p!="0"){
      s=p;
      u=true;
    }
    pp = WebCrawl(links[i],ff,bb,3);
    if(pp!="0"){
      ss=pp;
      uu=true;
    }
    ppp = WebCrawl(links[i], fff, bbb, 2);
    if(ppp!="0"){
      sss=ppp;
      uuu=true;
    }
    if(u&&uu&&uuu) break;
  }
  //println(sss);
  return s+"/"+ss+"/"+sss;
}
 

String WebCrawl(String s, String front, String back, int k){
  //http://www.yes24.com/Product/Goods/89309569
  int start = s.indexOf(front);
  if(start==-1) return "0";
  start += front.length();
  int end = s.indexOf(back, start);
  if(end==-1) return "0";
  s = s.substring(start,end);
  if(k==1);
    for(int i=8;i>0;i--) 
      if(s.length()==i) s = s.substring(0,i);
  //if(s.charAt(7)>='0'&&s.charAt(7)<='9') s = s.substring(0,8);
  //println(s);
  return s;
}


void mainevent(){
  background(0);
  fill(255);
  textAlign(LEFT);
  textFont(myFont);
  text("This week's Bestseller", 50, 50);
  text(chartcnt+1+"/"+upper, 500, 50);
  
  for(int i=15*chartcnt;i<15+15*chartcnt;i++){
    books[rate][i].display();
  }
  
  if(chartcnt<upper-1){
    for(int i=890;i<940;i++){
      stroke(0,0,0,(i-890)*5);
      line(i,100,i,900);
      noStroke();
    }
    fill(127);
    triangle(940,height/2,940,height/2+20,955,height/2+10);
  }
  
  if(chartcnt>0){
    for(int i=30;i<80;i++){
      stroke(0,0,0,255-(i-30)*5);
      line(i,100,i,900);
      noStroke();
    }
    fill(127);
    triangle(40,height/2,40,height/2+20,25,height/2+10);
  }
  
  backbutton();
  kindbutton();
  tum();
}


void star(float x, float y, float radius1, float radius2, int npoints) {
  fill(255);
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}


void keyPressed(){
  if(started&&keyCode==RIGHT){
    if(chartcnt<upper-1) chartcnt++;
  }
  if(started&&keyCode==LEFT){
    if(chartcnt>0) chartcnt--;
  }
}


void downBooksign(int k,int i){
  //println(kinds[k], i);
  String imageUrl = "http://image.yes24.com/goods/";
  //http://image.yes24.com/goods/89309569/800x0
  if(books[k][i].code==null) books[k][i].booksign = loadImage("loadbutton.png");
  else books[k][i].booksign = loadImage(imageUrl+books[k][i].code+"/M.jpg");
  books[k][i].booksign.resize(160, 230);
  if(books[k][i].code==null) books[k][i].bigbooksign = loadImage("loadbutton.png");
  else books[k][i].bigbooksign = loadImage(imageUrl+books[k][i].code+"/B.jpg");
}


void tum(){
  if(!tuok){
    fill(0, tu);
    rect(0, 0, 1500, 900);
    if(tu>=3) tu-=3;
    else{
      tuok=true;
      tu=255;
    }
  }
}


void backbutton(){
  fill(51);
  rectMode(CORNER);
  rect(width-90, 10, 60, 60, 10);
  fill(255);
  if(mouseX>width-90&&mouseX<width-30&&mouseY>10&&mouseY<70){
    fill(127);
    if(mousePressed){
      tuok=false;
      started=false;
      rate=0;
      waveh=180;
      a=0;
      yoff=0;
      ok=false;
      chartcnt=0;
      chkall=false;
      loadall=false;
      return;
    }
  }
  triangle(width-80, 40, width-45, 60, width-45, 20);
}


void kindbutton(){
  fill(100);
  rectMode(CORNER);
  rect(width-250, 10, 150, 60, 10);
  fill(255);
  if(mouseX>width-250&&mouseX<width-100&&mouseY>10&&mouseY<70){
    fill(127,205,255);
    if(mousePressed){
      moving=true;
    }
  }
  if(mouseX<width-250||mouseX>width-100) moving=false;
  myFont = createFont("나눔스퀘어", 32);
  textAlign(CENTER);
  textFont(myFont);
  textSize(22);
  text(kinds[rate],width-175,45);
  if(moving){
    int h=65;
    for(int i=0;i<kind;i++){
      if(i!=rate){
        fill(100);
        rectMode(CORNER);
        rect(width-250, 10+h, 150, 40, 10);
        fill(255);
        if(mouseX>width-250&&mouseX<width-100&&mouseY>10+h&&mouseY<50+h){
          if(mousePressed){
            rate=i;
            upper=3;
            maxbook=15*upper;
            cnt=0;
            chartcnt=0;
            moving=false;
            tuok=false;
            chkall=false;
            loadall=false;
          }
          fill(127,205,255);
        }
        text(kinds[i],width-175,35+h);
        h+=45;
      }
    }
  }
  fill(255); 
  triangle(width-140,30,width-120,30,width-130,45);
}


void loadbutton(){
  imageMode(CENTER);
  image(all, width-100, waveh+600);
  fill(127,205,255,70);
  if(dist(width-100, waveh+600, mouseX, mouseY)<=50){
    fill(127,205,255,150);
    if(mousePressed){
      //loadall=true; 멈췄던 원인
      chkall=true;
      //maxbook=45;
      ok=true;
      rate=0;
      upper=3;
      maxbook=45;
    }
  }
  ellipseMode(CENTER);
  ellipse(width-100, waveh+600, 100, 100);
  fill(0);
  text("All", width-100, waveh+670);
}


class Book {
  int x, y, rank;
  float star;
  String name;
  String code;
  String price;
  PImage booksign = new PImage();
  PImage bigbooksign = new PImage();
  
  void display(){
    image(booksign, x, y);
    if(mouseX>x&&mouseX<x+160&&mouseY>y&&mouseY<y+230){
      if(mousePressed){
        link("http://www.yes24.com/Product/Goods/"+code);
      }
      bigbooksign.resize(500,0);
      image(bigbooksign,970,100);
      rectMode(CORNER);
      fill(0, 200);
      rect(x, y, 160, 230);
      fill(255);
      myFont = createFont("나눔스퀘어 Bold", 32);
      textFont(myFont);
      textSize(20);
      textAlign(LEFT);
      //println(name);
      text(str(rank+1)+": "+name+" / "+nf(star,0,1), x, y, 160, 230);
      //text("기억", x, y);
      fill(0, 150);
      rect(940,height-170,600,220);
      pushMatrix();
      translate(1030, height-100);
      rotate(-PI/10);
      star(0, 0, 20, 50, 5);
      popMatrix();
      fill(0);
      textSize(18);
      textAlign(CENTER);
      text(nf(star,0,1), 1030, height-100);
      fill(255);
      textAlign(LEFT);
      textSize(20);
      if(!UIdebug){
        text(name,1090,height-150,420,100);
        text(price,1090,height-80);
      }
    }
  }
}
//2020.07.11
