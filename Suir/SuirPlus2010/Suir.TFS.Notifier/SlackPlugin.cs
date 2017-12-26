using System;
using Microsoft.TeamFoundation.Common;
using Microsoft.TeamFoundation.Framework.Server;
using Microsoft.TeamFoundation.WorkItemTracking.Server;
using Microsoft.TeamFoundation.WorkItemTracking.Client;
using Microsoft.TeamFoundation.Client;

namespace Suir.TFS.Notifier
{
    public class SlackPlugin : ISubscriber
    {
        public string Name
        {
            get
            {
                return "SuirPlus TFS-Slack Integration";
            }
        }

        public SubscriberPriority Priority
        {
            get
            {
                return SubscriberPriority.Normal;
            }
        }

        public EventNotificationStatus ProcessEvent(IVssRequestContext requestContext,
                                                    NotificationType notificationType,
                                                    object notificationEventArgs,
                                                    out int statusCode,
                                                    out string statusMessage,
                                                    out ExceptionPropertyCollection properties)
        {
            statusCode = 0;
            properties = null;
            statusMessage = String.Empty;

            if (notificationType == NotificationType.Notification && notificationEventArgs is WorkItemChangedEvent) {

                string AsignadoA = "";
                string AsignadoPor = "";
                string ID = "";
                string Titulo = "";
                string Tipo = "";

                string MensageEnviado = "";
                string RespuestaSlack = "";

                try
                {
                    WorkItemChangedEvent ev = (WorkItemChangedEvent)notificationEventArgs;

                    // get a reference to the team project collection 
                    TfsTeamProjectCollection tfs = new TfsTeamProjectCollection(new Uri(@"http://kronos:8080/tfs/TFS2008_Collection"));
                    tfs.EnsureAuthenticated();

                    WorkItemStore wiStore = tfs.GetService<WorkItemStore>();
                    WorkItem witem = wiStore.GetWorkItem(ev.CoreFields.IntegerFields[0].NewValue);

                    AsignadoA = witem.Fields["System.AssignedTo"].Value.ToString();
                    AsignadoPor = witem.Fields["System.ChangedBy"].OriginalValue.ToString();
                    ID = witem.Id.ToString();
                    Titulo = witem.Title;
                    Tipo = witem.Type.Name;

                    // No sea una modificación hecha por el mismo usuario
                    if (AsignadoA != AsignadoPor) {
                        SlackHelper slack = new SlackHelper();
                        slack.SendMsg(AsignadoA, AsignadoPor, ID, Titulo, Tipo, ref MensageEnviado, ref RespuestaSlack);
                    }

                }
                catch (Exception e)
                {
                    System.IO.StreamWriter objWriter = new System.IO.StreamWriter("c:\\apps\\logs\\tfs_slack.txt", true);
                    objWriter.WriteLine("-=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=--=-=-");
                    objWriter.WriteLine($"ID: {ID}");
                    objWriter.WriteLine($"Respuesta Slack: {RespuestaSlack}");
                    objWriter.WriteLine($"Mensage Enviado: {MensageEnviado}");
                    objWriter.WriteLine(e.ToString());
                    objWriter.Close();
                }
            }
            return EventNotificationStatus.ActionPermitted;
        }

        public Type[] SubscribedTypes()
        {

            return new Type[1] { typeof(WorkItemChangedEvent) };
        }
    }
}