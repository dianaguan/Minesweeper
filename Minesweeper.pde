import de.bezier.guido.*;
public final static int NUM_ROWS = 20; 
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make(this);
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    //your code to declare and initialize buttons goes here
    for(int r = 0; r<NUM_ROWS; r++){
       for (int c = 0; c<NUM_COLS; c++){
          buttons[r][c] = new MSButton(r,c);
       }
    }

    setBombs();
}
public void setBombs()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[row][col])){
        bombs.add(buttons[row][col]);
        setBombs();
    }
}

public void draw ()
{
    background(0);
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
  for (int i =0; i< bombs.size (); i++) {
    if (bombs.get(i).isMarked() == false) {
      return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][9].setLabel(" ");
    buttons[9][10].setLabel("L");
    buttons[9][11].setLabel("O");
    buttons[9][12].setLabel("S");
    buttons[9][13].setLabel("E");
  for (int i =0; i < bombs.size (); i++) {
    bombs.get(i).marked = false;
    bombs.get(i).clicked = true;
  }
}
public void displayWinningMessage()
{
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][9].setLabel(" ");
    buttons[9][10].setLabel("W");
    buttons[9][11].setLabel("I");
    buttons[9][12].setLabel("N");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        //registers squares that have been clicked on 
        clicked = true;
        if(keyPressed==true)
            marked = true;
        else if(bombs.contains(this))
            displayLosingMessage();
        else if (countBombs(r,c)>0) {
            setLabel(""+countBombs(r,c));
        }
        else
        {

            for (int ro = r-1; ro<=r+1; ro++){
                for (int co = c-1; co<=c+1; co++){
                    if(!(ro==r && co==c)){
                        if(isValid(ro,co) && buttons[ro][co].isClicked()==false){
                            buttons[ro][co].mousePressed();
                        }
                    }
                }
            }
        }    
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r<NUM_ROWS && r>-1 && c>-1 && c<NUM_COLS){
            return true;

      }
        return false;
    }
    public int countBombs(int row, int col)
    {
        //checks for bombs
        int numBombs = 0;

        for (int ro = r-1; ro<=r+1; ro++){
            for (int co = c-1; co<=c+1; co++){
                if(isValid(ro,co) && bombs.contains(buttons[ro][co]))
                {
                    numBombs++;                    
                }
            }
        }


        return numBombs;
    }
}
