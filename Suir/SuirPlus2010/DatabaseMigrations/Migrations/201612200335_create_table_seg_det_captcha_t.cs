using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612200335)]
    public class _201612200335_create_table_seg_det_captcha_t : FluentMigrator.Migration
    {

        public override void Up()
        {
            if (!Schema.Table("SEG_DET_CAPTCHA_T").Exists())
            {
                Create.Table("SEG_DET_CAPTCHA_T")
                .WithColumn("ID").AsCustom("NUMBER(4)").NotNullable().WithColumnDescription("PRIMARY KEY DE LA TABLA.")
                .WithColumn("ID_MASTER").AsCustom("NUMBER(4)").NotNullable().WithColumnDescription("FOREIGN KEY DE LA TABLA.")
                .WithColumn("PREGUNTA").AsCustom("VARCHAR2(200)").NotNullable().WithColumnDescription("PREGUNTA A MOSTRAR EN LA PANTALLA.")
                .WithColumn("TIPO_INPUT").AsCustom("CHAR(1)").WithColumnDescription("TIPO DE INPUT HTML QUE SE MOSTRARA EN LA PANTALLA.")
                .WithColumn("ESTATUS").AsCustom("CHAR(1)").NotNullable().WithDefaultValue("A").WithColumnDescription("ESTATUS DEL REGISTRO.")
                .WithColumn("ORIGEN_RESPUESTA").AsCustom("VARCHAR2(200)").WithColumnDescription("INDICA LA TABLA QUE PROVEE LA INFORMACION DE LA RESPUESTA.")
                .WithColumn("CAMPO_RESPUESTA").AsCustom("VARCHAR2(200)").WithColumnDescription("INDICA EL CAMPO DE LA TABLA QUE PROVEE LA INFORMACION DE LA RESPUESTA.")
                .WithColumn("COLETILLA").AsCustom("VARCHAR2(200)").WithColumnDescription("COMENTARIO DEL REGISTRO.");


                //Primary Key
                Create.PrimaryKey("PK_SEG_DET_CAPTCHA_T").OnTable("SEG_DET_CAPTCHA_T").Column("ID");

                //Foreign_key a la tabla SEG_CAPTCHA_T
                Create.ForeignKey("FK_DET_CAPTCHA_TO_CAPTCHA")
                    .FromTable("SEG_DET_CAPTCHA_T").ForeignColumn("ID_MASTER")
                    .ToTable("SEG_CAPTCHA_T").PrimaryColumn("ID");

                
                //crear un sequence
                Create.Sequence("SEG_DET_CAPTCHA_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);

            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_DET_CAPTCHA_T").Exists())
            {
                Delete.Table("SEG_DET_CAPTCHA_T");
                Delete.Sequence("SEG_DET_CAPTCHA_T_SEQ");
            }
        }
    }
}
