class stlLoop {
  float x1, x2, x3,
        y1, y2, y3,
        z1, z2, z3,
        xn, yn, zn;
  
  public stlLoop()  {
    this.x1 = 0;
    this.x2 = 0;
    this.x3 = 0;
    this.y1 = 0;
    this.y2 = 0;
    this.y3 = 0;
    this.z1 = 0;
    this.z2 = 0;
    this.z3 = 0;
    this.xn = 1;
    this.yn = 0;
    this.zn = 0;
  }
  
  public stlLoop( stlLoop original)  {
    this.x1 = original.x1;
    this.x2 = original.x2;
    this.x3 = original.x3;
    this.y1 = original.y1;
    this.y2 = original.y2;
    this.y3 = original.y3;
    this.z1 = original.z1;
    this.z2 = original.z2;
    this.z3 = original.z3;
    this.xn = original.xn;
    this.yn = original.yn;
    this.zn = original.zn;
  }
}
