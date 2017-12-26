using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706200922)]
    public class _201706200922_create_table_rpn_cartera_pensionados : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("RPN_CARTERA_PENSIONADOS_T").Exists())
            {
                Down();
                Create.Table("RPN_CARTERA_PENSIONADOS_T").WithDescription("Entidad que contiene la cartera de los pensionados por período de los distintos régimenes del plan especial de servicio de salud.")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_ARS").AsCustom("NUMBER(4)").NotNullable().WithColumnDescription("Identificador único de la ARS a la que está afiliado un pensionado. FK a la tabla ARS_CATALOGO_T.")
                    .WithColumn("ID_CARGA").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único de la carga en la que se procesó la cartera de pensionados para un régimen/período. FK a la tabla ARS_CARGA_T.")
                    .WithColumn("ID_REGIMEN").AsCustom("NUMBER(3)").NotNullable().WithColumnDescription("Identificador único del régimen al que pertenece el pensionado. FK a la tabla RPN_REGIMEN_T")
                    .WithColumn("ID_NSS_TITULAR").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del pensionado titular. FK a la tabla SRE_CIUDADANOS_T.")
                    .WithColumn("ID_NSS_DEPENDIENTE").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Identificador único del dependiente directo o adicional del pensionado titular. FK a la tabla SRE_CIUDADANOS_T.")
                    .WithColumn("ID_PARENTESCO").AsCustom("VARCHAR2(2)").Nullable().WithColumnDescription("Identificador único del parentesco del dependiente directo o adicional en relación al pensionado titular. FK a la tabla ARS_PARENTESCOS_T.")
                    .WithColumn("TIPO_AFILIADO").AsCustom("VARCHAR2(1)").NotNullable().WithColumnDescription("Tipo de afiliado. T=Titular, D=Dependiente Directo, A=Dependiente Adicional")
                    .WithColumn("PERIODO_FACTURA").AsCustom("NUMBER(6)").NotNullable().WithColumnDescription("Período para el cual tiene cobertura en formato AAAAMM")
                    .WithColumn("TIPO_FACTURABLE").AsCustom("NUMBER(2)").NotNullable().WithColumnDescription("1=Facturable Normal")
                    .WithColumn("ESTUDIANTE").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Si el dependiente es o no estudiante. S=Si, N=No.")
                    .WithColumn("DISCAPACITADO").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Si el dependiente es o no discapacitado. S=Si, N=No")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Usuario que actualizó el registro");

                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_RPN_CARTERA_PENS_T_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.RPN_CARTERA_PENSIONADOS_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");

                Execute.Sql("ALTER TABLE SUIRPLUS.RPN_CARTERA_PENSIONADOS_T ADD CONSTRAINT CHK_TIPO_FACT_RPN_CART_PENS CHECK(TIPO_FACTURABLE IN (1, 2))");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("RPN_CARTERA_PENSIONADOS_T").Exists())
            {
                Delete.Table("SUIRPLUS.RPN_CARTERA_PENSIONADOS_T");
            }

            Execute.Sql(@"DECLARE
                            v_conteo pls_integer;
                          BEGIN
                            --Buscamos el objeto para ver si existe
                            Select count(*)
                              Into v_conteo
                              From all_objects
                             Where owner       = 'SUIRPLUS'
                               And object_name = 'DATE_ON_RPN_CARTERA_PENS_T_TRG'
                               And object_type = 'TRIGGER';

                          --Si el objeto exite, lo borramos
                            If v_conteo > 0 Then
                              EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_RPN_CARTERA_PENS_T_TRG');
                            End if;                          
                        END;");
        }
    }
}
