<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    String strsql1, strsql2;

protected void Page_Load(object sender, EventArgs e)
{
    FunctionUtilitysDB.Connessione();
}

void btnSalva_Click(object sender, EventArgs e)
{
    lblUser.Text = "";

    var pwd = UserPass.Text;
    var user = Username.Text;

    strsql1 = "SELECT username FROM tblAccount WHERE username = '" + user + "'";
    var result = FunctionUtilitysDB.Verifica(strsql1);

    if (result)
    {
        lblUser.Text = "Questo username è già utilizzato.";
    }

    if (result == false)
    {
        strsql1 = "UPDATE tblAccount SET username = '" + user + "'";
        FunctionUtilitysDB.Scrivi(strsql1);
        strsql2 = "UPDATE tblAccount SET pwd = HASHBYTES('SHA1', '" + pwd + "')";
        FunctionUtilitysDB.Scrivi(strsql2);
        lblMsg.Text = "Cambiamenti effettutati!";
        Response.Redirect("~/index.aspx");
    } 
}
</script>
<html>
<head id="Head1" runat="server">
    <title>Forms Authentication - Login</title>
</head>
<body>
    <form id="form1" runat="server">
        <h3>Impostazioni</h3>
        <table>
            <tr>
                <td>E-mail address:</td>
                <td style="margin-left: 80px">
                    &nbsp;</td>
            </tr>
            <tr>
                <td>Username:</td>
                <td>
                    <asp:TextBox ID="Username" runat="server" />
                    <br />
                    <asp:Label ID="lblUser" runat="server" ForeColor="Black"></asp:Label>
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                        ControlToValidate="Username"
                        Display="Dynamic"
                        ErrorMessage="Cannot be empty."
                        runat="server" />
                </td>
            </tr>
            <tr>
                <td>Password:</td>
                <td>
                    <asp:TextBox ID="UserPass" TextMode="Password"
                        runat="server" />
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
                        ControlToValidate="UserPass"
                        ErrorMessage="Cannot be empty."
                        runat="server" />
                </td>
            </tr>
            </table>
        <asp:Button ID="btnAnnulla" Text="Annulla"
            runat="server" style="width: 63px" />
        &nbsp;&nbsp;
        <asp:Button ID="btnSalva" OnClick="btnSalva_Click" Text="Salva"
            runat="server" />
        &nbsp;<p>
            <asp:Label ID="lblMsg" ForeColor="Red" runat="server" />
        </p>
    </form>
</body>
</html>
