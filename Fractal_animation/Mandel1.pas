unit Mandel1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtDlgs, ComCtrls, ToolWin, Menus, mandel2, mandel3;

type
  tconfig=record
    _f,_z0,_c,_nframes,_output,_res,_teta,_phi,_nit,_t0,_t1,_x1,_x2,_y1,_y2,_ort:string;
  end;
  pstring=^string;
  tcomplex=record
    x,y:extended;
  end;
  tfunc=function:tcomplex of object;
  tarbre=class
    data:tlist;
    value:tfunc;
    val:tcomplex;
    constructor create(s:string);
    destructor destroy;override;
    function _sqr:tcomplex;
    function _ln:tcomplex;
    function _sin:tcomplex;
    function _cos:tcomplex;
    function _exp:tcomplex;
    function _add:tcomplex;
    function _mult:tcomplex;
    function _div:tcomplex;
    function _val:tcomplex;
    function _z:tcomplex;
    function _c:tcomplex;
    function _i:tcomplex;
    function _e:tcomplex;
    function _n:tcomplex;
    function _r:tcomplex;
    function _nit:tcomplex;
    function _t:tcomplex;
    function _opp:tcomplex;
    function _expo:tcomplex;
    function _egal:tcomplex;
    function _inf:tcomplex;
    function _sup:tcomplex;
    function _if:tcomplex;
    function _pi:tcomplex;
  end;
  TForm1 = class(TForm)
    SavePictureDialog1: TSavePictureDialog;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton1: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ToolButton4: TToolButton;
    PopupMenu1: TPopupMenu;
    Chargerscript1: TMenuItem;
    Enregistrerscript1: TMenuItem;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    GroupBox2: TGroupBox;
    StaticText5: TStaticText;
    Edit5: TEdit;
    StaticText13: TStaticText;
    Button3: TButton;
    StaticText12: TStaticText;
    ComboBox1: TComboBox;
    Button2: TButton;
    StaticText18: TStaticText;
    Edit16: TEdit;
    StaticText19: TStaticText;
    Edit17: TEdit;
    StaticText17: TStaticText;
    Edit15: TEdit;
    GroupBox3: TGroupBox;
    StaticText4: TStaticText;
    Edit4: TEdit;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    CheckBox1: TCheckBox;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    Edit6: TEdit;
    Edit7: TEdit;
    Button7: TButton;
    GroupBox4: TGroupBox;
    CheckBox2: TCheckBox;
    StaticText14: TStaticText;
    Edit13: TEdit;
    StaticText15: TStaticText;
    Edit14: TEdit;
    StaticText16: TStaticText;
    GroupBox5: TGroupBox;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    StaticText20: TStaticText;
    StaticText21: TStaticText;
    CheckBox3: TCheckBox;
    StaticText22: TStaticText;
    Edit18: TEdit;
    StaticText23: TStaticText;
    Edit19: TEdit;
    OpenDialog2: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button7Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure Chargerscript1Click(Sender: TObject);
    procedure Enregistrerscript1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ToolButton2Click(Sender: TObject);
  private
    procedure trace;
  public
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
  end;

var
  Form1:TForm1;
  pal0:tpalette;
  list:tlist;

implementation

{$R *.DFM}

procedure writearray(var f:textfile;t:array of string);
var
  a:integer;
begin
  for a:=0 to high(t) do writeln(f,t[a]);
end;

procedure readarray(var f:textfile;t:array of pstring);
var
  a:integer;
  s:string;
begin
  for a:=0 to high(t) do begin
    readln(f,s);
    t[a]^:=s;
  end;
end;

constructor tarbre.create(s:string);
label
  fin,debut;
var
  a,b:integer;
  t:string;
begin
  debut:
  data:=tlist.create;
  while s[1]='+' do s:=copy(s,2,length(s)-1);
  a:=length(s);
  b:=0;
  while a>=1 do begin
    case s[a] of
      ')':inc(b);
      '(':dec(b);
      '+':if b=0 then begin
            data.add(tarbre.create(copy(s,a+1,length(s)-a)));
            data.add(tarbre.create(copy(s,1,a-1)));
            value:=_add;
            a:=0;
          end;
      '-':if (b=0) and (a<>1) then begin
            data.add(tarbre.create(copy(s,a,length(s)-a+1)));
            data.add(tarbre.create(copy(s,1,a-1)));
            value:=_add;
            a:=0;
          end;
    end;
    dec(a);
  end;
  if data.count<>0 then exit;
  if s[1]='-' then begin
    data.add(tarbre.create(copy(s,2,length(s)-1)));
    value:=_opp;
    goto fin;
  end;
  a:=length(s);
  b:=0;
  while a>=1 do begin
    case s[a] of
      ')':inc(b);
      '(':dec(b);
      '*':if b=0 then begin
            data.add(tarbre.create(copy(s,a+1,length(s)-a)));
            data.add(tarbre.create(copy(s,1,a-1)));
            value:=_mult;
            a:=0;
          end;
      '/':if b=0 then begin
            data.add(tarbre.create(copy(s,1,a-1)));
            data.add(tarbre.create(copy(s,a+1,length(s)-a)));
            value:=_div;
            a:=0;
          end;
    end;
    dec(a);
  end;
  if data.count<>0 then exit;
  a:=length(s);
  b:=0;
  while a>=1 do begin
    case s[a] of
      ')':inc(b);
      '(':dec(b);
      '^':if b=0 then begin
            data.add(tarbre.create(copy(s,1,a-1)));
            data.add(tarbre.create(copy(s,a+1,length(s)-a)));
            value:=_expo;
            a:=0;
          end;
    end;
    dec(a);
  end;
  if data.count<>0 then exit;
  a:=length(s);
  b:=0;
  while a>=1 do begin
    case s[a] of
      ')':inc(b);
      '(':dec(b);
      '=':if b=0 then begin
            data.add(tarbre.create(copy(s,a+1,length(s)-a)));
            data.add(tarbre.create(copy(s,1,a-1)));
            value:=_egal;
            a:=0;
          end;
      '<':if b=0 then begin
            data.add(tarbre.create(copy(s,1,a-1)));
            data.add(tarbre.create(copy(s,a+1,length(s)-a)));
            value:=_inf;
            a:=0;
          end;
      '>':if b=0 then begin
            data.add(tarbre.create(copy(s,1,a-1)));
            data.add(tarbre.create(copy(s,a+1,length(s)-a)));
            value:=_sup;
            a:=0;
          end;
    end;
    dec(a);
  end;
  if data.count<>0 then exit;
  if (s[1]='(') and (s[length(s)]=')') then begin
    s:=copy(s,2,length(s)-2);
    goto debut;
  end;
  a:=0;
  while (s[a]<>'(') and (a<=length(s)) do inc(a);
  t:=copy(s,1,a-1);
  if s='c' then begin value:=_c;goto fin;end;
  if s='z' then begin value:=_z;goto fin;end;
  if s='i' then begin value:=_i;goto fin;end;
  if s='nit' then begin value:=_nit;goto fin;end;
  if s='n' then begin value:=_n;goto fin;end;
  if s='r' then begin value:=_r;goto fin;end;
  if s='t' then begin value:=_t;goto fin;end;
  if s='e' then begin value:=_e;goto fin;end;
  if s='pi' then begin value:=_pi;goto fin;end;
  if t='sqr' then begin value:=_sqr;data.add(tarbre.create(copy(s,a+1,length(s)-a-1)));goto fin;end;
  if t='ln' then begin value:=_ln;data.add(tarbre.create(copy(s,a+1,length(s)-a-1)));goto fin;end;
  if t='cos' then begin value:=_cos;data.add(tarbre.create(copy(s,a+1,length(s)-a-1)));goto fin;end;
  if t='sin' then begin value:=_sin;data.add(tarbre.create(copy(s,a+1,length(s)-a-1)));goto fin;end;
  if t='exp' then begin value:=_exp;data.add(tarbre.create(copy(s,a+1,length(s)-a-1)));goto fin;end;
  if t='if' then begin
    t:=copy(s,a+1,length(s)-a-1);
    a:=pos(',',t);
    data.add(tarbre.create(copy(t,1,a-1)));
    t:=copy(t,a+1,length(t)-a);
    a:=pos(',',t);
    data.add(tarbre.create(copy(t,1,a-1)));
    data.add(tarbre.create(copy(t,a+1,length(t)-a)));
    value:=_if;
    goto fin;
  end;
  val.x:=strtofloat(s);
  val.y:=0;
  value:=_val;
  fin:
end;

destructor tarbre.destroy;
var
  a:integer;
begin
  for a:=data.count-1 downto 0 do tarbre(data[a]).destroy;
  data.destroy;
  inherited destroy;
end;

function tarbre._sqr:tcomplex;
begin
  with tarbre(data[0]).value do begin
    _sqr.x:=sqr(x)-sqr(y);
    _sqr.y:=2*x*y;
  end;
end;

function tarbre._ln:tcomplex;
begin
  _ln.x:=ln(tarbre(data[0]).value.x);
  _ln.y:=0;
end;

function cosh(x:real):extended;
begin
  cosh:=(exp(x)+exp(-x))/2;
end;

function sinh(x:real):extended;
begin
  sinh:=(exp(x)-exp(-x))/2;
end;

function tarbre._cos:tcomplex;
var
  c:tcomplex;
begin
  c:=tarbre(data[0]).value;
  _cos.x:=cos(c.x)*cosh(c.y);
  _cos.y:=-sin(c.x)*sinh(c.y);
end;

function tarbre._exp:tcomplex;
var
  c:tcomplex;
  r:extended;
begin
  c:=tarbre(data[0]).value;
  r:=exp(c.x);
  _exp.x:=r*cos(c.y);
  _exp.y:=r*sin(c.y);
end;

function tarbre._sin:tcomplex;
var
  c:tcomplex;
begin
  c:=tarbre(data[0]).value;
  _sin.x:=cos(c.x)*sinh(c.y);
  _sin.y:=sin(c.x)*cosh(c.y);
end;

function tarbre._opp:tcomplex;
begin
  with tarbre(data[0]).value do begin
    _opp.x:=-x;
    _opp.y:=-y;
  end;
end;

function tarbre._add:tcomplex;
var
  c:tcomplex;
begin
  c:=tarbre(data[1]).value;
  with tarbre(data[0]).value do begin
    _add.x:=x+c.x;
    _add.y:=y+c.y;
  end;
end;

function tarbre._div:tcomplex;
var
  c:tcomplex;
  r:real;
begin
  c:=tarbre(data[0]).value;
  with tarbre(data[1]).value do begin
    r:=sqr(x)+sqr(y);
    _div.x:=(x*c.x-y*c.y)/r;
    _div.y:=(y*c.x+x*c.y)/r;
  end;
end;

function tarbre._mult:tcomplex;
var
  c:tcomplex;
begin
  c:=tarbre(data[1]).value;
  with tarbre(data[0]).value do begin
    _mult.x:=x*c.x-y*c.y;
    _mult.y:=x*c.y+y*c.x;
  end;
end;

function tarbre._inf:tcomplex;
begin
    if tarbre(data[0]).value.x<tarbre(data[1]).value.x then
      _inf.x:=1 else _inf.x:=0;
    _inf.y:=0;
end;

function tarbre._sup:tcomplex;
begin
  if tarbre(data[0]).value.x>tarbre(data[1]).value.x then
    _sup.x:=1 else _sup.x:=0;
  _sup.y:=0;
end;

function tarbre._egal:tcomplex;
var
  c:tcomplex;
begin
  c:=tarbre(data[0]).value;
  with tarbre(data[1]).value do
    if (c.x=x) and (c.y=y) then _egal.x:=1 else _egal.x:=0;
    _egal.y:=0;
end;

function tarbre._if:tcomplex;
begin
  if tarbre(data[0]).value.x=1 then
    _if:=tarbre(data[1]).value
  else
    _if:=tarbre(data[2]).value
end;

function sign(x:extended):shortint;
begin
  if x<0 then sign:=-1 else sign:=1;
end;

function _exp(c:tcomplex):tcomplex;
var
  r:real;
begin
  r:=exp(c.x);
  _exp.x:=r*cos(c.y);
  _exp.y:=r*sin(c.x);
end;

function pow(x,y:extended):extended;
begin
  if abs(x)<1E-5 then
    pow:=0
  else
    pow:=exp(ln(x)*y)
end;

function tarbre._expo:tcomplex;
var
  c:tcomplex;
  r,s:extended;
begin
  c:=tarbre(data[0]).value;
  with tarbre(data[1]).value do begin
    if abs(c.y)<1E-10 then begin
      if abs(c.x)<1E-100 then begin
        _expo.x:=0;
        _expo.y:=0;
      end else begin
        if c.x>0 then begin
          _expo.x:=pow(c.x,x);
          _expo.y:=0;
          exit;
        end else begin
          r:=pow(-c.x,x);
          s:=pi*x;
          _expo.x:=r*cos(s);
          _expo.y:=r*sin(s);
        end;
      end;
    end else begin
      r:=pow(sqr(c.x)+sqr(c.y),x/2);
      s:=-x*(arctan(c.x/c.y)-pi*sign(c.y)/2);
      _expo.x:=r*cos(s);
      _expo.y:=r*sin(s);
    end;
  end;
end;

function tarbre._val:tcomplex;
begin
  _val:=val;
end;

function tarbre._z:tcomplex;
begin
  _z.x:=xx;
  _z.y:=yy;
end;

function tarbre._c:tcomplex;
begin
  _c.x:=aa;
  _c.y:=bb;
end;

function tarbre._i:tcomplex;
begin
  _i.x:=0;
  _i.y:=1;
end;

function tarbre._e:tcomplex;
begin
  _e.x:=2.71828;
  _e.y:=0;
end;

function tarbre._r:tcomplex;
begin
  _r.x:=rr;
  _r.y:=0;
end;

function tarbre._nit:tcomplex;
begin
  _nit.x:=nit;
  _nit.y:=0;
end;

function tarbre._t:tcomplex;
begin
  _t.x:=tt;
  _t.y:=0;
end;

function tarbre._n:tcomplex;
begin
  _n.x:=nn;
  _n.y:=0;
end;

function tarbre._pi:tcomplex;
begin
  _pi.x:=pi;
  _pi.y:=0;
end;

function modulo(r:extended):extended;
begin
  if r>=0 then
    modulo:=r-trunc(r)
  else
    modulo:=r+trunc(-r)+1;
end;

function floattocolor(r:extended):tcolor;
begin
  floattocolor:=evalpalette(pal0,modulo(r));//rgb(trunc(128*cos(r))+128,trunc(128*cos(r+1))+128,trunc(128*cos(r+2))+128);
end;

function formater(n:integer):string;
var
  s:string;
  a:integer;
begin
  s:=inttostr(n-1);
  a:=trunc(ln(nframes)/ln(10));
  while length(s)<a do s:='0'+s;
  formater:=s;
end;

procedure tform1.trace;
const
  dz:integer=50;
type
  ttab=array[0..2000] of extended;
var
  f,z0,col,x1,x2,y1,y2,_nit,_teta,_phi,_prof,_tol,_tinitial,_tfinal,_rmax,_tolarret:tarbre;
  a,s,x,y,z,t,prof:integer;
  r,tol,c0,c1,rmax,tolarret:extended;
  tab:ttab;
  lisse,arret:bool;
  c:tcolor;
  function val(x,y:extended):extended;
  begin
    aa:=x;
    bb:=y;
    with z0.value do begin
      xx:=x;
      yy:=y;
    end;
    nn:=0;
    while (nn<>nit) and (sqr(xx)+sqr(yy)<rmax) do begin
      with f.value do begin
        if arret and (sqr(xx-x)+sqr(yy-y)<tolarret) then nn:=nit-1;
        xx:=x;
        yy:=y;
      end;
      inc(nn);
    end;
    rr:=sqr(xx)+sqr(yy);
    val:=teta*col.value.x
  end;
  function rec(x,y,rx,ry,c1,c2,c3,c4:extended;n:integer):extended;
  var
    u,v,c5,c6,c7,c8,c9:extended;
  begin
    if (n<=0) or (abs(c1-c2)+abs(c3-c1)+abs(c4-c1)+abs(c3-c2)+abs(c4-c2)+abs(c4-c3)<tol*2*pi/(1E-10+abs(teta))) then
      rec:=(c1+c2+c3+c4)/4
    else begin
      u:=x+rx/2;
      v:=y+ry/2;
      c5:=val(u,y);
      c6:=val(x+rx,v);
      c7:=val(u,y+ry);
      c8:=val(x,v);
      c9:=val(u,v);
      rec:=(rec(x,y,rx*0.5,ry*0.5,c1,c5,c9,c8,n-1)+
            rec(u,y,rx*0.5,ry*0.5,c5,c2,c6,c9,n-1)+
            rec(u,v,rx*0.5,ry*0.5,c9,c6,c3,c7,n-1)+
            rec(x,v,rx*0.5,ry*0.5,c8,c9,c7,c4,n-1))/4;
    end;
  end;
begin
  lisse:=checkbox2.checked;
  arret:=checkbox3.checked;
  pal0:=pal;
  x:=pos('*',combobox1.text);
  lx:=strtoint(copy(combobox1.text,1,x-1));
  ly:=strtoint(copy(combobox1.text,x+1,length(combobox1.text)));
  form2.paintbox1.width:=lx;
  form2.paintbox1.height:=ly;
  pic.width:=lx;
  pic.height:=ly;
  pic.pixelformat:=pf24bit;
  nframes:=strtoint(edit4.text);
  tinitial:=strtofloat(edit6.text);
  tfinal:=strtofloat(edit7.text);
  f:=nil;
  z0:=nil;
  col:=nil;
  try
    list:=tlist.create;
    stop:=false;
    fini:=false;
    pause:=false;
    toolbutton1.enabled:=false;
    toolbutton2.enabled:=true;
    f:=tarbre.create(edit1.text);
    list.add(f);
    z0:=tarbre.create(edit2.text);
    list.add(z0);
    col:=tarbre.create(edit3.text);
    list.add(col);
    x1:=tarbre.create(edit8.text);
    list.add(x1);
    y1:=tarbre.create(edit9.text);
    list.add(y1);
    x2:=tarbre.create(edit10.text);
    list.add(x2);
    y2:=tarbre.create(edit11.text);
    list.add(y2);
    _teta:=tarbre.create(edit16.text);
    list.add(_teta);
    _phi:=tarbre.create(edit17.text);
    list.add(_phi);
    _nit:=tarbre.create(edit15.text);
    list.add(_nit);
    _tinitial:=tarbre.create(edit6.text);
    list.add(_tinitial);
    _tfinal:=tarbre.create(edit7.text);
    list.add(_tfinal);
    _rmax:=tarbre.create(edit18.text);
    list.add(_rmax);
    _tolarret:=tarbre.create(edit19.text);
    list.add(_tolarret);
    tinitial:=round(_tinitial.value.x);
    tfinal:=round(_tfinal.value.x);
    if lisse then begin
      _prof:=tarbre.create(edit14.text);
      list.add(_prof);
      _tol:=tarbre.create(edit13.text);
      list.add(_tol);
    end;
    form2.show;
    for t:=1 to nframes do begin
      if stop then break;
      if nframes=1 then tt:=tinitial else tt:=tinitial+(tfinal-tinitial)*(t-1)/(nframes-1);
      progressbar2.Position:=(100*(t-1)) div nframes;
      nit:=round(_nit.value.x);
      phi:=_phi.value.x;
      teta:=_teta.value.x;
      xmin:=x1.value.x;
      xmax:=x2.value.x;
      ymin:=y1.value.x;
      ymax:=y2.value.x;
      rmax:=_rmax.value.x;
      tolarret:=_tolarret.value.x;
      if lisse then begin
        prof:=round(_prof.value.x);
        tol:=_tol.value.x/100;
      end;
      if checkbox1.checked then begin
        if (xmax-xmin)*ly>(ymax-ymin)*lx then begin
          r:=(ymax+ymin)/2;
          ymin:=r-(xmax-xmin)*ly/(2*lx);
          ymax:=2*r-ymin;
        end else begin
          r:=(xmax+xmin)/2;
          xmin:=r-(ymax-ymin)*lx/(2*ly);
          xmax:=2*r-xmin;
        end;
      end;





      if lisse then begin
        for x:=0 to lx do begin
          progressbar1.Position:=(100*x) div lx;
          application.processMessages;
          if stop then break;
          if pause then
            while pause do application.processmessages;
          for y:=0 to ly do begin
            application.processMessages;
            if stop then break;
            c0:=val(xmin+(xmax-xmin)*x/lx,ymin+(ymax-ymin)*y/ly);
            if x=0 then begin
              tab[y]:=c0
            end else begin
              if y=0 then begin
                 c1:=c0;
              end else begin
                pic.canvas.pixels[x-1,y-1]:=
                floattocolor(rec(xmin+(xmax-xmin)*(x-1)/lx,ymin+(ymax-ymin)*(y-1)/ly,(xmax-xmin)/lx,(ymax-ymin)/ly,
                               tab[y-1],c1,c0,tab[y],prof));
                form2.PaintBox1.canvas.brush.color:=pic.canvas.pixels[x-1,y-1];
                form2.paintbox1.canvas.fillrect(rect(((x-1)*lx) div form2.paintbox1.width,((y-1)*ly) div form2.paintbox1.height,
                                                 (x*lx) div form2.paintbox1.width,(y*ly) div form2.paintbox1.height));
                if y<ly then begin
                  tab[y-1]:=c1;
                  c1:=c0;
                end else begin
                  tab[y-1]:=c1;
                  tab[y]:=c0;
                end;
              end;
            end;
          end;
        end;
      end else begin
        z:=256;
        s:=0;
        while z<>0 do begin
          for x:=0 to lx div z do begin
            progressbar1.Position:=(100*s) div (lx*ly);
            application.processMessages;
            if stop then break;
            if pause then
              while pause do application.processmessages;
            for y:=0 to ly div z do begin
              application.processMessages;
              inc(s);
              if stop then break;
              if (x mod 2=1) or (y mod 2=1) or (x+y=0) then begin
                pic.canvas.pixels[x*z,y*z]:=floattocolor(val(xmin+(xmax-xmin)*x*z/lx,ymin+(ymax-ymin)*y*z/ly));
                form2.PaintBox1.canvas.brush.color:=pic.canvas.pixels[x*z,y*z];
                form2.paintbox1.canvas.fillrect(rect((x*z*lx) div form2.paintbox1.width,(y*z*ly) div form2.paintbox1.height,
                                                 ((x*z+z)*lx) div form2.paintbox1.width,((y*z+z)*ly) div form2.paintbox1.height));
              end;
            end;
          end;
          z:=z div 2;
        end;
      end;
      pic.savetofile(nom+formater(t)+'.bmp');
    end;
  finally
    toolbutton1.enabled:=true;
    toolbutton2.enabled:=false;
    fini:=true;
    for x:=list.count-1 downto 0 do tarbre(list[x]).destroy;
    list.destroy;
    progressbar1.Position:=100;
    progressbar2.Position:=100;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  trace;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if SavePictureDialog1.execute then begin
    nom:=SavePictureDialog1.filename;
    nom:=copy(nom,1,pos('.',nom)-1);
    edit5.text:=nom+'%.bmp';
  end;
end;

function readconfig(s:string):tconfig;
var
  c:tconfig;
  f:textfile;
begin
  assignfile(f,s);
  reset(f);
  with c do
    readarray(f,[@_f,@_z0,@_c,@_nframes,@_output,@_res,@_teta,@_phi,@_nit,@_t0,@_t1,@_x1,@_x2,@_y1,@_y2,@_ort]);
  readconfig:=c;
  closefile(f);
end;

procedure writeconfig(s:string;c:tconfig);
var
  f:textfile;
begin
  assignfile(f,s);
  rewrite(f);
  with c do
    writearray(f,[_f,_z0,_c,_nframes,_output,_res,_teta,_phi,_nit,_t0,_t1,_x1,_x2,_y1,_y2,_ort]);
  closefile(f);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  a:integer;
  f:file of tpalette;
begin
  fini:=true;
  top:=0;
  left:=screen.width-width;
  if fileexists('palettes\defaut.pal') then begin
    assignfile(f,'palettes\defaut.pal');
    reset(f);
    read(f,pal);
    read(f,points);
    closefile(f);
  end else begin
    for a:=0 to n do begin
      points[0,a]:=(1+cos(2*pi*a/n))/2;
      points[1,a]:=(1+cos(2*pi*a/n+1))/2;
      points[2,a]:=(1+cos(2*pi*a/n+2))/2;
    end;
    pal[0]:=adjust(points[0]);
    pal[1]:=adjust(points[1]);
    pal[2]:=adjust(points[2]);
    assignfile(f,'palettes\defaut.pal');
    rewrite(f);
    write(f,pal);
    write(f,points);
    closefile(f);
  end;
  pic:=tbitmap.create;
  nom:='image';
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  pic.destroy;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  g:file of tpalette;
begin
  if opendialog2.execute then begin
    assignfile(g,opendialog2.filename);
    reset(g);
    read(g,pal);
    read(g,points);
    closefile(g);
    if form3.visible then begin
      form3.paintbox2.repaint;
      form3.paintbox1.repaint;
    end;
  end;
end;
procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  pause:=not pause;
  toolbutton3.down:=pause;
end;

procedure TForm1.Chargerscript1Click(Sender: TObject);
var
  c:tconfig;
begin
  if savedialog1.execute then begin
    with c do begin
      _f:=edit1.Text;
      _z0:=edit2.Text;
      _c:=edit3.Text;
      _nframes:=edit4.Text;
      _output:=edit5.Text;
      _res:=combobox1.Text;
      _teta:=edit17.Text;
      _phi:=edit16.Text;
      _nit:=edit15.Text;
      _t0:=edit6.Text;
      _t1:=edit7.Text;
      _x1:=edit8.Text;
      _x2:=edit10.Text;
      _y1:=edit9.Text;
      _y2:=edit11.Text;
      if checkbox1.checked then _ort:='true' else _ort:='false';
    end;
    writeconfig(savedialog1.filename,c);
  end;
end;

procedure TForm1.Enregistrerscript1Click(Sender: TObject);
var
  c:tconfig;
begin
  if opendialog1.execute then begin
    c:=readconfig(opendialog1.filename);
    with c do begin
      edit1.Text:=_f;
      edit2.Text:=_z0;
      edit3.Text:=_c;
      edit4.Text:=_nframes;
      edit5.Text:=_output;
      combobox1.Text:=_res;
      edit17.Text:=_teta;
      edit16.Text:=_phi;
      edit15.Text:=_nit;
      edit6.Text:=_t0;
      edit7.Text:=_t1;
      edit8.Text:=_x1;
      edit10.Text:=_x2;
      edit9.Text:=_y1;
      edit11.Text:=_y2;
      checkbox1.checked:=_ort='true';
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  form3.show;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not fini then begin
    showmessage('En train de calculer! (faire stop pour arrêter)');
    canclose:=false;
  end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  form2.paintbox1.canvas.brush.style:=bssolid;
  form2.paintbox1.canvas.pen.mode:=pmcopy;
  if form2.down then begin
    edit10.text:=floattostr(xmin+x*(xmax-xmin)/form2.paintbox1.width);
    edit11.text:=floattostr(ymin+y*(ymax-ymin)/form2.paintbox1.height);
    edit8.text:=floattostr(xmin+form2.xxx*(xmax-xmin)/form2.paintbox1.width);
    edit9.text:=floattostr(ymin+form2.yyy*(ymax-ymin)/form2.paintbox1.height);
    form2.down:=false;
    trace;
  end;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  stop:=true;
end;


end.
