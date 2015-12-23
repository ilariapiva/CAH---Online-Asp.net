<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

String strsql;

protected void Page_Load(object sender, EventArgs e)
{
    FunctionUtilitysDB.Connessione();
}

protected void Register_Click(object sender, EventArgs e)
{
    lblEmail.Text = "";
    lblUser.Text = "";
    
    var email = UserEmail.Text;
    var pwd = UserPass.Text;
    var user = Username.Text;

    strsql = "SELECT email FROM tblAccount WHERE email = '" + email + "'";
    var result1 = FunctionUtilitysDB.Verifica(strsql);
    
    if (result1)
    {
        lblEmail.Text = "Questo indirizzo email è già utilizzato.";
    }
    
    strsql = "SELECT username FROM tblAccount WHERE username = '" + user + "'";
    var result2 = FunctionUtilitysDB.Verifica(strsql);
    
    if (result2)
    {
        lblUser.Text = "Questo username è già utilizzato.";
    }
    
    if((result1 == false) && (result2 == false))
    {
        strsql = "INSERT INTO tblAccount(email, username, pwd) VALUES ('"+email+"', '"+user+"', '"+pwd+"')";
        FunctionUtilitysDB.Scrivi(strsql);
        lblMsg.Text = "Registrazione effettuata!";
    }
}
</script>
<html>
<head id="Head1" runat="server">
    <title>Forms Registration - Register</title>
</head>
<body>
    <form id="form1" runat="server">
        <h3>Register Page</h3>
        <table>
            <tr>
                <td>E-mail address:</td>
                <td>
                    <asp:TextBox ID="UserEmail" runat="server" />
                    <br />
                    <asp:Label ID="lblEmail" runat="server" ForeColor="Black"></asp:Label>
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                        ControlToValidate="UserEmail"
                        Display="Dynamic"
                        ErrorMessage="Cannot be empty."
                        runat="server" />
                </td>
            </tr>
            <tr>
                <td>Username:</td>
                <td>
                    <asp:TextBox ID="Username" runat="server" />
                    <br />
                    <asp:Label ID="lblUser" runat="server" ForeColor="Black"></asp:Label>
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
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
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3"
                        ControlToValidate="UserPass"
                        ErrorMessage="Cannot be empty."
                        runat="server" />
                </td>
            </tr>
        </table>
        <asp:Button ID="Register" OnClick="Register_Click" Text="Register"
            runat="server" />
        <p>
            <asp:Label ID="lblMsg" ForeColor="Red" runat="server" />
        </p>
    </form>
</body>
</html>
