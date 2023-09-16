program dcsort;
{
	A program to study the effect of divide and conquor on the execution time of
	list sorting. With check_sorting set, we generate one random list of length
	check_length and sort with lots of printing to the console. Otherwise we
	generate random lists of increasing length and measure average sort time.
}

uses sysutils;

const
	check_sorting = false;
	check_length = 100;
	fsi = 5; {field size for integers}
	epl = 20; {elements per line}
	min_length = 10;
	max_length = 10000000;
	length_step = 2;
	depth = 1e5;
	us_per_ms = 1000;
	divide_threshold = 100;

type 
	array_type = array of real; 

var
	a : array_type;
	n,j : longint;
	start_time : Qword;
	num_reps: integer;
	sort_us: real;

{
	clock_milliseconds returns a sixty-four bit unsigned integer giving the
	number of milliseconds since the beginning of 1970. The routine has some
	bugs: occasionally it will record no passage of time, and sometimes it will
	record an excessive passage of time.
}
function clock_milliseconds:qword;
var
	tdt:TDateTime;
	tts:TTimeStamp;
begin
	tdt:=Now;
	tts:=DateTimeToTimeStamp(tdt);
	clock_milliseconds:=round(TimeStampToMSecs(tts));
end;


{	
	Generate a random list of numbers up to 1000 in one of our lists.
}
procedure randomize_list(var a: array_type);
var i:longint;
begin
	for i:=0 to length(a)-1 do a[i]:=random(1000);
end;

{
	dcsort is a divide and conquor sort routine that takes an array of real numbers
	or integers and sorts them in increasing order. We pass an array and the range
	of indeces in the array that we want sorted. To sort an entire list we pass zero
	and the length minus one for these indeces.
}
procedure dcsort(var a:array_type; i,j:longint);

var 
	swap:boolean;
	c,k,l,r:longint;
	b:real;
	scratch:array_type;

begin
{
	We want to be able to check the sort routines, so here we report starting
	this sort.
}
	if check_sorting then begin
		writeln('Sorting ',i:1,' to ',j:1,'...');
	end;
{
	We will divide and sort if the list is large enough to merit doing so. Otherwise
	we will sort directly with swapping.
}
	if j-i+1>divide_threshold then begin
{
	Divide the range into a left and right half and sort each half. Our half-way
	marker is k. Elements i to k are the left half. Those from k+1 to j are the
	right half.
}
		k:=i+((j-i) div 2);
		dcsort(a,i,k);
		dcsort(a,k+1,j);
{
	We have not been able to figure out how to combine these two halve in place,
	so create a scratch-pad array into which we can copy elements from the
	sorted left and right halves. We use c as our combined array index and l and
	r for the left and right halves.
}
		setlength(scratch,(j-i+1));
		c:=0;
		l:=i;
		r:=k+1;
{
	Go through the left and right halves, picking the lesser from each half and 
	placing it in our 
}
		while (c<=j-i) do begin
{
	We may have advanced all the way through the left half, in which case we
	will copy an element from the right half.
}
			if (l>k) then begin 
				scratch[c]:=a[r]; 
				inc(r); 
{
	Or we may have advanced all the way through the right half, in which case we
	copy an element from the left half.
}
			end else if (r>j) then begin
				scratch[c]:=a[l]; 
				inc(l); 
{
	If we have elements left in both halves, compare the elements and copy the
	lesser one into our scratch array.
}
			end else if a[l]>a[r] then begin
				scratch[c]:=a[r]; 
				inc(r); 
			end else begin
				scratch[c]:=a[l]; 
				inc(l); 
			end;
			inc(c);
		end;
{
	Copy the new list into the original list, overwriting the range we wanted to sort,
	and so producing the sorted range.
}
		for c:=0 to (j-i) do a[i+c]:=scratch[c];	
	end else begin
{
	Our list is short, so apply bubble sort to the small range remaining.
}
		repeat
			swap:=false;
			for l:=i to j-1 do begin
				if a[l]>a[l+1] then begin
					b:=a[l];
					a[l]:=a[l+1];
					a[l+1]:=b;
					swap:=true;
				end;
			end;
		until not swap;
	end;
{
	Elements i through j inclusive should now be sorted in increasing order. We can
	check by setting the check_sorting flag.
}
	if check_sorting then begin
		writeln('Result of sorting ',i:1,' to ',j:1,':');
		for c:=i to j do begin
			write(a[c]:fsi:0);
			if (c mod epl = (epl - 1)) or (c = j) then writeln;
		end;
	end;
end;


begin
{
	Initialize the random number generator.
}
	randomize;
{
	If the check_sorting flag is set, we are going to sort a list and print to the
	screen.
}
	if check_sorting then begin
		setlength(a,check_length);
		randomize_list(a);
		writeln('Initial:');
		for j:=0 to length(a)-1 do begin
			write(a[j]:fsi:0);
			if (j mod epl = (epl - 1)) or (j=length(a)-1) then writeln;
		end;
		dcsort(a,0,length(a)-1);
		exit;
	end;
{
	Set the first list length. We are going to increase the list length in
	stages and measure the average execution time for lists of each length. For
	short lists, we will randomize and sort many times. For long lists, we may
	sort only one.
}
	n:=min_length;
	repeat 
{
	Create a list and obtain a reasonable value for the number of times we will
	sort a list of this length and store the start time.
}
		setlength(a,n);
		num_reps:=round(depth/n); 
		if num_reps=0 then num_reps:=1;
		start_time:=clock_milliseconds;
{
	Randomize and sort with the divide and conquor sort routine num_reps times.
}
		for j:=1 to num_reps do begin 
			randomize_list(a);
			dcsort(a,0,length(a)-1);
		end;
{
	Calculate average sort time, print with list length and increase length.
}
		sort_us:=1.0*(clock_milliseconds-start_time)/num_reps*us_per_ms;
		writeln(n:1,' ',sort_us:0:1,' ');
		n:=length_step*n;
	until n>max_length;
end.



 





