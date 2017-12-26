using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201602120209)]
    public class _201602120209_add_uso_unipago_to_seg_error_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SEG_ERROR_T").Column("USO_UNIPAGO").Exists())
            {
                Alter.Table("SEG_ERROR_T")
                    .AddColumn("USO_UNIPAGO")
                    .AsCustom("VARCHAR2(10)")
                    .WithColumnDescription("ID Error equivalente al catalogo de errores de UNIPAGO")                    
                    .Nullable();
            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Column("USO_UNIPAGO").Exists())
            {
                Delete.Column("USO_UNIPAGO").FromTable("SEG_ERROR_T");
            }
        }      
    }
}