using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http.Headers;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using ConsumirWebServiceNUIs.Clase;
using System.Xml.Serialization;
using SuirPlusEF.Repositories;
using SuirPlusEF.Models;
using SuirPlusEF.Framework;
using Oracle.ManagedDataAccess.Client;

namespace Consola
{
    class Program
    {
        private static HttpClient client = new HttpClient();
        private static string fechafin = "";


        static void Main(string[] args)
        {
            Console.Write("Presione Enter para Incial el proceso");
            Console.ReadLine();
            Program.RunAsync().Wait();

        }


        private static async Task RunAsync()
        {
            Program.client.BaseAddress = new Uri("http://10.12.201.7:8090/");
            Program.client.DefaultRequestHeaders.Accept.Clear();
            Program.client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("Application/json"));
            try
            {
                DetalleSolicitudesRepository rep = new DetalleSolicitudesRepository();
                List<ObjetosNUIs> ListadoNuis;

                bool Resultado = true;

                while (Resultado)
                {
                    ListadoNuis = rep.GetAll().Where(x => x.IdTipoDocumento == "U" && x.IdEstatus == 1).Select(x => new ObjetosNUIs { Documento = x.Documento, Solicitud = x.IdSolicitud.ToString(), Registro = x.IdRegistro }).OrderByDescending(x => x.Registro).Take(500).ToList();


                    var nuis = ListadoNuis.ToArray();

                    int cantidadconsulta = 1;
                    for (int count = 1; count <= cantidadconsulta; ++count)
                    {
                        ObjetosNUIs[] strArray = nuis;
                        for (int index = 0; index < strArray.Length; ++index)
                        {
                            string nuiStr = SubStringNUIs(strArray[index].Documento);
                            RootObject nuiclass = (RootObject)null;
                            DateTime now = DateTime.Now;
                            string fechainicio = now.ToString("dd/MM/yyyy HH:mm:ss");
                            Program.fechafin = "";
                            RootObject rootObject = await Program.GetProductAsync(string.Format("Consulta/bfcd463e-9fab-4afd-9352-bf247466f9d7/2/{0}/json", (object)nuiStr));
                            nuiclass = rootObject;
                            rootObject = (RootObject)null;
                            if (nuiclass != null)
                            {
                                string estatus = nuiclass.Consulta.ConsultaValida.ToUpper() == "TRUE" ? "Ok" : "No";
                                string format = "Nui:{0}\t{1}\t{2}\t{3}";
                                object[] objArray = new object[4]
                                {
                                (object) nuiclass.Consulta.NUI,
                                (object) estatus,
                                (object) fechainicio,
                                null
                                };
                                int index1 = 3;
                                now = DateTime.Now;
                                string str = now.ToString("dd/MM/yyyy HH:mm:ss");
                                objArray[index1] = (object)str;
                                Program.CrearLog(string.Format(format, objArray));
                                Program.ShowNUI(count, nuiclass);
                                estatus = (string)null;

                                CallMetodo(Convert.ToInt32(strArray[index].Solicitud), "OPERACIONES", ToXML(nuiclass));


                            }
                            nuiclass = (RootObject)null;
                            fechainicio = (string)null;
                            nuiStr = (string)null;
                        }
                        strArray = (ObjetosNUIs[])null;
                    }
                    nuis = (ObjetosNUIs[])null;


                    //if (rep.GetAll().Where(x => x.IdTipoDocumento == "U" && x.IdEstatus == 1).Count() == 0)
                    //{
                    //    Resultado = false;
                    //}

                }



            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }


            await Task.Delay(1000);


            Console.Write("Fin del proceso");
            Console.ReadLine();
        }

        private static async Task<RootObject> GetProductAsync(string path)
        {
            RootObject nui = new RootObject();
            HttpResponseMessage httpResponseMessage = await Program.client.GetAsync(path);
            HttpResponseMessage response = httpResponseMessage;
            httpResponseMessage = (HttpResponseMessage)null;
            if (response.IsSuccessStatusCode)
            {
                string data = response.Content.ReadAsStringAsync().Result;
                nui = response.Content.ReadAsAsync<RootObject>().Result;
                data = (string)null;
            }
            Program.fechafin = DateTime.Now.ToString("yyyyMMdd HH:mm:ss");
            return nui;
        }

        private static void ShowNUI(int Index, RootObject Nui)
        {
            Console.WriteLine(ToXML(Nui));
        }

        public static void CrearLog(string Mensaje)
        {
            StreamWriter streamWriter = File.AppendText(Environment.CurrentDirectory + "\\Applog.log");
            string str = string.Format("{0}\t{1}", (object)DateTime.Now, (object)Mensaje);
            streamWriter.WriteLine(str);
            streamWriter.Close();
        }

        public class Rootobject
        {
            public Consulta Consulta { get; set; }
        }

        public static string ToXML(RootObject Elemento)
        {
            var stringwriter = new System.IO.StringWriter();
            var serializer = new XmlSerializer(Elemento.GetType());
            serializer.Serialize(stringwriter, Elemento);
            return stringwriter.ToString().ToUpper();
        }

        public static string SubStringNUIs(string NoDocumento)
        {
            var resultado = NoDocumento.Substring(0, 3) + "-" + NoDocumento.Substring(3, 7) + "-" + NoDocumento.Substring(10, 1);
            return resultado;
        }

        public static string CallMetodo(int Solicitud, string Usuario, string Mensaje)
        {

            //parametros de entrada
            OracleParameter p_id_solicitud = new OracleParameter();
            p_id_solicitud.ParameterName = "p_id_solicitud";
            p_id_solicitud.Value = Solicitud;
            p_id_solicitud.Direction = System.Data.ParameterDirection.Input;
            p_id_solicitud.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Int32;

            OracleParameter p_ult_usuario_act = new OracleParameter();
            p_ult_usuario_act.ParameterName = "p_ult_usuario_act";
            p_ult_usuario_act.Value = Usuario;
            p_ult_usuario_act.Direction = System.Data.ParameterDirection.Input;
            p_ult_usuario_act.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2;
            p_ult_usuario_act.Size = 35;

            OracleParameter p_nui_cadena = new OracleParameter();
            p_nui_cadena.ParameterName = "p_nui_cadena";
            p_nui_cadena.Value = Mensaje;
            p_nui_cadena.Direction = System.Data.ParameterDirection.Input;
            p_nui_cadena.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2;
            p_nui_cadena.Size = 3000;

            //parametro de salida
            OracleParameter p_resultado = new OracleParameter();
            p_resultado.ParameterName = "p_resultado";
            p_resultado.Direction = System.Data.ParameterDirection.Output;
            p_resultado.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2;
            p_resultado.Size = 3000;

            string Resultado = string.Empty;

            OracleDbContext db = new OracleDbContext();
            db.Database.ExecuteSqlCommand("begin suirplus.nss_validar_solicitud_nui_2(:p_id_solicitud, :p_ult_usuario_act, :p_nui_cadena, :p_resultado); end;", p_id_solicitud, p_ult_usuario_act, p_nui_cadena, p_resultado);

            if (p_resultado.Value.ToString() == "OK")
            {
                Resultado = "Solicitud procesada exitosamente!";
            }
            else
            {
                Resultado = "Error al ejecutar el proceso " + p_resultado.Value.ToString();
            }

            return Resultado;

        }

    }

    public class ObjetosNUIs
    {
        public string Documento { get; set; }
        public string Solicitud { get; set; }
        public int Registro { get; set; }
    }


}
