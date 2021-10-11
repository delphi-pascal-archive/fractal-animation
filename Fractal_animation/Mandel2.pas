unit Mandel2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ToolWin, Menus, ExtCtrls;

var
  xmin,xmax,ymin,ymax,xx,yy,aa,bb,rr,teta,phi,tt,tinitial,tfinal:extended;
  nn,nit,nframes,lx,ly:integer;
  nom:string;
  pic:tbitmap;
  stop,pause,fini:bool;

type
  TForm2 = class(TForm)
    PaintBox1: TPaintBox;
    procedure Arrter1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
  public
    xx,yy,xxx,yyy:integer;
    down:bool;
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.Arrter1Click(Sender: TObject);
begin
  stop:=true;
end;

procedure TForm2.PaintBox1Paint(Sender: TObject);
begin
  with paintbox1 do
    Canvas.stretchdraw(PaintBox1.clientrect,pic);
end;

procedure TForm2.FormResize(Sender: TObject);
begin
  if windowstate<>wsmaximized then begin
    paintbox1.align:=alnone;
    if clientwidth>pic.Width then
      width:=width-clientwidth+pic.Width;
    if clientheight>pic.height then
      height:=height-clientheight+pic.height;
  end else
    paintbox1.align:=alclient;
end;

procedure TForm2.ToolButton2Click(Sender: TObject);
begin
  stop:=true;
end;

procedure TForm2.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  caption:=floattostr(xmin+x*(xmax-xmin)/paintbox1.width)+' , '+floattostr(ymin+y*(ymax-ymin)/paintbox1.height);
  if down then begin
    paintbox1.Canvas.Rectangle(xx,yy,xxx,yyy);
    xx:=x;
    yy:=y;
    paintbox1.Canvas.Rectangle(xx,yy,xxx,yyy);
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  top:=0;
  left:=0;
  down:=false;
end;

procedure TForm2.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  stop:=true;
  down:=true;
  xxx:=x;
  yyy:=y;
  xx:=x;
  yy:=y;
  paintbox1.canvas.brush.style:=bsclear;
  paintbox1.canvas.pen.mode:=pmnot;
end;
end.
