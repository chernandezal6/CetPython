using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseMigrations.Migrations
{
    //Esta migración fue creada con errores (se pregunta si la tabla existe antes de operar con ella, 
    //lo cual no deja hacer nada con ella, esto seria valido si estuvieramos creando la tabla).
    //Se creó la migración "_201601270937_add_status_to_sfc_procesos_t" en sustitución, y se comentó
    //el código de esta para que no se ejecute mas.

    [Migration(201601270936)]
    public class _201601270936_add_status_to_sfc_procesos_t : FluentMigrator.Migration
    {
        public override void Up()
        {

            if (!Schema.Table("SFC_PROCESOS_T").Column("Status").Exists())
            {
                Alter.Table("SFC_PROCESOS_T")
                    .AddColumn("STATUS")
                    .AsString(1)
                    .WithColumnDescription("Status para manejar los procesos Activos e Inactivos.")
                    .SetExistingRowsTo("A")
                    .NotNullable();
            }
        }

        public override void Down()
        {

            if (Schema.Table("SFC_PROCESOS_T").Column("Status").Exists())
            {
                Delete.Column("STATUS").FromTable("SFC_PROCESOS_T");
            }

            //if (!Schema.Table("SFC_PROCESOS_T").Exists())
            //{
            //    if (!Schema.Table("SFC_PROCESOS_T").Column("Status").Exists())
            //    {
            //        Alter.Table("SFC_PROCESOS_T")
            //            .AddColumn("STATUS")
            //            .AsString(1)
            //            .WithColumnDescription("Status para manejar los procesos Activos e Inactivos.")
            //            .SetExistingRowsTo("A")
            //            .NotNullable();
            //    }
            //}
        }

    }

}