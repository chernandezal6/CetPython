using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703151122)]
    public class _201703151122_create_or_replace_package_sfs_subsidios_pkg : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sub_sfs_spec_subsidios.sql");
            Execute.Script(Framework.Configuration.ScriptDirectory() + "sub_sfs_body_subsidios.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PACKAGE SFS_SUBSIDIOS_PKG");
        }
    }
}
