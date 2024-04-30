program letpract;

uses consts;
uses products;
uses orders;
uses shipments;

const products_in_filename = 'products.txt';
const orders_in_filename = 'orders.txt';
const shipments_in_filename = 'shipments.txt';

var err_string, line: string;
var file_record_count, list_record_count: integer;
var f_prod, f_ord, f_ship: text;
var l_prod: list_prod; l_ord: list_ord; l_ship: list_ship;
var prod: product; ord: order; ship: shipment;
begin
  assign(f_prod, products_in_filename);
  assign(f_ord, orders_in_filename);
  assign(f_ship, shipments_in_filename);
  reset(f_prod); 
  reset(f_ord); 
  reset(f_ship);
  
  file_record_count := 0;
  list_record_count := 1;
  while (not eof(f_prod)) and (list_record_count <= possible_records) do begin
    err_string := '';
    readln(f_prod, line);
    file_record_count := file_record_count + 1;
    err_string := err_string + validateProductString(line);
    if err_string <> '' then begin
      writeln('Ошибки в ' + products_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
    end else begin
      prod := makeProductObjectFromString(line);
      err_string := validateProductObject(prod, l_prod);
      if err_string <> '' then begin
        writeln('Ошибки в ' + products_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
      end else begin
        l_prod[list_record_count] := prod;
        writeln(l_prod[list_record_count]);
        list_record_count := list_record_count + 1;
      end;
    end;
  end;
  if not eof(f_prod) and (list_record_count > possible_records) then writeln('Слишком много записей о товарах. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
  close(f_prod);
  
  file_record_count := 0;
  list_record_count := 1;
  while (not eof(f_ord)) and (list_record_count <= possible_records) do begin
    err_string := '';
    readln(f_ord, line);
    file_record_count := file_record_count + 1;
    err_string := err_string + validateOrderString(line);
    if err_string <> '' then begin
      writeln('Ошибки в ' + orders_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
    end else begin
      ord := makeOrderObjectFromString(line);
      err_string := validateOrderObject(ord, l_ord, l_prod);
      if err_string <> '' then begin
        writeln('Ошибки в ' + orders_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
      end else begin
        l_ord[list_record_count] := ord;
        writeln(l_ord[list_record_count]);
        list_record_count := list_record_count + 1;
      end;
    end;
  end;
  if not eof(f_ord) and (list_record_count > possible_records) then writeln('Слишком много записей о заказах. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
  close(f_ord);
  
  file_record_count := 0;
  list_record_count := 1;
  while (not eof(f_ship)) and (list_record_count <= possible_records) do begin
    err_string := '';
    readln(f_ship, line);
    file_record_count := file_record_count + 1;
    err_string := err_string + validateShipmentString(line);
    if err_string <> '' then begin
      writeln('Ошибки в ' + shipments_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
    end else begin
      ship := makeShipmentObjectFromString(line);
      err_string := validateShipmentObject(ship, l_ord, l_prod);
      if err_string <> '' then begin
        writeln('Ошибки в ' + shipments_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
      end else begin
        l_ship[list_record_count] := ship;
        writeln(l_ship[list_record_count]);
        list_record_count := list_record_count + 1;
      end;
    end;
  end;
  if not eof(f_ship) and (list_record_count > possible_records) then writeln('Слишком много записей о поставках. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
  close(f_ship);
end.