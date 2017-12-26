using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705161049)]
    public class _201705161049_create_table_sre_historico_documentos_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("SRE_HISTORICO_DOCUMENTOS_T").Exists())
            {
                Create.Table("SRE_HISTORICO_DOCUMENTOS_T")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID").AsCustom("NUMBER(10)").NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla.")
                    .WithColumn("ID_NSS").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Numero unico de Seguridad Social del ciudadano.")
                    .WithColumn("TIPO_DOCUMENTO").AsCustom("VARCHAR2(1)").NotNullable().WithColumnDescription("Tipo de documento anterior del ciudadano emitido por la JCE. Puede ser el mismo si solo cambia el numero de documento.")
                    .WithColumn("NO_DOCUMENTO").AsCustom("VARCHAR2(25)").Nullable().WithColumnDescription("Numero anterior del documento emitido por la JCE. Puede ser el mismo si solo cambia el tipo de documento.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").Nullable().WithColumnDescription("Fecha en que se realizo el cambio del registro");

                //Se necesita incluir el foreign_key a la tabla SRE_CIUDADANOS_T
                Create.ForeignKey("FK_HISTORICO_DOC_CIU")
                    .FromTable("SUIRPLUS.SRE_HISTORICO_DOCUMENTOS_T").ForeignColumn("ID_NSS")
                    .ToTable("SUIRPLUS.SRE_CIUDADANOS_T").PrimaryColumn("ID_NSS");

                //Se necesita incluir el foreign_key a la tabla SRE_TIPO_DOCUMENTOS_T
                Create.ForeignKey("FK_HISTORICO_DOC_TIPO_DOC")
                    .FromTable("SUIRPLUS.SRE_HISTORICO_DOCUMENTOS_T").ForeignColumn("TIPO_DOCUMENTO")
                    .ToTable("SUIRPLUS.SRE_TIPO_DOCUMENTOS_T").PrimaryColumn("ID_TIPO_DOCUMENTO");

                //como en oracle 11g no existe "identity" necesitamos crear un sequence
                Create.Sequence("SRE_HISTORICO_DOCUMENTOS_SEQ")
                    .InSchema("SUIRPLUS")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SRE_HISTORICO_DOCUMENTOS_T").Exists())
            {
                Delete.Table("SRE_HISTORICO_DOCUMENTOS_T").InSchema("SUIRPLUS");
                Delete.Sequence("SRE_HISTORICO_DOCUMENTOS_SEQ").InSchema("SUIRPLUS");
            }
        }
    }
}
