using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603030233)]
    public class _201603030233_add_registros_to_sfc_procesos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SFC_PROCESOS_T").Column("REGISTROS").Exists())
            {
                Alter.Table("SFC_PROCESOS_T")
                    .AddColumn("REGISTROS")
                    .AsCustom("NUMBER(5)")
                    .WithColumnDescription("Cantidad de registros a tomar en cuenta por el proceso para escribir en el detalle de bitacora")
                    .Nullable();
            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_PROCESOS_T").Column("REGISTROS").Exists())
            {
                Delete.Column("REGISTROS").FromTable("SFC_PROCESOS_T");
            }
        }
    }
}
