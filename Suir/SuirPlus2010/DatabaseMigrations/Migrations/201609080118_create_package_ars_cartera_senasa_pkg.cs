using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201609080118)]
    public class _201609080118_create_package_ars_cartera_senasa_pkg: FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_empleadores_espec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_empleadores_body_pkg.sql");
        }

        public override void Down()
        {
            throw new NotImplementedException();
        }
    }
}
