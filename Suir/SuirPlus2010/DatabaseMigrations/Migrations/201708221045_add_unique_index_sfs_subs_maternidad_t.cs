using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseMigrations.Migrations
{

    [Migration(201708221045)]
    public class _201708221045_add_unique_index_sfs_subs_maternidad_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SISALRIL_SUIR").Table("SFS_SUBS_MATERNIDAD_T").Index("UK_SFS_SUBS_MATERNIDAD").Exists())
            {
                Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T ADD CONSTRAINT UK_SFS_SUBS_MATERNIDAD UNIQUE(NRO_SOLICITUD, NRO_PAGO, ID_REGISTRO_PATRONAL,SECUENCIA, NRO_LOTE) DEFERRABLE NOVALIDATE");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SISALRIL_SUIR").Table("SFS_SUBS_MATERNIDAD_T").Index("UK_SFS_SUBS_MATERNIDAD").Exists())
            {
                Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_MATERNIDAD_T DROP CONSTRAINT UK_SFS_SUBS_MATERNIDAD");
            }
        }

    }
}
