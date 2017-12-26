using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201603030243)]
    public class _201603030243_create_table_sfc_det_bitacora_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Table("SFC_DET_BITACORA_T").Exists())
            {
                Create.Table("SFC_DET_BITACORA_T").WithDescription("Detalle de corrida de un proceso.")
                    .WithColumn("ID").AsInt32().NotNullable().WithColumnDescription("ID unico del registro.")
                    .WithColumn("ID_BITACORA").AsInt32().NotNullable().WithColumnDescription("ID de la bitacora. Viene de la tabla SFC_BITACORA_T.")
                    .WithColumn("FECHA_MENSAJE").AsCustom("DATE").NotNullable().WithColumnDescription("Fecha y hora en que se creo el registro")
                    .WithColumn("MENSAJE").AsCustom("VARCHAR2(500)").NotNullable().WithColumnDescription("Mensaje colocado por el proceso");

                //Primary key de la tabla
                Create.PrimaryKey("PK_DET_BITACORA").OnTable("SFC_DET_BITACORA_T").Column("ID");
                
                //Foreign key a la tabla SFC_BITACORA_T
                Create.ForeignKey("FK_DET_BITACORA_SFC_BITACORA_T")
                    .FromTable("SFC_DET_BITACORA_T").ForeignColumn("ID_BITACORA")
                    .ToTable("SFC_BITACORA_T").PrimaryColumn("ID_BITACORA");

                //crear un sequence
                Create.Sequence("SFC_DET_BITACORA_T_SEQ")
                    .MinValue(1)
                    .MaxValue(9999999999)
                    .StartWith(1)
                    .IncrementBy(1);


            }
        }

        public override void Down()
        {
            if (Schema.Table("SFC_DET_BITACORA_T").Exists())
            {
                Delete.Table("SFC_DET_BITACORA_T");
                Delete.Sequence("SFC_DET_BITACORA_T_SEQ");
            }
        }
    }
}