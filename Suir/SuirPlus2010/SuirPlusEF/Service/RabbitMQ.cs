using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RabbitMQ.Client;
using SuirPlusEF.Repositories;
using SuirPlusEF.Models;

namespace SuirPlusEF.Service
{
    public class RabbitMQ
    {

       // public static string ColaAsignacionNSS = "asignacion_nss";

        public static void EnviarMensaje(string cola, string mensaje) {
            try
            {
                ConfigRepository _RepConfig = new ConfigRepository();
                Config configuracion = _RepConfig.GetByIdModulo("WS_COLANSS");
                var factory = new ConnectionFactory() { HostName = configuracion.FTPUser };
                using (var connection = factory.CreateConnection())
                using (var channel = connection.CreateModel())
                {
                    channel.QueueDeclare(queue: cola,
                                         durable: true,
                                         exclusive: false,
                                         autoDelete: false,
                                         arguments: null);

                    var body = Encoding.UTF8.GetBytes(mensaje);

                    var properties = channel.CreateBasicProperties();
                    properties.Persistent = true;
                    //properties..SetPersistent(true);

                    channel.BasicPublish(exchange: "",
                                         routingKey: cola,
                                         basicProperties: properties,
                                         body: body);

                }
            }
            catch (Exception ex) {
                throw ex;
            }

        }

        public enum ColaAsignacionNSSEnum
        {
            asignacion_nss_menor_nac_acta = 1,
            asignacion_nss_NUI = 2,
            asignacion_nss_cedulado = 3,
            asignacion_nss_extranjero = 4,
            asignacion_nss_menor_extranjero = 5,
            asignacion_nss = 6
        }
    }
}
