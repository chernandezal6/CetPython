using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace CrudWebApp.Models
{
    public class Contact
    {

        public int id { get; set; }
        public string nombres { get; set; }
        public string contaco { get; set; }
        public string email { get; set; }
        public DateTime fecha_reg { get; set; }

    }
}