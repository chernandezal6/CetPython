using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200924)]
    public class _201706200924_create_table_rpn_dep_adicionales_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_DEP_ADICIONALES_T").Exists())
            {
                Create.Table("RPN_DEP_ADICIONALES_T").WithDescription("Entidad que contiene las nóminas de los dependientes adicionales aceptados para pensionados titulares por período de los distintos régimenes del plan especial de servicio de salud.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_RECEPCION").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del archivo donde vino la nómina de dependientes adicionales de pensionados titulares para un régimen/período. FK a la tabla SRE_ARCHIVOS_T.")
                    .WithColumn("ID_ENTIDAD").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Identificador único de la entidad que subió el archivo de nómina de dependientes adicionales de pensionados titulares para un régimen/período. FK a la tabla RPN_ENTIDADES_T.")
                    .WithColumn("ID_CARGA").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único de la carga en la que se procesó la cartera de pensionados para un régimen/período. FK a la tabla ARS_CARGA_T.")
                    .WithColumn("ID_REGIMEN").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Identificador único del régimen al que pertenece el pensionado titular del dependiente adicional. FK a la tabla RPN_REGIMEN_T.")
                    .WithColumn("ID_NSS_TITULAR").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del pensionado titular. FK a la tabla SRE_CIUDADANOS_T.")
                    .WithColumn("ID_NSS_DEPENDIENTE").AsCustom("NUMBER(10)").Nullable().WithColumnDescription("Identificador único del dependiente adicional. FK a la tabla SRE_CIUDADANOS_T.")
                    .WithColumn("PERIODO").AsCustom("NUMBER(6)").NotNullable().WithColumnDescription("Período enviado, en formato AAAAMM")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro");

                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_DEP_ADICIONAL_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_DEP_ADICIONALES_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_DEP_ADICIONALES_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_DEP_ADICIONALES_T");
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_DEP_ADICIONAL_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_DEP_ADICIONAL_TRG');
                            End if;                          
                        END;");
        }
    }
}
