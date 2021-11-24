use curso;
-- ************************************************************
-- Laboratorio - PLSQL-CS
-- Carlos Selman 2018325 IN5BM
-- ************************************************************
-- 01. Realiza los siguientes incisos según
-- correspondan a vistas o rutinas almacenadas:
-- ------------------------------------------------------------
-- 1) CRUD de productos.
-- sp_Instertar
Delimiter $$
	create procedure sp_Insertar_Productos(in pd Varchar(80),in pc varchar(20),in ps tinyint,in pp decimal(10,2), in ppid int)
Begin 
	insert into Productos(Prod_Descripcion,Prod_Color,Prod_Status,Prod_Precio,Prod_ProvId) values (pd,pc,ps,pp,ppid);
end $$
Delimiter ;
call sp_Insertar_Productos('Cable fibra 2.0','',1,0.00,14);
-- sp_Modificar
Delimiter $$
	create procedure sp_Modificar_Productos(in pd Varchar(80),in pc varchar(20),in ps tinyint,in pp decimal(10,2), in ppid int, in spmp1 int)
begin
	update Productos set Prod_Descripcion=pd,Prod_Color=pc,Prod_Status=ps,Prod_Precio=pp,Prod_ProvId=ppid where Prod_Id=spmp1;
end $$
Delimiter ;
call sp_Modificar_Productos('CF 2.0','',1,0.00,14,1); -- Modificando al id
call sp_Modificar_Productos('Cable fibra 2.0','',1,0.00,14,1); -- Regresando al id
-- sp_Eliminar
Delimiter $$
create procedure sp_Eliminar_Productos(in spep1 int)
begin
	delete from Productos where Prod_Id=spep1;
end $$
Delimiter ;
call sp_Eliminar_Productos (3)
-- sp_Buscar
Delimiter $$
create procedure sp_Buscar_Productos(in spbp1 int)
begin
	select * from Productos where Prod_Id=spbp1;
end $$
Delimiter ;
call sp_Buscar_Productos (5)
-- 2) CRUD de clientes.
-- sp_Instertar
Delimiter $$
create procedure sp_Insertar_Clientes(in crz varchar(80))
Begin 
	insert into clientes(Cli_RazonSocial) values (crz);
end $$
Delimiter ;
call sp_Insertar_Clientes('Cosum fin');
-- sp_Modificar
Delimiter $$
create procedure sp_Modificar_Clientes(in crz varchar(80), in cid int)
Begin 
	update clientes set Cli_RazonSocial=crz where Cli_Id=cid ;
end $$
Delimiter ;
call sp_Modificar_Clientes('CF','1'); -- Modificando al id 
call sp_Modificar_Clientes('CONSUMIDOR FINAL','1'); -- Regresando al id
-- sp_Eliminar
Delimiter $$
create procedure sp_Eliminar_Clientes(in specl1 int)
begin
	delete from clientes where Cli_Id=specl1;
end $$
Delimiter ;
call sp_Eliminar_Clientes (3);
-- sp_Buscar
Delimiter $$
create procedure sp_Buscar_Clientes(in spbcl1 int)
begin
	select * from clientes where Cli_Id=spbcl1;
end $$
Delimiter ;
call sp_Buscar_Clientes (5);
-- 3) Una vista para las ventas hechas al
-- consumidor final.
 create view vw_VCF as 
 select v.Ventas_Id,v.Ventas_Fecha,v.Ventas_CliId,v.Ventas_NroFactura,v.Ventas_Neto,v.Ventas_Iva,v.Ventas_Total from ventas v,clientes c where
 v.Ventas_CliId=Cli_Id and c.Cli_RazonSocial= "CONSUMIDOR FINAL";
-- 4) Un sp para mostrar las ventas hechas a un
-- cliente en específico recibiendo como
-- argumento el identificador del cliente.
Delimiter $$
create procedure sp_Buscar_Ventas_Cliente(in spcv1 int)
begin
	select * from ventas where Ventas_CliId=spcv1;
end $$
Delimiter ;
call sp_Buscar_Ventas_Cliente (6602);
-- 5) Una vista para mostrar los clientes ordenados
-- de manera ascendente por la razón social.
create view vw_VCRZ as
select * from clientes order by Cli_RazonSocial  asc
-- 6) Un sp para mostrar los productos según su
-- estado.
Delimiter $$
create procedure sp_Productos_Estado(in spps1 int)
begin
	select * from productos where Prod_Status=spps1;
end $$
Delimiter ;
call sp_Productos_Estado (1);
-- 7) Un sp para mostrar las ventas según un
-- rango de fechas.
Delimiter $$
create procedure sp_Ventas_Fechas(in d1 date,in d2 date)
begin
	select * from ventas where Ventas_Fecha between d1 and d2;
end $$
Delimiter ;
call sp_Ventas_Fechas ("2018-01-01","2018-01-31");
-- 8) Una vista que muestre los productos que
-- nunca se han vendido.
create view vw_PNV as 
select Prod_Id,Prod_Descripcion from productos  where Prod_Id not in(select VD_ProdId
    from ventas_detalle);
-- 9) Un sp para consultar los productos que no se
-- han vendido en algún rango de fechas.
Delimiter $$
create procedure sp_Productos_no_Fechas(in d1 date, in d2 date)
begin
    select p.prod_id,p.prod_descripcion from productos p 
    where prod_id not in(select vd.VD_ProdId from ventas v,ventas_detalle vd where
	v.Ventas_Id=vd.VD_VentasId and
    p.Prod_Id=vd.vd_ProdId and
    v.Ventas_Fecha between d1 and d2);
end $$
Delimiter ;
call sp_Productos_no_Fechas ("2018-01-01","2018-05-31");
-- 10) Un sp para consultar los productos que
-- se han vendido dependiendo un rango de
-- fechas.
Delimiter $$
create procedure sp_Ventas_si_Fechas(in d1 date,in d2 date)
begin
	select p.prod_id,p.prod_descripcion from productos p 
	where prod_id  in(select vd.VD_ProdId from ventas v,ventas_detalle vd where
	v.Ventas_Id=vd.VD_VentasId and
    p.Prod_Id=vd.vd_ProdId and
    v.Ventas_Fecha between d1 and d2);
end $$
Delimiter ;
call sp_Ventas_si_Fechas ("2018-01-01","2018-01-31");
