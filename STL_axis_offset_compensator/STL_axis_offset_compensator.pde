boolean b_file_is_selected = false,
        b_file_is_opened = false;

String  s_STL_file_path = "",
        s_STL_file_name = "";

String[] f_STL_file;

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
  
  if ( b_file_is_selected == false )  {
    background(150, 50, 50);
    text("ФАЙЛ НЕ ВЫБРАН", width/2, height*0.4 );
    text("ДЛЯ ВЫБОРА ФАЙЛА КЛИКНИТЕ ПО РАБОЧЕМУ ПОЛЮ ИЛИ НАЖМИТЕ 'ПРОБЕЛ'", width/2, height*0.5 );
  } else {
    background(100, 150, 100);
    text("ФАЙЛ ВЫБРАН", width/2, height*0.2 );
    text("ПУТЬ К ВЫБРАННОМУ ФАЙЛУ:", width/2, float(height)*0.3 );
    text( s_STL_file_path , width/2, float(height)*0.37 );
    text("ИМЯ ФАЙЛА:", width/2, float(height)*0.5 );
    text( s_STL_file_name , width/2, float(height)*0.57 );
    
    fill(0);
    text("ДЛЯ ОТКРЫТИЯ ФАЙЛА КЛИКНИТЕ ПО РАБОЧЕМУ ПОЛЮ ИЛИ НАЖМИТЕ 'ПРОБЕЛ'", width/2, height*0.7 );
    fill(150, 50, 50);
    text("ДЛЯ ВЫБОРА ДРУГОГО ФАЙЛА НАЖМИТЕ 'BACKSPACE'", width/2, height*0.77 );
  }
  
}

void mouseClicked() {
  if ( ( b_file_is_selected == false )&(b_file_is_opened == false) )  {
    selectInput("Select a file to process:", "select_STL_file");
  }
  
  if ( ( b_file_is_selected == true )&(b_file_is_opened == false) )  {
    open_STL_file();
  }
}

void keyPressed() {
  if ( ( b_file_is_selected == true )&(b_file_is_opened == false)&(keyCode == BACKSPACE) )  {
    b_file_is_selected = false;  // сброс выбора файла при нажатии BACKSPACE
  }
  
  if ( ( b_file_is_selected == false )&(b_file_is_opened == false)&(key == 32) )  {
    selectInput("Select a file to process:", "select_STL_file");  // выбор файл при нажатии ПРОБЕЛ
  }
  
  if ( ( b_file_is_selected == true )&(b_file_is_opened == false)&(key == 32) )  {
    open_STL_file();  // открытие файла при нажатии ПРОБЕЛ
  }
    
}

void select_STL_file(File selection)  {
  if (selection == null) {
    
    println( "Window was closed or the user hit cancel." );
  } else {
    s_STL_file_path = selection.getAbsolutePath();
    b_file_is_selected = true;
    
    s_STL_file_name = s_STL_file_path;
    
    while (s_STL_file_name.indexOf("/")>=0)  {    // отрезаем все разделители из пути к файлу
      //println(s_STL_file_name.indexOf("/"));
      s_STL_file_name = s_STL_file_name.substring( s_STL_file_name.indexOf("/")+1 );
    }
    
    s_STL_file_path = s_STL_file_path.substring( 0, s_STL_file_path.indexOf( s_STL_file_name ) );
    
    println( "User selected: " + s_STL_file_path );
    println( "File name: " + s_STL_file_name );
  }
}

int open_STL_file() {
  int int_elements_count = 0;
  
  println("попытка открыть файл");
  
  f_STL_file = loadStrings( s_STL_file_path + s_STL_file_name );
  
  for (int i =0; i<f_STL_file.length; i++)  {
    if ( f_STL_file[i].indexOf("outer loop") > 0 )  {
      int_elements_count++;
    }
  }
  //println(int_elements_count);
  
  return int_elements_count;
}
