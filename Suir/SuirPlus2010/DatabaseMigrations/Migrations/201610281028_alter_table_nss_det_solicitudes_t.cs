using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201610281028)]
    public class _201610281028_alter_table_nss_det_solicitudes_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("NSS_DET_SOLICITUDES_T").Constraint("FK_NSS_DET_SOL_USU_ACT").Exists())
            {
                //Se necesita borrar foreign_key a la tabla SEG_USUARIO_T
                Delete.ForeignKey("FK_NSS_DET_SOL_USU_ACT").OnTable("NSS_DET_SOLICITUDES_T");
            }

            if (Schema.Table("NSS_DET_SOLICITUDES_T").Constraint("FK_NSS_DET_SOL_USU_PROCESA").Exists())
            {
                //Se necesita borrar foreign_key a la tabla SEG_USUARIO_T
                Delete.ForeignKey("FK_NSS_DET_SOL_USU_PROCESA").OnTable("NSS_DET_SOLICITUDES_T"); ;
            }
        }


        public override void Down()
        {
            if (Schema.Table("NSS_DET_SOLICITUDES_T").Exists())
            {
                //Nothing
            }
        }
    }
}
