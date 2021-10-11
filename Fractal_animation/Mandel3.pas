unit Mandel3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, ToolWin, Menus;

type
  ttab=array[0..20,0..20] of integer;
  tpoly=array[0..20] of extended;
  tpalette=array[0..2] of tpoly;
  TForm3=class(TForm)
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    Panel2: TPanel;
    PaintBox2: TPaintBox;
    Splitter1: TSplitter;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ComboBox1: TComboBox;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    Ouvrir1: TMenuItem;
    Enregistrer1: TMenuItem;
    Prfabriqus1: TMenuItem;
    Dfaut1: TMenuItem;
    Cycle3couleurs1: TMenuItem;
    Random1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure PaintBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Ouvrir1Click(Sender: TObject);
    procedure Enregistrer1Click(Sender: TObject);
    procedure Cycle3couleurs1Click(Sender: TObject);
    procedure Dfaut1Click(Sender: TObject);
    procedure Random1Click(Sender: TObject);
  private
    down:bool;
    ind,xx,yy:integer;
    procedure ellipse(x,y:integer);
  public
  end;

const
  n:byte=20;

var
  Form3:TForm3;
  cnk:ttab;
  points,pal:tpalette;

function evalpoly(p:tpoly;t:extended):extended;
function evalpalette(p:tpalette;t:extended):tcolor;
function adjust(t:tpoly):tpoly;

implementation

{$R *.DFM}

function evalpoly(p:tpoly;t:extended):extended;
var
  s,u:extended;
  a:integer;
begin
  s:=0;
  u:=1;
  for a:=0 to n do begin
    s:=s+p[a]*u;
    u:=u*t;
  end;
  evalpoly:=s;
end;

function evalpalette(p:tpalette;t:extended):tcolor;
begin
  evalpalette:=rgb(trunc(256*(1-evalpoly(p[0],t))),trunc(256*(1-evalpoly(p[1],t))),trunc(256*(1-evalpoly(p[2],t))));
end;

function adjust(t:tpoly):tpoly;
var
  i,j,k:integer;
  u:tpoly;
begin
  for i:=0 to n do u[i]:=0;
  for k:=0 to n do begin
    j:=1;
    for i:=0 to n-k do begin
      u[k+i]:=u[k+i]+j*cnk[n-k,i]*cnk[n,k]*t[k];
      j:=-j;
    end;
  end;
  adjust:=u;
end;

procedure makecnk;
var
  a,b:byte;
begin
  for a:=0 to n do begin
    if a<>n then cnk[a,a+1]:=0;
    cnk[a,0]:=1;
    for b:=1 to a do
      cnk[a,b]:=cnk[a-1,b]+cnk[a-1,b-1];
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  top:=screen.height-height;
  left:=0;
  combobox1.itemindex:=0;
  down:=false;
end;

procedure TForm3.PaintBox2Paint(Sender: TObject);
const
  t:array[0..2] of tcolor=(clred,clgreen,clblue);
var
  a,x1,lx,y1,ly:integer;
begin
  with paintbox2 do begin
    canvas.brush.color:=t[combobox1.itemindex];
    canvas.fillrect(clientrect);
    x1:=10;
    lx:=clientwidth-20;
    y1:=10;
    ly:=clientheight-20;
    canvas.moveto(x1,y1+round(ly*evalpoly(pal[combobox1.itemindex],0)));
    for a:=0 to lx do
      canvas.lineto(x1+a,y1+round(ly*evalpoly(pal[combobox1.itemindex],a/lx)));
    for a:=0 to n do
      ellipse(x1+((a*lx) div n),y1+round(ly*points[combobox1.itemindex,a]));
  end;
end;

procedure TForm3.PaintBox1Paint(Sender: TObject);
var
  a:integer;
begin
  with paintbox1 do begin
    for a:=0 to clientwidth do begin
      canvas.pen.color:=evalpalette(pal,a/clientwidth);
      canvas.moveto(a,0);
      canvas.lineto(a,clientheight);
    end;
  end;
end;

procedure TForm3.ComboBox1Change(Sender: TObject);
begin
  paintbox2.repaint;
end;

procedure tform3.ellipse(x,y:integer);
begin
  paintbox2.canvas.pen.mode:=pmnot;
  paintbox2.canvas.brush.style:=bsclear;
  paintbox2.canvas.ellipse(x-3,y-3,x+3,y+3);
  paintbox2.canvas.brush.style:=bssolid;
  paintbox2.canvas.pen.mode:=pmcopy;
end;

function minn(x,y:integer):integer;
begin
  if x<y then minn:=x else minn:=y;
end;

function maxn(x,y:integer):integer;
begin
  if x>y then maxn:=x else maxn:=y;
end;

procedure TForm3.PaintBox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  a:integer;
  t:bool;
begin
  with paintbox2 do begin
    t:=false;
    for a:=0 to n do
      if abs(10+((a*(clientwidth-20)) div n)-x)+abs(round(10+(clientheight-20)*points[combobox1.itemindex,a])-y)<10 then begin
        t:=true;
        ind:=a;
      end;
    down:=t;
    if t then begin
      xx:=10+((ind*(clientwidth-20)) div n);
      yy:=minn(maxn(10,y),clientheight-10);
      ellipse(xx,yy);
    end;
  end;
end;

procedure TForm3.PaintBox2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if down then with paintbox2 do begin
    ellipse(xx,yy);
    xx:=10+((ind*(clientwidth-20)) div n);
    yy:=minn(maxn(10,y),clientheight-10);
    ellipse(xx,yy);
  end;
end;

procedure TForm3.PaintBox2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if down then with paintbox2 do begin
    xx:=10+((ind*(clientwidth-20)) div n);
    yy:=minn(maxn(10,y),clientheight-10);
    points[combobox1.itemindex,ind]:=(yy-10)/(clientheight-20);
    if ind=n then points[combobox1.itemindex,0]:=(yy-10)/(clientheight-20);
    if ind=0 then points[combobox1.itemindex,n]:=(yy-10)/(clientheight-20);
    pal[combobox1.itemindex]:=adjust(points[combobox1.itemindex]);
    down:=false;
    paintbox2.repaint;
    paintbox1.repaint;
  end;
end;

procedure TForm3.Ouvrir1Click(Sender: TObject);
var
  f:file of tpalette;
begin
  if opendialog1.execute then begin
    assignfile(f,opendialog1.filename);
    reset(f);
    read(f,pal);
    read(f,points);
    closefile(f);
    paintbox2.repaint;
    paintbox1.repaint;
  end;
end;

procedure TForm3.Enregistrer1Click(Sender: TObject);
var
  f:file of tpalette;
begin
  if savedialog1.execute then begin
    assignfile(f,savedialog1.filename);
    rewrite(f);
    write(f,pal);
    write(f,points);
    paintbox2.repaint;
    closefile(f);
  end;
end;

procedure TForm3.Cycle3couleurs1Click(Sender: TObject);
var
  a:integer;
begin
  for a:=0 to n do begin
    points[0,a]:=(1+cos(2*pi*a/n))/2;
    points[1,a]:=(1+cos(2*pi*a/n+1))/2;
    points[2,a]:=(1+cos(2*pi*a/n+2))/2;
  end;
  pal[0]:=adjust(points[0]);
  pal[1]:=adjust(points[1]);
  pal[2]:=adjust(points[2]);
  paintbox1.repaint;
  paintbox2.repaint;
end;

procedure TForm3.Dfaut1Click(Sender: TObject);
var
  a:integer;
begin
  for a:=0 to n do begin
    points[0,a]:=(1+cos(2*pi*a/n))/2;
    points[1,a]:=(1+cos(2*pi*a/n))/2;
    points[2,a]:=(1+cos(2*pi*a/n))/2;
  end;
  pal[0]:=adjust(points[0]);
  pal[1]:=adjust(points[1]);
  pal[2]:=adjust(points[2]);
  paintbox1.repaint;
  paintbox2.repaint;
end;

procedure TForm3.Random1Click(Sender: TObject);
var
  a:integer;
begin
  for a:=1 to n do begin
    points[0,a]:=random;
    points[1,a]:=random;
    points[2,a]:=random;
  end;
  points[0,0]:=points[0,n];
  points[1,0]:=points[1,n];
  points[2,0]:=points[2,n];
  pal[0]:=adjust(points[0]);
  pal[1]:=adjust(points[1]);
  pal[2]:=adjust(points[2]);
  paintbox1.repaint;
  paintbox2.repaint;
end;

initialization
  makecnk;
end.
