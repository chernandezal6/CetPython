using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703271631)]
    public class _201703271631_create_table_ars_dep_adicionales_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("ARS_DEP_ADICIONALES_T").Exists())
            {
                Create.Table("SUIRPLUS.ARS_DEP_ADICIONALES_T")
                    .WithColumn("ID_NSS_TITULAR").AsCustom("NUMBER(9)").NotNullable().WithColumnDescription("NSS del titular afiliado, viene del catalogo SUIRPLUS.SRE_CIUDADANOS_T")
                    .WithColumn("ID_NSS_DEPENDIENTE").AsCustom("NUMBER(9)").NotNullable().WithColumnDescription("NSS del dependiente adicional afiliado, viene del catalogo SUIRPLUS.SRE_CIUDADANOS_T")
                    .WithColumn("ID_NSS_CONYUGE").AsCustom("NUMBER(9)").Nullable().WithColumnDescription("NSS del conyuge del nucleo, viene del catalogo SUIRPLUS.SRE_CIUDADANOS_T")
                    .WithColumn("ID_PARENTESCO").AsCustom("VARCHAR2(3)").NotNullable().WithColumnDescription("Id del parentesco del afiliado con respecto al titular, viene del catalogo SUIRPLUS.ARS_PARENTESCO_T")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Ultimo usuario que modifico el registro. FK de la tabla SUIRPLUS.SEG_USUARIO_T")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Ultima fecha de actualizacinn del registro.");

                //Indice UNIQUE por los campos ID_NSS_TITULAR, ID_NSS_DEPENDIENTE
                Create.UniqueConstraint("UQ_ARS_DEP_ADIC_NSS_TIT_DEP").OnTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").Columns("ID_NSS_TITULAR", "ID_NSS_DEPENDIENTE, ID_NSS_CONYUGE");

                //Foreign_key a la tabla SRE_CIUDADANOS_T por el campo ID_NSS_TITULAR
                Create.ForeignKey("FK_ARS_DEP_ADIC_ID_NSS_TITULAR")
                    .FromTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").ForeignColumn("ID_NSS_TITULAR")
                    .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                //Foreign_key a la tabla SRE_CIUDADANOS_T por el campo ID_NSS_DEPENDIENTE
                Create.ForeignKey("FK_ARS_DEP_ADIC_ID_NSS_DEP")
                    .FromTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").ForeignColumn("ID_NSS_DEPENDIENTE")
                    .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                //Foreign_key a la tabla SRE_CIUDADANOS_T por el campo ID_NSS_TITULAR
                Create.ForeignKey("FK_ARS_DEP_ADIC_ID_NSS_CONYUGE")
                    .FromTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").ForeignColumn("ID_NSS_CONYUGE")
                    .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                //Foreign_key a la tabla ARS_PARENTESCOS_T por el campo ID_PARENTESCO
                Create.ForeignKey("FK_ARS_DEP_ADIC_ID_PARENTESCO")
                    .FromTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").ForeignColumn("ID_PARENTESCO")
                    .ToTable("SUIRPLUS.ARS_PARENTESCOS_T").PrimaryColumn("ID_PARENTESCO");

                //Foreign_key a la tabla SEG_USUARIO_T por el campo ULT_USUARIO_ACT
                Create.ForeignKey("FK_ARS_DEP_ADIC_SEG_USU_ID_USU")
                    .FromTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").ForeignColumn("ULT_USUARIO_ACT")
                    .ToTable("SUIRPLUS.SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                //Creamos tres indices por los campos NSS
                Create.Index("IDX_ARS_DEP_ADIC_NSS_TITULAR").OnTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").OnColumn("ID_NSS_TITULAR");
                Create.Index("IDX_ARS_DEP_ADIC_NSS_DEP").OnTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").OnColumn("ID_NSS_DEPENDIENTE");
                Create.Index("IDX_ARS_DEP_ADIC_NSS_CONYUGE").OnTable("SUIRPLUS.ARS_DEP_ADICIONALES_T").OnColumn("ID_NSS_CONYUGE");

                //Le creamos un trigger
                Execute.Sql(@"DECLARE 
                                scr_sql VARCHAR2(2000);
                              BEGIN 
                                scr_sql := 'CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_ARS_DEP_ADICIONALE_TRG'||chr(10)|| 
                                           'BEFORE INSERT OR UPDATE ON SUIRPLUS.ARS_DEP_ADICIONALES_T FOR EACH ROW'||chr(10)||
                                           'BEGIN'||chr(10)||
                                           ' :new.ult_fecha_act := SYSDATE;'||chr(10)||chr(10)||
                                           ' --Par no permitir que traten de poner nulo el valor del campo usuario una vez asignado'||chr(10)||
                                           ' If :new.ult_usuario_act IS NULL and :old.ult_usuario_act IS NOT NULL Then'||chr(10)||
                                           '   :new.ult_usuario_act := :old.ult_usuario_act;'||chr(10)||
                                           ' End if;'||chr(10)||
                                           'END;'; 
                                EXECUTE IMMEDIATE scr_sql; 
                              END;");
            }
        }
    
        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("ARS_DEP_ADICIONALES_T").Exists())
            {
                Execute.Sql(@"DECLARE
                                v_conteo pls_integer;
                              BEGIN
                                --Buscamos el objeto para ver si existe
                                Select count(*)
                                  Into v_conteo
                                  From all_objects
                                 Where owner       = 'SUIRPLUS'
                                   And object_name = 'DATE_ON_ARS_DEP_ADICIONALE_TRG'
                                   And object_type = 'TRIGGER';
                               --Si el objeto exite, lo borramos
                                If v_conteo > 0 Then
                                  EXECUTE IMMEDIATE('DROP TRIGGER SUIRPLUS.DATE_ON_ARS_DEP_ADICIONALE_TRG');
                                End if;                          
                             END;");

                Delete.Table("SUIRPLUS.ARS_DEP_ADICIONALES_T");
            }
        }
    }
}
