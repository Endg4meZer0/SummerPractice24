unit space_many;
interface

function get_next(var s: string): string;
function validate(s: string; elements_count: integer): boolean;

implementation

function get_next(var s: string): string;
var i: integer;
begin
  i := 0;
  while s[i] <> ' ' do i := i + 1;
  Result := copy(s, 0, i);
  while s[i] = ' ' do i := i + 1;
  s := copy(s, i, s.Length - i);
end;

function validate(s: string; elements_count: integer): boolean;
var i, count: integer;
var space_flag: boolean;
begin
  count := 1;
  for i := 0 to s.Length-1 do begin
    if (s[i] = ' ') and not space_flag then begin
      space_flag := true;
      count := count + 1;
    end
    else space_flag := false;
  end;
  Result := count = elements_count
end;

end.