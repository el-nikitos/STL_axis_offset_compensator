boolean b_file_is_selected = false,
        b_file_is_opened = false;
        
byte byte_XYZ_choze = 0;

String  s_STL_file_path = "",
        s_STL_file_name = "",
        s_log = "ЗАПУСТИЛИСЬ";

String[] f_STL_file;

PGraphics canva_XY,
          canva_ZY;

float f_max_X = -10000,
      f_max_Y = -10000,
      f_max_Z = -10000,
      f_min_X =  10000,
      f_min_Y =  10000,
      f_min_Z =  10000,
      f_koeff = 1;
      
float XY_degree = 0,
      YX_degree = 0,
      YZ_degree = 0,
      ZY_degree = 0,
      max_offset_degree = 9.75;

STL_data[] STL_triangles,
           STL_buffer;

void setup()  {
  size(1300, 650);
  background(0);
  
  //while ( open_STL_file() == false )  {}
  selectInput("Select a file to process:", "select_STL_file");
  
  canva_XY = createGraphics( round( width*0.4 ), round( height*0.85 ) );
  canva_ZY = createGraphics( round( width*0.4 ), round( height*0.85 ) );
}

void draw()  {
  fill(255);
  textSize( height*0.045 );
  textAlign(CENTER, CENTER);
  
  if (b_file_is_opened == false)  {  // отрисовка меню, пока файл не открыт
    if ( b_file_is_selected == false )  {
      background(150, 50, 50);
      //fill(50, 50, 100);
      //text("ФАЙЛ НЕ ВЫБРАН", width/2, height*0.4 );
      fill(255);
      text("ДЛЯ ВЫБОРА ФАЙЛА КЛИКНИТЕ ПО РАБОЧЕМУ ПОЛЮ ИЛИ НАЖМИТЕ 'ПРОБЕЛ'", width/2, height*0.5 );
    } else {
      background(100, 150, 100);
      
      fill(50, 50, 100);
      text("ФАЙЛ ВЫБРАН", width/2, height*0.2 );
      text("ПУТЬ К ВЫБРАННОМУ ФАЙЛУ:", width/2, float(height)*0.3 );
      text("ИМЯ ФАЙЛА: ", width/2, float(height)*0.5 );
      
      fill(255);
      text( s_STL_file_path , width/2, float(height)*0.37 );
      text( s_STL_file_name , width/2, float(height)*0.57 );
      
      fill(50, 50, 100);
      text("ДЛЯ ОТКРЫТИЯ ФАЙЛА КЛИКНИТЕ ПО РАБОЧЕМУ ПОЛЮ ИЛИ НАЖМИТЕ 'ПРОБЕЛ'", width/2, height*0.7 );
      fill(150, 50, 50);
      text("ДЛЯ ВЫБОРА ДРУГОГО ФАЙЛА НАЖМИТЕ 'BACKSPACE'", width/2, height*0.77 );
    }
  } else  {  // отрисовка меню, когда файл открыт
    background(150, 150, 250);
    
    text("ДЛЯ ВОЗВРАТА НАЖМИТЕ 'BACKSPACE'", width/2, height*0.015 );
    
    image(canva_XY, width*0.02, height*0.05);
    image(canva_ZY, width*0.43, height*0.05);
    
    draw_spin_menu();
  }
  
  fill(0);
  text( "LOG: " + s_log, width/2, height*0.95 );
}

void mouseClicked() {
  if ( ( b_file_is_selected == false )&(b_file_is_opened == false) )  {
    selectInput("Select a file to process:", "select_STL_file");
    s_log = "ОТКРЫТ ПРОВОДНИК ДЛЯ ВЫБОРА ФАЙЛА";
  }
  
  if ( ( b_file_is_selected == true )&(b_file_is_opened == false) )  {
    open_STL_file();
  }
}

void keyPressed() {
  if ( ( b_file_is_selected == true )&(b_file_is_opened == false)&(keyCode == BACKSPACE) )  {
    b_file_is_selected = false;  // сброс выбора файла при нажатии BACKSPACE
    s_log = "ПУТЬ К ФАЙЛУ СБРОШЕН";
  }
  
  if ( ( b_file_is_selected == true )&(b_file_is_opened == true)&(keyCode == BACKSPACE) )  {
    b_file_is_opened = false;  // сброс выбора файла при нажатии BACKSPACE
      
    s_log = "ВЫПОЛНЕН ВОЗВРАТ В МЕНЮ ВЫБОРА И ОТКРЫТИЯ ФАЙЛА";
  }
  
  if ( ( b_file_is_selected == false )&(b_file_is_opened == false)&(key == 32) )  {
    selectInput("Select a file to process:", "select_STL_file");  // выбор файл при нажатии ПРОБЕЛ
    s_log = "ОТКРЫТ ПРОВОДНИК ДЛЯ ВЫБОРА ФАЙЛА";
  }
  
  if ( ( b_file_is_selected == true )&(b_file_is_opened == true)&(key == 32) )  {
    spin_along_XY( XY_degree*PI/180 );  // перерисовка при нажатии ПРОБЕЛ
    
    find_canva_size( STL_triangles.length );  
    draw_canva_XY( STL_triangles.length );
    draw_canva_ZY( STL_triangles.length );
    
    println( STL_triangles.length );
    s_log = "ПРОЕКЦИИ ПЕРЕРИСОВАНЫ";
  }
  
  if ( ( b_file_is_selected == true )&(b_file_is_opened == false)&(key == 32) )  {
    open_STL_file();  // открытие файла при нажатии ПРОБЕЛ
  }
  
  if (  (b_file_is_selected == true )&(b_file_is_opened == true) )  {
    if (key == '0')  { byte_XYZ_choze = 0; }
    if (key == '1')  { byte_XYZ_choze = 1; }
    if (key == '2')  { byte_XYZ_choze = 2; }
    if (key == '3')  { byte_XYZ_choze = 3; }
    if (key == '4')  { byte_XYZ_choze = 4; }
    
    if ( (byte_XYZ_choze == 1)&(keyCode == UP) )  {
      XY_degree = XY_degree + 0.25;
    }
    if ( (byte_XYZ_choze == 1)&(keyCode == DOWN) )  {
      XY_degree = XY_degree - 0.25;
    }
    
    if ( (byte_XYZ_choze == 2)&(keyCode == UP) )  {
      YX_degree = YX_degree + 0.25;
    }
    if ( (byte_XYZ_choze == 2)&(keyCode == DOWN) )  {
      YX_degree = YX_degree - 0.25;
    }
    
    if ( (byte_XYZ_choze == 3)&(keyCode == UP) )  {
      ZY_degree = ZY_degree + 0.25;
    }
    if ( (byte_XYZ_choze == 3)&(keyCode == DOWN) )  {
      ZY_degree = ZY_degree - 0.25;
    }
    
    if ( (byte_XYZ_choze == 4)&(keyCode == UP) )  {
      YZ_degree = YZ_degree + 0.25;
    }
    if ( (byte_XYZ_choze == 4)&(keyCode == DOWN) )  {
      YZ_degree = YZ_degree - 0.25;
    }
    
    if (XY_degree > max_offset_degree) { XY_degree = max_offset_degree; }  // ограничение по максимальному перекосу
    if (XY_degree < -max_offset_degree) { XY_degree = -max_offset_degree; }
    if (YX_degree > max_offset_degree) { YX_degree = max_offset_degree; }
    if (YX_degree < -max_offset_degree) { YX_degree = -max_offset_degree; }
    if (ZY_degree > max_offset_degree) { ZY_degree = max_offset_degree; }
    if (ZY_degree < -max_offset_degree) { ZY_degree = -max_offset_degree; }
    if (YZ_degree > max_offset_degree) { YZ_degree = max_offset_degree; }
    if (YZ_degree < -max_offset_degree) { YZ_degree = -max_offset_degree; }
      
    //}
  }
    
}

void select_STL_file(File selection)  {
  if (selection == null) {
    s_log = "ФАЙЛ НЕ ВЫБРАН";
    //println( "Window was closed or the user hit cancel." );
  } else {
    s_STL_file_path = selection.getAbsolutePath();
    b_file_is_selected = true;
    
    s_STL_file_name = s_STL_file_path;
    
    while (s_STL_file_name.indexOf("/")>=0)  {    // отрезаем все разделители из пути к файлу
      //println(s_STL_file_name.indexOf("/"));
      s_STL_file_name = s_STL_file_name.substring( s_STL_file_name.indexOf("/")+1 );
    }
    
    s_STL_file_path = s_STL_file_path.substring( 0, s_STL_file_path.indexOf( s_STL_file_name ) );
    
    s_log = "ФАЙЛ ВЫБРАН";
  }
}

void open_STL_file() {
  int int_elements_count = 0;
  
  //println("попытка открыть файл");
  s_log = "ПОПЫТКА ОТКРЫТЬ ФАЙЛ...";
  
  f_STL_file = loadStrings( s_STL_file_path + s_STL_file_name );
  
  for (int i =0; i<f_STL_file.length; i++)  {
    if ( f_STL_file[i].indexOf("outer loop") > 0 )  {
      int_elements_count++;
    }
  }
  //println(int_elements_count);
  
  if (int_elements_count > 3)  {  // действие, если файл содержит упоменание граней
  
  STL_triangles = new STL_data[int_elements_count];  //  определили размер массива и его данные
  STL_buffer = new STL_data[int_elements_count];
  
  for (int i=0; i<int_elements_count; i++)  {
    
    STL_triangles[i] = new STL_data();  
    STL_buffer[i] = new STL_data(); 
  }
    read_STL_file();
    find_canva_size( int_elements_count );
    draw_canva_XY( int_elements_count );
    draw_canva_ZY( int_elements_count );
    
  } else {
    b_file_is_selected = false;
    s_log = "ФАЙЛ НЕ СОДЕРЖИТ КОРРЕКТНЫХ ДАННЫХ О ПОЛИГОНАХ";
  }
  
  //println(int_elements_count);
}

void read_STL_file()  {
  int count = 0;
  String bufer_str_x = "",
         bufer_str_y = "",
         bufer_str_z = "";
  
  for (int i=0; i<f_STL_file.length; i++)  {  // построчно парсим STL-файл
    
    String bufer_str = f_STL_file[i];
    //println( bufer_str );
    if ( bufer_str.indexOf("facet normal ")>0 )  {  // нашли и парсим строку данных НОРМАЛИ
      bufer_str = bufer_str.substring( bufer_str.indexOf("normal") + 1 );
      bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      bufer_str_x = bufer_str.substring( 0, bufer_str.indexOf(" ") );
      bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      bufer_str_y = bufer_str.substring( 0, bufer_str.indexOf(" ") );
      
      bufer_str_z = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      STL_triangles[count].xn = Float.parseFloat( bufer_str_x );
      STL_triangles[count].yn = Float.parseFloat( bufer_str_y );
      STL_triangles[count].zn = Float.parseFloat( bufer_str_z );
      
      bufer_str = f_STL_file[i+2]; // нашли и парсим строку данных ПЕРВОЙ точки треугольника
      bufer_str = bufer_str.substring( bufer_str.indexOf("vertex") + 1 );
      bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      bufer_str_x = bufer_str.substring( 0, bufer_str.indexOf(" ") );
      bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      bufer_str_y = bufer_str.substring( 0, bufer_str.indexOf(" ") );
      
      bufer_str_z = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      STL_triangles[count].x1 = Float.parseFloat( bufer_str_x );
      STL_triangles[count].y1 = Float.parseFloat( bufer_str_y );
      STL_triangles[count].z1 = Float.parseFloat( bufer_str_z );
      
      bufer_str = f_STL_file[i+3]; // нашли и парсим строку данных ВТОРОЙ точки треугольника
      bufer_str = bufer_str.substring( bufer_str.indexOf("vertex") + 1 );
      bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      bufer_str_x = bufer_str.substring( 0, bufer_str.indexOf(" ") );
      bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      bufer_str_y = bufer_str.substring( 0, bufer_str.indexOf(" ") );
      
      bufer_str_z = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      STL_triangles[count].x2 = Float.parseFloat( bufer_str_x );
      STL_triangles[count].y2 = Float.parseFloat( bufer_str_y );
      STL_triangles[count].z2 = Float.parseFloat( bufer_str_z );
      
      bufer_str = f_STL_file[i+4]; // нашли и парсим строку данных ТРЕТЬЕЙ точки треугольника
      bufer_str = bufer_str.substring( bufer_str.indexOf("vertex") + 1 );
      bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      bufer_str_x = bufer_str.substring( 0, bufer_str.indexOf(" ") );
      bufer_str = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      bufer_str_y = bufer_str.substring( 0, bufer_str.indexOf(" ") );
      
      bufer_str_z = bufer_str.substring( bufer_str.indexOf(" ") + 1 );
      
      STL_triangles[count].x3 = Float.parseFloat( bufer_str_x );
      STL_triangles[count].y3 = Float.parseFloat( bufer_str_y );
      STL_triangles[count].z3 = Float.parseFloat( bufer_str_z );
      
      STL_buffer[count].x1 = STL_triangles[count].x1;  // скопировать данные в буфер
      STL_buffer[count].y1 = STL_triangles[count].y1;
      STL_buffer[count].z1 = STL_triangles[count].z1;
      STL_buffer[count].x2 = STL_triangles[count].x2;
      STL_buffer[count].y2 = STL_triangles[count].y2;
      STL_buffer[count].z2 = STL_triangles[count].z2;
      STL_buffer[count].x3 = STL_triangles[count].x3;
      STL_buffer[count].y3 = STL_triangles[count].y3;
      STL_buffer[count].z3 = STL_triangles[count].z3;
      STL_buffer[count].xn = STL_triangles[count].xn;
      STL_buffer[count].yn = STL_triangles[count].yn;
      STL_buffer[count].zn = STL_triangles[count].zn;
      /*
      print( STL_triangles[count].xn + ";");
      print( STL_triangles[count].yn + ";");
      println( STL_triangles[count].zn );
      print( STL_triangles[count].x1 + ";");
      print( STL_triangles[count].y1 + ";");
      println( STL_triangles[count].z1 );
      print( STL_triangles[count].x2 + ";");
      print( STL_triangles[count].y2 + ";");
      println( STL_triangles[count].z2 );
      print( STL_triangles[count].x3 + ";");
      print( STL_triangles[count].y3 + ";");
      println( STL_triangles[count].z3 );
      println();
      */
    }
    
    if ( bufer_str.indexOf("endloop")>0 )  {
      count++;
      //println( count );
    }
    
  }
  //println( count );
  
  s_log = "ФАЙЛ ПРОЧИТАН";
  b_file_is_opened = true;
}

void find_canva_size(int count)  {  //поиск наибольших размеров модели

  float f_koeff_X = 1,
        f_koeff_Y = 1,
        f_koeff_Z = 1;
  
  f_max_X = -10000;
  f_max_Y = -10000;
  f_max_Z = -10000;
  f_min_X =  10000;
  f_min_Y =  10000;
  f_min_Z =  10000;
  f_koeff = 1;
  
  for (int i=0;i<count;i++)  {
    if (STL_buffer[i].x1 > f_max_X)  {    // поиск максимальных координат по X
      f_max_X = STL_buffer[i].x1;
    }
    if (STL_buffer[i].x2 > f_max_X)  {
      f_max_X = STL_buffer[i].x2;
    }
    if (STL_buffer[i].x3 > f_max_X)  {
      f_max_X = STL_buffer[i].x3;
    }
    
    if (STL_buffer[i].y1 > f_max_Y)  {    // поиск максимальных координат по Y
      f_max_Y = STL_buffer[i].y1;
    }
    if (STL_buffer[i].y2 > f_max_Y)  {
      f_max_Y = STL_buffer[i].y2;
    }
    if (STL_buffer[i].y3 > f_max_Y)  {
      f_max_Y = STL_buffer[i].y3;
    }
    
    if (STL_buffer[i].z1 > f_max_Z)  {    // поиск максимальных координат по Z
      f_max_Z = STL_buffer[i].z1;
    }
    if (STL_buffer[i].z2 > f_max_Z)  {
      f_max_Z = STL_buffer[i].z2;
    }
    if (STL_buffer[i].z3 > f_max_Z)  {
      f_max_Z = STL_buffer[i].z3;
    }
    
    if (STL_buffer[i].x1 < f_min_X)  {    // поиск минимальных координат по X
      f_min_X = STL_buffer[i].x1;
    }
    if (STL_buffer[i].x2 < f_min_X)  {
      f_min_X = STL_buffer[i].x2;
    }
    if (STL_buffer[i].x3 < f_min_X)  {
      f_min_X = STL_buffer[i].x3;
    }
    
    if (STL_buffer[i].y1 < f_min_Y)  {    // поиск минимальных координат по Y
      f_min_Y = STL_buffer[i].y1;
    }
    if (STL_buffer[i].y2 < f_min_Y)  {
      f_min_Y = STL_buffer[i].y2;
    }
    if (STL_buffer[i].y3 < f_min_Y)  {
      f_min_Y = STL_buffer[i].y3;
    }
    
    if (STL_buffer[i].z1 < f_min_Z)  {    // поиск минимальных координат по Z
      f_min_Z = STL_buffer[i].z1;
    }
    if (STL_buffer[i].z2 < f_min_Z)  {
      f_min_Z = STL_buffer[i].z2;
    }
    if (STL_buffer[i].z3 < f_min_Z)  {
      f_min_Z = STL_buffer[i].z3;
    }
    
  }
  
  f_koeff_X = canva_XY.width / (f_max_X - f_min_X) ;
  f_koeff_Y = canva_XY.height / (f_max_Y - f_min_Y) ;
  f_koeff_Z = canva_ZY.width / (f_max_Z - f_min_Z) ;
  /*
  println( f_min_X );
  println( f_max_X );
  println( f_min_Y );
  println( f_max_Y );
  println( f_min_Z );
  println( f_max_Z );
  
  println( f_koeff_X );
  println( f_koeff_Y );
  println( f_koeff_Z );
  */
  f_koeff = min( f_koeff_X, f_koeff_Y, f_koeff_Z )*0.9;
  
  //println( STL_triangles.length );
  
}

void draw_canva_XY(int count)  {
  
  float f_center_Y = (canva_XY.height - f_koeff * (f_max_Y - f_min_Y))/2,
        f_center_X = (canva_XY.width - f_koeff * (f_max_X - f_min_X))/2;
  
  canva_XY.beginDraw();
  canva_XY.background(255);
  canva_XY.noFill();
  
  for (int i=0;i<count;i++)  {
    if (STL_buffer[i].zn > 0)  {
      canva_XY.triangle( f_koeff * (STL_buffer[i].x1 - f_min_X) + f_center_X, canva_XY.height - (f_koeff * (STL_buffer[i].y1 - f_min_Y) + f_center_Y), 
                         f_koeff * (STL_buffer[i].x2 - f_min_X) + f_center_X, canva_XY.height - (f_koeff * (STL_buffer[i].y2 - f_min_Y) + f_center_Y), 
                         f_koeff * (STL_buffer[i].x3 - f_min_X) + f_center_X, canva_XY.height - (f_koeff * (STL_buffer[i].y3 - f_min_Y) + f_center_Y) );
    }
  }
  
  canva_XY.fill(0);
  canva_XY.textAlign(CENTER, CENTER);
  canva_XY.textSize( canva_XY.width*0.08 );
  canva_XY.text("X", canva_XY.width*0.97, canva_XY.height*0.96);
  canva_XY.text("Y", canva_XY.width*0.03, canva_XY.height*0.03);
  canva_XY.endDraw();
}

void draw_canva_ZY(int count)  {
  
  float f_center_Y = (canva_ZY.height - f_koeff * (f_max_Y - f_min_Y))/2,
        f_center_Z = (canva_ZY.width - f_koeff * (f_max_Z - f_min_Z))/2;
  
  canva_ZY.beginDraw();  
  canva_ZY.background(255);
  canva_ZY.noFill();
  
  for (int i=0;i<count;i++)  {
    if (STL_buffer[i].xn > 0)  {
      canva_ZY.triangle( f_koeff * (STL_buffer[i].z1 - f_min_Z) + f_center_Z, canva_ZY.height - (f_koeff * (STL_buffer[i].y1 - f_min_Y) + f_center_Y), 
                         f_koeff * (STL_buffer[i].z2 - f_min_Z) + f_center_Z, canva_ZY.height - (f_koeff * (STL_buffer[i].y2 - f_min_Y) + f_center_Y), 
                         f_koeff * (STL_buffer[i].z3 - f_min_Z) + f_center_Z, canva_ZY.height - (f_koeff * (STL_buffer[i].y3 - f_min_Y) + f_center_Y) );
    }
  }
  
  canva_ZY.fill(0);
  canva_ZY.textAlign(CENTER, CENTER);
  canva_ZY.textSize( canva_ZY.width*0.08 );
  canva_ZY.text("Z", canva_ZY.width*0.97, canva_ZY.height*0.96);
  canva_ZY.text("Y", canva_ZY.width*0.03, canva_ZY.height*0.03);
  canva_ZY.endDraw();
}

void draw_spin_menu()  {
  PGraphics graphic_XY = createGraphics( round( width*0.13 ), round( height*0.2 ) ),
            graphic_YX = createGraphics( round( width*0.13 ), round( height*0.2 ) ),
            graphic_ZY = createGraphics( round( width*0.13 ), round( height*0.2 ) ),
            graphic_YZ = createGraphics( round( width*0.13 ), round( height*0.2 ) );
            
  graphic_XY.beginDraw();  // отрисовка меню смещения X вдоль Y
  if (byte_XYZ_choze == 1)  {
    graphic_XY.background(150, 200, 150);
  } else {
    graphic_XY.background(150);
  }
  graphic_XY.fill(0);
  graphic_XY.quad( round(graphic_XY.width*0.2), round(graphic_XY.height*0.9),
                   round(graphic_XY.width*0.2), round(graphic_XY.height*0.2),
                   round(graphic_XY.width*0.8), round(graphic_XY.height*0.1),
                   round(graphic_XY.width*0.8), round(graphic_XY.height*0.8) );
  graphic_XY.textSize(graphic_XY.height*0.2);                 
  graphic_XY.text("1", graphic_XY.width*0.85, graphic_XY.height*0.2);
  graphic_XY.text("X", graphic_XY.width*0.85, graphic_XY.height*0.95);
  graphic_XY.text("Y", graphic_XY.width*0.05, graphic_XY.height*0.2);
  graphic_XY.fill(255);
  graphic_XY.textAlign(CENTER, CENTER);
  graphic_XY.text(XY_degree, graphic_XY.width/2, graphic_XY.height/2);
  graphic_XY.endDraw();
  
  graphic_YX.beginDraw();  // отрисовка меню смещения Y вдоль X
  if (byte_XYZ_choze == 2)  {
    graphic_YX.background(150, 200, 150);
  } else {
    graphic_YX.background(150);
  }
  graphic_YX.fill(0);
  graphic_YX.quad( round(graphic_YX.width*0.15), round(graphic_YX.height*0.9),
                   round(graphic_YX.width*0.25), round(graphic_YX.height*0.1),
                   round(graphic_YX.width*0.83), round(graphic_YX.height*0.1),
                   round(graphic_YX.width*0.73), round(graphic_YX.height*0.9) );
  graphic_YX.textSize(graphic_YX.height*0.2);                 
  graphic_YX.text("2", graphic_YX.width*0.85, graphic_YX.height*0.2);
  graphic_YX.text("X", graphic_YX.width*0.85, graphic_YX.height*0.95);
  graphic_YX.text("Y", graphic_YX.width*0.05, graphic_YX.height*0.2);
  graphic_YX.fill(255);
  graphic_YX.textAlign(CENTER, CENTER);
  graphic_YX.text(YX_degree, graphic_YX.width/2, graphic_YX.height/2);
  graphic_YX.endDraw();
  
  graphic_ZY.beginDraw();  // отрисовка меню смещения Z вдоль Y
  if (byte_XYZ_choze == 3)  {
    graphic_ZY.background(150, 200, 150);
  } else {
    graphic_ZY.background(150);
  }
  graphic_ZY.fill(0);
  graphic_ZY.quad( round(graphic_ZY.width*0.2), round(graphic_ZY.height*0.9),
                   round(graphic_ZY.width*0.2), round(graphic_ZY.height*0.2),
                   round(graphic_ZY.width*0.8), round(graphic_ZY.height*0.1),
                   round(graphic_ZY.width*0.8), round(graphic_ZY.height*0.8) );
  graphic_ZY.textSize(graphic_ZY.height*0.2);                 
  graphic_ZY.text("3", graphic_ZY.width*0.85, graphic_ZY.height*0.2);
  graphic_ZY.text("Z", graphic_ZY.width*0.85, graphic_ZY.height*0.95);
  graphic_ZY.text("Y", graphic_ZY.width*0.05, graphic_ZY.height*0.2);    
  graphic_ZY.fill(255);
  graphic_ZY.textAlign(CENTER, CENTER);
  graphic_ZY.text(ZY_degree, graphic_ZY.width/2, graphic_ZY.height/2);
  graphic_ZY.endDraw();
  
  graphic_YZ.beginDraw();  // отрисовка меню смещения Y вдоль Z
  if (byte_XYZ_choze == 4)  {
    graphic_YZ.background(150, 200, 150);
  } else {
    graphic_YZ.background(150);
  }
  graphic_YZ.fill(0);
  graphic_YZ.quad( round(graphic_YZ.width*0.15), round(graphic_YZ.height*0.9),
                   round(graphic_YZ.width*0.25), round(graphic_YZ.height*0.1),
                   round(graphic_YZ.width*0.83), round(graphic_YZ.height*0.1),
                   round(graphic_YZ.width*0.73), round(graphic_YZ.height*0.9) );
  graphic_YZ.textSize(graphic_YZ.height*0.2);                 
  graphic_YZ.text("4", graphic_YZ.width*0.85, graphic_YZ.height*0.2);
  graphic_YZ.text("Z", graphic_YZ.width*0.85, graphic_YZ.height*0.95);
  graphic_YZ.text("Y", graphic_YZ.width*0.05, graphic_YZ.height*0.2);  
  graphic_YZ.fill(255);
  graphic_YZ.textAlign(CENTER, CENTER);
  graphic_YZ.text(YZ_degree, graphic_YZ.width/2, graphic_YZ.height/2);
  graphic_YZ.endDraw();
  
  image( graphic_XY, width*0.85, height*(0.05+0.21*0) );
  image( graphic_YX, width*0.85, height*(0.05+0.21*1) );
  image( graphic_ZY, width*0.85, height*(0.05+0.21*2) );
  image( graphic_YZ, width*0.85, height*(0.05+0.21*3) );
}

void spin_along_XY( float alpha)  {
  
  for (int i=0;i<STL_triangles.length;i++)  {
    STL_buffer[i].y1 = STL_triangles[i].y1 + STL_triangles[i].x1*tan(alpha);
    STL_buffer[i].y2 = STL_triangles[i].y2 + STL_triangles[i].x2*tan(alpha);
    STL_buffer[i].y3 = STL_triangles[i].y3 + STL_triangles[i].x3*tan(alpha);
  }
  
}
