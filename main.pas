program letpract;
//?const N = 100;
uses types;


var f_prod, f_ord, f_ship: text;
var l_prod: list_prod; l_ord: list_ord; l_ship: list_ship;
begin
  assign(f_prod, 'products.txt');
  assign(f_ord, 'orders.txt');
  assign(f_ship, 'shipments.txt');
  reset(f_prod); 
  reset(f_ord); 
  reset(f_ship);
  
  
  
end.