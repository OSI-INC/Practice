program prime;

const
startlength = 1;
maxlength =1000000;
type

array_type= array of real;

 var


n,p,i,j:longint;

isprime:boolean;
begin 

	n:=startlength;
	repeat 

{	 Repeat the following procedure until we have tested all numbers up to
	one milliom=n Set the prime counter to zero for each list of N numbers, then
	test each number "i" from 1 to N by dividing i by the number "j" which is
	every number from 2 to i-1. J must start at two because every number is
	divisible by one, and j must not ever be i because every number is divsible
	by itself. If i is divisible by j, set the prime flag to false- this means
	the number i is not prime. If i is not divisible by any numer "j", it is
	prime, we increment the prime value.

}
		p:=0;
		for i:=1 to n-1 do begin
			isprime:=true;
				for j:=2 to i-1 do begin
					if i mod j = 0 then isprime:=false;
				end;
				if isprime=true then inc(p);
			end;
		
		if p=0 then p:=1;
		writeln('this is how many prime numbers there are in', n , ':', p-1);
		n:=n*10;
	until n>maxlength;
end.

