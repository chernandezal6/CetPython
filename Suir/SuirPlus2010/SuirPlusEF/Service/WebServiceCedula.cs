using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using System;
using System.IO;
using System.Net;
using System.Xml;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Service
{
    public class WebServiceCedula : Framework.WebService<WebServiceCedula>
    {

        public WebServiceCedula() : base(){

            ConfigRepository _RepConfig = new ConfigRepository();
            Config configuracion = _RepConfig.GetByIdModulo("WS JCE");

            this.Config = configuracion;
            // Llenar los valores que necesita ese WebService

            this.AccessToken = configuracion.Field1;
            this.ServiceID = configuracion.Field2;

            this.UrlString = $"{this.AccessToken}{this.ServiceID}";
            
            this.ServiceResult.ServiceExecuted = true;
        }

        public ServiceResult ConsultaByCedula(DocumentoCedula documento, ref WebServiceCedulaModel wsServiceCedulaModel) {
            // Modelo
            String UrlStringConParametros = $"{this.UrlString}{"&ID1=" + documento.Municipio()  + "&ID2="+ documento.Numero() + "&ID3=" + documento.DigitoVerificador()}";
            Uri UrlConParametros = new Uri(UrlStringConParametros);
            ServiceResult.AddMessage($"Consulta la cedula en el WebService de la JCE. Parametros: {UrlConParametros} ");
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

                //Llenar los valores
                while (reader.Read())
                {
                    #region valores recorridos en el xml
                    if (reader.Name.ToUpper() == "NOMBRES")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Nombres= reader.Value;
                            wsServiceCedulaModel.Cedula = documento.NumeroSinGuiones();
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "APELLIDO1")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Apellido1 = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "APELLIDO2")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Apellido2 = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "FECHA_NAC")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.FechaNacimiento= reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "COD_SANGRE")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.CodSangre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "SEXO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Sexo = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "COD_NACION")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.CodNacionalidad = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "EST_CIVIL")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.EstadoCivil = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "ACTA_MUN")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.MunicipioActa = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "ACTA_OFIC")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.OficialiaActa = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "ACTA_LIBRO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.NoLibro = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "ACTA_FOLIO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.NoFolio = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "ACTA_NUMERO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.NoActa = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "ACTA_ANO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.AnoActa = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "TIPO_LIBRO")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.TipoLibroActa = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "ESTATUS")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Estatus = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "PADRE_NOMBRES")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.NombrePadre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "PADRE_APELLIDO1")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Apellido1Padre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "MADRE_NOMBRES")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.NombreMadre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "MADRE_APELLIDO1")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Apellido1Madre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "MADRE_APELLIDO2")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Apellido2Madre = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "TIPO_CAUSA")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.TipoCausa = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "COD_CAUSA")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.CodCausa = reader.Value;
                            reader.Read();
                        }
                    }

                    if (reader.Name.ToUpper() == "SUCCESS")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Success = reader.Value;
                            reader.Read();
                        }
                    }
                    if (reader.Name.ToUpper() == "MESSAGE")
                    {
                        reader.Read();
                        if (reader.NodeType == XmlNodeType.Text)
                        {
                            wsServiceCedulaModel.Mensaje = reader.Value;
                            reader.Read();
                        }
                    }

                    #endregion
                }

                if (wsServiceCedulaModel.Success.ToUpper() == "TRUE")
                {
                    this.MatchFound = true;
                    ServiceResult.AddMessage($"Se obtuvieron los datos de la cedula {wsServiceCedulaModel.CedCompleta} para {wsServiceCedulaModel.Nombres} {wsServiceCedulaModel.Apellido1}");                   
                }
                else
                { 
                    ServiceResult.AddMessage($"El WEBSERVICE-CEDULA se ejecutó bien?: {wsServiceCedulaModel.Success.ToUpper()} - {wsServiceCedulaModel.Mensaje}");
                }
            }
            catch (Exception ex)
            {
                ServiceResult.AddErrorMessage("Ha ocurrido una excepcion");
                ServiceResult.Exception = ex;
                throw ex;
            }
            ServiceResult.ServiceExecuted = true;
            return ServiceResult;
        }

    }
}
