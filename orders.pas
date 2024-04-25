unit orders;
interface

uses errors;
uses space_one;

type order = record
  code: integer;
  name: string;
  phone: integer;
  date: record
    day: 1..31;
    month: 1..12;
    year: 2000..2100;
  end;
  prod_list: array of record
    code: integer;
    amount: integer;
  end;
end;
list_ord = array of order;

function makeFromString(s: string): order;
function validateString(s: string): string;

implementation

function makeFromString(s: string): order;
begin
  
end;

function validateString(s: string): string;
var err_string: string;
var t_s: string;
var t_i: integer;
var t_err: integer;
begin
  err_string := '';
  
  
  
end;

end.