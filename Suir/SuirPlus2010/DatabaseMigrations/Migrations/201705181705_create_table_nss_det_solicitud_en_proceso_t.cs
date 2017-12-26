using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201705181705)]
    public class _201705181705_create_table_nss_det_solicitud_en_proceso_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("NSS_DET_SOLICITUD_EN_PROCESO_T").Exists())
            {
                Create.Table("NSS_DET_SOLICITUD_EN_PROCESO_T")
                    .InSchema("SUIRPLUS")
                    .WithColumn("ID_REGISTRO").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Id del registro de la solicitud. FK de la tabla NSS_DET_SOLICITUDES_T.")
                    .WithColumn("ID_ESTATUS").AsCustom("NUMBER(2)").NotNullable().WithColumnDescription("Estatus de la solicitud. FK de la tabla NSS_ESTATUS_T.")
                    .WithColumn("ID_ERROR").AsCustom("VARCHAR2(10)").Nullable().WithColumnDescription("Id de error. FK de la tabla SEG_ERROR_T.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").Nullable().WithColumnDescription("Ultima fecha de actualización del registro.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Usuario que actualizo por última vez el registro. FK de la tabla SEG_USUARIO_T");

                //Creamos un unique constraint para evitar que entren dos registros
                Create.UniqueConstraint("UQ_NSS_DET_SOL_EN_PROCESO")
                    .OnTable("SUIRPLUS.NSS_DET_SOLICITUD_EN_PROCESO_T").Columns("ID_REGISTRO", "ID_ESTATUS", "ID_ERROR");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("NSS_DET_SOLICITUD_EN_PROCESO_T").Exists())
            {
                Delete.Table("NSS_DET_SOLICITUD_EN_PROCESO_T").InSchema("SUIRPLUS");
            }
        }
    }
}
