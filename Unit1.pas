unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure Convertimage(InImageName1,OutImageName1:string; px_x,px_y:integer);
var
InImageBmp1,Bmp1:tbitmap;
begin
  InImageBmp1:=tbitmap.Create;
  Bmp1:=tbitmap.Create;
  try
    InImageBmp1.LoadFromFile(InImageName1);
    Bmp1.Width := px_x;
    Bmp1.Height :=px_y;
    Bmp1.PixelFormat :=pf32bit;
    SetStretchBltMode(Bmp1.Canvas.Handle, COLORONCOLOR);
    stretchblt(Bmp1.Canvas.Handle, 00, 00,
               Bmp1.Width,Bmp1.Height,
               InImageBmp1.Canvas.Handle, 0, 0,
               InImageBmp1.Width,InImageBmp1.Height, srccopy);
    Bmp1.SaveToFile(OutImageName1);     
  finally
    InImageBmp1.Free;
    Bmp1.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Image1.Picture.LoadFromFile(Edit1.Text);
Convertimage(Edit1.Text,Edit2.Text,
             strtoint(Edit3.Text),
             strtoint(Edit4.Text));
//Image2.AutoSize:=true;
Image2.Picture.LoadFromFile(Edit2.Text);
end;

end.
