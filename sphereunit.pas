unit SphereUnit;

{$mode delphiunicode}

interface

uses
  Classes, SysUtils, GL, VerticesUnit, ImagingOpenGL, Math;

type
  { TSphere }

  TSphere = class
    private
      FX, FY, FZ: GLfloat;
      SphereRadius: GLfloat;
      Vertices: array of array of TSimpleVertexf;
      TexCoords: array of array of TSimpleVertexf;
      Normals: array of array of TSimpleVertexf;
      FTexturePath: string;
      TextureID: GLuint;

      procedure Render;
      procedure SetTexturePath(Path: string);
    public
      property TexturePath: string write SetTexturePath;

      procedure View;
      procedure SetPosition(X, Y, Z: GLfloat);
      constructor Create(Radius: GLfloat; Lon, Lat: Integer);
  end;


implementation

{ TSphere }

constructor TSphere.Create(Radius: GLfloat; Lon, Lat: Integer);
var
  I, J: Integer;
  LonAngles, LatAngles: Single;
  X, Y, Z: GLfloat;
begin
  if (Lon < 0) or (Lat < 0) or (Radius < 0) then
    raise Exception.Create('Lon, Lat or Radius cannot be negative');

  SphereRadius := Radius;
  LonAngles := 0; // Longitude (долгота)
  LatAngles := 0; // Latitude (широта)

  SetLength(Vertices, Lat + 1);
  SetLength(TexCoords, Lat + 1);
  SetLength(Normals, Lat + 1);

  for I:=0 to Lat do
  begin
    SetLength(Vertices[I], (Lon + 1) * SizeOf(TSimpleVertexf));
    SetLength(TexCoords[I], (Lon + 1) * SizeOf(TSimpleVertexf));
    SetLength(Normals[I], (Lon + 1) * SizeOf(TSimpleVertexf));

    for J:=0 to Lon do
    begin
      X := Radius * Sin(LonAngles) * Cos(LatAngles);
      Z := Radius * Sin(LonAngles) * Sin(LatAngles);
      Y := Radius * Cos(LonAngles);

      Vertices[I][J] := GetSimpleVertexf(X, Y, Z);
      TexCoords[I][J] := GetSimpleVertexf(LatAngles / 2 / Pi, LonAngles / Pi, 0);
      Normals[I][J] := GetSimpleVertexf(
        X / SphereRadius,
        Y / SphereRadius,
        Z / SphereRadius);

      LonAngles := LonAngles + (2 * Pi) / Lon;
    end;
    LatAngles := LatAngles + Pi / Lat;
    LonAngles := 0;
  end;

  FX := 0;
  FY := 0;
  FZ := 0;
end;

procedure TSphere.Render;
var
  Lon, Lat, R: GLdouble;
  I, J: Integer;
  V: TSimpleVertexf;
begin
  for I:=Low(Vertices) to High(Vertices)-1 do
  begin
    glBegin(GL_TRIANGLE_STRIP);
    for J:=Low(Vertices[I]) to High(Vertices[I]) do
    begin
      V := Vertices[I][J];

      glNormal3f(Normals[I][J].X, Normals[I][J].Y, Normals[I][J].Z);
      glTexCoord2f(TexCoords[I][J].X, TexCoords[I][J].Y);

      ViewSimpleVertexf(V);

      V := Vertices[I+1][J];

      glNormal3f(Normals[I+1][J].X, Normals[I+1][J].Y, Normals[I+1][J].Z);
      glTexCoord2f(TexCoords[I+1][J].X, TexCoords[I+1][J].Y);

      ViewSimpleVertexf(V);
    end;

    glEnd;
  end;
end;

procedure TSphere.View;
begin
  // Load textures
  if (TextureID = 0) and (FTexturePath <> '')
  then begin
    try
      TextureID := LoadGLTextureFromFile(FTexturePath);
    except
      raise Exception.Create('Texture is not found!');
    end;
  end;
  glBindTexture(GL_TEXTURE_2D, TextureID);

  glPushMatrix;
  glTranslatef(FX, FY, FZ);

  Render;

  glPopMatrix;
end;

procedure TSphere.SetTexturePath(Path: string);
begin
  TextureID := 0;
  FTexturePath := Path;
end;

procedure TSphere.SetPosition(X, Y, Z: GLfloat);
begin
  FX := X;
  FY := Y;
  FZ := Z;
end;

end.

