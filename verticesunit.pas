unit VerticesUnit;

{$mode DelphiUnicode}


interface

uses
  Classes, SysUtils, GL;

type

  TColorf = record
    Red, Green, Blue: GLfloat;
  end;

  TVertexf = record
    X, Y, Z: GLfloat;
    Color: TColorf;
  end;

  TSimpleVertexf = record
    X, Y, Z: GLfloat;
  end;


function GetColorf(Red, Green, Blue: GLfloat): TColorf;

// Vertex with Color attribute
function GetVertexf(X, Y, Z: GLfloat; Color: TColorf): TVertexf;
procedure ViewVertexf(Vertex: TVertexf);

// Vertex without Color attribute
function GetSimpleVertexf(X, Y, Z: GLfloat): TSimpleVertexf;
procedure ViewSimpleVertexf(Vertex: TSimpleVertexf);

procedure SetNormal(Vertex1, Vertex2, Vertex3: TSimpleVertexf; Sign: Boolean);

function Red: TColorf;
function Blue: TColorf;
function Green: TColorf;
function Yellow: TColorf;
function Orange: TColorf;
function White: TColorf;


implementation

function GetColorf(Red, Green, Blue: GLfloat): TColorf;
var
  Color: TColorf;
begin
  Color.Red := Red;
  Color.Green := Green;
  Color.Blue := Blue;
  Result := Color;
end;


function GetVertexf(X, Y, Z: GLfloat; Color: TColorf): TVertexf;
var
  Vertex: TVertexf;
begin
  Vertex.X := X;
  Vertex.Y := Y;
  Vertex.Z := Z;
  Vertex.Color := Color;
  Result := Vertex;
end;

procedure ViewVertexf(Vertex: TVertexf);
begin
  glColor3f(
    Vertex.Color.Red,
    Vertex.Color.Green,
    Vertex.Color.Blue
  );
  glVertex3f(
    Vertex.X,
    Vertex.Y,
    Vertex.Z
  );
end;


function GetSimpleVertexf(X, Y, Z: GLfloat): TSimpleVertexf;
var
  Vertex: TSimpleVertexf;
begin
  Vertex.X := X;
  Vertex.Y := Y;
  Vertex.Z := Z;
  Result := Vertex;
end;

procedure ViewSimpleVertexf(Vertex: TSimpleVertexf);
begin
  glVertex3f(
    Vertex.X,
    Vertex.Y,
    Vertex.Z
  );
end;

procedure SetNormal(Vertex1, Vertex2, Vertex3: TSimpleVertexf; Sign: Boolean);
var
  X, Y, Z, L: GLfloat;
  VecX1, VecY1, VecZ1: GLfloat;
  VecX2, VecY2, VecZ2: GLfloat;
begin
  VecX1 := Vertex2.X - Vertex1.X;
  VecY1 := Vertex2.Y - Vertex1.Y;
  VecZ1 := Vertex2.Z - Vertex1.Z;

  VecX2 := Vertex3.X - Vertex1.X;
  VecY2 := Vertex3.Y - Vertex1.Y;
  VecZ2 := Vertex3.Z - Vertex1.Z;

  X := VecY1 * VecZ2 - VecZ1 * VecY2;
  Y := VecZ1 * VecX2 - VecX1 * VecZ2;
  Z := VecX1 * VecY2 - VecY1 * VecX2;

  L := Sqrt(X * X + Y * Y + Z * Z);
  X := X / L;
  Y := Y / L;
  Z := Z / L;

  if Sign then
    glNormal3f(X, Y, Z)
  else
    glNormal3f(-X, -Y, -Z);
end;


function Red: TColorf;
begin
  Result := GetColorf(0.7, 0.0, 0);
end;

function Blue: TColorf;
begin
  Result := GetColorf(0.0, 0.5, 1);
end;

function Green: TColorf;
begin
  Result := GetColorf(0.0, 0.7, 0);
end;

function Yellow: TColorf;
begin
  Result := GetColorf(0.7, 0.7, 0);
end;

function Orange: TColorf;
begin
  Result := GetColorf(0.9, 0.6, 0);
end;

function White: TColorf;
begin
  Result := GetColorf(1.0, 1.0, 1);
end;

end.

