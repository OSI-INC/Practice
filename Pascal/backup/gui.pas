program gui;
{$mode objfpc}{$H+}
 
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
   cthreads,
  {$ENDIF}{$ENDIF}
   Interfaces,
   Forms, StdCtrls;
  {$R *.res}
 
procedure MyWnd;
var
 wnd: TForm;
 btn: TButton;
begin
  wnd         := TForm.Create(Application);
  wnd.Height  := 300;
  wnd.Width   := 400;
  wnd.Position:= poDesktopCenter;
  wnd.Caption := 'Example Window';
 
  btn          := TButton.Create(wnd);
  btn.SetBounds(0, 0, 100, 50);
  btn.Caption  := 'Click Me';
  btn.Parent   := wnd;
 
  wnd.ShowModal;
end;
 
begin
  Application.Initialize;
  MyWnd;
end.
