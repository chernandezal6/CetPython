using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200920)]
    public class _201706200920_create_table_rpn_entidades_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_ENTIDADES_T").Exists())
            {
                Down();
                Create.Table("RPN_ENTIDADES_T").WithDescription("Catálogo de las entidades que suben los archivos de nóminas de titulares y dependientes adicionales del plan especial de servicios de salud para pensionados.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_ENTIDAD").AsCustom("NUMBER(3)").NotNullable().PrimaryKey().WithColumnDescription("Identificador único de la entidad que sube los archivos de nómina de titulares y dependientes adicionales.")
                    .WithColumn("DESCRIPCION").AsCustom("VARCHAR2(50)").NotNullable().WithColumnDescription("Nombre de la entidad que carga los archivos de nómina de titulares y dependientes adicionales")
                    .WithColumn("ID_ENTIDAD_RECAUDADORA").AsCustom("NUMBER(2)").Nullable().WithColumnDescription("ID de la entidad recaudadora.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro.");
              
                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_ENTIDADES_T_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_ENTIDADES_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");            }
        }
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_ENTIDADES_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_ENTIDADES_T");
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_ENTIDADES_T_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_ENTIDADES_T_TRG');
                            End if;                          
                        END;");
        }
    }
}
