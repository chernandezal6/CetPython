using FluentMigrator;
using System;
namespace DatabaseMigrations.Migrations
{
    [Migration(201705101511)]
    public class _201705101511_delete_from_seg_permiso_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_PERMISOS_T").Exists())
            {
                Delete.FromTable("SEG_PERMISOS_T").Row(new { ID_PERMISO = 470});               
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_PERMISOS_T").Exists())
            {
              
            }
        }
    }
}
