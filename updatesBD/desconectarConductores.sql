begin

declare total_rows int;
declare contador int unsigned default 1;
declare diferencia_tiempo int;
declare fecha_ahora datetime;

select COUNT(*) into total_rows from mv_ulttaxi;

 start transaction;
 while contador <= total_rows do
   
select @codigo_row:=x.utaxi_idulttaxi, @fecha_row:=x.utaxi_diahora
from (select t.utaxi_idulttaxi,
              t.utaxi_diahora,
              @rownum := @rownum +1 as position
         from mv_ulttaxi t
         join (select @rownum := 0) r
		 where t.utaxi_estadocond='1'
     order by t.utaxi_idulttaxi) x where x.position=contador;

	 select CONVERT_TZ(now(), @@global.time_zone, '-05:00') into fecha_ahora;
	 select time_to_sec(timediff(fecha_ahora, @fecha_row)) / 3600 into diferencia_tiempo;

    if diferencia_tiempo >= 1 then
update mv_ulttaxi set utaxi_diahora=fecha_ahora, utaxi_estadocond='0' where utaxi_idulttaxi=@codigo_row;
    end if;
   set contador=contador+1;
 end while;
 commit;
end


CREATE EVENT `desconectarConductor_Event` ON SCHEDULE EVERY 30 SECOND 
    ON COMPLETION PRESERVE ENABLE DO CALL cond_DesconectarCond()