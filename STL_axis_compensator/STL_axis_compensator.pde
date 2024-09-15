stlModel inputModel = new stlModel("./test-models/model-0.stl");
stlModel outputModel = new stlModel("./export/export-model.stl");

PGraphics canvaXY,
          canvaZY,
          canvaXZ;
float canvaScale = 2;

float offsetX = 0,
      offsetY = 0,
      offsetZ = 0,
      maxOffset = 5;
      
boolean boolOffsetX = false,
        boolOffsetY = false,
        boolOffsetZ = false,
        boolAnyOffset = false,
        boolModelChoosed = false,
        boolModelLoad = false,
        boolFileSaved = false;

void setup() {
  canvaXY = createGraphics(600, 300);
  canvaZY = createGraphics(600, 300);
  canvaXZ = createGraphics(600, 300);
  
  selectInput("Select a file to process:", "selectSTLfile");
  
  size(1200, 600);
  surface.setResizable(true);
  surface.setTitle("STL axis offset compensator");
  frameRate(5);
  
  /*
  println("errCounter = ", inputModel.readStl() );
  //println("loopCounter = ", inputModel.loopCounter );
  println(  "maxX: ", inputModel.stlMidPoint.x1, 
          "; maxY: ", inputModel.stlMidPoint.y1,
          "; maxZ: ", inputModel.stlMidPoint.z1, 
          "; minX: ", inputModel.stlMidPoint.x2,
          "; minY: ", inputModel.stlMidPoint.y2,
          "; minZ: ", inputModel.stlMidPoint.z2,
          "; midX: ", inputModel.stlMidPoint.x3,
          "; midY: ", inputModel.stlMidPoint.y3,
          "; midZ: ", inputModel.stlMidPoint.z3,
          "; sizeX: ", inputModel.stlMidPoint.xn,
          "; sizeY: ", inputModel.stlMidPoint.yn,
          "; sizeZ: ", inputModel.stlMidPoint.zn);
          */
}


void draw()  {
  if ( (boolModelChoosed == true) & (boolModelLoad==false) )  {
    println("errCounter = ", inputModel.readStl() );
    //println("loopCounter = ", inputModel.loopCounter );
    println(  "maxX: ", inputModel.stlMidPoint.x1, 
            "; maxY: ", inputModel.stlMidPoint.y1,
            "; maxZ: ", inputModel.stlMidPoint.z1, 
            "; minX: ", inputModel.stlMidPoint.x2,
            "; minY: ", inputModel.stlMidPoint.y2,
            "; minZ: ", inputModel.stlMidPoint.z2,
            "; midX: ", inputModel.stlMidPoint.x3,
            "; midY: ", inputModel.stlMidPoint.y3,
            "; midZ: ", inputModel.stlMidPoint.z3,
            "; sizeX: ", inputModel.stlMidPoint.xn,
            "; sizeY: ", inputModel.stlMidPoint.yn,
            "; sizeZ: ", inputModel.stlMidPoint.zn);
            
    boolModelLoad = true;  // тут нет проверки на ошибки в файле, только факт загрузки некоего файла
  }
  
  background(50);
  textAlign(RIGHT, CENTER);
  textSize(18);
  
  fill(0);
  if (( offsetX != 0 ) || ( offsetY != 0 ) || ( offsetZ != 0 ))  { fill(250); }
  text("'BACKSPACE' для сброса и перестройки", width-5, height - 260);
  
  fill(0);
  if (boolAnyOffset == true)  { fill(150, 150, 50); }
  text("'SPACE' для перестройки модели", width-5, height - 240);
  
  fill(0);
  if (boolOffsetX == true)  { fill(150, 150, 50); }
  text("смещение вдоль X: " + offsetX, width-5, height - 200);
  
  fill(0);
  if (boolOffsetY == true)  { fill(150, 150, 50); }
  text("смещение вдоль Y: " + offsetY, width-5, height - 180);
  
  fill(0);
  if (boolOffsetZ == true)  { fill(150, 150, 50); }
  text("смещение вдоль Z: " + offsetZ, width-5, height - 160);
  
  fill(0);
  if ( (boolAnyOffset == false) & (( offsetX != 0 ) || ( offsetY != 0 ) || ( offsetZ != 0 )) )  { fill(250); }
  text("'s' для сохранения модели", width-5, height - 120);
  text("Файл будет сохранен в расположении:", width-5, height - 100);
  text(outputModel.strPath, width-5, height - 80);
  
  fill(120);
  text("'+' или '-' для изменения масштаба. Масштаб: " + canvaScale, width-5, height - 40);
  
  fill(0);
  text("Разрешение окна: " + width + " х " + height, width-5, height - 15);
  
  if (boolModelLoad==true) {
    canvaXY = inputModel.clearCanva(canvaXY, 250, 250, 250);
    canvaXY = inputModel.drawXY( canvaXY, 50, 50, 150, canvaScale );
    canvaXY = outputModel.drawXY( canvaXY, 150, 50, 50, canvaScale );
    
    canvaZY = inputModel.clearCanva(canvaZY, 250, 250, 250);
    canvaZY = inputModel.drawZY( canvaZY, 50, 50, 150, canvaScale );
    canvaZY = outputModel.drawZY( canvaZY, 150, 50, 50, canvaScale );
    
    canvaXZ = inputModel.clearCanva(canvaXZ, 250, 250, 250);
    canvaXZ = inputModel.drawXZ( canvaXZ, 50, 50, 150, canvaScale );
    canvaXZ = outputModel.drawXZ( canvaXZ, 150, 50, 50, canvaScale );
    
    outputModel.strPath = "./export/export-model_"+"offsetX_"+offsetX+"_offsetY_"+offsetY+"_offsetZ_"+offsetZ+".stl";
  }
  
  image(canvaXY, width*0.02, height*0.02, width*0.46, height*0.46);
  image(canvaZY, width*0.52, height*0.02, width*0.46, height*0.46);
  image(canvaXZ, width*0.02, height*0.52, width*0.46, height*0.46);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    outputModel.strPath = "./export/export-model_"+"offsetX_"+offsetX+"_offsetY_"+offsetY+"_offsetZ_"+offsetZ+".stl"; //<>//
    //inputModel.strPath = "./export/input-export-model.stl"; //<>//
    
    if ( (boolAnyOffset == false) & (( offsetX != 0 ) || ( offsetY != 0 ) || ( offsetZ != 0 )) )  { 
      outputModel.exportStl(); 
    }
     //<>//
    //inputModel.exportStl(); //<>//
  }
  
  if (key == '+') {
    canvaScale = canvaScale + 0.25;
  }
  
  if (key == '-') {
    canvaScale = canvaScale - 0.25;
    if (canvaScale < 0.25)  { canvaScale = 0.25; }
  } 
  
  if ( (key == 'x' || key == 'X') ) {
    boolOffsetX = true;
    boolOffsetY = false;
    boolOffsetZ = false;
  }
  
  if ( (key == 'y' || key == 'Y') ) {
    boolOffsetX = false;
    boolOffsetY = true;
    boolOffsetZ = false;
  }
  
  if ( (key == 'z' || key == 'Z') ) {
    boolOffsetX = false;
    boolOffsetY = false;
    boolOffsetZ = true;
  }
  
  if (keyCode == UP) {
    if (boolOffsetX == true)  { offsetX = offsetX + 0.25; boolAnyOffset = true; }
    if (boolOffsetY == true)  { offsetY = offsetY + 0.25; boolAnyOffset = true; }
    if (boolOffsetZ == true)  { offsetZ = offsetZ + 0.25; boolAnyOffset = true; }
    
    if (offsetX > maxOffset) { offsetX = maxOffset; }
    if (offsetY > maxOffset) { offsetY = maxOffset; }
    if (offsetZ > maxOffset) { offsetZ = maxOffset; }
    
    offsetX = float(round(offsetX*100))/100;
    offsetY = float(round(offsetY*100))/100;
    offsetZ = float(round(offsetZ*100))/100;
  }
  
  if (keyCode == DOWN) {
    if (boolOffsetX == true)  { offsetX = offsetX - 0.25; boolAnyOffset = true; }
    if (boolOffsetY == true)  { offsetY = offsetY - 0.25; boolAnyOffset = true; }
    if (boolOffsetZ == true)  { offsetZ = offsetZ - 0.25; boolAnyOffset = true; }
    
    if (offsetX < -maxOffset) { offsetX = -maxOffset; }
    if (offsetY < -maxOffset) { offsetY = -maxOffset; }
    if (offsetZ < -maxOffset) { offsetZ = -maxOffset; }
    
    offsetX = float(round(offsetX*100))/100;
    offsetY = float(round(offsetY*100))/100;
    offsetZ = float(round(offsetZ*100))/100;
  }
  
  if (key == 32) {
    //outputModel = inputModel;
    outputModel = inputModel.cloneLoops(outputModel); //<>//
    
    boolAnyOffset = false; //<>//
    outputModel.rebuild(offsetX, offsetY, offsetZ);
  }
  
  if (keyCode == BACKSPACE) {
    offsetX = 0;
    offsetY = 0;
    offsetZ = 0;
    
    outputModel = inputModel.cloneLoops(outputModel);
    
    boolAnyOffset = false;
    outputModel.rebuild(offsetX, offsetY, offsetZ);
  }
  
}

void selectSTLfile(File selection)  {
  String filePath;
  if (selection == null) {
    //s_log = "ФАЙЛ НЕ ВЫБРАН";
  } else {
    filePath = selection.getAbsolutePath();
    inputModel.strPath = filePath;
    
    boolModelChoosed = true;
    
    println( inputModel.strPath );
    /*
    s_STL_file_name = filePath;
    
    while (s_STL_file_name.indexOf("/")>=0)  {    // отрезаем все разделители из пути к файлу
      //println(s_STL_file_name.indexOf("/"));
      s_STL_file_name = s_STL_file_name.substring( s_STL_file_name.indexOf("/")+1 );
    }
    
    s_STL_file_path = s_STL_file_path.substring( 0, s_STL_file_path.indexOf( s_STL_file_name ) );
    
    s_log = "ФАЙЛ ВЫБРАН";
    */
  }
}
