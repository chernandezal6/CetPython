CREATE OR REPLACE PROCEDURE SUIRPLUS.SRE_ACTUALIZAR_DGI_MAESTRO_P(P_TIPO IN VARCHAR2 DEFAULT 'D') AS
  conteo integer;
  html clob;
  mNombres varchar2(250);
  mRazonSocial varchar2(250);
  mFechaNacCons Date;
  --v_regPatronal  suirplus.sre_empleadores_t.id_registro_patronal%type;
  --v_idSolicitud  number(10);
  v_secuencia number;
  --p_resultnumber varchar2(4000);
  c_mail_to      varchar2(250);
  v_rnc_o_cedula varchar2(11);
  
  procedure add(texto in string) is
  begin
    dbms_lob.append(html,'<tr><td>'||texto||'</td></tr>');
  end;
begin
  dbms_lob.createtemporary(html,true);
  dbms_lob.append(html,
      '<html>'
    ||' <head>'
    ||'  <STYLE TYPE="text/css"><!--.smallfont {font-size:8pt;}--></STYLE>'
    ||'  <title>Log de actualizacion de empleadores</title>'
    ||' </head>'
    ||'  <table border="1" cellpadding=3 cellspacing=0 CLASS="smallfont" style="border-collapse: collapse">');

  add('Inicio: '||to_char(sysdate,'dd/mm/yyyy HH:MI:SS'));
  begin
	  --se agrego un nuevo refresh para la vista materializada "suirplus.dgii_empleadores_general_mv"
	  if trim(upper(p_tipo)) = 'G' then
	    execute immediate 'begin dbms_mview.refresh(''suirplus.dgii_empleadores_general_mv'',''?''); end;';
    end if;

    --modificado por:  CMHA
    --fecha         : 21/11/2016
    --Se modifico el llamado a la visata "dgi_empleadores_diarios_mv" por "DGIITSS_empleadores_GENERAL" 
    -- insertar actividades economicas desconocidas como TMP
	  --modificado por : CMHA
    --fecha : 17/02/2017
	  --se agrego condicion
	  if trim(upper(p_tipo)) = 'G' then
		  insert into suirplus.sre_actividad_economica_t
		  select distinct emps.drg_tae_cod_actividad,'TMP',0.00
		  from suirplus.dgii_empleadores_general_mv emps
		  where emps.drg_tae_cod_actividad is not null
		  and emps.drg_tae_cod_actividad not in (
			select id_actividad_eco from suirplus.sre_actividad_economica_t
		  );	  
		  commit;
	  else 
		  insert into suirplus.sre_actividad_economica_t
		  select distinct emps.drg_tae_cod_actividad,'TMP',0.00
		  from suirplus.dgi_empleadores_diarios_mv emps
		  where emps.drg_tae_cod_actividad is not null
		  and emps.drg_tae_cod_actividad not in (
			select id_actividad_eco from suirplus.sre_actividad_economica_t
		  );	  
		  commit;
	  end if;

    -- insertar Administracion Locales desconocidas
    insert into suirplus.DGI_ADMINISTRACION_LOCAL_t
      (id_administracion_local, administracion_local_des, ult_fecha_act, ult_usuario_act)
    select tab_cod_unidad, tab_nom_unidad, sysdate, 'OPERACIONES'
      from suirplus.DGI_ADMINISTRACION_LOCAL_mv
     where tab_cod_unidad not in
          (select to_number(id_administracion_local)
             from suirplus.DGI_ADMINISTRACION_LOCAL_t);
    commit;

    --modificado por:  CMHA
    --fecha         : 21/11/2016
    --Se modifico el llamado a la vista "dgi_empleadores_diarios_mv" por "DGIITSS_empleadores_GENERAL" 
	  --fecha :15/02/2017
	  --task #10680- Se modifico el llamado a la vista "DGIITSS_empleadores_GENERAL" por "suirplus.dgii_empleadores_general_mv" 
    for emps in (select drg_rnc_cedula, 
                        drg_nombre_razon_social, 
                        drg_tipo_persona, 
                        drg_nombre_comercial, 
                        drg_telefono, 
                        drg_fax, 
                        drg_cod_unidad, 
                        drg_administracion_local, 
                        to_char(drg_tae_cod_actividad) drg_tae_cod_actividad, 
                        drg_actividad_economica, 
                        drg_direccion, 
                        drg_numero, 
                        drg_num_apto_ofic, 
                        drg_referencia, 
                        drg_urbanizacion, 
                        drg_ciudad, 
                        fec_nac_const, 
                        fec_ini_act, 
                        fec_ini_obligaciones, 
                        estatus, 
                        rge_tmu_cod_municipio, 
                        fecha_act
                 from suirplus.dgi_empleadores_diarios_mv
                where 'D' = trim(upper(p_tipo))
                UNION
               select drg_rnc_cedula, 
                      drg_nombre_razon_social, 
                      drg_tipo_persona, 
                      drg_nombre_comercial, 
                      drg_telefono, 
                      drg_fax, 
                      drg_cod_unidad, 
                      drg_administracion_local, 
                      drg_tae_cod_actividad, 
                      drg_actividad_economica, 
                      drg_direccion, 
                      drg_numero, 
                      drg_num_apto_ofic, 
                      drg_referencia, 
                      drg_urbanizacion, 
                      drg_ciudad, 
                      fec_nac_const, 
                      fec_ini_act, 
                      fec_ini_obligaciones, 
                      estatus, 
                      rge_tmu_cod_municipio, 
                      fecha_act
                 from suirplus.dgii_empleadores_general_mv
                where 'G' = trim(upper(p_tipo)))
    loop
	    begin
				v_secuencia := 0;
				v_rnc_o_cedula := TRIM(emps.drg_rnc_cedula); 
				 -- ver si existe como empleador empradronado
				select count(*) into conteo
				from suirplus.sre_empleadores_t a
				where a.rnc_o_cedula = v_rnc_o_cedula;
       
			  --comentamos este codigo hasta que se aclare de la creacion de las solicituds de nss empleadores
			  --fecha : 17/02/2017
			  --cmha
			  --buscamo el registro patronal para este empleador para crear una solicitud
			  /*if (conteo=1) then
					select e.id_registro_patronal
					 into v_regPatronal
					 from SRE_EMPLEADORES_T E
					where TRIM(e.rnc_o_cedula) =  v_rnc_o_cedula;  
				end if;*/  
        
				-- es cedulado, buscar el nombre para comparar
				mNombres := null;
				begin
				  select trim(c.nombres||' '||c.primer_apellido||' '||nvl(c.segundo_apellido,'')),
						 c.fecha_nacimiento
				  into mNombres, mFechaNacCons
				  from suirplus.sre_ciudadanos_t c
				  where c.tipo_documento='C'
				  and c.no_documento = v_rnc_o_cedula;
				exception when no_data_found then
				  mNombres := null;
				end;
 
			  -- empleadores-----------------------------------------------------------------
				if (conteo=1) then
				  if (mNombres is null)  then
				    -- no es cedulado, actualizar fecha nacimiento/constitucion
					  update suirplus.sre_empleadores_t e
					     set e.razon_social = emps.drg_nombre_razon_social,
                   e.fecha_nac_const = emps.fec_nac_const,
                   e.fecha_inicio_actividades = emps.fec_ini_act,
                   e.ult_usuario_act='DGII',
                   e.ult_fecha_act=sysdate
             where e.rnc_o_cedula = v_rnc_o_cedula
               and (e.razon_social <> emps.drg_nombre_razon_social
                    or e.fecha_nac_const <> emps.fec_nac_const
                    or e.fecha_inicio_actividades <> emps.fec_ini_act
                    );

            if SQL%rowcount >= 1 then
					    add('upd sre rnc: '||v_rnc_o_cedula);
					    commit;
					  end if;
				  else
					  --***********************************************************************************************************************************    
					  --Modificado por: CMHA
					  --Fecha         : 21/11/2016 
					  -- Verificamos si el nombre de la razon social es difirente a la razon social dl empleador crear una solicitud
					  /* if (upper(emps.drg_nombre_razon_social) <> upper(mNombres))  then                 
                   
						  nss_insert_solicitudes( p_id_tipo => 3,p_usuario_solicita => 'OPERACIONES',p_fecha_solicitud => trunc(sysdate),
										   p_id_registro_patronal => v_regPatronal,p_ult_fecha_act => trunc(sysdate),
										   p_ult_usuario_act => 'OPERACIONES', p_id_solicitud => v_idSolicitud, p_resultado => p_resultnumber);
                      
                       
						  nss_insert_det_solicitudes( p_id_solicitud => v_idSolicitud, p_secuencia =>  v_secuencia, p_id_tipo_documento =>'C', 
													  p_no_documento_sol => v_rnc_o_cedula, p_id_estatus => 1, p_ult_fecha_act => trunc(sysdate), 
													  p_ult_usuario_act => 'OPERACIONES', p_resultado => p_resultnumber); 
					  end if;
						v_secuencia := v_secuencia + 1;  
                    
					  if (p_resultnumber ='OK' and  v_idSolicitud is not null) then
						  --buscamos los cedulados no encontrados en el WebServices de la JCE
						  NSS_VALIDAR_SOL_CEDULADOS(p_id_solicitud => v_idSolicitud ,p_ult_usuario_act => 'OPERACIONES'  ,p_resultado => p_resultnumber);
					    p_resultnumber:=  'OK';            
					  else
					    p_resultnumber:=  '1';
					  end if;*/
					 --***********************************************************************************************************************************  
					 
           -- si es cedulado, no actualizar la fecha de nacimiento
					 update suirplus.sre_empleadores_t e
					    set e.razon_social = mNombres,
					        e.fecha_inicio_actividades = emps.fec_ini_act,
						      e.id_administracion_local = emps.drg_cod_unidad,
						      e.id_actividad_eco = emps.drg_tae_cod_actividad,
						      e.ult_usuario_act='DGII',
						      e.ult_fecha_act=sysdate
					  where e.rnc_o_cedula = v_rnc_o_cedula
					    and (e.razon_social <> mNombres
					         or e.fecha_inicio_actividades <> emps.fec_ini_act
					         or e.id_administracion_local <> emps.drg_cod_unidad
					         or e.id_actividad_eco <> emps.drg_tae_cod_actividad
                   );

					  if SQL%rowcount >= 1 then
					    add('upd sre ced: '||v_rnc_o_cedula);
					    commit;
					  end if;
				  end if;
				end if;

				-- DGI Maestro Empleadores ----------------------------------------------------------------------
				select count(*) into conteo
				from suirplus.dgi_maestro_empleadores_t a
				where a.rnc_cedula = v_rnc_o_cedula;

				if mNombres is null then
				  mRazonSocial  := emps.drg_nombre_razon_social;
				  mFechaNacCons := emps.fec_nac_const;
				else
				  mRazonSocial  := mNombres;
				  mFechaNacCons := mFechaNacCons; --solo para recordar que ya esta seteada la variable
				end if;

				if (conteo=0) then
				  -- no existe en dgi_maestro_empleadores_t, insertarlo
				  insert into suirplus.dgi_maestro_empleadores_t (
					RNC_CEDULA,
					ID_ACTIVIDAD_ECO,
					TIPO_PERSONA,
					RAZON_SOCIAL,
					NOMBRE_COMERCIAL,
					FECHA_REGISTRO,
					CALLE,
					NUMERO,
					EDIFICIO,
					PISO,
					APARTAMENTO,
					TELEFONO_1,
					EMAIL,
					DIRECCION,
					COD_MUNICIPIO,
					ID_ADMINISTRACION_LOCAL,
					FECHA_INICIO_ACTIVIDADES,
					FECHA_NAC_CONST
				  ) values (
					v_rnc_o_cedula,
					emps.drg_tae_cod_actividad,
					substr(emps.drg_tipo_persona,1,1),
					mRazonSocial,
					emps.drg_nombre_comercial,
					trunc(sysdate),
					null,
					emps.drg_numero,
					null,
					null,
					substr(emps.drg_num_apto_ofic,1,10),
					emps.drg_telefono,
					null,
					emps.drg_direccion,
					null,
					emps.drg_cod_unidad,
					emps.fec_ini_act,
					mFechaNacCons
				  );
				  add('ins dgi: '||v_rnc_o_cedula);
				else
				  -- existe en dgi_maestro_empleadores_t, actualizarlo
				  if (mNombres is null) then
					-- si no es cedulado, actualizar fecha nacimiento/constitucion
					update suirplus.dgi_maestro_empleadores_t a
					set a.razon_social               =  mRazonSocial,
						a.id_actividad_eco           =  emps.drg_tae_cod_actividad,
						a.id_administracion_local    =  emps.drg_cod_unidad,
						fecha_inicio_actividades     =  emps.fec_ini_act,
						fecha_nac_const              =  mFechaNacCons
					where a.rnc_cedula               =  v_rnc_o_cedula
					  and (a.razon_social            <> mRazonSocial
					   or a.id_actividad_eco         <> emps.drg_tae_cod_actividad
					   or a.id_administracion_local  <> emps.drg_cod_unidad
					   or fecha_inicio_actividades   <> emps.fec_ini_act
					   or fecha_nac_const            <> mFechaNacCons);

					if SQL%rowcount >= 1 then
					  add('upd sre ced: '||v_rnc_o_cedula);
					  commit;
					end if;
				  else     
					-- si es cedulado no actualizar la fecha de nacimiento
					update suirplus.dgi_maestro_empleadores_t a
					set a.razon_social               =  mRazonSocial,
						fecha_inicio_actividades     =  emps.fec_ini_act,
						fecha_nac_const              =  mFechaNacCons
					where a.rnc_cedula               =  v_rnc_o_cedula
					  and (a.razon_social            <> mRazonSocial
					   or fecha_inicio_actividades   <> emps.fec_ini_act);

					if SQL%rowcount >= 1 then
					  add('upd sre ced: '||v_rnc_o_cedula);
					  commit;
					end if;
				  end if;
				end if;
				commit;
			  exception when others then
			  add('Se produjo un error para el empleador : '||v_rnc_o_cedula||' -- '||sqlerrm);
			  end;
      end loop;
  exception when others then
    add(sqlerrm);
  end;

  -- fin ------------------------------------------------------------------------------------------
  add('Final: '||to_char(sysdate,'dd/mm/yyyy HH:MI:SS'));
  dbms_lob.append(html,'</table></body></html>');

   -- Modificado por: CMHA
 --  Fecha : 18/01/2017
 --  Se agrego la busqueda de los email desde la tabla de proceso 
  select p.lista_ok
  into c_mail_to
  from suirplus.sfc_procesos_t p
  where p.id_proceso = 'AD';

  system.html_mail(p_sender    => 'info@mail.tss2.gov.do',
                   p_recipient => c_mail_to,
                   p_subject   => 'Log de actualzacion de empleadores',
                   p_message   => html);

  dbms_lob.freetemporary(html);
END;