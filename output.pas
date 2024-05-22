unit output;
interface

uses consts;
uses products, orders, shipments;

procedure printSheet(lp: list_prod; lo: list_ord; ls: list_ship; year: integer; f: text);
function makeOutputProdString(orderName: string; cost: real; orderAmount: integer; shippedAmount: integer): string;

implementation

procedure printSheet(lp: list_prod; lo: list_ord; ls: list_ship; year: integer; f: text);
var prodCounter, ordCounter, shipCounter, i: integer;
    productGotOrderedThisYear, orderHasProduct, shipmentExists: boolean;
    prod: product;
    ord: order;
    ship: shipment;
    prodOrdered, prodShipped: integer;
    overallOrdered, overallShipped: integer;
    res: string;
begin
  writeln(f, 'Ведомость поставок товаров заказчикам заводом "Прогресс" за ' + year.ToString() + ' год.');
  
  // Наименование заказчика - 32 символа
  // Цена товара - 10 символов
  // Плановая поставка - 8 символов
  // Фактически отгружено - 8 символов
  // Отклонение - 8 символов
  // Между каждым полем еще по 4 пробела
  // Это минимальные длины. Вообще даю больше места в основном из-за заголовков.
  writeln(f, '--------------------------------------------------------------------------------------------------------------');
  writeln(f, 'Наименование                        Цена товара,    Плановая поставка,    Фактически отгружено,    Отклонение,');
  writeln(f, 'заказчика                           тыс. руб.       шт.                   шт.                      шт.        ');
  writeln(f, '--------------------------------------------------------------------------------------------------------------');
  
  prodCounter := 1;
  while prodCounter <= lp.Count do begin
    productGotOrderedThisYear := false;
    res := '';
    prod := lp.List[prodCounter];
    prodOrdered := 0; prodShipped := 0;
    res := 'Товар ' + prod.name + char(10);
    ordCounter := 1;
    while ordCounter <= lo.Count do begin
      i := 1;
      orderHasProduct := false;
      while (i <= max_products) and (lo.List[ordCounter].prod_list[i].Code <> 0) and not orderHasProduct do begin
        if (lo.List[ordCounter].prod_list[i].Code = prod.code) and (lo.List[ordCounter].date.Year = year) then orderHasProduct := true;
        i := i + 1;
      end;
      if orderHasProduct then begin
        i := i - 1;
        productGotOrderedThisYear := true;
        ord := lo.List[ordCounter];
        shipCounter := 0;
        shipmentExists := false;
        while (shipCounter <= ls.Count) and not shipmentExists do begin
          shipCounter := shipCounter + 1;
          if (ls.List[shipCounter].order_code = ord.code) and (ls.List[shipCounter].date.Year = year) then shipmentExists := true;
        end;
        
        if shipmentExists then begin
          ship := ls.List[shipCounter];
          res := res + makeOutputProdString(ord.name, prod.cost, ord.prod_list[i].Amount, ship.prod_list[i].Amount) + char(10);
          prodShipped := prodShipped + ship.prod_list[i].Amount;
        end else begin
          res := res + makeOutputProdString(ord.name, prod.cost, ord.prod_list[i].Amount, 0) + char(10);
        end;
        prodOrdered := prodOrdered + ord.prod_list[i].Amount;
      end;
      
      ordCounter := ordCounter + 1;
    end;
    
    if productGotOrderedThisYear then begin
      write(f, res);
      writeln(f, makeOutputProdString('Итого по товару:', 0, prodOrdered, prodShipped));
    
      overallOrdered := overallOrdered + prodOrdered;
      overallShipped := overallShipped + prodShipped;
    end;
    
    prodCounter := prodCounter + 1;
  end;
  writeln(f, '..............................................................................................................');
  writeln(f, makeOutputProdString('Итого:', 0, overallOrdered, overallShipped));
end;

function makeOutputProdString(orderName: string; cost: real; orderAmount: integer; shippedAmount: integer): string;
var i: integer;
    res: string;
begin
  result := orderName;
  for i := 1 to 32 - orderName.Length do result := result + ' ';
  result := result + '    '; // те самые 4 пробела между полями
  res := cost.ToString();
  if res = '0' then res := '';
  result := result + res;
  for i := 1 to 12 - res.Length do result := result + ' '; // на 2 пробела больше
  result := result + '    ';
  res := orderAmount.ToString();
  result := result + res;
  for i := 1 to 18 - res.Length do result := result + ' '; // на 10 пробелов больше
  result := result + '    ';
  res := shippedAmount.ToString();
  if res = '0' then res := '-';
  result := result + res;
  for i := 1 to 21 - res.Length do result := result + ' '; // на 13 пробелов больше
  result := result + '    ';
  res := (abs(orderAmount - shippedAmount)).ToString();
  result := result + res;
  for i := 1 to 8 - res.Length do result := result + ' ';
end;


end.