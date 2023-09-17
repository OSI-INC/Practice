program dcsort;
{
	A program to study the effect of divide and conquor on the execution time of
	list sorting. With check_sorting set, we generate one random list of length
	check_length and sort with lots of printing to the console. Otherwise we
	generate random lists of increasing length and measure average sort time.
}

{$MODESWITCH CLASSICPROCVARS+}
{$LONGSTRINGS ON}

uses sysutils;

const
	demo_length=100;
	fsi=5; {field size for integers}
	epl=20; {elements per line}
	min_length=10;
	max_length=10000000;
	length_step=2;
	depth=1e5;
	us_per_ms=1000;
	default_divide_threshold=4;

type 
	integer=longint;
	array_type=array of integer; 
	sort_procedure_type=procedure(var a:array_type;i,j:integer);

var
	answer:char;
	sort:sort_procedure_type;
	quit:boolean=false;
	show_progress:boolean=false;
	divide_threshold:integer;

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
	Generate a random list of numbers. We allow the range of each random number to
	be between zero and the length of the list, because lists that contain far fewer
	possible values than they contain elements will present algorithms like quick
	sort with particular problems, greatly decreasing their efficiency.
	
}
procedure randomize_list(var a:array_type);
var i,n:integer;
begin
	n:=length(a);
	for i:=0 to n-1 do a[i]:=random(n);
end;

{
	dcs_sort is a divide and conquor sort routine that uses a scratch array to
	combine two sorted half-lists. We pass an array and the range of indeces in
	the array that we want sorted. To sort an entire list we pass zero and the
	length minus one for these indeces.
}
procedure dcs_sort(var a:array_type; i,j:integer);

var 
	swap:boolean;
	c,k,l,r,b:integer;
	scratch:array_type;

begin
{
	We want to be able to check the sort routines, so here we report starting
	this sort.
}
	if show_progress then begin
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
		dcs_sort(a,i,k);
		dcs_sort(a,k+1,j);
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
	confirm this by setting the show_progress flag.
}
	if show_progress then begin
		writeln('Result of sorting ',i:1,' to ',j:1,':');
		for c:=i to j do begin
			write(a[c]:fsi);
			if (c mod epl = (epl - 1)) or (c = j) then writeln;
		end;
	end;
end;

{
	quick_sort performs the sort in place. We allocate no new arrays to hold a
	temporary list. We pick a random element in the list. We call it the pivot
	element. We put every element greater than the pivot on the right side of
	the list. We put the pivot at the end of the left side. We then sort the
	left and right sides. In this variant of the quick sort algorithm, we divide
	and conquor only if the number of elements we are being asked to sort is
	greater than a threshold. 
}
procedure quick_sort(var a:array_type;i,j:integer);

var 
	m,n,p,c,l,b:integer; 
	swap:boolean;

begin
{
	If we have only one element, we are already sorted.
}
	if j<=i then exit;
{
	Show what we are doing if flag set.
}
	if show_progress then begin
		writeln('Sorting ',i:1,' to ',j:1,'...');
	end;
{
	We will split the list into left and right halves and call quick sort on each
	half only if there are a minimum number of elements in the range.
}
	if j-i+1>divide_threshold then begin
{
	Pick a random pivot element. We pick a random element to avoid quicksort being
	slowed down by certain regular patterns that may arise in the list.
}
		p:=i+random(j-i);
{
	Swap the pivot element with the final element.
}
		b:=a[p];
		a[p]:=a[j];
		a[j]:=b;
{
	Move all elements greater than the pivot to the right side of the list.
}
		m:=i;
		n:=j-1;
		while m<n do begin
			if a[m]>a[j] then begin
				b:=a[m];
				a[m]:=a[n];
				a[n]:=b;
				dec(n);
			end else begin
				inc(m);
			end;
		end;
{
	Move the pivot to the right edge of the left side of the list.
}
		if a[m]>a[j] then p:=m else p:=m+1;
		b:=a[j];
		a[j]:=a[p];
		a[p]:=b;
{
	Assuming we have two or more elements, sort the left and right sides.
}
		if p-1>i then quick_sort(a,i,p-1);
		if j>p+1 then quick_sort(a,p+1,j);
	end else begin
{
	For short ranges, bubble sort directly to save the work of dividing calling.
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
	Show progress if requested.
}
	if show_progress then begin
		writeln('Result of sorting ',i:1,' to ',j:1,':');
		for c:=i to j do begin
			write(a[c]:fsi);
			if (c mod epl = (epl - 1)) or (c = j) then writeln;
		end;
	end;
end;

{
	Measure sort time versus list length.
}
procedure measure_sort_time;

var
	a:array_type;
	n,num_reps,j:integer;
	start_time:qword;
	sort_us:real;

begin
	writeln('Measure Sort Time');
	writeln('Length Repetitions Microseconds');
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
		num_reps:=round(1.0*depth/n); 
		if num_reps=0 then num_reps:=1;
		start_time:=clock_milliseconds;
{
	Randomize and sort with the divide and conquor sort routine num_reps times.
}
		for j:=1 to num_reps do begin 
			randomize_list(a);
			sort(a,0,length(a)-1);
		end;
{
	Calculate average sort time, print with list length and increase length.
}
		sort_us:=1.0*(clock_milliseconds-start_time)/num_reps*us_per_ms;
		writeln(n:1,' ',num_reps:1,' ',sort_us:0:1,' ');
		n:=length_step*n;
	until n>max_length;
end;

{
	Demonstrate sorting by setting show_progress flag and sorting a list.
}
procedure demonstrate_sorting;

var
	a:array_type;
	j:integer;
	
begin
	writeln('Demonstrate Sorting');
	show_progress:=true;
	setlength(a,demo_length);
	randomize_list(a);
	writeln('Initial:');
	for j:=0 to length(a)-1 do begin
		write(a[j]:fsi);
		if (j mod epl = (epl - 1)) or (j=length(a)-1) then writeln;
	end;
	sort(a,0,length(a)-1);
	show_progress:=false;
end;

{
	Test sorting by creating successively larger lists and checking each to see if
	it is correctly sorted.
}
procedure test_sorting;

var
	a:array_type;
	j,n:integer;
	err:boolean;
	
begin
	writeln('Test Sorting');
	n:=min_length;
	repeat 
		write('Length ',n:1,'...');
		setlength(a,n);
		randomize_list(a);
		sort(a,0,length(a)-1);
		j:=0;
		err:=false;
		repeat
			if a[j]>a[j+1] then err:=true;
			inc(j);
		until err or (j=n-1);
		n:=length_step*n;
		if err then writeln(' FAIL.') else writeln(' PASS.');
	until n>max_length;
end;

{
	Main Program.
}
begin
{
	Initialize the random number generator and configuration.
}
	randomize;
	sort:=dcs_sort;
	divide_threshold:=default_divide_threshold;
{
	Pick the sort algorithm.
}
	repeat
		if (@sort=@dcs_sort) then
			writeln('Sort algorithm is dcs_sort.')
		else
			writeln('Sort algorithm is quick_sort.');
		writeln('Divide threshold is ',divide_threshold:1,'.');
		writeln('D  Demonstrate sorting process.');
		writeln('M  Measure sort time versus list length.');
		writeln('T  Test sorting of various length lists.');
		writeln('W  Use dcs_sort.');
		writeln('X  Use quick_sort.');
		writeln('Y  Set sort algorithm divide threshold.');
		writeln('Q  Quit.');
		write('? ');
		readln(answer);
		case answer of
			'd','D' : demonstrate_sorting;
			'm','M' : measure_sort_time;
			't','T' : test_sorting;
			'w','W' : sort:=dcs_sort;
			'x','X' : sort:=quick_sort;
			'y','Y' : begin
				write('Enter divide threshold: ');
				readln(divide_threshold);
			end;			
			'q','Q' : quit:=true;
		else
			writeln('Unrecognised selection "',answer,'".')
		end;
	until quit;
end.
