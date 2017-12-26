using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201706221619)]
    public class _201706221619_alter_table_sisalril_suir_sfs_subs_maternidad_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Schema("SUIRPLUS").Table("SUIRPLUS.SFS_SUBS_MATERNIDAD_T").Column("PERIODO").Exists())
            {
                Alter.Table("SUIRPLUS.SFS_SUBS_MATERNIDAD_T")
                    .AlterColumn("PERIODO")
                    .AsCustom("NUMBER(6)").Nullable()
                    .WithColumnDescription("Periodo del envio");                                   
            }

            if (Schema.Schema("SUIRPLUS").Table("SUIRPLUS.SFS_SUBS_MATERNIDAD_T").Column("ID_ENTIDAD_RECAUDADORA").Exists())
            {
                Alter.Table("SUIRPLUS.SFS_SUBS_MATERNIDAD_T")
                    .AlterColumn("ID_ENTIDAD_RECAUDADORA")
                    .AsCustom("NUMBER(2)").Nullable()
                    .WithColumnDescription("ID de la entidad recaudadora");
            }
        }


        public override void Down()
        {
            if (Schema.Table("SUIRPLUS.SFS_SUBS_MATERNIDAD_T").Exists())
            {
                //Nothing
            }
        }
    }
}
