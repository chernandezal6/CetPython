using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    //Esta migración fue creada con errores(la fecha, hora y minutos incluidos en el nombre de la migración estan fuera de tiempo y mal formados) 
    //por lo que se creó la migración "201603280530_next_sequence" en sustitución.
    [Migration(201606284000)]
    public class _201606284000_next_sequence : FluentMigrator.Migration
    {
        public override void Up()
        {
           //Execute.Script(Framework.Configuration.ScriptDirectory() + "next_sequence.sql");
        }

        public override void Down()
        {
            //Execute.Sql("DROP PROCEDURE NEXT_SEQUENCE");
        }
    }
}
