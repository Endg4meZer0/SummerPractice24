unit sort;
interface

uses products, orders;
uses consts;

type list_str = array[1..possible_records] of string;

procedure sortProducts(var lp: list_prod);
procedure sortOrders(var lo: list_ord);

implementation

procedure sortProducts(var lp: list_prod);
begin
  
end;

procedure sortOrders(var lo: list_ord);
var ls: list_str;
var i: integer;
begin
  
end;

procedure quickSort(var ls: list_str; lo: integer; hi: integer);
begin
  if lo < hi then begin
    p := partition(ls, lo, hi);
    quickSort(ls, lo, p);
    quickSort(ls, p + 1, hi); 
end;

function partition(var ls: list_str; low: integer; high: integer): integer;
var flag: boolean;
var i,j,k,compareResult: integer;
var pivot: string;
begin
  pivot := ls[(low + high) / 2];
  i := low;
  j := high;
  flag := true;
  while i < j do begin
    compareResult := stringCompare(ls[i], pivot);
    while compareResult = -1 then i := i + 1;
    while compareResult = 1 then j := j - 1;
    (ls[i], ls[j]) := (ls[j], ls[i]);
    i := i + 1;
    j := j - 1;
  end;
  result := j;
end;

function stringCompare(s1, s2: string): integer;
// Если s1 < s2 - -1
// Если s1 = s2 - 0
// Если s1 > s2 - 1
var c1, c2: char;
var i: integer;
begin
  result := 0;
  if (s1 = '') and (s2 = '') then result := 0
  else if (s1 = '') and (s2 <> '') then result := -1
  else if (s1 <> '') and (s2 = '') then result := 1
  else if (s1.Length < s2.Length) then result := -1
  else if (s1.Length > s2.Length) then result := 1
  else begin
    i := 1;
    c1 := s1[i];
    c2 := s2[i];
    while (i <= s1.Length) and (result = 0) do begin
      if c1 < c2 then result := -1
      else if c1 > c2 then result := 1;
    end;
  end;
end;

end.
