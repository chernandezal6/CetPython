using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610281027)]
    public class _201610281027_alter_table_nss_solicitudes_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("NSS_SOLICITUDES_T").Constraint("FK_NSS_SOL_USU_SOL").Exists())
            {
                //Se necesita borrar foreign_key a la tabla SEG_USUARIO_T
                Delete.ForeignKey("FK_NSS_SOL_USU_SOL").OnTable("NSS_SOLICITUDES_T");
            }

            if (Schema.Table("NSS_SOLICITUDES_T").Constraint("FK_NSS_SOL_ULT_USUARIO_ACT").Exists())
            {
                //Se necesita borrar foreign_key a la tabla SEG_USUARIO_T
                Delete.ForeignKey("FK_NSS_SOL_ULT_USUARIO_ACT").OnTable("NSS_SOLICITUDES_T");
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_SOLICITUDES_T").Exists())
            {
                //Nothing
            }
        }
    }
}