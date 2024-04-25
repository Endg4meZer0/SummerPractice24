unit space_one;
interface

function get_next(var s: string): string;
function validate(s: string; elements_count: integer): boolean;

implementation

function get_next(var s: string): string;
var i: integer;
begin
  i := 0;
  while s[i] <> ' ' do i++;
  Result := copy(s, 0, i);
  s := copy(s, i + 1, s.Length - (i + 1));
end;

function validate(s: string; elements_count: integer): boolean;
var i, count: integer;
begin
  count := 1;
  for i := 0 to s.Length-1 do begin
    if (s[i] = ' ') then begin
      count := count + 1;
    end;
  end;
  Result := count = elements_count
end;

end.