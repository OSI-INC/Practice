program button_windows;

{
	Example code from FPC forum, to which we add the interfaces unit so that
	Lazarus can find the gui routines. 26-DEC-24
}

{$mode objfpc}{$H+}

uses

	{$IFDEF UNIX}
		{$IFDEF UseCThreads}
	 	cthreads,
		{$ENDIF}
	{$ENDIF}

	 Interfaces,Forms, Classes, StdCtrls, Dialogs;

	{$R *.res}

procedure ShowMainWnd(x, y, w, h: Integer);

// main form as one proc, no units, no type...
var
 wnd : TForm;
 btn1, btn2: TButton;
 clk1, clk2: TNotifyEvent;

 // all events inside the proc
 procedure Button1Click(Sender: TObject);
 begin
	 ShowMessage('Button 1');
 end;

 procedure Button2Click(Sender: TObject);
 begin
	 ShowMessage('Button 2');
 end;

begin
	wnd					:= TForm.Create(Application);
	wnd.SetBounds(x, y, w, h);
	wnd.Caption	:= 'My Window Proc';

	TMethod(clk1).Code:= @Button1Click;
	TMethod(clk2).Code:= @Button2Click;

	btn1					:= TButton.Create(wnd);
	btn1.Caption	:= 'Button 1';
	btn1.SetBounds(0, 0, 100, 50);
	btn1.OnClick	:= clk1;
	btn1.Parent	 := wnd;

	btn2					:= TButton.Create(wnd);
	btn2.Caption	:= 'Button 2';
	btn2.SetBounds(0, 80, 100, 50);
	btn2.OnClick	:= clk2;
	btn2.Parent	 := wnd;

	wnd.ShowModal;
end;

begin
	RequireDerivedFormResource:=True;
	Application.Scaled:=True;
	Application.Initialize;
	Application.TaskBarBehavior:= tbSingleButton;
	ShowMainWnd(500, 500, 400, 300);
end.
