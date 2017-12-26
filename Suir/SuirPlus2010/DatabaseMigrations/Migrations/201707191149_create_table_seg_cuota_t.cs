using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201707191149)]
    public class _201707191149_create_table_seg_cuota_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SUIRPLUS").Table("SEG_CUOTA_T").Exists())
            {
                Create.Table("SUIRPLUS.SEG_CUOTA_T")
                    .WithColumn("ID_PERMISO").AsCustom("NUMBER(10)").NotNullable().WithColumnDescription("Representa el id de permiso que se sometera a la cuota(ESTO ESPECIFICAMENTE PARA WEB SERVICES).")
                    .WithColumn("ID_USUARIO").AsCustom("VARCHAR2(35)").NotNullable().WithColumnDescription("Id del usuario que esta relacionado con el permiso.")
                    .WithColumn("CUOTA").AsCustom("NUMBER(8)").Nullable().WithColumnDescription("Valor de Cuota que tendra el servicio relacionado con el usuario.")
                    .WithColumn("CONSUMO").AsCustom("NUMBER(8)").Nullable().WithColumnDescription("Cantidad consumida hasta el momento por el usuario.")
                    .WithColumn("ULT_USUARIO_ACT").AsCustom("VARCHAR2(35)").Nullable().WithColumnDescription("Usuario que actualizo por última vez el registro.")
                    .WithColumn("ULT_FECHA_ACT").AsCustom("DATE").NotNullable().WithColumnDescription("Ultima fecha en que fue actualizado el registro.");                

                Create.PrimaryKey("PK_CUOTA").OnTable("SUIRPLUS.SEG_CUOTA_T").Columns(new string[] { "ID_PERMISO", "ID_USUARIO" });

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_SEG_CUOTA_ID_PERMISO")
                    .FromTable("SUIRPLUS.SEG_CUOTA_T").ForeignColumn("ID_PERMISO")
                    .ToTable("SUIRPLUS.SEG_PERMISO_T").PrimaryColumn("ID_PERMISO");

                //Se necesita incluir el foreign_key a la tabla SEG_USUARIO_T
                Create.ForeignKey("FK_SEG_CUOTA_ULT_USUARIO")
                    .FromTable("SUIRPLUS.SEG_CUOTA_T").ForeignColumn("ULT_USUARIO_ACT")
                    .ToTable("SUIRPLUS.SEG_USUARIO_T").PrimaryColumn("ID_USUARIO");

                Execute.Sql(@"CREATE OR REPLACE TRIGGER SUIRPLUS.DATE_ON_SEG_CUOTA_T
                            BEFORE INSERT OR UPDATE ON SUIRPLUS.SEG_CUOTA_T for each row
                            Begin
                            IF :old.ULT_USUARIO_ACT is not null AND :new.ULT_USUARIO_ACT is null THEN
                             :new.ULT_USUARIO_ACT := :old.ULT_USUARIO_ACT;
                            END IF;
                             :new.ULT_FECHA_ACT := sysdate;
                            End;");

                Execute.Sql(@"ALTER TABLE SUIRPLUS.SEG_CUOTA_T ADD CONSTRAINT CHK_CUOTAS_SEG_CUOTA_T CHECK(CUOTA >= 0)");

                Execute.Sql(@"ALTER TABLE SUIRPLUS.SEG_CUOTA_T ADD CONSTRAINT CHK_CONSUMO_SEG_CUOTA_T CHECK(CONSUMO >= 0)");
                
            }

        }

        public override void Down()
        {
            if (Schema.Schema("SUIRPLUS").Table("SEG_CUOTA_T").Exists())
            {
                Execute.Sql("DROP TRIGGER SUIRPLUS.DATE_ON_SEG_CUOTA_T");
                Delete.Table("SUIRPLUS.SEG_CUOTA_T");
            }

        }
    }
}
