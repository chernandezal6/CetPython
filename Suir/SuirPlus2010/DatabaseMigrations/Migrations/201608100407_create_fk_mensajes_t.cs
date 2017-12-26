using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201608100407)]
    public class _201608100407_create_fk_mensajes_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SRE_MENSAJES_t").Exists())
            {
                //Se necesita incluir el foreign_key a la tabla SRE_EMPLEADORES_T
                Create.ForeignKey("FK_SRE_CIUDADANO_T_SRE_TIPO_DOC")
                    .FromTable("SRE_MENSAJES_T").ForeignColumn("ID_REGISTRO_PATRONAL")
                    .ToTable("SRE_EMPLEADORES_T").PrimaryColumn("ID_REGISTRO_PATRONAL");
            }
        }

        public override void Down()
        {
        //    throw new NotImplementedException();
        }
       
    }
}
