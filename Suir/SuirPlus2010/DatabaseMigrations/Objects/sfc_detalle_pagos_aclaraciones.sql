create or replace procedure suirplus.sfc_detalle_pagos_aclaraciones(p_mes in varchar2) as
	v_mailsubject	 varchar2(100);
	v_mailfrom	 	varchar2(100);
	v_mailto	 	varchar2(4000);
	v_desde			date;
	v_hasta			date;
	v_html		 	varchar2(32767) := '';
	v_sub_ok_monto  	number(18,2);
	v_sub_ok_conteo 	integer;
	v_sub_ac_monto  	number(18,2);
	v_sub_ac_conteo 	integer;
	v_sub_re_monto  	number(18,2);
	v_sub_re_conteo 	integer;
	v_sub_conteo		integer;
	v_tot_ok_monto  	number(18,2);
	v_tot_ok_conteo 	integer;
	v_tot_ac_monto  	number(18,2);
	v_tot_ac_conteo 	integer;
	v_tot_re_monto  	number(18,2);
	v_tot_re_conteo 	integer;
	v_tot_conteo		integer;
	v_banco		 	sfc_entidad_recaudadora_t.entidad_recaudadora_des%type;
begin
	v_mailfrom		:= 'info@mail.tss2.gov.do';
	v_mailsubject	:= 'Resumen de Envios de Archivos de Pagos';
	if p_mes is null then
		v_desde			:= to_date('01/'||nvl(p_mes,to_char(sysdate,'mm/yyyy')),'dd/mm/yyyy');
		v_hasta			:= sysdate;
	else
		v_desde			:= to_date('01/'||nvl(p_mes,to_char(sysdate,'mm/yyyy')),'dd/mm/yyyy');
		v_hasta			:= add_months(v_desde,1)-(1/24/60/60);
	end if;
	v_html 			:= v_html||'<html>';
	v_html 			:= v_html||'<head>';
	v_html 			:= v_html||'<title>'||v_mailsubject||'</title>';
	v_html 			:= v_html||'</head>';
	v_html 			:= v_html||'<body align=center>';
	v_html 			:= v_html||'<center><h2><font color=blue>'||v_mailsubject||'</h2><h4>';
	v_html 			:= v_html||'Desde '||to_char(v_desde,'dd/mm/yyyy HH24:mi:ss');
	v_html 			:= v_html||'<br>Hasta '||to_char(v_hasta,'dd/mm/yyyy HH24:mi:ss');
	v_html 			:= v_html||'</h4></font>';
	v_html 			:= v_html||'<table border="1" cellpadding=3 cellspacing=0>';
	v_html 			:= v_html||'<tr bgcolor=#E0E0E0>';
	v_html 			:= v_html||'<th align=center><br>Banco</th>';
	v_html 			:= v_html||'<th align=center>No.<br>Envio</th>';
	v_html 			:= v_html||'<th align=center><br>Fecha Envio</th>';
	v_html 			:= v_html||'<th align=center>Tipo de<br>Archivo</th>';
	v_html 			:= v_html||'<th align=center><br>Aceptados</th>';
	v_html 			:= v_html||'<th align=center>Total<br>Aceptado</th>';
	v_html 			:= v_html||'<th align=center>Requieren<br>Aclaracion</th>';
	v_html 			:= v_html||'<th align=center>Total<br>Aclaracion</th>';
	v_html 			:= v_html||'<th align=center>Fueron<br>Rechazados</th>';
	v_html 			:= v_html||'<th align=center>Total<br>Rechazados</th>';
	v_html 			:= v_html||'</tr>';
	v_tot_ok_monto  := 0;
	v_tot_ok_conteo := 0;
	v_tot_ac_monto  := 0;
	v_tot_ac_conteo := 0;
	v_tot_re_monto  := 0;
	v_tot_re_conteo := 0;
	v_tot_conteo 	:= 0;
	for bancos in (
		select e.id_entidad_recaudadora,e.entidad_recaudadora_des,count(*)+1 conteo
		from sre_archivos_t a,
			 sfc_entidad_recaudadora_t e,
			(select id_recepcion,count(*) conteo from sre_tmp_movimiento_recaudo_t where status='AC' group by id_recepcion) ac,
			(select id_recepcion,count(*) conteo from sre_tmp_movimiento_recaudo_t where status='RE' group by id_recepcion) RE
		where a.fecha_carga between v_desde and v_hasta
		and a.id_tipo_movimiento in ('EP')
		and a.status<>'N'
		and e.id_entidad_recaudadora=a.id_entidad_recaudadora
		and ac.id_recepcion(+)=a.id_recepcion
		and re.id_recepcion(+)=a.id_recepcion
		group by e.id_entidad_recaudadora,e.entidad_recaudadora_des
		order by e.entidad_recaudadora_des)
	loop
		v_html := v_html||'<tr>';
		v_html := v_html||'<td rowspan='||bancos.conteo||'>'||bancos.entidad_recaudadora_des||'</td>';
		v_sub_ok_monto  := 0;
		v_sub_ok_conteo := 0;
		v_sub_ac_monto  := 0;
		v_sub_ac_conteo := 0;
		v_sub_re_monto  := 0;
		v_sub_re_conteo := 0;
		v_sub_conteo 	:= 0;
		for registros in (
			select a.id_recepcion no_envio,
					to_char(a.fecha_carga,'dd/mm/yyyy') fecha_envio,
					a.status,
					decode(a.id_tipo_movimiento,'EP','Pago','Aclar.') Tipo,
					count(d.id_recepcion) ok_conteo,
					sum(d.monto) ok_monto,
					nvl(ac.conteo,0) ac_conteo,
					nvl(ac.suma  ,0) ac_monto,
					nvl(re.conteo,0) re_conteo,
					nvl(re.suma  ,0) re_monto
			from sre_archivos_t a,
				sre_det_movimiento_recaudo_t d,
				(select id_recepcion,sum(monto) suma,count(*) conteo from sre_tmp_movimiento_recaudo_t where status='AC' group by id_recepcion) ac,
				(select id_recepcion,sum(monto) suma,count(*) conteo from sre_tmp_movimiento_recaudo_t where status='RE' group by id_recepcion) RE
			where a.fecha_carga between v_desde and v_hasta
			and a.id_tipo_movimiento in ('EP')
			and a.status<>'N'
			and a.id_entidad_recaudadora=bancos.id_entidad_recaudadora
			and d.id_recepcion(+) =a.id_recepcion
			and ac.id_recepcion(+)=a.id_recepcion
			and re.id_recepcion(+)=a.id_recepcion
			group by a.id_recepcion,
					a.fecha_carga,
					a.status,
					a.id_tipo_movimiento,
					ac.conteo,
					re.conteo,
					ac.suma,
					re.suma
			order by a.id_recepcion)
		loop
			v_html := v_html||'<td align=center>'	||registros.no_envio||'</td>';
			v_html := v_html||'<td>'				||registros.fecha_envio||'</td>';
			v_html := v_html||'<td align=center>'	||registros.tipo||'</td>';
			v_html := v_html||'<td bgcolor=#90EE90 align=center>'	||trim(to_char(nvl(registros.ok_conteo,0),'999,999,990'))||'</td>';
			v_html := v_html||'<td bgcolor=#90EE90 align=right >'	||trim(to_char(nvl(registros.ok_monto ,0),'999,999,999,990.00'))||'</td>';
			v_html := v_html||'<td bgcolor=#FAFAD2 align=center>'	||trim(to_char(nvl(registros.ac_conteo,0),'999,999,990'))||'</td>';
			v_html := v_html||'<td bgcolor=#FAFAD2 align=right >'	||trim(to_char(nvl(registros.ac_monto  ,0),'999,999,990.00'))||'</td>';
			v_html := v_html||'<td bgcolor=#87CEFA align=center>'	||trim(to_char(nvl(registros.re_conteo,0),'999,999,990'))||'</td>';
			v_html := v_html||'<td bgcolor=#87CEFA align=right >'	||trim(to_char(nvl(registros.re_monto ,0),'999,999,990.00'))||'</td>';
			v_html := v_html||'</tr><tr>';
			v_sub_ok_monto  := v_sub_ok_monto  + nvl(registros.ok_monto ,0);
			v_sub_ok_conteo := v_sub_ok_conteo + nvl(registros.ok_conteo,0);
			v_sub_ac_monto  := v_sub_ac_monto  + nvl(registros.ac_monto ,0);
			v_sub_ac_conteo := v_sub_ac_conteo + nvl(registros.ac_conteo,0);
			v_sub_re_monto  := v_sub_re_monto  + nvl(registros.re_monto ,0);
			v_sub_re_conteo := v_sub_re_conteo + nvl(registros.re_conteo,0);
			v_sub_conteo	:= v_sub_conteo	   + 1;
			v_tot_ok_monto  := v_tot_ok_monto  + nvl(registros.ok_monto ,0);
			v_tot_ok_conteo := v_tot_ok_conteo + nvl(registros.ok_conteo,0);
			v_tot_ac_monto  := v_tot_ac_monto  + nvl(registros.ac_monto ,0);
			v_tot_ac_conteo := v_tot_ac_conteo + nvl(registros.ac_conteo,0);
			v_tot_re_monto  := v_tot_re_monto  + nvl(registros.re_monto ,0);
			v_tot_re_conteo := v_tot_re_conteo + nvl(registros.re_conteo,0);
			v_tot_conteo	:= v_tot_conteo	   + 1;
		end loop;
		v_html := v_html||'<td><b>Subtotal</b></td>';
		v_html := v_html||'<td align=center><b>'||trim(to_char(v_sub_conteo))||' archivos</b></td>';
		v_html := v_html||'<td>&nbsp</td>';
		v_html := v_html||'<td bgcolor=#90EE90 align=center><b>'||trim(to_char(v_sub_ok_conteo,'999,999,999,990'))||'</b></td>';
		v_html := v_html||'<td bgcolor=#90EE90 align=right ><b>'||trim(to_char(v_sub_ok_monto ,'999,999,999,990.00'))||'</b></td>';
		v_html := v_html||'<td bgcolor=#FAFAD2 align=center><b>'||trim(to_char(v_sub_ac_conteo,'999,999,999,990'))||'</b></td>';
		v_html := v_html||'<td bgcolor=#FAFAD2 align=right ><b>'||trim(to_char(v_sub_ac_monto ,'999,999,999,990.00'))||'</b></td>';
		v_html := v_html||'<td bgcolor=#87CEFA align=center><b>'||trim(to_char(v_sub_re_conteo,'999,999,999,990'))||'</b></td>';
		v_html := v_html||'<td bgcolor=#87CEFA align=right ><b>'||trim(to_char(v_sub_re_monto ,'999,999,999,990.00'))||'</b></td>';
		v_html := v_html||'</tr>';
	end loop;
	v_html := v_html||'<tr>';
	v_html := v_html||'<th align=left colspan=2><b>Total General</b></th>';
	v_html := v_html||'<th align=center><b>'||trim(to_char(v_tot_conteo))||' archivos</b></th>';
	v_html := v_html||'<th>&nbsp</th>';
	v_html := v_html||'<th bgcolor=#90EE90 align=center><b>'||trim(to_char(v_tot_ok_conteo,'999,999,999,990'))||'</b></th>';
	v_html := v_html||'<th bgcolor=#90EE90 align=right ><b>'||trim(to_char(v_tot_ok_monto ,'999,999,999,990.00'))||'</b></th>';
	v_html := v_html||'<th bgcolor=#FAFAD2 align=center><b>'||trim(to_char(v_tot_ac_conteo,'999,999,999,990'))||'</b></th>';
	v_html := v_html||'<th bgcolor=#FAFAD2 align=right ><b>'||trim(to_char(v_tot_ac_monto ,'999,999,999,990.00'))||'</b></th>';
	v_html := v_html||'<th bgcolor=#87CEFA align=center><b>'||trim(to_char(v_tot_re_conteo,'999,999,999,990'))||'</b></th>';
	v_html := v_html||'<th bgcolor=#87CEFA align=right ><b>'||trim(to_char(v_tot_re_monto ,'999,999,999,990.00'))||'</b></th>';
	v_html := v_html||'</tr>';
	v_html := v_html||'</table>';
	v_html := v_html||'</center>';
	v_html := v_html||'</body>';
	v_html := v_html||'</html>';
--    system.html_mail(v_mailfrom,v_mailto,v_mailsubject,v_html);
   -- modificado por: CMHA
   -- fecha         : 03/03/2017
   --Buscamos la receptor en la tabla sfc_procesos_t 
    select p.lista_ok 
    into v_mailto
    from suirplus.sfc_procesos_t p
    where p.id_proceso = '90';
    
    system.html_mail(v_mailfrom,v_mailto,v_mailsubject,v_html);
end;