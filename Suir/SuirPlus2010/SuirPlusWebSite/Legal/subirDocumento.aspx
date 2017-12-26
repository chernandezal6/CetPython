<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="subirDocumento.aspx.vb" Inherits="Legal_subirDocumento" title="Documentos de Acuerdos de Pagos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

  <script type="text/javascript" language="javascript">
     
        var PROGRESS_INTERVAL = 500;
        var PROGRESS_COLOR = '#63AD22';
        
        var _divFrame;
        var _divUploadMessage;
        var _divUploadProgress;
        var _ifrPhoto;
        
        var _loopCounter = 1;
        var _maxLoop = 10;
        var _photoUploadProgressTimer;
        
        function initPhotoUpload()
        {          
                                         
            _divFrame = document.getElementById('divFrame');
            _divUploadMessage = document.getElementById('divUploadMessage');
            _divUploadProgress = document.getElementById('divUploadProgress');
            _ifrPhoto = document.getElementById('ifrPhoto');
             
            var btnUpload = _ifrPhoto.contentWindow.document.getElementById('btnUpload');
              
             btnUpload.onclick = function(event)
             {
                var filPhoto = _ifrPhoto.contentWindow.document.getElementById('filPhoto');
                
                //Validacion Basica para la imagen.
                _divUploadMessage.style.display = 'none';
                
                if (filPhoto.value.length == 0)
                {
                    _divUploadMessage.innerHTML = '<span class=\"error">Por favor especifique un archivo.</span>';
                    _divUploadMessage.style.display = '';
                    filPhoto.focus();
                    return;
                }
                
                var regExp = /^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.jpg|.JPG|.gif|.GIF|.tif|.TIF|.bmp|.BMP)$/;
                
                if (!regExp.test(filPhoto.value)) //Somehow the expression does not work in Opera
                {
                    _divUploadMessage.innerHTML = '<span class=\"error">Archivo Inválido. Solo soporta jpg, gif, tif y bmp.</span>';
                    _divUploadMessage.style.display = '';
                    filPhoto.focus();
                    return;
                }
               
                beginPhotoUploadProgress();
                _ifrPhoto.contentWindow.document.getElementById('photoUpload').submit();
                _divFrame.style.display = 'none'; 
                
             }            
        }
        
        function beginPhotoUploadProgress()
        {
            _divUploadProgress.style.display = '';
            clearPhotoUploadProgress();
            _photoUploadProgressTimer = setTimeout(updatePhotoUploadProgress, PROGRESS_INTERVAL);
        }
        
        function clearPhotoUploadProgress()
        {
            for (var i = 1; i <= _maxLoop; i++)
            {
                document.getElementById('tdProgress' + i).style.backgroundColor = 'transparent';
            }

            document.getElementById('tdProgress1').style.backgroundColor = PROGRESS_COLOR;
            _loopCounter = 1;
        }
        
        function updatePhotoUploadProgress()
        {
            _loopCounter += 1;

            if (_loopCounter <= _maxLoop)
            {
                document.getElementById('tdProgress' + _loopCounter).style.backgroundColor = PROGRESS_COLOR;
            }
            else 
            {
                clearPhotoUploadProgress();
            }

            if (_photoUploadProgressTimer)
            {
                clearTimeout(_photoUploadProgressTimer);
            }

            _photoUploadProgressTimer = setTimeout(updatePhotoUploadProgress, PROGRESS_INTERVAL);
        }
        
        function documentUploadComplete(message, isError)
        {
            clearPhotoUploadProgress();

            if (_photoUploadProgressTimer)
            {
                clearTimeout(_photoUploadProgressTimer);
            }

            _divUploadProgress.style.display = 'none';
            _divUploadMessage.style.display = 'none';
            _divFrame.style.display = '';

            if (message.length)
            {
                var color = (isError) ? '#ff0000' : '#008000';

                _divUploadMessage.innerHTML = '<span style=\"color:' + color + '\;font-weight:bold">' + message + '</span>';
                _divUploadMessage.style.display = '';

                if (isError)
                {
                    _ifrPhoto.contentWindow.document.getElementById('filPhoto').focus();
                }
            }
        }
                
  </script>

    <div class="header">Documento de Acuerdos</div> <br />
    <asp:UpdatePanel ID="upError" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Label ID="lblMsg" runat="server" CssClass="error"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>    
    <table cellpadding="1" cellspacing="1" class="td-content" style="width: 375px">
        <tr>
            <td colspan="2">
                RNC/Cédula:<asp:TextBox ID="txtRnc" runat="server" MaxLength="11"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRnc"
                    CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                <asp:Button ID="btnConsultar" runat="server" Text="Consultar" />
                <asp:Button ID="btnCancelar" runat="server" CausesValidation="False" Text="Cancelar" />
                <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" ControlToValidate="txtRNC"
                    CssClass="error" Display="Dynamic" EnableViewState="False" ErrorMessage="RNC o Cédula invalido."
                    SetFocusOnError="True" ValidationExpression="^(\d{9}|\d{11})$"></asp:RegularExpressionValidator></td>
        </tr>
    </table>
    <br />
    <asp:UpdatePanel ID="upAcuerdos" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Panel runat="server" ID="pnlAcuerdos" Visible="false">
            <table cellpadding="0" cellspacing="0" class="td-note" style="width: 550px" id="TABLE1" onclick="return TABLE1_onclick()">
                <tr>
                    <td style="width: 18%">
                        Razon Social</td>
                    <td>
                        <asp:Label ID="lblRazonSocial" runat="server" CssClass="LabelDataGreen"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 100px">
                        Nombre Comercial</td>
                    <td>
                        <asp:Label ID="lblNombreComercial" runat="server" CssClass="LabelDataGreen"></asp:Label></td>
                </tr>
            </table>
            <br />
            <asp:Panel runat="server" ID="pnlDetAcuerdo">
                <table cellpadding="0" cellspacing="1" class="td-content" style="width: 550px">
                    <tr>
                        <td style="width: 14%">
                            Tipo Acuerdo</td>
                        <td>
                            <asp:Label ID="lblTipoAcuerdo" runat="server" CssClass="labelData"></asp:Label></td>
                        <td style="width: 10%">
                            Estatus</td>
                        <td style="width: 17%">
                            <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="width: 100px">
                            Fecha Registro</td>
                        <td>
                            <asp:Label ID="lblFechaRegistro" runat="server" CssClass="labelData"></asp:Label></td>
                        <td>
                            Cuotas</td>
                        <td>
                            <asp:Label ID="lblCuotas" runat="server" CssClass="labelData"></asp:Label></td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div style="width:400px">
                                <fieldset>
                                    <legend>Documentos de Acuerdos</legend>
                                    <div id="divFrame">
                                        <iframe id="ifrPhoto" scrolling="no" frameborder="0"  onload="initPhotoUpload()" hidefocus="true" style="text-align:center;vertical-align:middle;border-style:none;margin:2px;width:100%;height:55px" src="documentUpload.aspx"></iframe>
                                    </div>
                                    <div id="divUploadMessage" style="padding-top:4px;display:none"></div>
                                    <div id="divUploadProgress" style="padding-top:4px;display:none">
                                        <span style="font-size:smaller">Cargando documento...</span>
                                        <div>
                                            <table border="0" cellpadding="0" cellspacing="2" style="width:100%">
                                                <tbody>
                                                    <tr>
                                                        <td id="tdProgress1">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress2">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress3">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress4">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress5">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress6">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress7">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress8">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress9">&nbsp; &nbsp;</td>
                                                        <td id="tdProgress10">&nbsp; &nbsp;</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                            <br />
                        </td>
                    </tr>
                </table>
            </asp:Panel>           
            <asp:GridView ID="gvAcuerdos" runat="server" AutoGenerateColumns="False" HorizontalAlign="Left" Width="550px">
                <Columns>
                    <asp:BoundField DataField="ID_ACUERDO" HeaderText="ID">
                        <HeaderStyle HorizontalAlign="Left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ACUERDO" HeaderText="Tipo Acuerdo" />
                    <asp:BoundField DataField="STATUS" HeaderText="Estatus">
                        <ItemStyle HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CUOTAS" HeaderText="Cuotas">
                        <ItemStyle HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Documento">
                        <ItemStyle HorizontalAlign="Right" />
                        <HeaderStyle HorizontalAlign="Right" />
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" CommandName="Subir" CommandArgument='<%# Eval("ID_ACUERDO") & "|" &  Eval("Tipo") %>' runat="server">[subir]</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle HorizontalAlign="Left" />
            </asp:GridView>
          </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnConsultar" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnCancelar" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>

