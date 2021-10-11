program Mandel;

uses
  Forms,
  Mandel1 in 'Mandel1.pas' {Form1},
  Mandel2 in 'Mandel2.pas' {Form2},
  Mandel3 in 'Mandel3.pas' {Form3};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  form2.PaintBox1.OnMouseUp:=form1.PaintBox1MouseUp;
  Application.Run;
end.
