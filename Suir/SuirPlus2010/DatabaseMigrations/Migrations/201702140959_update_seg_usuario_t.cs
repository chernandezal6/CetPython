using System;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201703080303)]
    public class _201703080303_update_seg_usuario_t : FluentMigrator.Migration
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
