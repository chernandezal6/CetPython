using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200931)]
   public class _201706200931_create_table_rpn_cartera_rechazos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_CARTERA_RECHAZOS_T").Exists())
            {
                Create.Table("RPN_CARTERA_RECHAZOS_T").WithDescription("Entidad que contiene los registros rechazados durante la validación a la cartera de los pensionados por período de los distintos régimenes del plan especial de servicio de salud.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_CARGA").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único de la carga en la que se procesó la cartera de pensionados para un régimen/período.")
                    .WithColumn("ID_NSS_TITULAR").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del pensionado titular.")
                    .WithColumn("ID_NSS_DEPENDIENTE").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("Identificador único del dependiente directo o adicional del pensionado titular.")
                    .WithColumn("PERIODO_FACTURA").AsCustom("NUMBER(6)").NotNullable().WithColumnDescription("Período para el cual se rechaza el registro en formato AAAAMM.")
                    .WithColumn("ID_ERROR").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del error por el cual se rechaza el registro.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro");

                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_CARTERA_RECH_T_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_CARTERA_RECHAZOS_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_CARTERA_RECHAZOS_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_CARTERA_RECHAZOS_T");
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_CARTERA_RECH_T_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_CARTERA_RECH_T_TRG');
                            End if;                          
                        END;");
        }
    }
}
