using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200926)]
    public class _201706200926_create_table_rpn_tmp_nominas_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_TMP_NOMINAS_T").Exists())
            {
                Create.Table("RPN_TMP_NOMINAS_T").WithDescription("Entidad que contiene los archivos de nóminas de los pensionados titulares y sus dependientes adicionales por período de los distintos regímenes del plan especial de servicio de salud.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_SECUENCIA").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único secuencial por recepción que identifica una fila del archivo donde vino la nómina de titulares o dependiente adicional.")
                    .WithColumn("ID_RECEPCION").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del archivo donde vino la nómina de titulares de pensionados o de dependientes adicionales para un régimen/período.")
                    .WithColumn("ID_ENTIDAD").AsCustom("VARCHAR2(3)").Nullable().WithColumnDescription("Identificador único de la entidad que subió el archivo de nómina de titulares o dependiente adicional para un régimen/período.")
                    .WithColumn("ID_REGIMEN").AsCustom("VARCHAR2(3)").Nullable().WithColumnDescription("Identificador único del régimen al que pertenece el pensionado titular.")
                    .WithColumn("ID_PENSIONADO").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Código del pensionado.")
                    .WithColumn("CEDULA_PENSIONADO").AsCustom("VARCHAR2(11)").Nullable().WithColumnDescription("Nro. de identificación personal del pensionado titular.")
                    .WithColumn("CEDULA_DEP_ADICIONAL").AsCustom("VARCHAR2(11)").Nullable().WithColumnDescription("Nro. de identificación personal del dependiente adicional.")
                    .WithColumn("SALARIO").AsCustom("VARCHAR2(16)").Nullable().WithColumnDescription("Salario del pensionado.")
                    .WithColumn("MONTO_DESC_SEGURO_SALUD").AsCustom("VARCHAR2(16)").Nullable().WithColumnDescription("Descuento realizado al salario del pensionado por el régimen al que pertenece el titular para su propia cobertura de salud.")
                    .WithColumn("TOTAL_DESC_CAPITA_ADICIONAL").AsCustom("VARCHAR2(16)").Nullable().WithColumnDescription("Descuento realizado al salario del pensionado por el régimen al que pertenece el titular para la cobertura de salud sus dependientes adicionales.")
                    .WithColumn("PERIODO").AsCustom("VARCHAR2(6)").Nullable().WithColumnDescription("Período para el cual se realizan los aportes para la cobertura de salud en formato AAAAMM.")
                    .WithColumn("TIPO_PAGO").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Forma en que se le devolvería lo descontado al pensionado titular en caso de rechazos o pagos en excesos. H=Hacienda, C=Cheque.")
                    .WithColumn("CUENTA_BANCO").AsCustom("VARCHAR2(20)").Nullable().WithColumnDescription("Nro. cuenta bancaria donde se deposita el dinero devuelto al pensionado titular cuando el pago no se realiza por cheque.")
                    .WithColumn("TIPO_PENSIONADO").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Tipo de pensionado. O=Es el pensionado original, S=Es un sobreviviente del pensionado fallecido.")
                    .WithColumn("ID_ERROR").AsCustom("VARCHAR2(6)").Nullable().WithColumnDescription("Identificador único del error por el cual se rechaza el registro.")
                    .WithColumn("STATUS").AsCustom("VARCHAR2(2)").Nullable().WithColumnDescription("Estatus del registro. PE=Pendiente, OK=Aceptado, RE=Rechazado.")
                    .WithColumn("OBSERVACION").AsCustom("VARCHAR2(200)").Nullable().WithColumnDescription("Observación de los mensajes de errores de cargas de archivos.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro.");

                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_TMP_NOMINAS_T_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_TMP_NOMINAS_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");

                Execute.Sql("ALTER TABLE SUIRPLUS.RPN_TMP_NOMINAS_T ADD CONSTRAINT CHK_RPN_TMP_NOMINAS_STATUS CHECK(STATUS IN ('PE','RE','OK','PY1'))");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_TMP_NOMINAS_T").Exists())
            {
                Delete.Table("RPN_TMP_NOMINAS_T").InSchema("SUIRPLUS");
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_TMP_NOMINAS_T_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_TMP_NOMINAS_T_TRG');
                            End if;                          
                        END;");
        }
    }
}
