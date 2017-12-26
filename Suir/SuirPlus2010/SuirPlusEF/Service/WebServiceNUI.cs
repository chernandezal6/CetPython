using SuirPlusEF.Framework;
using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace SuirPlusEF.Service
{
    public class WebServiceNUI : Framework.WebService<WebServiceNUI>
    {

        public WebServiceNUI() : base() {

            ConfigRepository _RepConfig = new ConfigRepository();
            Config configuracion = _RepConfig.GetByIdModulo("WS_NUI_JCE");

            this.Config = configuracion;

            // Llenar los valores que necesita ese WebService

            this.AccessToken = configuracion.Field1;
            this.ServiceID = configuracion.Field2;
            
            this.UrlString = $"{this.AccessToken}/{this.ServiceID}";
        }

        public ServiceResult ConsultaByNUI(DocumentoNUI documento, ref WebServiceNUIModel wsServiceNUIModel)
        {
            String UrlStringConParametros = $"{this.UrlString}/{documento.NumeroConGuiones()}";
            Uri UrlConParametros = new Uri(UrlStringConParametros);

            ServiceResult.AddMessage($"Consulta el NUI en el WebService de la JCE. Parametros: {UrlConParametros} ");
            
            try
            {
                //Invocar el webservice  
                HttpWebRequest wrc;
                wrc = (HttpWebRequest)WebRequest.Create(UrlConParametros);

                var prxInternet = new SuirPlus.Config.Configuracion(SuirPlus.Config.ModuloEnum.ProxyInternet);
                var infoWS = new SuirPlus.Config.Configuracion(SuirPlus.Config.ModuloEnum.WS_JCE);

                var ProxyUser = prxInternet.FTPUser;
                var ProxyIP = prxInternet.FTPHost;
                var ProxyDomain = prxInternet.FTPDir;
                var ProxyPort = prxInternet.FTPPort;
                var ProxyPass = prxInternet.FTPPass;
                var dataPass = Convert.FromBase64String(ProxyPass);
                ProxyPass = System.Text.ASCIIEncoding.ASCII.GetString(dataPass);

                var Autenticacion = new NetworkCredential(ProxyUser, ProxyPass, ProxyDomain);
                var ProxyWeb = new WebProxy(ProxyIP, Convert.ToInt32(ProxyPort));

                ProxyWeb.Credentials = Autenticacion;
                wrc.Proxy.Credentials = ProxyWeb.Credentials;
                wrc.Proxy = ProxyWeb;
                wrc.UserAgent = "RobotTSS";

                Stream objStream = wrc.GetResponse().GetResponseStream();
                XmlTextReader reader = new XmlTextReader(objStream);

                while (reader.Read())
                {
                    #region valores recorridos en el xml
                    if (reader.Name.ToUpper() == "NUI")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.NUI = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "NOMBRE")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.Nombre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "PRIMER_APELLIDO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.PrimerApellido = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "SEGUNDO_APELLIDO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.SegundoApellido = reader.Value;
                            reader.Read();
                        }
                    }

                    if (reader.Name.ToUpper() == "FECHAEVENTO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.FechaEvento = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "SEXO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.Sexo = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "MUNICIPIO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.Municipio = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "OFICIALIA")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.Oficialia = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "ANO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.Ano = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "IDTIPOLIBRO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.idTipoLibro = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "NOLIBRO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.NoLibro = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "LITERAL")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.Literal = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "NOFOLIO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.NoFolio = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "NOACTA")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.NoActa = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "CEDULAPADRE")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.CedulaPadre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "CEDULAMADRE")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.CedulaMadre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "CONSULTAVALIDA")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.ConsultaValida = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "FECHAHORACONSULTA")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.FechaHoraConsulta = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "MENSAJE")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceNUIModel.Mensaje = reader.Value;
                            reader.Read();
                        }
                    }
                    #endregion
                }
                if (wsServiceNUIModel.ConsultaValida.ToUpper() == "TRUE")
                {
                    this.MatchFound = true;
                    ServiceResult.AddMessage($"Se obtuvieron los datos del NUI {wsServiceNUIModel.NUI} para {wsServiceNUIModel.Nombre} {wsServiceNUIModel.PrimerApellido}");
                }
                else
                {
                    ServiceResult.AddMessage($"El WEBSERVICE-NUI se ejecutó bien?: {wsServiceNUIModel.ConsultaValida.ToUpper()} - {wsServiceNUIModel.Mensaje}");
                }

            }
            catch (Exception ex)
            {
                //Console.WriteLine("error  " + ex.ToString());
                ServiceResult.AddErrorMessage("Ha ocurrido una excepcion");
                ServiceResult.Exception = ex;
                throw ex;
            }
            ServiceResult.ServiceExecuted = true;
            return ServiceResult;
        }

    }
}
