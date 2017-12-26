using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SuirPlusEF.Models
{
    [Table("SRP_CONFIG_T")]
    public class Config
    {
        [Key, Column("ID_MODULO")]
        public string IdModulo { get; set; }

        [Column("FTP_HOST")]
        public string FTPHost { get; set; }

        [Column("FTP_USER")]
        public string FTPUser { get; set; }

        [Column("FTP_PASS")]
        public string FTPPass { get; set; }

        [Column("FTP_PORT")]
        public string FTPPort { get; set; }

        [Column("FTP_DIR")]
        public string FTPDir { get; set; }

        [Column("ARCHIVES_DIR")]
        public string ArchivesDir { get; set; }

        [Column("ARCHIVES_OK_DIR")]
        public string ArchivesOkDir { get; set; }

        [Column("ARCHIVES_ERR_DIR")]
        public string ArchivesErrDir { get; set; }

        [Column("OTHER1_DIR")]
        public string Other1Dir{ get; set; }

        [Column("OTHER2_DIR")]
        public string Other2Dir { get; set; }

        [Column("OTHER3_DIR")]
        public string Other3Dir { get; set; }

        [Column("USER_MAILS")]
        public string UserMails { get; set; }

        [Column("DBA_MAILS")]
        public string DBAMails { get; set; }

        [Column("PROG_MAILS")]
        public string ProgMails { get; set; }

        [Column("OTHER1_MAILS")]
        public string Other1Mails { get; set; }

        [Column("OTHER2_MAILS")]
        public string Other2Mails{ get; set; }

        [Column("OTHER3_MAILS")]
        public string Other3Mails{ get; set; }

        [Column("FIELD1")]
        public string Field1 { get; set; }

        [Column("FIELD2")]
        public string Field2 { get; set; }

        [Column("FIELD3")]
        public string Field3 { get; set; }

        [Column("FIELD4")]
        public string Field4 { get; set; }


    }
}
