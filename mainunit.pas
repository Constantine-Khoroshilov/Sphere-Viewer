unit MainUnit;

{$mode delphiunicode}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  OpenGLContext, GL, glu, SphereUnit, Math;



type

  TPoint = record
    X, Y: Single;
  end;

  TClickState = (Hold, NotHold);

  { TMainForm }

  TMainForm = class(TForm)
    GLBox: TOpenGLControl;
    MainPanel: TPanel;
    GrassTexRadio: TRadioButton;
    BallTexRadio: TRadioButton;
    WoodTexButton: TRadioButton;
    MarbleTexRadio: TRadioButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure GLBoxMouseDown(
      Sender: TObject;
      Button: TMouseButton;
      Shift: TShiftState;
      X, Y: Integer);

    procedure GLBoxMouseMove(
      Sender: TObject;
      Shift: TShiftState;
      X, Y: Integer);

    procedure GLBoxMouseUp(
      Sender: TObject;
      Button: TMouseButton;
      Shift: TShiftState;
      X, Y: Integer);

    procedure GLBoxPaint(Sender: TObject);
    procedure GrassTexRadioChange(Sender: TObject);
    procedure MarbleTexRadioChange(Sender: TObject);
    procedure WoodTexButtonChange(Sender: TObject);
    procedure BallTexRadioChange(Sender: TObject);

  private
    ClickState: TClickState;
    PreviosMousePos: TPoint;
    CurrentMousePos: TPoint;

    VRotationAngle: GLdouble;
    HRotationAngle: GLdouble;
    MySphere: TSphere;
  end;



const
  DiffuseLight:  array [0..3] of GLfloat = (1, 0.7, 0.7, 1);
  AmbientLight:  array [0..3] of GLfloat = (0.3, 0.3, 0.3, 1);
  // Z = 1 sets the point light source
  LightPosition: array [0..3] of GLfloat = (3, 5, 1.5, 1);
  // Meterial color
  MaterialColor: array [0..3] of GLfloat = (1.4, 1.4, 1.4, 1);

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.GLBoxPaint(Sender: TObject);
begin
  glClearColor(0, 0.6, 0.8, 0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glEnable(GL_DEPTH_TEST);
  glEnable(GL_LIGHTING);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(80, GLBox.Width / GLBox.Height, 1, 90);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
   gluLookAt(3, 1, 0,
             0, 0, 0,
             0, 1, 0);

  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, MaterialColor);

  glLightfv(GL_LIGHT0, GL_DIFFUSE, DiffuseLight);
  glLightfv(GL_LIGHT0, GL_AMBIENT, AmbientLight);
  glLightfv(GL_LIGHT0, GL_POSITION, LightPosition);
  glEnable(GL_LIGHT0);

  // Texture wrapping
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glEnable(GL_TEXTURE_2D);

  glRotatef(VRotationAngle, 0, 0, -1);
  glRotatef(HRotationAngle, 0, 1, 0);

  MySphere.View;

  GLBox.SwapBuffers;
end;

procedure TMainForm.GrassTexRadioChange(Sender: TObject);
begin 
  MySphere.TexturePath := 'textures\grass.jpg';
  GLBox.Invalidate;
end;

procedure TMainForm.MarbleTexRadioChange(Sender: TObject);
begin
  MySphere.TexturePath := 'textures\marble.jpg';
  GLBox.Invalidate;
end;

procedure TMainForm.WoodTexButtonChange(Sender: TObject);
begin
  MySphere.TexturePath := 'textures\wood.bmp';
  GLBox.Invalidate;
end;

procedure TMainForm.BallTexRadioChange(Sender: TObject);
begin 
  MySphere.TexturePath := 'textures\ball2.png';
  GLBox.Invalidate;
end;


procedure TMainForm.GLBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  dx, dy: Single;
begin
  // Figuring out HRotationAngle and VRotationAngle
  PreviosMousePos := CurrentMousePos;
  CurrentMousePos.X := X;
  CurrentMousePos.Y := Y;

  dx := CurrentMousePos.X - PreviosMousePos.X;
  dy := CurrentMousePos.Y - PreviosMousePos.Y;

  case ClickState of
    Hold:
    begin
      if (Abs(Floor(VRotationAngle)) >= 90 ) and
         (Abs(Floor(VRotationAngle)) <= 270)
      then begin
        HRotationAngle -= 0.2 * dx;
        VRotationAngle += 0.2 * dy;
      end
      else begin
        HRotationAngle += 0.2 * dx;
        VRotationAngle += 0.2 * dy;
      end;

      if Abs(HRotationAngle) > 360 then
        HRotationAngle := Sign(HRotationAngle) * (Abs(HRotationAngle) - 360);
      if Abs(VRotationAngle) > 360 then
        VRotationAngle := Sign(VRotationAngle) * (Abs(VRotationAngle) - 360)
    end;
  end;
  GLBox.Invalidate;
end;


procedure TMainForm.GLBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:
      ClickState := NotHold;
  end;
end;


procedure TMainForm.GLBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:
      ClickState := Hold;
  end;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  MySphere := TSphere.Create(1.5, 90, 90);
  ClickState := NotHold;
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(MySphere);
end;

end.

