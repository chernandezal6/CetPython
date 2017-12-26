using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201602101000)]
    public class _201602101000_create_table_seg_msg_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SEG_MSG_T").Exists()) {
                Create.Table("SEG_MSG_T")
                    .WithColumn("Id").AsInt32().NotNullable().PrimaryKey().WithColumnDescription("Primary key de la tabla.")
                    .WithColumn("Id_Proceso").AsCustom("VARCHAR2(2)").Unique().Nullable().WithColumnDescription("Representa el id del proceso que envia el mensaje.")
                    .WithColumn("Mensaje").AsCustom("VARCHAR2(500)").NotNullable().WithColumnDescription("Descripcion del mensaje arrojado por la ejecución del proceso.")
                    .WithColumn("Canal").AsCustom("VARCHAR2(50)").Nullable().WithColumnDescription("Canal o grupo al cual se va a distribuir este mensaje.")
                    .WithColumn("Usuarios").AsCustom("VARCHAR2(255)").Nullable().WithColumnDescription("Usuario específico al cual se debe alertar")
                    .WithColumn("Status").AsCustom("VARCHAR2(1)").Nullable().WithColumnDescription("Estatus para manejar los procesos: P=Pendiente, E=Error, C=Completado, T=Se esta enviando")
                    .WithColumn("Log").AsCustom("VARCHAR2(500)").Nullable()
                    .WithColumn("Fecha_Registro").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha de registro del mensaje")
                    .WithColumn("Fecha_Envio").AsCustom("DATE").Nullable().WithColumnDescription("Fecha en que se envío el mensaje")
                    .WithColumn("Cantidad_Envios").AsInt32().Nullable().WithColumnDescription("Cantidad de intentos de envios");

                //Se necesita incluir el foreign_key a la tabla SFC_PROCESOS_T
                Create.ForeignKey("FK_SEG_MSG_T_SFC_PROCESOS_T")
                    .FromTable("SEG_MSG_T").ForeignColumn("ID_PROCESO")
                    .ToTable("SFC_PROCESOS_T").PrimaryColumn("ID_PROCESO");

                //como en oracle 11g no existe "identity" necesitamos crear un sequence
                Create.Sequence("SEG_MSG_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);
            }

        }

        public override void Down()
        {
            if (Schema.Table("SEG_MSG_T").Exists())
            {
                Delete.Table("SEG_MSG_T");
                Delete.Sequence("SEG_MSG_T_SEQ");
            }

        }
    }
}
