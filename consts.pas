unit consts;
interface

type date = class
  private
    day, month, year: integer;
    unixTime: integer;
  public
    constructor create(_d, _m, _y: integer);
    function compare(_d: date): integer;
    function getDay(): integer;
    function getMonth(): integer;
    function getYear(): integer;
end;

function getDay(): integer;
begin
  result := day;
end;

function getMonth(): integer;
begin
  result := month;
end;

function getYear(): integer;
begin
  result := year;
end;

constructor date.create(_d, _m, _y: integer);
var i: integer;
begin
  day := _d;
  month := _m;
  year := _y;
  unixTime := 0;
  
  for i := 1 to year-1 do begin
    if ((i div 4 = 0) and not (i div 100 = 0)) or (i div 400 = 0) 
      then unixTime := unixTime + 8784
    else unixTime := unixTime + 8760;
  end;

  for i := 1 to month-1 do begin
    case i of
      1,3,5,7,8,10: unixTime := unixTime + 31 * 24
      4,6,9,11: unixTime := unixTime + 30 * 24
      2: if ((year div 4 = 0) and not (year div 100 = 0)) or (year div 400 = 0)
          then unixTime := unixTime + 29 * 24
         else unixTime := unixTime + 28 * 24
    end;
  end;
  
  for i := 1 to day do begin
    unixTime := unixTime + 24;
  end;
end;

function date.compare(_d: date): integer;
begin
  if date.unixTime > _d.unixTime then result := 1
  else if date.unixTime < _d.unixTime then result := -1
  else result := 0;
end;

const possible_records = 100;
const max_products = 25;
const months: array of string = (
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
);

implementation

end.