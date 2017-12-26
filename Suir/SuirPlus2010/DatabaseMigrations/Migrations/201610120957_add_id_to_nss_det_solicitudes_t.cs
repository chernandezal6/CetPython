using FluentMigrator;

namespace DatabaseMigrations
{
    [Migration(201610190255)]
    public class _201610190255_add_id_to_nss_det_solicitudes_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("NSS_DET_SOLICITUDES_T").Exists())
            {
                if (!Schema.Table("NSS_DET_SOLICITUDES_T").Column("ID").Exists())
                {
                    Alter.Table("NSS_DET_SOLICITUDES_T")
                        .AddColumn("ID")
                        .AsCustom("INTEGER")
                        .WithColumnDescription("ID para referenciar PK en la tabla SUIR_R_SOL_ASIG_CEDULA_MV")
                        .Nullable();
                }
            }
        }

        public override void Down()
        {
            if (Schema.Table("NSS_DET_SOLICITUDES_T").Exists())
            {
                if (Schema.Table("NSS_DET_SOLICITUDES_T").Column("ID").Exists())
                {
                    Delete.Column("ID").FromTable("NSS_DET_SOLICITUDES_T");
                }
            }
        }
    }
}
