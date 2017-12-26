using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201601270937)]
    public class _201601270937_add_status_to_sfc_procesos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SFC_PROCESOS_T").Column("STATUS").Exists())
            {
                Alter.Table("SFC_PROCESOS_T")
                    .AddColumn("STATUS").AsCustom("CHAR(1)")
                    .WithColumnDescription("Status para manejar los procesos Activos e Inactivos.")
                    .SetExistingRowsTo("A")
                    .NotNullable();
            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_PROCESOS_T").Column("Status").Exists())
            {
                Delete.Column("STATUS").FromTable("SFC_PROCESOS_T");
            }
        }

    }
}
