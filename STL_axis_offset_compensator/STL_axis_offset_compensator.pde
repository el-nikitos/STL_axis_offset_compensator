boolean b_file_is_selected = false,
        b_file_is_opened = false;

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

STL_data[] STL_triangles;

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
    //b_file_is_selected = false;  // сброс выбора файла при нажатии BACKSPACE
    b_file_is_opened = false;
    
    f_max_X = -10000;
    f_max_Y = -10000;
    f_max_Z = -10000;
    f_min_X =  10000;
    f_min_Y =  10000;
    f_min_Z =  10000;
    f_koeff = 1;
      
    s_log = "ВЫПОЛНЕН ВОЗВРАТ В МЕНЮ ВЫБОРА И ОТКРЫТИЯ ФАЙЛА";
  }
  
  if ( ( b_file_is_selected == false )&(b_file_is_opened == false)&(key == 32) )  {
    selectInput("Select a file to process:", "select_STL_file");  // выбор файл при нажатии ПРОБЕЛ
    s_log = "ОТКРЫТ ПРОВОДНИК ДЛЯ ВЫБОРА ФАЙЛА";
  }
  
  if ( ( b_file_is_selected == true )&(b_file_is_opened == false)&(key == 32) )  {
    open_STL_file();  // открытие файла при нажатии ПРОБЕЛ
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
  for (int i=0; i<int_elements_count; i++)  {
    
    STL_triangles[i] = new STL_data();  
  }
    read_STL_file();
    find_canva_size( int_elements_count );
    draw_canva_XY( int_elements_count );
    draw_canva_ZY( int_elements_count );
    
  } else {
    b_file_is_selected = false;
    s_log = "ФАЙЛ НЕ СОДЕРЖИТ КОРРЕКТНЫХ ДАННЫХ О ПОЛИГОНАХ";
  }
  
  println(int_elements_count);
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

  for (int i=0;i<count;i++)  {
    if (STL_triangles[i].x1 > f_max_X)  {    // поиск максимальных координат по X
      f_max_X = STL_triangles[i].x1;
    }
    if (STL_triangles[i].x2 > f_max_X)  {
      f_max_X = STL_triangles[i].x2;
    }
    if (STL_triangles[i].x3 > f_max_X)  {
      f_max_X = STL_triangles[i].x3;
    }
    
    if (STL_triangles[i].y1 > f_max_Y)  {    // поиск максимальных координат по Y
      f_max_Y = STL_triangles[i].y1;
    }
    if (STL_triangles[i].y2 > f_max_Y)  {
      f_max_Y = STL_triangles[i].y2;
    }
    if (STL_triangles[i].y3 > f_max_Y)  {
      f_max_Y = STL_triangles[i].y3;
    }
    
    if (STL_triangles[i].z1 > f_max_Z)  {    // поиск максимальных координат по Z
      f_max_Z = STL_triangles[i].z1;
    }
    if (STL_triangles[i].z2 > f_max_Z)  {
      f_max_Z = STL_triangles[i].z2;
    }
    if (STL_triangles[i].z3 > f_max_Z)  {
      f_max_Z = STL_triangles[i].z3;
    }
    
    if (STL_triangles[i].x1 < f_min_X)  {    // поиск минимальных координат по X
      f_min_X = STL_triangles[i].x1;
    }
    if (STL_triangles[i].x2 < f_min_X)  {
      f_min_X = STL_triangles[i].x2;
    }
    if (STL_triangles[i].x3 < f_min_X)  {
      f_min_X = STL_triangles[i].x3;
    }
    
    if (STL_triangles[i].y1 < f_min_Y)  {    // поиск минимальных координат по Y
      f_min_Y = STL_triangles[i].y1;
    }
    if (STL_triangles[i].y2 < f_min_Y)  {
      f_min_Y = STL_triangles[i].y2;
    }
    if (STL_triangles[i].y3 < f_min_Y)  {
      f_min_Y = STL_triangles[i].y3;
    }
    
    if (STL_triangles[i].z1 < f_min_Z)  {    // поиск минимальных координат по Z
      f_min_Z = STL_triangles[i].z1;
    }
    if (STL_triangles[i].z2 < f_min_Z)  {
      f_min_Z = STL_triangles[i].z2;
    }
    if (STL_triangles[i].z3 < f_min_Z)  {
      f_min_Z = STL_triangles[i].z3;
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
  f_koeff = min( f_koeff_X, f_koeff_Y, f_koeff_Z )*0.8;
  
}

void draw_canva_XY(int count)  {
  
  float f_center_Y = (canva_XY.height - f_koeff * (f_max_Y - f_min_Y))/2,
        f_center_X = (canva_XY.width - f_koeff * (f_max_X - f_min_X))/2;
  
  canva_XY.beginDraw();
  canva_XY.background(255);
  
  for (int i=0;i<count;i++)  {
    canva_XY.triangle( f_koeff * (STL_triangles[i].x1 - f_min_X) + f_center_X, f_koeff * (STL_triangles[i].y1 - f_min_Y) + f_center_Y, 
                       f_koeff * (STL_triangles[i].x2 - f_min_X) + f_center_X, f_koeff * (STL_triangles[i].y2 - f_min_Y) + f_center_Y, 
                       f_koeff * (STL_triangles[i].x3 - f_min_X) + f_center_X, f_koeff * (STL_triangles[i].y3 - f_min_Y) + f_center_Y );
  }
  
  canva_XY.endDraw();
  
}

void draw_canva_ZY(int count)  {
  
  float f_center_Y = (canva_ZY.height - f_koeff * (f_max_Y - f_min_Y))/2,
        f_center_Z = (canva_ZY.width - f_koeff * (f_max_Z - f_min_Z))/2;
  
  canva_ZY.beginDraw();
  canva_ZY.background(255);
  
  for (int i=0;i<count;i++)  {
    canva_ZY.triangle( f_koeff * (STL_triangles[i].z1 - f_min_Z) + f_center_Z, f_koeff * (STL_triangles[i].y1 - f_min_Y) + f_center_Y, 
                       f_koeff * (STL_triangles[i].z2 - f_min_Z) + f_center_Z, f_koeff * (STL_triangles[i].y2 - f_min_Y) + f_center_Y, 
                       f_koeff * (STL_triangles[i].z3 - f_min_Z) + f_center_Z, f_koeff * (STL_triangles[i].y3 - f_min_Y) + f_center_Y );
  }
  
  canva_ZY.endDraw();
    
}
