using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201702140413)]
    public class _201702140413_add_numero_evento_to_sre_ciudadanos_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SRE_CIUDADANOS_T").Column("NUMERO_EVENTO").Exists())
            {
                Alter.Table("SRE_CIUDADANOS_T")
                    .AddColumn("NUMERO_EVENTO")
                    .AsCustom("VARCHAR2(50)")
                    .WithColumnDescription("Número del evento de nacimiento")
                    .Nullable();
            }            
        }

        public override void Down()
        {
            if (Schema.Table("SRE_CIUDADANOS_T").Column("NUMERO_EVENTO").Exists())
            {
            }
        }               
    }
}
