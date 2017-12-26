using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201708310947)]
    public class _201708310947_add_nro_solicitud_sisalril_to_sub_elegibles : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("SUB_ELEGIBLES_T").Column("NRO_SOLICITUD_SISALRIL").Exists())
            {
                Alter.Table("SUIRPLUS.SUB_ELEGIBLES_T")
                    .AddColumn("NRO_SOLICITUD_SISALRIL").AsCustom("NUMBER(9)").Nullable()
                    .WithColumnDescription("Numero de Solicitud manejado por SISALRIL");                    
            }          
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SUB_ELEGIBLES_T").Column("NRO_SOLICITUD_SISALRIL").Exists())
            {
                Delete.Column("NRO_SOLICITUD_SISALRIL").FromTable("SUIRPLUS.SUB_ELEGIBLES_T");
            }
           
        }

    }
}
