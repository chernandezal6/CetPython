using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200921)]
    public class _201706200921_create_table_rpn_regimen_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_REGIMEN_T").Exists())
            {
                Down();
                Create.Table("RPN_REGIMEN_T").WithDescription("Catálogo de los distintos regímenes del plan especial de servicios de salud para pensionados.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_REGIMEN").AsCustom("NUMBER(3)").NotNullable().PrimaryKey().WithColumnDescription("Identificador único del régimen al que pertenece un pensionado.")
                    .WithColumn("DESCRIPCION").AsCustom("VARCHAR2(100)").NotNullable().WithColumnDescription("Nombre del régimen al que pertenece un pensionado.")
                    .WithColumn("ID_PARAM_CONTRIBUCION").AsCustom("NUMBER(3)").Nullable().WithColumnDescription("ID del parametro definido para la contribución del pensionado para su seguro de salud. FK a la tabla SFC_PARAMETROS_T.")
                    .WithColumn("ID_PARAM_CAPITA").AsCustom("NUMBER(3)").Nullable().WithColumnDescription("Código del parámetro definido para la cápita correspondiente a los dependientes adicionales de los pensionados para su seguro de salud, fk de la SFC_PARAMETROS_T.")
                    .WithColumn("ID_PARAM_APORTE_DIRECTOS").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Código del parámetro definido para la contribución de los pensionados directo para su seguro de salud, fk de la tabla SFC_PARAMETROS_T.")
                    .WithColumn("ID_PARAM_APORTE_ADICIONALES").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Código del parámetro definido para la contribución de los dependientes adicional de pensionados para su seguro de salud, fk de la tabla SFC_PARAMETROS_T.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro.");

                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_REGIMEN_T_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_REGIMEN_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_REGIMEN_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_REGIMEN_T");                
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_REGIMEN_T_TR'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_REGIMEN_T_TR');
                            End if;                          
                        END;");
        }
    }
}
