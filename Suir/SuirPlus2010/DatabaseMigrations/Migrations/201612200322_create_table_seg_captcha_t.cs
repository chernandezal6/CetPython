using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201612200322)]
    public class _201612200322_create_table_seg_captcha_t : FluentMigrator.Migration
    {

        public override void Up()
        {
            if (!Schema.Table("SEG_CAPTCHA_T").Exists())
            {
                Create.Table("SEG_CAPTCHA_T")
                    .WithColumn("ID").AsCustom("NUMBER(4)").NotNullable().WithColumnDescription("PRIMARY KEY DE LA TABLA.")
                    .WithColumn("DESCRIPCION").AsCustom("VARCHAR2(200)").WithColumnDescription("DESCRIPCION DEL REGISTRO.")
                    .WithColumn("URL").AsCustom("VARCHAR2(100)").WithColumnDescription("URL DE LA PAGINA QUE TIENE EL CAPTCHA.")
                    .WithColumn("ESTATUS").AsCustom("CHAR(1)").NotNullable().WithDefaultValue("A").WithColumnDescription("ESTATUS DEL REGISTRO.")
                    .WithColumn("COLETILLA").AsCustom("VARCHAR2(200)").WithColumnDescription("COMENTARIO DEL REGISTRO.");

                //Primary Key
                Create.PrimaryKey("PK_SEG_CAPTCHA_T").OnTable("SEG_CAPTCHA_T").Column("ID");

                //crear un sequence
                Create.Sequence("SEG_CAPTCHA_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);

            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_CAPTCHA_T").Exists())
            {
                Delete.Table("SEG_CAPTCHA_T");
                Delete.Sequence("SEG_CAPTCHA_T_SEQ");
            }
        }
    }
}
