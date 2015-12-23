<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

String strsql;

protected void Page_Load(object sender, EventArgs e)
{
    FunctionUtilitysDB.Connessione();
}

void Lgoin_Click(object sender, EventArgs e)
{
    var email = UserEmail.Text;
    var pwd = UserPass.Text;
    
    strsql = "SELECT email FROM tblAccount WHERE email = '"+email+"' and pwd = '"+pwd+"' ";
    var result = FunctionUtilitysDB.Verifica(strsql);
    
    if (result)
    {
        FormsAuthentication.RedirectFromLoginPage(UserEmail.Text, Persist.Checked);
    }
    else
    {
        Msg.Text = "Invalid credentials. Please try again.";
    }
}
</script>
<html>
<head id="Head1" runat="server">
    <title>Forms Authentication - Login</title>
</head>
<body>
    <form id="form1" runat="server">
        <h3>Login Page</h3>
        <table>
            <tr>
                <td>E-mail address:</td>
                <td>
                    <asp:TextBox ID="UserEmail" runat="server" /></td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                        ControlToValidate="UserEmail"
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
            <tr>
                <td>Remember me?</td>
                <td>
                    <asp:CheckBox ID="Persist" runat="server" /></td>
            </tr>
        </table>
        <asp:Button ID="Submit1" OnClick="Lgoin_Click" Text="Login"
            runat="server" />
        <p>
            <asp:Label ID="Msg" ForeColor="red" runat="server" />
        </p>
    </form>
</body>
</html>
