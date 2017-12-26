using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708310945)]
    public class _201708310945_add_nro_solicitud_sisalril_to_sfs_elegibles_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SISALRIL_SUIR").Table("SFS_ELEGIBLES_T").Column("NRO_SOLICITUD_SISALRIL").Exists())
            {
                Alter.Table("SISALRIL_SUIR.SFS_ELEGIBLES_T")
                    .AddColumn("NRO_SOLICITUD_SISALRIL").AsCustom("NUMBER(9)").Nullable()
                    .WithColumnDescription("Numero de Solicitud manejado por SISALRIL");                    
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SISALRIL_SUIR").Table("SFS_ELEGIBLES_T").Column("NRO_SOLICITUD_SISALRIL").Exists())
            {
                Delete.Column("NRO_SOLICITUD_SISALRIL").FromTable("SISALRIL_SUIR.SFS_ELEGIBLES_T");
            }
        }

    }
}
