using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703161022)]
    public class _201703161022_alter_table_ars_cartera_senasa_con_error_t:FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("ars_cartera_senasa_con_error_t").Column("tipo_facturable").Exists())
            {
                Alter.Table("ars_cartera_senasa_con_error_t")
                    .AddColumn("tipo_facturable")
                    .AsCustom("number(1)")
                    .WithColumnDescription("tipo de facturable posibles valores 1=facturable, 2=reclamos recien nacidos");                
            }
        }

        public override void Down()
        {
            if (Schema.Table("ars_cartera_senasa_con_error_t").Column("tipo_facturable").Exists())
            {

            }
        }
    }
}
