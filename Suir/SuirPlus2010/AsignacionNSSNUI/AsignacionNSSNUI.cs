using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Threading;
using SuirPlusEF.Service;
using SuirPlusEF.Repositories;
using SuirPlusEF.Models;

namespace AsignacionNSSNUI
{
    public class AsignacionNSSNUI
    {
        public static void Main()
        {
            ConfigRepository _RepConfig = new ConfigRepository();
            Config configuracion = _RepConfig.GetByIdModulo("WS_COLANSS");
            var factory = new ConnectionFactory() { HostName = configuracion.FTPUser };
            using (var connection = factory.CreateConnection())
            using (var channel = connection.CreateModel())
            {
                channel.QueueDeclare(queue: "asignacion_nss_NUI",
                                     durable: true,
                                     exclusive: false,
                                     autoDelete: false,
                                     arguments: null);

                var consumer = new EventingBasicConsumer(channel);
                consumer.Received += (model, ea) =>
                {
                    var body = ea.Body;
                    var message = Encoding.UTF8.GetString(body);

                    Console.WriteLine("Solicitud: {0} asignacion_nss_NUI", message);

                    ProcesarSolicitud(message);

                    channel.BasicAck(deliveryTag: ea.DeliveryTag, multiple: false);

                };
                channel.BasicConsume(queue: "asignacion_nss_NUI",
                                     noAck: false,
                                     consumer: consumer);

                Console.WriteLine(" Press [enter] to exit asignacion_nss_NUI.");
                Console.ReadLine();
            }
        }

        public static void ProcesarSolicitud(string solicitud)
        {
            try {
                Console.WriteLine("arrancó el esclavo de rabbit...con el numero de solicitud: " + solicitud);
                SolicitudAsignacion servSolicitud = new SolicitudAsignacion(Convert.ToInt32(solicitud));
                //servSolicitud.Procesar();
            }
            catch (Exception ex) {
                Console.WriteLine("mi error es: " + ex.ToString());
            }

        }
    }
}
