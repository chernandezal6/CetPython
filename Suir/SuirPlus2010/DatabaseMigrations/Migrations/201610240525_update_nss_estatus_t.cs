using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610240525)]
    public class _201610240525_update_nss_estatus_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("NSS_ESTATUS_T").Column("ID_ESTATUS").Exists())
            {
                Update.Table("NSS_ESTATUS_T").Set(new { DESCRIPCION = "Registro rechazado" }).Where(new { ID_ESTATUS = "6" });
                Update.Table("NSS_ESTATUS_T").Set(new { DESCRIPCION = "Registro actualizado" }).Where(new { ID_ESTATUS = "7" });
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_ESTATUS_T").Column("ID_ESTATUS").Exists())
            {
                Update.Table("NSS_ESTATUS_T").Set(new { DESCRIPCION = "" }).Where(new { ID_ESTATUS = "6" });
                Update.Table("NSS_ESTATUS_T").Set(new { DESCRIPCION = "" }).Where(new { ID_ESTATUS = "7" });
            }
        }
    }
}
