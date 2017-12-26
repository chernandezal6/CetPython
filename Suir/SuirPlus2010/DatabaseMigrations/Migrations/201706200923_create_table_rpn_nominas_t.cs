using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200923)]
    public class _201706200923_create_table_rpn_nominas_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_NOMINAS_T").Exists())
            {
                Create.Table("RPN_NOMINAS_T").WithDescription(" Entidad que contiene las nóminas de los pensionados titulares por período de los distintos régimenes del plan especial de servicio de salud.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_RECEPCION").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del archivo donde vino la nómina de titulares de pensionados para un régimen/período. FK a la tabla SRE_ARCHIVOS_T.")
                    .WithColumn("ID_CARGA").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único de la carga en la que se procesó la cartera de pensionados para un régimen/período. FK a la tabla ARS_CARGA_T.")
                    .WithColumn("ID_ENTIDAD").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Identificador único de la entidad que subió el archivo de nómina de titulares de pensionados para un régimen/período. FK a la tabla RPN_ENTIDADES_T.")
                    .WithColumn("ID_REGIMEN").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Identificador único del régimen al que pertenece el pensionado. FK a la tabla RPN_REGIMEN_T.")
                    .WithColumn("ID_PENSIONADO").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Código del pensionado")
                    .WithColumn("ID_NSS_TITULAR").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del pensionado titular. FK a la tabla SRE_CIUDADANOS_T.")
                    .WithColumn("SALARIO").AsCustom("NUMBER(13,2)").NotNullable().WithColumnDescription("Salario del pensionado")
                    .WithColumn("MONTO_DESC_SEGURO_SALUD").AsCustom("NUMBER(13,2)").NotNullable().WithColumnDescription("Descuento realizado al salario del pensionado por el régimen al que pertenece el titular para su propia cobertura de salud.)")
                    .WithColumn("TOTAL_DESC_CAPITA_ADICIONAL").AsCustom("NUMBER(13,2)").NotNullable().WithColumnDescription("Descuento realizado al salario del pensionado por el régimen al que pertenece el titular para la cobertura de salud sus dependientes adicionales.")
                    .WithColumn("PERIODO").AsCustom("NUMBER(6)").NotNullable().WithColumnDescription("Período para el cual se realizan los aportes para la cobertura de salud en formato AAAAMM")
                    .WithColumn("TIPO_PAGO").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Forma en que se le devolvería lo descontado al pensionado titular en caso de rechazos o pagos en excesos. H=Hacienda, C=Cheque")
                    .WithColumn("CUENTA_BANCO").AsCustom("VARCHAR2(20)").Nullable().WithColumnDescription("Nro. cuenta bancaria donde se deposita el dinero devuelto al pensionado titular cuando el pago no se realiza por cheque.)")
                    .WithColumn("TIPO_PENSIONADO").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Tipo de pensionado. O=Es el pensionado original, S=Es un sobreviviente del pensionado fallecido.")
                    .WithColumn("ID_ERROR").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("Identificador único del error por el cual se rechaza el registro. FK a la tabla ARS_CARTERA_ERRORES_T.")
                    .WithColumn("STATUS").AsCustom("VARCHAR2(2)").NotNullable().WithColumnDescription("Estatus del registro.PE=Pendiente, OK=Aceptado, RE=Rechazado.")
                    .WithColumn("MONTO_DEVOLVER").AsCustom("NUMBER(13,2)").NotNullable().WithColumnDescription("Monto devuelto al pensionado por haberles descontado de más, de menos o por rechazos.")
                    .WithColumn("CAPITA_DEVOLVER").AsCustom("NUMBER(13,2)").NotNullable().WithColumnDescription("Cápita devuelto al pensionado por haberles descontado de más, de menos o por rechazos a un dependiente adicional.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro");

                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_NOMINAS_T_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_NOMINAS_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_NOMINAS_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_NOMINAS_T");
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_NOMINAS_T_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_NOMINAS_T_TRG');
                            End if;                          
                        END;");
        }
    }
}
