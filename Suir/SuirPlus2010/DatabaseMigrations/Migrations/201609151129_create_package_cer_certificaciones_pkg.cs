using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201609151129)]
    public class _201609151129_create_package_cer_certificaciones_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "cer_certificaciones_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "cer_certificaciones_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE CER_CERTIFICACIONES_PKG");
        }
    }
}
