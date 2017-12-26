using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201710201612)]
    public class _201710201612_alter_table_sisalril_suir_sfs_subs_enf_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SISALRIL_SUIR").Table("SFS_SUBS_ENF_T").Column("SECUENCIA").Exists())
            {
                Alter.Table("SISALRIL_SUIR.SFS_SUBS_ENF_T")
                    .AlterColumn("SECUENCIA")
                    .AsCustom("NUMBER(10)")
                    .WithColumnDescription("Secuencia de renovacion");
            }
        }

        public override void Down()
        {
            if (Schema.Table("SISALRIL_SUIR.SFS_SUBS_ENF_T").Exists())
            {
                //Nothing
            }
        }
    }
}