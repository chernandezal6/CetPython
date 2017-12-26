using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608040310)]
    public class _201608040310_nss_consultar_afiliacion_sfs : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "nss_consultar_afiliacion_sfs.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP FUNCTION NSS_CONSULTAR_AFILIACION_SFS");
        }
    }
}
