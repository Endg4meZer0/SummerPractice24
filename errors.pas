unit errors;
interface

procedure append_err(var err_string: string; err: string);

implementation

procedure append_err(var err_string: string; err: string);
begin
  err_string := err_string + char(10) + char(9) + err;
end;

end.