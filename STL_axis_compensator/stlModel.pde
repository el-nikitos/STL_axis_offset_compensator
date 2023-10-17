class stlModel {
  
  String strPath = "";
  String[] textFile; 
  
  stlLoop[] arrLoops;
  stlLoop stlMidPoint;
  
  int errCounter = 0,
      loopCounter = 0;
  
  float scaleX = 1,
        scaleY = 1,
        scaleZ = 1;
  
  stlModel(String constrStrPath)  {  // constructor
    this.strPath = constrStrPath;
    
    this.stlMidPoint = new stlLoop();
    
  }
  
  public int readStl()  {
    this.textFile = loadStrings( this.strPath );
    
    int fileLength = textFile.length;
    println("fileLength = " + fileLength);
    
    this.errCounter = 0;
    
    for ( int i=0; i<fileLength; i++ )  {
      if ( ( this.textFile[i].indexOf("solid") >= 0 ) & ( this.textFile[i].indexOf("endsolid") < 0 ) )  { this.errCounter++; }
      if ( this.textFile[i].indexOf("endsolid") >= 0 )  { this.errCounter--; }
      
      if ( this.textFile[i].indexOf("normal") >= 0 )  { this.errCounter++; }
      if ( this.textFile[i].indexOf("vertex") >= 0 )  { this.errCounter++; }
     
      if ( ( this.textFile[i].indexOf("loop") >= 0 ) & ( this.textFile[i].indexOf("endloop") < 0 ) )  { this.errCounter++; this.loopCounter++; }
      
      if ( this.textFile[i].indexOf("endloop") >= 0 )  { this.errCounter = this.errCounter - 5; }
    }
    
    if (this.errCounter == 0)  {  // инициализация массива полигонов и инициализация точек внутри массива
      this.arrLoops = new stlLoop[ this.loopCounter ];
      for (int i=0; i<arrLoops.length; i++)
      {
        arrLoops[i] = new stlLoop();
      }
      
    }
    
    parcingStl();
    
    return this.errCounter;
  }
  
  public void parcingStl()  {
    int count = 0;
    String bufer_str_x = "",
           bufer_str_y = "",
           bufer_str_z = "";
    
    int fileLength = textFile.length;
    
    stlMidPoint.x1 = -10000;  // исходные значения для поиска максимума X
    stlMidPoint.x2 = 10000;  // исходные значения для поиска минимума X
    stlMidPoint.y1 = -10000;  // исходные значения для поиска максимума Y
    stlMidPoint.y2 = 10000;  // исходные значения для поиска минимума Y
    stlMidPoint.z1 = -10000;  // исходные значения для поиска максимума Z
    stlMidPoint.z2 = 10000;  // исходные значения для поиска минимума Z
    
    for ( int i=0; i<fileLength; i++ )  {  // построчно парсим STL-файл
      
      String bufer_str = textFile[i];
      //println( bufer_str );
      if ( bufer_str.indexOf("facet normal ")>0 )  {  // нашли и парсим строку данных НОРМАЛИ
        bufer_str = bufer_str.substring( bufer_str.indexOf("normal") + 1 );
        bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        bufer_str_x = bufer_str.substring( 0, bufer_str.indexOf(" ") );
        bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        bufer_str_y = bufer_str.substring( 0, bufer_str.indexOf(" ") );
        
        bufer_str_z = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        /*
        println("buf_x: " + bufer_str_x);
        println("buf_y: " + bufer_str_y);
        println("buf_z: " + bufer_str_z);
        */
        arrLoops[count].xn = Float.parseFloat( bufer_str_x );
        arrLoops[count].yn = Float.parseFloat( bufer_str_y );
        arrLoops[count].zn = Float.parseFloat( bufer_str_z );
        
        bufer_str = textFile[i+2]; // нашли и парсим строку данных ПЕРВОЙ точки треугольника
        bufer_str = bufer_str.substring( bufer_str.indexOf("vertex") + 1 );
        bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        bufer_str_x = bufer_str.substring( 0, bufer_str.indexOf(" ") );
        bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        bufer_str_y = bufer_str.substring( 0, bufer_str.indexOf(" ") );
        
        bufer_str_z = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        arrLoops[count].x1 = Float.parseFloat( bufer_str_x );
        arrLoops[count].y1 = Float.parseFloat( bufer_str_y );
        arrLoops[count].z1 = Float.parseFloat( bufer_str_z );
        
        bufer_str = textFile[i+3]; // нашли и парсим строку данных ВТОРОЙ точки треугольника
        bufer_str = bufer_str.substring( bufer_str.indexOf("vertex") + 1 );
        bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        bufer_str_x = bufer_str.substring( 0, bufer_str.indexOf(" ") );
        bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        bufer_str_y = bufer_str.substring( 0, bufer_str.indexOf(" ") );
        
        bufer_str_z = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        arrLoops[count].x2 = Float.parseFloat( bufer_str_x );
        arrLoops[count].y2 = Float.parseFloat( bufer_str_y );
        arrLoops[count].z2 = Float.parseFloat( bufer_str_z );
        
        bufer_str = textFile[i+4]; // нашли и парсим строку данных ТРЕТЬЕЙ точки треугольника
        bufer_str = bufer_str.substring( bufer_str.indexOf("vertex") + 1 );
        bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        bufer_str_x = bufer_str.substring( 0, bufer_str.indexOf(" ") );
        bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        bufer_str_y = bufer_str.substring( 0, bufer_str.indexOf(" ") );
        
        bufer_str_z = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
        
        arrLoops[count].x3 = Float.parseFloat( bufer_str_x );
        arrLoops[count].y3 = Float.parseFloat( bufer_str_y );
        arrLoops[count].z3 = Float.parseFloat( bufer_str_z );
        
        // поиск крайних точек
        float maxX = max(arrLoops[count].x1, arrLoops[count].x2, arrLoops[count].x3);
        if (stlMidPoint.x1 < maxX)  {  stlMidPoint.x1 = maxX;  }
        float minX = min(arrLoops[count].x1, arrLoops[count].x2, arrLoops[count].x3);
        if (stlMidPoint.x2 > minX)  {  stlMidPoint.x2 = minX;  }
        
        float maxY = max(arrLoops[count].y1, arrLoops[count].y2, arrLoops[count].y3);
        if (stlMidPoint.y1 < maxY)  {  stlMidPoint.y1 = maxY;  }
        float minY = min(arrLoops[count].y1, arrLoops[count].y2, arrLoops[count].y3);
        if (stlMidPoint.y2 > minY)  {  stlMidPoint.y2 = minY;  }
        
        float maxZ = max(arrLoops[count].z1, arrLoops[count].z2, arrLoops[count].z3);
        if (stlMidPoint.z1 < maxZ)  {  stlMidPoint.z1 = maxZ;  }
        float minZ = min(arrLoops[count].z1, arrLoops[count].z2, arrLoops[count].z3);
        if (stlMidPoint.z2 > minZ)  {  stlMidPoint.z2 = minZ;  }

      }
      
      if ( bufer_str.indexOf("endloop")>0 )  {
        count++;
        //println( count );
      }
      
    }
    stlMidPoint.x3 = (stlMidPoint.x1 + stlMidPoint.x2)/2;  // поиск средней точки
    stlMidPoint.y3 = (stlMidPoint.y1 + stlMidPoint.y2)/2;
    stlMidPoint.z3 = (stlMidPoint.z1 + stlMidPoint.z2)/2;
    
    stlMidPoint.xn = stlMidPoint.x1 - stlMidPoint.x2;  // поиск размаха
    stlMidPoint.yn = stlMidPoint.y1 - stlMidPoint.y2;
    stlMidPoint.zn = stlMidPoint.z1 - stlMidPoint.z2;
    
  }
  
  public void exportStl()  {
    PrintWriter output = createWriter( strPath );
    output.println("solid ");
    
    for (int i=0; i<loopCounter; i++)  {
      output.println("  facet normal " + arrLoops[i].xn + " " + arrLoops[i].yn + " " + arrLoops[i].zn);
      output.println("    outer loop");
      output.println("      vertex " + arrLoops[i].x1 + " " + arrLoops[i].y1 + " " + arrLoops[i].z1);
      output.println("      vertex " + arrLoops[i].x2 + " " + arrLoops[i].y2 + " " + arrLoops[i].z2);
      output.println("      vertex " + arrLoops[i].x3 + " " + arrLoops[i].y3 + " " + arrLoops[i].z3);
      output.println("    endloop");
      output.println("  endfacet");
    }
    
    output.println("endsolid");
    output.flush();
    output.close();
  }
  
  public PGraphics drawXY(PGraphics canva, float colorRed, float colorGreen, float colorBlue, float scale)  {
    
    canva.beginDraw();
    canva.fill(colorRed, colorGreen, colorBlue, 125);
    canva.noStroke();
    for (int i=0; i<loopCounter; i++)  {
      if (arrLoops[i].zn > 0)  {
        canva.triangle( canva.width/2 + scale*(arrLoops[i].x1 - stlMidPoint.x3), canva.height/2 - scale*(arrLoops[i].y1 - stlMidPoint.y3),
                        canva.width/2 + scale*(arrLoops[i].x2 - stlMidPoint.x3), canva.height/2 - scale*(arrLoops[i].y2 - stlMidPoint.y3),
                        canva.width/2 + scale*(arrLoops[i].x3 - stlMidPoint.x3), canva.height/2 - scale*(arrLoops[i].y3 - stlMidPoint.y3) );
      }
    }
    
    canva.endDraw();
    
    return canva;
  }
  
  public PGraphics drawZY(PGraphics canva, float colorRed, float colorGreen, float colorBlue, float scale)  {
    
    canva.beginDraw();
    canva.fill(colorRed, colorGreen, colorBlue, 125);
    canva.noStroke();
    for (int i=0; i<loopCounter; i++)  {
      if (arrLoops[i].xn < 0)  {
        canva.triangle( canva.width/2 + scale*(arrLoops[i].z1 - stlMidPoint.z3), canva.height/2 - scale*(arrLoops[i].y1 - stlMidPoint.y3),
                        canva.width/2 + scale*(arrLoops[i].z2 - stlMidPoint.z3), canva.height/2 - scale*(arrLoops[i].y2 - stlMidPoint.y3),
                        canva.width/2 + scale*(arrLoops[i].z3 - stlMidPoint.z3), canva.height/2 - scale*(arrLoops[i].y3 - stlMidPoint.y3) );
      }
    }
    
    canva.endDraw();
    
    return canva;
  }
  
  public PGraphics drawXZ(PGraphics canva, float colorRed, float colorGreen, float colorBlue, float scale)  {
    
    canva.beginDraw();
    canva.fill(colorRed, colorGreen, colorBlue, 125);
    canva.noStroke();
    for (int i=0; i<loopCounter; i++)  {
      if (arrLoops[i].yn < 0)  {
        canva.triangle( canva.width/2 + scale*(arrLoops[i].x1 - stlMidPoint.x3), canva.height/2 + scale*(arrLoops[i].z1 - stlMidPoint.z3),
                        canva.width/2 + scale*(arrLoops[i].x2 - stlMidPoint.x3), canva.height/2 + scale*(arrLoops[i].z2 - stlMidPoint.z3),
                        canva.width/2 + scale*(arrLoops[i].x3 - stlMidPoint.x3), canva.height/2 + scale*(arrLoops[i].z3 - stlMidPoint.z3) );
      }
    }
    
    canva.endDraw();
    
    return canva;
  }
  
  public PGraphics clearCanva(PGraphics canva, float colorRed, float colorGreen, float colorBlue)  {
    canva.beginDraw();
    canva.background(colorRed, colorGreen, colorBlue);
    canva.endDraw();
    
    return canva;
  }
  
  public stlModel cloneLoops(stlModel externalObject)  {  // не работает - внутренний класс копируется ссылкой
    
    externalObject.stlMidPoint = new stlLoop( this.stlMidPoint );
    
    externalObject.loopCounter = this.loopCounter;
    
    externalObject.arrLoops = new stlLoop[ externalObject.loopCounter ];
    
    for (int i=0; i<externalObject.loopCounter; i++)  {
      externalObject.arrLoops[i] = new stlLoop( this.arrLoops[i] );
    }
    
    return externalObject;
  }
  
  public void rebuild(float degreeOffsetX, float degreeOffsetY, float degreeOffsetZ)  {
    for (int i=0; i<loopCounter; i++)  {
      arrLoops[i].x1 = arrLoops[i].x1 - stlMidPoint.x3;
      arrLoops[i].y1 = arrLoops[i].y1 - stlMidPoint.y3;  // перенос точки в центр
      arrLoops[i].z1 = arrLoops[i].z1 - stlMidPoint.z3;
      arrLoops[i].x2 = arrLoops[i].x2 - stlMidPoint.x3;
      arrLoops[i].y2 = arrLoops[i].y2 - stlMidPoint.y3;
      arrLoops[i].z2 = arrLoops[i].z2 - stlMidPoint.z3;
      arrLoops[i].x3 = arrLoops[i].x3 - stlMidPoint.x3;
      arrLoops[i].y3 = arrLoops[i].y3 - stlMidPoint.y3;
      arrLoops[i].z3 = arrLoops[i].z3 - stlMidPoint.z3;
      
      arrLoops[i].x1 = arrLoops[i].x1 + arrLoops[i].y1*sin(degreeOffsetX*PI/180);  // смещение вдоль оси X
      arrLoops[i].x2 = arrLoops[i].x2 + arrLoops[i].y2*sin(degreeOffsetX*PI/180);
      arrLoops[i].x3 = arrLoops[i].x3 + arrLoops[i].y3*sin(degreeOffsetX*PI/180);
      
      arrLoops[i].y1 = arrLoops[i].y1 + arrLoops[i].x1*sin(degreeOffsetY*PI/180);  // смещение вдоль оси Y
      arrLoops[i].y2 = arrLoops[i].y2 + arrLoops[i].x2*sin(degreeOffsetY*PI/180);
      arrLoops[i].y3 = arrLoops[i].y3 + arrLoops[i].x3*sin(degreeOffsetY*PI/180);
      
      arrLoops[i].z1 = arrLoops[i].z1 + arrLoops[i].x1*sin(degreeOffsetZ*PI/180);  // смещение вдоль оси Z
      arrLoops[i].z2 = arrLoops[i].z2 + arrLoops[i].x2*sin(degreeOffsetZ*PI/180);
      arrLoops[i].z3 = arrLoops[i].z3 + arrLoops[i].x3*sin(degreeOffsetZ*PI/180);
      
      arrLoops[i].x1 = arrLoops[i].x1 + stlMidPoint.x3;
      arrLoops[i].y1 = arrLoops[i].y1 + stlMidPoint.y3;  // возврат смещение центра
      arrLoops[i].z1 = arrLoops[i].z1 + stlMidPoint.z3;
      arrLoops[i].x2 = arrLoops[i].x2 + stlMidPoint.x3;
      arrLoops[i].y2 = arrLoops[i].y2 + stlMidPoint.y3;
      arrLoops[i].z2 = arrLoops[i].z2 + stlMidPoint.z3;
      arrLoops[i].x3 = arrLoops[i].x3 + stlMidPoint.x3;
      arrLoops[i].y3 = arrLoops[i].y3 + stlMidPoint.y3;
      arrLoops[i].z3 = arrLoops[i].z3 + stlMidPoint.z3;
    }
  }
}
