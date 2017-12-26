using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;
namespace DatabaseMigrations.Migrations
{
    [Migration(201603280530)]
    public class _201603280530_next_sequence : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Script(Framework.Configuration.ScriptDirectory() + "next_sequence.sql");
        }

        public override void Down()
        {
            Execute.Sql("DROP PROCEDURE NEXT_SEQUENCE");
        }
    }
}
