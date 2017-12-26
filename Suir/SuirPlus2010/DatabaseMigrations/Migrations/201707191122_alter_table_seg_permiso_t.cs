using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201707191122)]
    public class _201707191122_alter_table_seg_permiso_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("SEG_PERMISO_T").Column("MARCA_CUOTA").Exists())
            {
                Alter.Table("SUIRPLUS.SEG_PERMISO_T")
                    .AddColumn("MARCA_CUOTA")
                    .AsCustom("VARCHAR2(1)")
                    .Nullable() 
                    .WithColumnDescription("Esta marca indica que este permiso utiliza Cuotas, para poder ser utilizado");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_PERMISO_T").Column("MARCA_CUOTA").Exists())
            {
                Delete.Column("MARCA_CUOTA").FromTable("SUIRPLUS.SEG_PERMISO_T");
            }
        }
    }
}
