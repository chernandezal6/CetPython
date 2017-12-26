using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201702140959)]
    public class _201702140959_update_seg_usuario_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            Execute.Sql("update seg_usuario_t u set u.cantidad_intentos = 0");
        }

        public override void Down()
        {
            
        }
       
    }
}
