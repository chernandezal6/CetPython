using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201703011016)]
    public class _201703011016_create_package_sre_nominas_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_nominas_spec_pkg.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sre_nominas_body_pkg.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SRE_NOMINAS_PKG");
        }
    }
}
