color[][] image;
double scale = .0001;

double zoomx = 0;
double zoomy = 0;

double jr = -.8;
double ji = .156;

void settings(){
  //size(800, 800);
  //image = new color[800][800];
  fullScreen();
  image = new color[displayWidth][displayHeight];
}

void setup(){
  //drawJulia(-.8, .152, 0, 0, .001);
  //drawJulia(0.285 , -.01, -.474, .19, .001);
  //drawMandelbrot(-0.7615754, -0.08475945,.0000000004);
  drawMandelbrot(-.75, 0, .0025);
  saveFrame("Mandelbrot.png");
  //saveFrame("-0.7615754010103152 -0.08475945867249790i mandelbrot b.png");
  //saveFrame("julia " + jr + " " + ji + "i.png");
}

void draw(){}

void drawMandelbrot(double x, double y, double zoom){
  zoomx = x;
  zoomy = y;
  scale = zoom;
  color[][] smooth = new color[width][height];
  
  for(int i = 0; i < width; i ++){
    for(int j = 0; j < height; j ++){
      image[i][j] = divergeColor(getCoX(i), getCoY(j));
      if(i == 0 || j == 0 || i == width - 1 || j == height - 1)
        smooth[i][j] = image[i][j];
    }
  }
  
  for(int i = 1; i < width - 1; i ++){
    for(int j = 1; j < height - 1; j ++){
      int center = image[i][j] >> 16 & 0xFF;
      center += image[i - 1][j] >> 16 & 0xFF;
      center += image[i][j - 1] >> 16 & 0xFF;
      center += image[i + 1][j] >> 16 & 0xFF;
      center += image[i][j + 1] >> 16 & 0xFF;
      center = center/5;
      smooth[i][j] = color(center);
    }
  }
  
  loadPixels();
  for(int i = width - 1; i >= 0; i --){
    for(int j = 0; j < height; j ++){
      pixels[i + j * width] = image[i][j];
    }
  }
  updatePixels();
}

void drawJulia(double zr, double zi, double x, double y, double zoom){
  zoomx = x;
  zoomy = y;
  scale = zoom;
  jr = zr;
  ji = zi;
  
  for(int i = 0; i < width; i ++){
    for(int j = 0; j < height; j ++){
      image[i][j] = juliaColor(getCoX(i), getCoY(j));
    }
  }
  
  loadPixels();
  for(int i = width - 1; i >= 0; i --){
    for(int j = 0; j < height; j ++){
      pixels[i + j * width] = image[i][j];
    }
  }
  updatePixels();
}

double getCoX(int x){
  return (x - width / 2) * scale + zoomx;
}

double getCoY(int y){
  return (y - height / 2) * scale + zoomy;
}

boolean doesConverge(double a, double b){
  //a + bi
  double zr = a;
  double zi = b;
  
  for(int i = 0; i < 10000; i ++){
    double temp = zr*zr - zi*zi + a;
    zi = 2*zr*zi + b;
    zr = temp;
    
    if(zr > 2)
      return false;
  }
  return true;
}

color divergeColor(double a, double b){
  double zr = a;
  double zi = b;
  
  for(int i = 0; i < 1000; i ++){
    double temp = zr*zr - zi*zi + a;
    zi = 2*zr*zi + b;
    zr = temp;
    
    //diverges
    if(zr*zr + zi+zi > 16){
      //return color(i % 200 + 55);
      //return color(128 + 128*sin(TAU/500*(i+300)));
      //return color(i * 255 / 1000);
      return color(i * 255 / 1000, 128 + 128*sin(TAU/500*(i+300)), 128 + 128*cos(TAU/500*i));
      //return color((i) % 255, i * 255 / 1000, (i + 128) % 255);
    }
  }
  
  return color(0);
}

color juliaColor(double a, double b){
  double zr = a;
  double zi = b;
  
  for(int i = 0; i < 1000; i ++){
    double temp = zr*zr - zi*zi + jr;
    zi = 2*zr*zi + ji;
    zr = temp;
    
    //diverges
    if(zr*zr + zi+zi > 16){
      //return color(i % 200 + 55);
      //return color(i * 255 / 1000);
      return color(i * 255 / 1000, 128 + 128*sin(TAU/500*(i+300)), 128 + 128*cos(TAU/500*i));
    }
  }
  
  return color(0);
}

void mousePressed(){
  println(getCoX(mouseX) + " , " + getCoY(mouseY));
}