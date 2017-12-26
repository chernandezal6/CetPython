using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Collections;

namespace SuirPlus.Config
{
    public enum ModuloEnum
    {
        [StringValue("EMAIL")]
        Email = 1,
        [StringValue("XML_BC")]
        XML_BC = 2,
        [StringValue("VOCOM")]
        Vocom = 3,
        [StringValue("WS JCE")]
        WS_JCE = 4,
        [StringValue("NACHA")]
        NACHA = 5,
        [StringValue("JCE")]
        JCE = 6,
        [StringValue("IB BPTSS")]
        IB_BP_TSS = 7,
        [StringValue("FTPBPD")]
        FTP_BPD = 8,
        [StringValue("IB BPIR17")]
        IB_BPIR17 = 9,
        [StringValue("IB BPISR")]
        IB_BPISR = 10,
        [StringValue("ENVIONACHA")]
        EnvioNacha = 11,
        [StringValue("CONTRALOR")]
        Contralor = 12,
        [StringValue("WS_SDSS")]
        WS_SDSS = 13,
        [StringValue("ACUERDO_PG")]
        AcuerdoPago = 14,
        [StringValue("CERTIFICAC")]
        Certificaciones = 15,
        [StringValue("OFICIO")]
        Oficios = 16,
        [StringValue("ARCHI_SUIR")]
        ArchivosSuir = 17,
        [StringValue("BANCO")]
        BancosRecaudadores = 18,
        [StringValue("WS_USER")]
        ProxyInternet = 19,
        [StringValueAttribute("ARCHI_PY")]
        ArchivosSuirPython = 20
    }

    public class StringValueAttribute : System.Attribute
    {

        private string _value;

        public StringValueAttribute(string value)
        {
            _value = value;
        }

        public string Value
        {
            get { return _value; }
        }

        private static Hashtable _stringValues = new Hashtable();
        public static string GetStringValue(Enum value)
        {
            string output = null;
            Type type = value.GetType();

            //Check first in our cached results...

            if (_stringValues.ContainsKey(value))
                output = (_stringValues[value] as StringValueAttribute).Value;
            else
            {
                //Look for our 'StringValueAttribute' 

                //in the field's custom attributes

                FieldInfo fi = type.GetField(value.ToString());
                StringValueAttribute[] attrs =
                   fi.GetCustomAttributes(typeof(StringValueAttribute),
                                           false) as StringValueAttribute[];
                if (attrs.Length > 0)
                {
                    _stringValues.Add(value, attrs[0]);
                    output = attrs[0].Value;
                }
            }

            return output;
        }

    }
}
