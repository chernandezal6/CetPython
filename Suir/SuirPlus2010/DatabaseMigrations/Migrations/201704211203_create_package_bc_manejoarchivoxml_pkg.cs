using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201704211203)]
    public class _201704211203_create_package_bc_manejoarchivoxml_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "bc_manejoarchivoxml_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "bc_manejoarchivoxml_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SUIRPLUS.BC_MANEJOARCHIVOXML_PKG");
        }
    }
}
