unit output;
interface

uses consts;
uses products;

procedure printSheet(lp: list_prod; f: text);
function makeOutputProdString(prod: product): string;

implementation

procedure printSheet(lp: list_prod; f: text);
var prodCounter: integer;
    prod: product;
begin  
  prodCounter := 1;
  while prodCounter <= lp.Count do begin
    writeln(f, makeOutputProdString(lp.List[prodCounter]));
    prodCounter := prodCounter + 1;
  end;
end;

function makeOutputProdString(prod: product): string;
var i: integer;
    res: string;
begin
  res := prod.code.ToString();
  result := res;
  for i := 1 to 8 - res.Length do result := result + ' ';
  result := result + '|'; // разделитель табличный
  res := prod.name;
  result := result + res;
  for i := 1 to 32 - res.Length do result := result + ' ';
  result := result + '|';
  res := prod.cost.ToString();
  result := result + res;
  for i := 1 to 10 - res.Length do result := result + ' ';
end;


end.