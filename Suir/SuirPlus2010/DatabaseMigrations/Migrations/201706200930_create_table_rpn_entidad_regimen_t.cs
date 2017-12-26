using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200930)]
    public class _201706200930_create_table_rpn_entidad_regimen_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_ENTIDAD_REGIMEN_T").Exists())
            {
                Create.Table("RPN_ENTIDAD_REGIMEN_T").WithDescription("Entidad que contiene la relación entre el régimen al que pertenece un pensionado y la entidad que sube los archivos de nóminas de titulares y dependientes adicionales del plan especial de servicio de salud..")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_ENTIDAD").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Identificador único de la entidad que sube el archivo de nómina de titulares de pensionados y dependientes adicionales para un régimen. FK a la tabla RPN_ENTIDADES_T.")
                    .WithColumn("ID_REGIMEN").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Identificador único del régimen al que pertenece el pensionado. FK a la tabla RPN_REGIMEN_T.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro.");

                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_ENTIDAD_REG_T_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_ENTIDAD_REGIMEN_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");
            }
        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_ENTIDAD_REGIMEN_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_ENTIDAD_REGIMEN_T");
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_ENTIDAD_REG_T_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                          If v_conteo > 0 Then
                            EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_ENTIDAD_REG_T_TRG');
                          End if;                          
                        END;");
        }
    }
}
