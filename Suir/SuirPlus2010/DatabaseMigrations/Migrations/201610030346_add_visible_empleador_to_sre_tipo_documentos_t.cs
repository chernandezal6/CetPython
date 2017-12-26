using FluentMigrator;


namespace DatabaseMigrations.Migrations
{
    [Migration(201610030346)]
    public class _201610030346_add_visible_empleador_to_sre_tipo_documentos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SRE_TIPO_DOCUMENTOS_T").Exists())
            {
                if (!Schema.Table("SRE_TIPO_DOCUMENTOS_T").Column("VISIBLE_EMPLEADOR").Exists())
                {
                    Alter.Table("SRE_TIPO_DOCUMENTOS_T")
                        .AddColumn("VISIBLE_EMPLEADOR")
                        .AsCustom("CHAR(1)")
                        .WithColumnDescription("Campo visible para el empleador")
                        .WithDefaultValue("N")
                        .Nullable();
                }
            }
        }

        public override void Down()
        {
            if (Schema.Table("SRE_TIPO_DOCUMENTOS_T").Exists())
            {
                if (Schema.Table("SRE_TIPO_DOCUMENTOS_T").Column("VISIBLE_EMPLEADOR").Exists())
                {
                    Delete.Column("VISIBLE_EMPLEADOR").FromTable("SRE_TIPO_DOCUMENTOS_T");
                }
            }
        }
    }
}
