using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200927)]
   public class _201706200927_create_table_rpn_dispersion_resumen_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_DISPERSION_RESUMEN_T").Exists())
            {
                Create.Table("RPN_DISPERSION_RESUMEN_T").WithDescription("Entidad que contiene por ARS, régimen y períodos los cápitas dispersados para titulares, dependientes directos y dependientes adicionales del plan especial de servicio de salud.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_REGIMEN").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Identificador único del régimen que se está dispersando. FK a la tabla RPN_REGIMEN_T.")
                    .WithColumn("ID_ARS").AsCustom("NUMBER(4)").NotNullable().WithColumnDescription("Identificador único de la ARS que recibe los cápitas dispersados. FK a la tabla ARS_CATALOGO_T.")
                    .WithColumn("PERIODO").AsCustom("NUMBER(6)").NotNullable().WithColumnDescription("Período para el cual se realiza la dispersión en formato AAAAMM.")
                    .WithColumn("TITULARES").AsCustom("NUMBER").NotNullable().WithColumnDescription("Cantidad de titulares dispersados por ARS, régimen y período.")
                    .WithColumn("DEPENDIENTES").AsCustom("NUMBER").Nullable().WithColumnDescription("Cantidad de dependientes directos dispersados por ARS, régimen y período.")
                    .WithColumn("ADICIONALES").AsCustom("NUMBER").Nullable().WithColumnDescription("Cantidad de dependientes adicionales dispersados por ARS, régimen y período.")
                    .WithColumn("MONTO_TITULARES").AsCustom("NUMBER(16, 2)").NotNullable().WithColumnDescription("Monto total dispersado por titulares, ARS, régimen y período.")
                    .WithColumn("MONTO_DEPENDIENTES").AsCustom("NUMBER(16, 2)").NotNullable().WithColumnDescription(" Monto total dispersado por dependientes directos, ARS, régimen y período.")
                    .WithColumn("MONTO_ADICIONALES").AsCustom("NUMBER(16, 2)").NotNullable().WithColumnDescription("Monto total dispersado por dependientes adicionales, ARS, régimen y período.")
                    .WithColumn("TOTAL_PAGADO").AsCustom("NUMBER(16, 2)").NotNullable().WithColumnDescription("Monto total dispersado por, ARS, régimen y período.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro");

                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_DISP_RESUMEN_T_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_DISPERSION_RESUMEN_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");

                Execute.Sql(@"DECLARE
                                v_conteo pls_integer;
                                BEGIN
                                  --Buscamos el objeto para ver si existe
                                  Select count(*)
                                    Into v_conteo
                                  From all_objects
                                  Where owner       = 'SUIRPLUS'
                                   And object_name = 'IDX_RPN_DISP_IDARS'
                                   And object_type = 'INDEX';

                                  --Si el objeto exite, lo borramos
                                  If v_conteo = 0 Then                                
                                    EXECUTE IMMEDIATE('CREATE INDEX SUIRPLUS.IDX_RPN_DISP_IDARS ON SUIRPLUS.RPN_DISPERSION_RESUMEN_T(ID_ARS)');
                                  End if;                          
                                END;");

                Execute.Sql(@"DECLARE
                                 v_conteo pls_integer;
                                 BEGIN
                                   --Buscamos el objeto para ver si existe
                                   Select count(*)
                                     Into v_conteo
                                   From all_objects
                                   Where owner       = 'SUIRPLUS'
                                    And object_name = 'IDX_RPN_DISP_PERIODO'
                                    And object_type = 'INDEX';

                                   --Si el objeto exite, lo borramos
                                   If v_conteo = 0 Then                             
                                     EXECUTE IMMEDIATE('CREATE INDEX SUIRPLUS.IDX_RPN_DISP_PERIODO ON SUIRPLUS.RPN_DISPERSION_RESUMEN_T(PERIODO)');
                                   End if;                          
                                 END;");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_DISPERSION_RESUMEN_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_DISPERSION_RESUMEN_T");        
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_DISP_RESUMEN_T_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_DISP_RESUMEN_T_TRG');
                            End if;                          
                        END;");
        }
    }
}
