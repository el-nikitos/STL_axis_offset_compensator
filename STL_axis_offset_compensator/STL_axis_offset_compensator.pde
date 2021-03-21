boolean b_file_is_selected = false,
        b_file_is_opened = false;

String  s_STL_file_path = "",
        s_STL_file_name = "",
        s_log = "ЗАПУСТИЛИСЬ";

String[] f_STL_file;

STL_data[] STL_triangles;

void setup()  {
  size(1300, 650);
  background(0);
  
  //while ( open_STL_file() == false )  {}
  selectInput("Select a file to process:", "select_STL_file");
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
    
    
  }
  
  fill(0);
  text( "КРАЙНЕЕ СОБЫТИЕ: " + s_log, width/2, height*0.95 );
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
  
  if (int_elements_count > 0)  {  // действие, если файл содержит упоменание вершин
  
  STL_triangles = new STL_data[int_elements_count];  //  определили размер массива и его данные
  for (int i=0; i<int_elements_count; i++)  {
    
    STL_triangles[i] = new STL_data();  
  }
    read_STL_file();
  } else {
    b_file_is_selected = false;
    s_log = "ФАЙЛ НЕ СОДЕРЖИТ ДАННЫХ О ПОЛИГОНАХ";
  }
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
