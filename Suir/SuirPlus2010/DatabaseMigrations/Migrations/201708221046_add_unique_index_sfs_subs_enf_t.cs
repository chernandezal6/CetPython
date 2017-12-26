using FluentMigrator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DatabaseMigrations.Migrations
{

    [Migration(201708221046)]
    public class _201708221046_add_unique_index_sfs_subs_enf_t : FluentMigrator.Migration
    {
        public override void Up()
        {
            if (!Schema.Schema("SISALRIL_SUIR").Table("SFS_SUBS_ENF_T").Index("UK_SFS_SUBS_ENF").Exists())
            {
                Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_ENF_T ADD CONSTRAINT UK_SFS_SUBS_ENF UNIQUE(NRO_SOLICITUD, NRO_PAGO, ID_REGISTRO_PATRONAL,SECUENCIA, PADECIMIENTO,NRO_LOTE) DEFERRABLE NOVALIDATE");
            }
        }

        public override void Down()
        {
            if (Schema.Schema("SISALRIL_SUIR").Table("SFS_SUBS_ENF_T").Index("UK_SFS_SUBS_ENF").Exists())
            {
                Execute.Sql("ALTER TABLE SISALRIL_SUIR.SFS_SUBS_ENF_T DROP CONSTRAINT UK_SFS_SUBS_ENF");
            }
        }

    }
}
