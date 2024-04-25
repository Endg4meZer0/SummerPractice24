unit shipments;
interface

uses errors;
uses space_many;

type shipment = record
  date: record
    day: 1..31;
    month: 1..12;
    year: 2000..2100;
  end;
  order_code: integer;
  prod_list: array of record
    code: integer;
    amount: integer;
  end;
end;
list_ship = array of shipment;

function makeFromString(s: string): shipment;
function validateString(s: string): string;

implementation

function makeFromString(s: string): shipment;
begin
  
end;

function validateString(s: string): string;
begin
  
end;

end.