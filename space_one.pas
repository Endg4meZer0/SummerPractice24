unit space_one;
interface

uses errors;

function get_next(var s: string): string;
function validate(s: string; max_elements_count: integer): string;

implementation

function get_next(var s: string): string;
var i: integer;
begin
  if s = '' then Result := ''
  else begin
    i := 0;
    while s[i] <> ' ' do i := i+1;
    Result := copy(s, 0, i);
    s := copy(s, i + 1, s.Length - (i + 1));
  end;
end;

function validate(s: string; max_elements_count: integer): string;
var i, count: integer;
var err_string: string;
begin
  err_string := '';
  
  if s[1] = ' ' then append_err(err_string, 'ФОРМАТ ДАННЫХ: ');
  count := 1;
  for i := 0 to s.Length-1 do begin
    if (s[i] = ' ') then begin
      count := count + 1;
    end;
  end;
  Result := ((s[0] <> ' ') or (s[s.Length-1] <> ' ')) and (count <= max_elements_count)
end;

end.