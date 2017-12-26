using FluentMigrator;

namespace DatabaseMigrations.Migrations
{
    [Migration(201607210350)]
    public class _201607210350_update_seg_error_t: FluentMigrator.Migration
    {
        public override void Up()
        {
            if (Schema.Table("SEG_ERROR_T").Column("USO_UNIPAGO").Exists())
            {
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "0" }).Where(new { ID_ERROR = "0" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "246" }).Where(new { ID_ERROR = "NSS001" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "101" }).Where(new { ID_ERROR = "NSS401" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "245" }).Where(new { ID_ERROR = "NSS402" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "244" }).Where(new { ID_ERROR = "NSS403" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "439" }).Where(new { ID_ERROR = "NSS404" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "J01" }).Where(new { ID_ERROR = "NSS501" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "441" }).Where(new { ID_ERROR = "NSS502" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "151" }).Where(new { ID_ERROR = "NSS503" });

                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "1603"}).Where(new { ID_ERROR = "NSS901" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "1603"}).Where(new { ID_ERROR = "NSS902" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "1613"}).Where(new { ID_ERROR = "NSS903" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "429" }).Where(new { ID_ERROR = "NSS904" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "424" }).Where(new { ID_ERROR = "NSS905" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "430" }).Where(new { ID_ERROR = "NSS906" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "435" }).Where(new { ID_ERROR = "NSS907" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "437" }).Where(new { ID_ERROR = "NSS908" });

            }
        }

        public override void Down()
        {
            if (Schema.Table("SEG_ERROR_T").Column("USO_UNIPAGO").Exists())
            {
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "0" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS001" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS401" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS402" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS403" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS404" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS501" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS502" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS503" });

                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS901" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS902" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS903" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS904" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS905" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS906" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS907" });
                Update.Table("SEG_ERROR_T").Set(new { USO_UNIPAGO = "" }).Where(new { ID_ERROR = "NSS908" });
            }
        }
    }
}
